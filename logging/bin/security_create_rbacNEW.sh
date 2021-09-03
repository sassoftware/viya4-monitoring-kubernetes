#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#
# Creates the following RBAC structures (NST=NAMESPACE|NAMESPACE-__TENANT__):
# 
#
#                                    /-- [ROLE: kibana_user]       (allows access to Kibana)
# [BACKEND_ROLE: {NST}_kibana_user]<-
#                                    \-- [ROLE: search_index_{NST}] (allows access to log messages from {NST})
#
#
#
# READONLY ROLE
#
#                                         /- [ROLE: cluster_ro_perms]  (limits access to cluster to read-only)
#                                        /-- [ROLE: kibana_read_only]  (limits Kibana access to read-only)
#                                       /--- [ROLE: kibana_user]       (allows access to Kibana)
# [BACKEND_ROLE: {NST}_kibana_ro_user]<-
#                                       \--- [ROLE: search_index_{NST}] (allows access to log messages from {NST})
#

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

function show_usage {
  log_message  "Usage: $this_script NAMESPACE [TENANT]"
  log_message  ""
  log_message  "Creates access controls (e.g. roles, role-mappings, etc.) to limit access to the specified namespace and, optionally, the specified tenant within that namespace."
  log_message  ""
  log_message  "        NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace for which access controls should be created"
  log_message  ""
  log_message  "        TENANT    - (Optional) The tenant with the Viya deployment/Kubernetes Namespace for which access controls should be created"
  log_message  ""
}

#TO DO: Move to named args

NAMESPACE=${1}
TENANT=${2}
READONLY=${3:-false}

if [ "$TENANT" == "--add_read_only" ]; then
   READONLY="--add_read_only"
   TENANT=""
fi

if [ "$READONLY" == "--add_read_only" ]; then
 READONLY="true"
 READONLY_FLAG="_ro"
elif [[ "$READONLY" =~ -H|--HELP|-h|--help ]]; then
 show_usage
 exit
elif [ "$READONLY" != "false" ]; then
 log_error "Unrecognized additional option(s) [$READONLY] provided."
 show_usage
 exit 2
fi

if [ -z "$NAMESPACE" ]; then
  log_error "Required argument NAMESPACE no specified"
  echo  ""
  show_usage
  exit 4
elif [[ "$NAMESPACE" =~ -H|--HELP|-h|--help ]]; then
 show_usage
 exit
fi

if [[ "$TENANT" =~ -H|--HELP|-h|--help ]]; then
   show_usage
   exit
elif [ -n "$TENANT" ]; then
   NST="${NAMESPACE}-__${TENANT}__"
else
   NST="$NAMESPACE"
fi

if [ -n "$TENANT" ]; then
  log_notice "Creating access controls for tenant [$TENANT] within namespace [$NAMESPACE] [$(date)]"
else
  log_notice "Creating access controls for namespace [$NAMESPACE] [$(date)]"
fi


INDEX_PREFIX=viya_logs
#ROLENAME=search_index_$NAMESPACE
#BE_ROLENAME=${NAMESPACE}_kibana_users
ROLENAME=search_index_$NST
BE_ROLENAME=${NST}_kibana_users
if [ "$READONLY" == "true" ]; then
   #RO_BE_ROLENAME=${NAMESPACE}_kibana_ro_users
   RO_BE_ROLENAME=${NST}_kibana_ro_users
else
   RO_BE_ROLENAME="null"
fi

log_debug "NST: $NST TENANT: $TENANT NAMESPACE: $NAMESPACE ROLENAME: $ROLENAME RO_BE_ROLENAME: $RO_BE_ROLENAME "


# Copy RBAC templates
cp logging/es/odfe/rbac $TMP_DIR -r

# Replace PLACEHOLDERS
sed -i'.bak' "s/xxIDXPREFIXxx/$INDEX_PREFIX/g"  $TMP_DIR/rbac/*.json                  # IDXPREFIX
#sed -i'.bak' "s/xxNAMESPACExx/$NAMESPACE/g"     $TMP_DIR/rbac/*.json                  # NAMESPACE
sed -i'.bak' "s/xxNAMESPACExx/$NST/g"     $TMP_DIR/rbac/*.json                  # NAMESPACE


# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)


#temp file to hold responses
tmpfile=$TMP_DIR/output.txt


# TO DO: Replace w/function call that uses existing ES connection or establishes one via port-forwarding

# set up temporary port forwarding to allow curl access
ES_PORT=$(kubectl -n $LOG_NS get service v4m-es-client-service -o=jsonpath='{.spec.ports[?(@.name=="http")].port}')

# command is sent to run in background
kubectl -n $LOG_NS port-forward --address localhost svc/v4m-es-client-service :$ES_PORT > $tmpfile  &

# get PID to allow us to kill process later
pfPID=$!
log_debug "pfPID: $pfPID"

# pause to allow port-forwarding messages to appear
sleep 5s

# determine which port port-forwarding is using
pfRegex='Forwarding from .+:([0-9]+)'
myline=$(head -n1  $tmpfile)

if [[ $myline =~ $pfRegex ]]; then
   TEMP_PORT="${BASH_REMATCH[1]}";
   log_debug "TEMP_PORT=${TEMP_PORT}"
else
   set +e
   log_error "Unable to obtain or identify the temporary port used for port-forwarding; exiting script.";
   kill -9 $pfPID
   rm -f  $tmpfile
   exit 18
fi



function role_exists {
   #Check if $role role exists
   #
   # Returns: 0 - Role exists
   #          1 - Role does not exist

   local role

   role=$1

   response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/roles/$role"   --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
   if [[ $response == 2* ]]; then
      log_debug "Confirmed [$role] exists."
      return 0
   else
      log_debug "Role [$role] does not exist."
      return 1
   fi
}

function create_role {
   # Creates role using provided role template
   #
   # Returns: 0 - Role created
   #          1 - Role NOT created

   local role role_template

   role=$1
   role_template=$2

   response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_opendistro/_security/api/roles/$role"  -H 'Content-Type: application/json' -d @${role_template}  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

   if [[ $response == 2* ]]; then
      log_info "Security role [$role] created [$response]"
      return  0
   else
      log_error "There was an issue creating the security role [$role] [$response]"
      log_debug "template contents: /n $(cat $role_template)"
      return 1
   fi
}

function ensure_role_exists {
   # Ensures specified role exists; creating it if necessary
   #
   # Returns: 0 - Role exists or was created
   #          1 - Role does NOT exist and/or was NOT created

   local role role_template

   role=$1
   role_template=${2:-null}

   if  role_exists $role; then
      return 0
   else
      if [ -n "$role_template" ]; then
         rc=$()
         if create_role $role $role_template; then
            return 0
         else
            return 1
         fi
      else
         # couldn't create it b/c we didn't have a template
         log_debug "No role template provided; did not attempt to create role [$role]"
         return 1
      fi
  fi

 }


function add_rolemapping {
 # adds $ROLENAME and $RO_BE_ROLENAME to the
 # rolemappings for $targetrole (create $targetrole if it does NOT exists)

 targetrole=$1
 berole=$2
 log_debug "Parms passed to add_rolemapping function  targetrole=$targetrole  berole=$berole"


 # get existing rolemappings for $targetrole
 response=$(curl -s -o $TMP_DIR/rolemapping.json -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/$targetrole"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

 if [[ $response == 404 ]]; then
    log_debug "Rolemappings for [$targetrole] do not exist; creating rolemappings. [$response]"

    json='{"backend_roles" : ["'"$berole"'"]}'
    verb=PUT

 elif [[ $response == 2* ]]; then
    log_debug "Existing rolemappings for [$targetrole] obtained. [$response]"
    log_debug "$(cat $TMP_DIR/rolemapping.json)"

    if [ "$(grep $berole  $TMP_DIR/rolemapping.json)" ]; then
       log_debug "A rolemapping between [$targetrole] and  back-end role [$berole] already appears to exist; leaving as-is."
       return
    else
       json='[{"op": "add","path": "/backend_roles/-","value":"'"$berole"'"}]'
       verb=PATCH
    fi

 else
     log_error "There was an issue getting the existing rolemappings for [$targetrole]. [$response]"
     kill -9 $pfPID
     exit 17
 fi

 log_debug "JSON data passed to curl [$verb]: $json"

 response=$(curl -s -o /dev/null -w "%{http_code}" -X${verb} "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/$targetrole"  -H 'Content-Type: application/json' -d "$json" --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
 if [[ $response != 2* ]]; then
    log_error "There was an issue creating the rolemapping between [$targetrole] and backend-role(s) ["$berole"]. [$response]"
    kill -9 $pfPID
    exit 22
 else
    log_info "Security rolemapping created between [$targetrole] and backend-role(s) ["$berole"]. [$response]"
 fi

}

#index user
ensure_role_exists $ROLENAME $TMP_DIR/rbac/index_role.json
add_rolemapping $ROLENAME $BE_ROLENAME 

#kibana_user
add_rolemapping kibana_user $BE_ROLENAME null

# Create restricted READ_ONLY Kibana role as well
if [ "$READONLY" == "true" ]; then

   #index user
   add_rolemapping $ROLENAME $RO_BE_ROLENAME

   #kibana_user
   add_rolemapping kibana_user $RO_BE_ROLENAME

   #cluster_ro_perms
   ensure_role_exists cluster_ro_perms $TMP_DIR/rbac/cluster_ro_perms_role.json
   add_rolemapping cluster_ro_perms $RO_BE_ROLENAME

   #kibana_read_only
   add_rolemapping kibana_read_only $RO_BE_ROLENAME
fi

# terminate port-forwarding and remove tmpfile
log_info "You may see a message below about a process being killed; it is expected and can be ignored."
kill  -9 $pfPID
rm -f $tmpfile

#pause to allow port-forward kill message to appear
sleep 7s

log_notice "Access controls created [$(date)]"
echo ""
log_notice "============================================================================================================================"
if [ -n "$TENANT" ]; then
   log_notice "   Assign users the back-end role of [${BE_ROLENAME}] to grant access to Kibana and limit access to log messages for the [$TENANT] tenant within the [$NAMESPACE] namespace"
else
   log_notice "   Assign users the back-end role of [${BE_ROLENAME}] to grant access to Kibana and limit access to log messages for [$NAMESPACE] namespace "
fi
if [ "$READONLY" == "true" ]; then
   log_notice " Assign users the back-end role of [${RO_BE_ROLENAME}] to grant access to log messages for [$TENANT/$NAMESPACE] namespace but limit Kibana access to READ-ONLY ="
fi
log_notice "============================================================================================================================"
