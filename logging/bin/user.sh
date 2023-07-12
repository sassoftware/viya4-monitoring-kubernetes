#!/bin/bash


# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0


cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

source logging/bin/rbac-include.sh
source logging/bin/apiaccess-include.sh

function show_usage {
  which_action=$1
  case "$which_action" in
    "CREATE")
       log_message  ""
       log_message  "Usage: $this_script CREATE [REQUIRED_PARAMETERS] [OPTIONS] "
       log_message  ""
       log_message  "Creates a user in the internal user database and limits their access to only log messages from the specified namespace and, optionally, more narrowly, to the specified tenant within the specified namespace"
       log_message  ""
       log_message  "     -ns, --namespace   NAMESPACE - (Required) The SAS Viya deployment/Kubernetes Namespace to which this user should be granted access"
       log_message  "     -t,  --tenant      TENANT    - (Optional) The tenant within the specific SAS Viya deployment/Kubernetes Namespace to which this user should be granted access."
       log_message  "     -u,  --user        USERNAME  - (Optional) The username to be created (default: [NAMESPACE]|[NAMESPACE_TENANT]_admin)"
       log_message  "     -p,  --password    PASSWORD  - (Optional) The password for the newly created account (default: [USERNAME])"
       echo ""
       ;;
    "DELETE")
       log_message  "Usage: $this_script DELETE [REQUIRED_PARAMETERS]"
       log_message  ""
       log_message  "Removes the specified user from the internal user database"
       log_message  ""
       log_message  "     -u,  --user        USERNAME  - (Required) The username to be deleted."
       ;;
    *)
       log_message  ""
       log_message  "Usage: $this_script ACTION [REQUIRED_PARAMETERS] [OPTIONS] "
       log_message  ""
       log_message  "Creates or deletes a user in the internal user database.  Newly created users are granted permission limiting their access to log messages for the specified namespace, and, optionally, to a specific tenant within that namespace."
       log_message  ""
       log_message  "        ACTION - (Required) one of the following actions: [CREATE, DELETE]"
       log_message  ""
       log_message  "        Additional help information, including details of required and optional parameters, can be displayed by submitting the command: $this_script ACTION --help"
       echo ""
       ;;
  esac
}

set -e

POS_PARMS=""

while (( "$#" )); do
  case "$1" in
    -ns|--namespace)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        namespace=$2
        shift 2
      else
        log_error "Error: A value for parameter [Namespace] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -t|--tenant)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        tenant=$2
        shift 2
      else
        log_error "Error: A value for parameter [Tenant] has not been provided." >&2
        show_usage
      exit 2
      fi
      ;;
    -u|--user|--username)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        username=$2
        shift 2
      else
        log_error "Error: A value for parameter [User] has not been provided." >&2
        show_usage
      exit 2
      fi
      ;;
    -p|--password)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        password=$2
        shift 2
      else
        log_error "Error: A value for parameter [Password] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -g|--grafanads)
      grafanads_user="true"
      shift
      ;;
    -h|--help)
      show_usage=1
      shift
      ;;
    -*|--*=) # unsupported flags
      log_error "Error: Unsupported flag $1" >&2
      show_usage
      exit 2
      ;;
    *) # preserve positional arguments
      POS_PARMS="$POS_PARMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$POS_PARMS"

if [ "$#" -lt 1 ]; then
    log_error "No ACTION specified; exiting."
    show_usage
    exit 1
else
   action=$(echo $1|tr '[a-z]' '[A-Z]')
   shift

   if [ "$action" != "CREATE" ] &&  [ "$action" != "DELETE" ] ; then
      log_error "Invalid action [$action] specified; exiting"
      show_usage
      exit 1
   fi
fi

log_debug "Action: $action"

if [ "$show_usage" == "1" ]; then
   show_usage $action
   exit
fi

# No positional parameters (other than ACTION) are supported
if [ "$#" -ge 1 ]; then
    log_error "Unexpected additional arguments were found; exiting."
    show_usage
    exit 4
fi


log_debug "POS_PARMS: $POS_PARMS"

# Convert namespace and tenant to all lower-case
namespace=$(echo "$namespace"| tr '[:upper:]' '[:lower:]')
tenant=$(echo "$tenant"| tr '[:upper:]' '[:lower:]')


if [ "$namespace" == "_all_" ] && [ "$tenant" == "_all_" ]; then
   if [ -z "$username"  ] && [ "$grafanads_user" != "true" ]; then
     log_error "Required parameter USERNAME not specified"
     show_usage $action
     exit 4
   fi
   cluster="true"
   namespace=''
   tenant=''
else
   cluster="false"

   if [ -z "$username"  ] && [ -z "$namespace" ]; then
     log_error "Required parameter(s) NAMESPACE and/or USERNAME not specified"
     show_usage $action
     exit 4
   fi
fi

log_debug "CLUSTER: $cluster NAMESPACE: $namespace TENANT: $tenant NST: $nst USERNAME: $username"

# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)


# Get Security API URL
get_sec_api_url

if [ -z "$sec_api_url" ]; then
   log_error "Unable to determine URL to access security API endpoint"
   exit 1
fi


case "$action" in
   CREATE)
      if [ "$cluster" == "true" ]; then
         if [ "$grafanads_user" == "true" ]; then
            berole="V4MCLUSTER_ADMIN_grafana_dsusers"
            pwdchangetxt="Do NOT use OpenSearch Dashboards or API, MUST re-run Grafana datasource creation script"
         else
            berole="V4MCLUSTER_ADMIN_kibana_users"
         fi
         rolename="search_index_-ALL-"
         scope="ALL namespaces"
      else
         if [ -z "$namespace" ]; then
            log_error "Required argument NAMESPACE no specified"
            echo ""
            show_usage CREATE
            exit 1
         fi

         if [ -n "$tenant" ]; then
            nst="${namespace}_${tenant}"
            scope="the tenant [$tenant] within the namespace [$namespace]"
         else
            nst="$namespace"
            scope="namespace [$namespace]"
         fi

         rolename=search_index_$nst

         if [ "$grafanads_user" == "true" ]; then
            berole="${nst}_grafana_dsusers"
            pwdchangetxt="Do NOT use OpenSearch Dashboards or API, MUST re-run Grafana datasource creation script"
         else
            berole="${nst}_kibana_users"

            if [ -z "$username" ]; then
               username="${nst}_admin"
            fi
         fi
      fi

      log_info "Attempting to create user [$username] and grant them access to log messages from $scope [$(date)]"

      # Check if user exists
      if user_exists $username; then
         log_error "A user with this name [$username] already exists."
         exit 1
      fi

      #Check if role exists
      if ! role_exists $rolename; then
         log_error "The expected access control role [$rolename] does NOT exist."
         if [ "$cluster" != "true" ]; then
            log_error "You must on-oboard $scope to create required the access control role."
         fi
         exit 1
      fi

      password=${password:-$username}

      if [ -z "$namespace" ]; then
         nsconstraint="-none-"
      else
         nsconstraint=$namespace
      fi
      if [ -z "$tenant" ]; then
         tconstraint="-none-"
      else
         tconstraint=$tenant
      fi

      if [ -z "$pwdchangetxt" ]; then
         pwdchangetxt="Use OpenSearch Dashboards or API"
      fi

      exitnow="false"
      weakpass="false"
      loopcounter=1
      until [ "$exitnow" == "true" ]
      do

         cp logging/opensearch/rbac/user.json $TMP_DIR/user.json
         # Replace PLACEHOLDERS
         sed -i'.bak' "s/xxBEROLExx/$berole/g"             $TMP_DIR/user.json      # (NAMESPACE|NAMESPACE_TENANT|'V4MCLUSTER_ADMIN') + '_kibana_users'
         sed -i'.bak' "s/xxNSCONSTRAINTxx/$nsconstraint/g" $TMP_DIR/user.json      # NAMESPACE|'-none-'
         sed -i'.bak' "s/xxTCONSTRAINTxx/$tconstraint/g"   $TMP_DIR/user.json      # TENANT|'-none-'
         sed -i'.bak' "s/xxPASSWORDxx/$password/g"         $TMP_DIR/user.json      # PASSWORD
         sed -i'.bak' "s/xxCREATEDBYxx/$this_script/g"     $TMP_DIR/user.json      # CREATEDBY
         sed -i'.bak' "s/xxPWDCHANGEXX/$pwdchangetxt/g"    $TMP_DIR/user.json      # PASSWORD CHANGE MECHANISM (OSD|change_internal_password.sh script)
         sed -i'.bak' "s/xxDATETIMExx/$(date)/g"           $TMP_DIR/user.json      # DATE

         log_debug "Contents of user.json template file after substitutions: \n $(cat $TMP_DIR/user.json)"


         #remove any existing instance of this file
         rm -f $TMP_DIR/user_create.txt

         # Create user
         response=$(curl -s -o $TMP_DIR/user_create.txt -w "%{http_code}" -XPUT "$sec_api_url/internalusers/$username"  -H 'Content-Type: application/json' -d @$TMP_DIR/user.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

         if grep -i 'weak password' $TMP_DIR/user_create.txt >/dev/null 2>&1; then
            log_warn "The password specified for user [$username] did not meet complexity requirements of OpenSearch."
            log_warn "A randomly generated password will be used instead."
            log_warn "Check notices below for additional details."
            weakpassword="true"
            password="$(randomPassword)"
            exitnow="false"
         else
            exitnow="true"
         fi

         ((loopcounter++))

         if [[ $loopcounter -gt 3 ]]; then
            exitnow='true'
            log_debug "Weak password check looped too many times [$loopcounter]"
         else
            log_debug "Weak password check loop [$loopcounter]"
         fi
      done

      if [[ $response != 2* ]]; then
         log_error "There was an issue creating the user [$username]. [$response]"
         exit 1
      else
         log_info "User [$username] created. [$response]"
      fi
      log_notice "User [$username] added to internal user database [$(date)]"
      add_notice "                                                          "
      add_notice "User [$username] added to internal user database. "

      if [ "$weakpassword" == "true" ]; then
         add_notice '+------------------------------------------------------------------------------+'
         add_notice '|.............IMPORTANT NOTICE: REQUESTED PASSWORD REJECTED....................|'
         add_notice '+------------------------------------------------------------------------------+'
         add_notice "The specified password failed the complexity requirements of OpenSearch."
         add_notice "The password [$password] was generated randomly for [$username]."
         add_notice "$pwdchangetxt to change the password later."
      fi
      add_notice " "

      ;;
   DELETE)
      if [ -z "$username" ]; then
         log_error "Required argument USERNAME not specified"
         echo ""
         show_usage DELETE
         exit 1
      fi

      log_info "Attempting to remove user [$username] from the internal user database [$(date)]"

      # Check if user exists
      if ! user_exists $username; then
         log_error "There was an issue deleting the user [$username]; the user does NOT exists."
         exit 1
      else
         log_debug "User [$username] exists."
      fi

      # Delete user
      response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "$sec_api_url/internalusers/$username"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
      if [[ $response != 2* ]]; then
         log_error "There was an issue deleting the user [$username]. [$response]"
         exit 1
      else
         log_info "User [$username] deleted. [$response]"
         log_notice "User [$username] removed from internal user database [$(date)]"
      fi
      ;;
   *)
      log_error "Invalid action specified"
      exit 1
   ;;
esac


LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
   echo ""
   display_notices
   echo ""
fi
