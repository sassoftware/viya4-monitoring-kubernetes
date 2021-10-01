#! /bin/bash

# Copyright Ã‚Â© 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

source logging/bin/apiaccess-include.sh
source logging/bin/secrets-include.sh
source logging/bin/rbac-include.sh

function show_usage {
  log_message  "Usage: $this_script --namespace NAMESPACE [--tenant TENANT] [OPTIONS]"
  log_message  ""
  log_message  "'Offboards' either the specified Viya deployment (namespace) or the specified tenant within that deployment.  This removes the ability to limit admins to the Viya deployment (or a single tenant within a given deployment)."
  log_message  "The offboarding process deletes the security access controls and the associated Kibana tenant space (including any saved Kibana content (e.g. visualizations, dashboards, etc.)."
  log_message  ""
  log_message  "    Arguments:"
  log_message  "     -ns, --namespace   NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace to which access should be removed."
  log_message  "     -t,  --tenant      TENANT    - (Optional) The tenant within the specific Viya deployment/Kubernetes Namespace to which access should be removed."
  log_message  ""
  #log_message  "    Options:"
  #log_message  ""
}


if [ "$V4M_FEATURE_MULTITENANT_ENABLE" == "true" ]; then
  log_debug "Multi-tenant feature flag is enabled"
else
  log_error "Multi-tenant support is under active development and is not yet fully    "
  log_error "functional. Set V4M_FEATURE_MULTITENANT_ENABLE=true to continue anyway.  "
  log_message ""
  exit 1
fi


# set flag indicating wrapper/driver script being run
export LOGGING_DRIVER=true

tmpfile=$TMP_DIR/output.txt


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


# No positional parameters are supported
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
   log_error "Invalid namespace value specified; you can NOT offboard the [global] namespace."
   exit 1
fi

if [ -n "$tenant" ]; then
   validateTenantID $tenant

   nst="${namespace}_${tenant}"
   index_nst="${namespace}-__${tenant}__"
else
   nst="$namespace"
   index_nst="${namespace}"
fi

# Kibana tenant space
ktenant=$nst

if [ -n "$tenant" ]; then
   tenant_description="A Kibana tenant space for tenant [$tenant] within Viya deployment (namespace) [$namespace]."
   log_notice "Offboarding tenant [$tenant] within namespace [$namespace] [$(date)]"
else
   tenant_description="A Kibana tenant space for Viya deployment (namespace) [$namespace]."
   log_notice "Offboarding namespace [$namespace] [$(date)]"
fi

#
# get to work
#

# get credentials
get_credentials_from_secret admin

# get ES API URL (needed to delete .kibana index)
get_es_api_url

# get Security API URL
get_sec_api_url

# Delete Kibana tenant space (if it exists)
if kibana_tenant_exists "$ktenant"; then
   delete_kibana_tenant "$ktenant"
   rc=$?
   if [ "$rc" == "0" ]; then
      add_notice "                                                      "
      add_notice "   The Kibana tenant space [$ktenant] has been deleted.   "
      add_notice "                                                      "
   else
      log_error "Problems were encountered while attempting to delete tenant space [$ktenant]."
      exit 1
   fi
else
   log_warn "The Kibana tenant space [$ktenant] does not exist and, therefore, could not be deleted."
fi

# Delete ES index containing tenant content
kibana_index_name=".kibana_*_$(echo "$ktenant"|tr -d _)"
response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "${es_api_url}$kibana_index_name"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response == 2* ]]; then
   log_info "Deleted index [$kibana_index_name]. [$response]"
else
   log_warn "There was an issue deleting the index [$kibana_index_name] holding content related to Kibana tenant space [$ktenant]. You may need to manually delete this index. [$response]"
fi


# Delete access controls
./logging/bin/security_delete_rbac.sh $namespace $tenant

# Reminder that users are not deleted
add_notice "                                                                 "
add_notice "   The off-boarding process does NOT remove any users.  If there "
add_notice "   are users which are no longer needed after off-boarding the   "
if [ -n "$tenant" ]; then
   add_notice "   tenant [$tenant] within the                                   "
fi
add_notice "   Viya deployment/namespace of [$namespace]                     "
add_notice "   you must delete those users manually, either through the      "
add_notice "   Kibana web application or via the logging/bin/user.sh script. "
add_notice "                                                                 "

# Write any "notices" to console
echo ""
log_notice "=================================================================="
display_notices
log_notice "=================================================================="

echo ""

# Exit with an overall success/failure message
if [ -n "$tenant" ]; then
  log_notice "Successfully offboarded tenant [$tenant] within namespace [$namespace] [$(date)]"
else
  log_notice "Successfully offboarded namespace [$namespace] [$(date)]"
fi