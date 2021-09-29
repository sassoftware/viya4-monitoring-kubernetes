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
       log_info  ""
       log_info  "Usage: $this_script CREATE [REQUIRED_PARAMETERS] [OPTIONS] "
       log_info  ""
       log_info  "Creates a user in the internal user database and limits their access to only log messages from the specified namespace and, optionally, more narrowly, to the specified tenant within the specified namespace"
       log_info  ""
       log_info  "     -ns, --namespace   NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace to which this user should be granted access"
       log_info  "     -t,  --tenant      TENANT    - (Optional) The tenant within the specific Viya deployment/Kubernetes Namespace to which this user should be granted access."
       log_info  "     -u,  --user        USERNAME  - (Optional) The username to be created (default: [NAMESPACE]|[NAMESPACE_TENANT]_admin)"
       log_info  "     -p,  --password    PASSWORD  - (Optional) The password for the newly created account (default: [USERNAME])"
       echo ""
       ;;
    "DELETE")
       log_info  "Usage: $this_script DELETE [REQUIRED_PARAMETERS]"
       log_info  ""
       log_info  "Removes the specified user from the internal user database"
       log_info  ""
       log_info  "     -u,  --user        USERNAME  - (Required) The username to be deleted."
       ;;
    *)
       log_info  ""
       log_info  "Usage: $this_script ACTION [REQUIRED_PARAMETERS] [OPTIONS] "
       log_info  ""
       log_info  "Creates or deletes a user in the internal user database.  Newly created users are granted permission limiting their access to log messages for the specified namespace, and, optionally, to a specific tenant within that namespace."
       log_info  ""
       log_info  "        ACTION - (Required) one of the following actions: [CREATE, DELETE]"
       log_info  ""
       log_info  "        Additional help information, including details of required and optional parameters, can be displayed by submitting the command: $this_script ACTION --help"
       echo ""
       ;;
  esac
}

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

action=$(echo $1|tr '[a-z]' '[A-Z]')
shift

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

if [ -n "$tenant" ]; then
   nst="${namespace}_${tenant}"
else
   nst="$namespace"
fi

if [ -z "$username"  ] && [ -z "$namespace" ]; then
  log_error "Required parameter(s) NAMESPACE and/or USERNAME not specified"
  show_usage $action
  exit 4
elif [ -z "$username" ]; then
  username="${nst}_admin"
fi

log_debug "NAMESPACE: $namespace TENANT: $tenant NST: $nst USERNAME: $username"

# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)

#temp file to hold responses
tmpfile=$TMP_DIR/output.txt

# Get Security API URL
get_sec_api_url

if [ -z "$sec_api_url" ]; then
   log_error "Unable to determine URL to access security API endpoint"
   exit 1
fi



# Check if user exists
response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "$sec_api_url/internalusers/$username"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response == 404 ]]; then
   user_exists=false
else
   user_exists=true
fi
log_debug "USER_EXISTS: $user_exists"

case "$action" in
   CREATE)
      if [ -z "$namespace" ]; then
         log_error "Required argument NAMESPACE no specified"
         echo ""
         show_usage CREATE
         exit 1
      fi
      if [ -n "$tenant" ]; then
         nst="${namespace}_${tenant}"
         log_info "Attempting to create user [$username] and grant them access to the tenant [$tenant] within the namespace [$namespace] [$(date)]"
      else
         nst="$namespace"
         log_info "Attempting to create user [$username] and grant them access to namespace [$namespace] [$(date)]"
      fi

      # Check if user exists
      if [[ "$user_exists" == "true" ]]; then
         log_error "A user with this name [$username] already exists. [$response]"
          exit 1
      fi

      index_prefix=viya_logs
      rolename=search_index_$nst

      #Check if role exists
      if ! role_exists $rolename; then
         log_error "The expected access control role [$rolename] does NOT exist; the role must be created before users can be linked to that role."
         exit 1
      fi

      password=${password:-$username}
      if [ -z "$tenant" ]; then
         tconstraint="-none-"
      else
         tconstraint=$tenant
      fi

      cp logging/es/odfe/rbac $TMP_DIR -r

      # Replace PLACEHOLDERS
      sed -i'.bak' "s/xxIDXPREFIXxx/$index_prefix/g"  $TMP_DIR/rbac/*.json                  # IDXPREFIX
      sed -i'.bak' "s/xxNSTxx/$nst/g"                 $TMP_DIR/rbac/*.json                  # NAMESPACE|NAMESPACE_TENANT
      sed -i'.bak' "s/xxNAMESPACExx/$namespace/g"     $TMP_DIR/rbac/*.json                  # NAMESPACE
      sed -i'.bak' "s/xxTENANTxx/$tenant/g"           $TMP_DIR/rbac/*.json                  # TENANT
      sed -i'.bak' "s/xxTCONSTRAINTxx/$tconstraint/g" $TMP_DIR/rbac/*.json                  # TENANT|'-none-'
      sed -i'.bak' "s/xxPASSWORDxx/$password/g"       $TMP_DIR/rbac/*.json                  # PASSWORD
      sed -i'.bak' "s/xxCREATEDBYxx/$this_script/g"   $TMP_DIR/rbac/*.json                  # CREATEDBY
      sed -i'.bak' "s/xxDATETIMExx/$(date)/g"         $TMP_DIR/rbac/*.json                  # DATE

      log_debug "Contents of user.json template file after substitutions: \n $(cat $TMP_DIR/rbac/user.json)"


      # Create user
      response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$sec_api_url/internalusers/$username"  -H 'Content-Type: application/json' -d @$TMP_DIR/rbac/user.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

      if [[ $response != 2* ]]; then
         log_error "There was an issue creating the user [$username]. [$response]"
         exit 1
      else
      log_info "User [$username] created. [$response]"
      fi
      log_notice "User [$username] added to internal user database [$(date)]"
      add_notice "                                                          "
      add_notice "   User [$username] added to internal user database.      "
      add_notice "                                                          "
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
      if [[ "$user_exists" != "true" ]]; then
         log_error "There was an issue deleting the user [$username]; the user does NOT exists. [$response]"
         exit 1
      else
         log_debug "User [$username] exists. [$response]"
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


#remove tmpfile
rm -f $tmpfile

LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
   echo ""
   display_notices
   echo ""
fi
