#! /bin/bash

# Copyright Ã‚Â© 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

source logging/bin/apiaccess-include.sh
source logging/bin/secrets-include.sh
source logging/bin/rbac-include.sh

this_script=`basename "$0"`


function show_usage {
  log_message  "Usage: $this_script --namespace NAMESPACE [--tenant TENANT] [OPTIONS]"
  log_message  ""
  log_message  "'Onboards' a SAS Viya deployment (namespace) or a specific tenant within that deployment.  This process allows admins responsible for a SAS Viya deployment (or a single tenant within a given deployment) to work with log messages collected from the deployment (or tenant within the deployment)."
  log_message  "The onboarding process creates the security access controls and, optionally, an initial user granted access.  In addition, an OpenSearch Dashboards tenant space is created and populated with an initial set of OpenSearch Dashboards content (e.g. visualizations, dashboards, etc.)."
  log_message  ""
  log_message  "    Arguments:"
  log_message  "     -ns, --namespace   NAMESPACE - (Required) The SAS Viya deployment/Kubernetes Namespace to 'on-board' or the namespace in which the tenant to 'on-board' resides."
  log_message  "     -t,  --tenant      TENANT    - (Optional) The tenant within the specified SAS Viya deployment/Kubernetes Namespace to 'on-board'."
  log_message  ""
  log_message  "    Options:"
  log_message  "        -u, --user [USER]           - Create an initial user with access to this OpenSearch Dashboards tenant space. User name is optional, by default its name will combine the OpenSearch Dashboards tenant space name with '_admin'."
  log_message  "        -p, --password PASSWORD     - Password for the initial user."
  log_message  ""
}


# set flag indicating wrapper/driver script being run
export LOGGING_DRIVER=true

#default values for flags
createuser=false

#
#Handle arguments and parameters
#
POS_PARMS=""

while (( "$#" )); do
  case "$1" in
    -ns|--namespace)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        namespace=$2
        shift 2
      else
        log_error "A value for parameter [NAMESPACE] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -t|--tenant)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        tenant=$2
        shift 2
      else
        log_error "A value for parameter [TENANT] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -u|--user)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        createuser=true
        inituser=$2
        shift 2
      else
        # no initial user name provided, assign default name
        createuser=true
        shift 1
      fi
      ;;
    -p|--password)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        initpasswd=$2
        shift 2
      else
        log_error "A value for parameter [PASSWORD] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -h|--help)
      show_usage
      exit
      ;;
    -*|--*=) # unsupported flags
      log_error "Unsupported flag $1" >&2
      show_usage
      exit 1
      ;;
    *) # preserve positional arguments
      POS_PARMS="$POS_PARMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$POS_PARMS"


# No positional parameters (other than ACTION) are supported
if [ "$#" -ge 1 ]; then
    log_error "Unexpected additional arguments were found; exiting."
    show_usage
    exit 4
fi

# Convert namespace and tenant to all lower-case
namespace=$(echo "$namespace"| tr '[:upper:]' '[:lower:]')
tenant=$(echo "$tenant"| tr '[:upper:]' '[:lower:]')

# validation of input args
if [ "$namespace" == "global" ]; then
   log_error "Invalid namespace value specified; you can NOT onboard the [global] namespace."
   exit 1
fi

validateNamespace "$namespace"

if [ -n "$tenant" ]; then
   validateTenantID $tenant

   nst="${namespace}_${tenant}"
   index_nst="${namespace}-__${tenant}__"
else
   nst="$namespace"
   index_nst="${namespace}"
fi

#FUTURE: Allow user to specify OpenSearch Dashboards tenant space name?
ktenant=$nst

if [ -n "$tenant" ]; then
   tenant_description="An OpenSearch Dashboards tenant space for tenant [$tenant] within SAS Viya deployment (namespace) [$namespace]."
   log_notice "Onboarding tenant [$tenant] within namespace [$namespace] [$(date)]"
else
   tenant_description="An OpenSearch Dashboards tenant space for SAS Viya deployment (namespace) [$namespace]."
   log_notice "Onboarding namespace [$namespace] [$(date)]"
fi

#
# get to work
#

# get credentials
get_credentials_from_secret admin

# get Security API URL
get_sec_api_url

# Create OpenSearch Dashboards tenant space (if it doesn't exist)
if ! kibana_tenant_exists "$ktenant"; then
   create_kibana_tenant "$ktenant" "$tenant_description"
   rc=$?
   if [ "$rc" == "0" ]; then
      add_notice "                                                      "
      add_notice "   The OpenSearch Dashboards tenant space [$ktenant] was created.   "
      add_notice "                                                      "
   else
      log_error "Problems were encountered while attempting to create tenant space [$ktenant]."
      exit 1
   fi
else
   log_error "A OpenSearch Dashboards tenant space [$ktenant] already exists."
   exit 1
fi

# get KIBANA API URL
get_kb_api_url

# Import appropriate content into OpenSearch Dashboards tenant space
./logging/bin/import_osd_content.sh logging/osd/common $ktenant

if [ -z "$tenant" ]; then
   ./logging/bin/import_osd_content.sh logging/osd/namespace $ktenant
else
   ./logging/bin/import_osd_content.sh logging/osd/tenant    $ktenant
fi

if [ -d "$USER_DIR/logging/osd" ] && [ "$USER_DIR" != "$(pwd)" ]; then

   export IGNORE_NOT_FOUND="true"
   ./logging/bin/import_osd_content.sh $USER_DIR/logging/osd/common $ktenant

   if [ -z "$tenant" ]; then
      ./logging/bin/import_osd_content.sh $USER_DIR/logging/osd/namespace $ktenant
   else
      ./logging/bin/import_osd_content.sh $USER_DIR/logging/osd/tenant    $ktenant
   fi
   unset IGNORE_NOT_FOUND
fi

# Create access controls
./logging/bin/security_create_rbac.sh $namespace $tenant

# Create an initial user
if [ "$createuser" == "true" ]; then

   if [ -z "$inituser" ]; then
      inituser="${ktenant}_admin"

   else
      log_debug "Initial user name [$inituser] provided."
   fi

   if [ -n "$initpasswd" ]; then
      passwdarg="-p $initpasswd"
   else
      passwdarg=""
   fi

   if user_exists $inituser; then
      log_warn "A user with the requested user name of  [$inituser] already exists; the initial user account you requested was NOT created."
      log_warn "This existing user may have completely different access controls than you intended for the initial user."
      log_warn "You can create a new user with the appropriate access controls by calling the logging/bin/user.sh script directly."
   else
      if [ -z "$tenant" ]; then
         ./logging/bin/user.sh CREATE -ns $namespace -u $inituser $passwdarg
      else
         ./logging/bin/user.sh CREATE -ns $namespace -t $tenant -u $inituser $passwdarg
      fi
   fi
else
   log_debug "An initial user will NOT be created."
fi

# Write any "notices" to console
echo ""
log_notice "=================================================================="
display_notices
log_notice "=================================================================="

echo ""

# Exit with an overall success/failure message
if [ -n "$tenant" ]; then
  log_notice "Successfully onboarded tenant [$tenant] within namespace [$namespace] [$(date)]"
else
  log_notice "Successfully onboarded namespace [$namespace] [$(date)]"
fi
