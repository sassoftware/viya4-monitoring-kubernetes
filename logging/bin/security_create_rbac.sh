#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#
# Creates the following RBAC structures
#
#                                   /-- [ROLE: kibana_user]       (allows access to Kibana)
# [BACKEND_ROLE: {NS}_kibana_user]<-
#                                   \-- [ROLE: search_index_{NS}] (allows access to log messages from {NS})
#
#
#
# READONLY ROLE
#
#                                        /- [ROLE: cluster_ro_perms]  (limits access to cluster to read-only)
#                                       /-- [ROLE: kibana_read_only]  (limits Kibana access to read-only)
#                                      /--- [ROLE: kibana_user]       (allows access to Kibana)
# [BACKEND_ROLE: {NS}_kibana_ro_user]<-
#                                      \--- [ROLE: search_index_{NS}] (allows access to log messages from {NS})
#

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

function show_usage {
  log_info  "Usage: $this_script NAMESPACE"
  log_info  ""
  log_info  "Creates access control artifacts (e.g. roles, role-mappings, etc.) to limit access to the specified namespace."
  log_info  ""
  log_info  "        NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace for which access controls should be created"
}

NAMESPACE=${1}
READONLY=${2:-false}


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
else
  log_notice "Creating access controls for namespace [$NAMESPACE] [$(date)]"
fi

INDEX_PREFIX=viya_logs
ROLENAME=search_index_$NAMESPACE
BE_ROLENAME=${NAMESPACE}_kibana_users
RO_BE_ROLENAME=${NAMESPACE}_kibana_ro_users

log_debug "NAMESPACE: $NAMESPACE ROLENAME: $ROLENAME"

# Copy RBAC templates
cp logging/es/odfe/rbac $TMP_DIR -r

# Replace PLACEHOLDERS
sed -i "s/xxIDXPREFIXxx/$INDEX_PREFIX/gI"  $TMP_DIR/rbac/*.json                  # IDXPREFIX
sed -i "s/xxNAMESPACExx/$NAMESPACE/gI"     $TMP_DIR/rbac/*.json                  # NAMESPACE


# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)


#temp file to hold responses
tmpfile=$TMP_DIR/output.txt

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

#Check if role exists already
response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/roles/$ROLENAME"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then

  # Create Viya deployment-restricted role
  response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_opendistro/_security/api/roles/$ROLENAME" -H 'Content-Type: application/json' -d @$TMP_DIR/rbac/index_role.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
  if [[ $response != 2* ]]; then
     log_error "There was an issue creating the security role [$ROLENAME] [$response]"
     kill -9 $pfPID
     exit 20
  else
     log_info "Security role [$ROLENAME] created [$response]"
  fi
else
  log_info "The security role [$ROLENAME] already exists; using existing definition. [$response]"
fi

# Create role-mapping b/w Viya deployment-restricted role <==> backend-role(s)
response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/$ROLENAME"  -H 'Content-Type: application/json' -d @$TMP_DIR/rbac/index_role_backend_rolemapping${READONLY_FLAG}.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue creating the rolemapping between [$ROLENAME] and backend-role(s) [$response]"
   kill -9 $pfPID
   exit 21
else
   log_info "Security rolemapping created between [$ROLENAME] and backend-role(s). [$response]"
fi


# Create role-mapping b/w kibana_user <==> backend-role(s)
response=$(curl -s -o /dev/null -w "%{http_code}" -XPATCH "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping"  -H 'Content-Type: application/json' -d @$TMP_DIR/rbac/kibana_user_backend_rolemapping${READONLY_FLAG}.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue creating the rolemapping between [kibana_user] and backend-role(s) [$response]"
   kill -9 $pfPID
   exit 22
else
   log_info "Security rolemapping created between [kibana_user] and backend-role(s). [$response]"
fi

# Additional work needed for create deployment-restricted READ_ONLY Kibana role
if [ "$READONLY" == "true" ]; then

  #Check if CLUSTER_RO_PERMS role exists already
  response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/roles/cluster_ro_perms"   --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
  if [[ $response != 2* ]]; then

     # Create CLUSTER_RO_PERMS role
     response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_opendistro/_security/api/roles/cluster_ro_perms"  -H 'Content-Type: application/json' -d @$TMP_DIR/rbac/cluster_ro_perms_role.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
     if [[ $response != 2* ]]; then
        log_error "There was an issue creating the security role [$ROLENAME] [$response]"
        kill -9 $pfPID
        exit 20
     else
        log_info "Security role [cluster_ro_perms] created [$response]"
     fi
  else
    log_debug "Role [cluster_ro_perms] already exists."
  fi

  # Create role-mapping b/w CLUSTER_RO_PERMS <==> read-only backend-role
  response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/cluster_ro_perms"  -H 'Content-Type: application/json' -d @$TMP_DIR/rbac/ro_role_backend_rolemapping.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
  if [[ $response != 2* ]]; then
     log_error "There was an issue creating the rolemapping between [cluster_ro_perms] and backend-role [$RO_BE_ROLENAME]. [$response]"
     kill -9 $pfPID
     exit 21
  else
     log_info "Security rolemapping created between [cluster_ro_perms] and backend-role [$RO_BE_ROLENAME]. [$response]"
  fi

  # Create role-mapping b/w KIBANA_READ_ONLY <==> read-only backend-role
  response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/kibana_read_only"   -H 'Content-Type: application/json' -d @$TMP_DIR/rbac/ro_role_backend_rolemapping.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
  if [[ $response != 2* ]]; then
     log_error "There was an issue creating the rolemapping between [kibana_read_only] and backend-role [$RO_BE_ROLENAME]. [$response]"
     kill -9 $pfPID
     exit 21
  else
     log_info "Security rolemapping created between [kibana_read_only] and backend-role [$RO_BE_ROLENAME]. [$response]"
  fi

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
log_notice "== Assign users the back-end role of [${BE_ROLENAME}] to grant access to log messages for [$NAMESPACE] namespace and Kibana =="
if [ "$READONLY" == "true" ]; then
   log_notice "== Assign users the back-end role of [${RO_BE_ROLENAME}] to grant access to log messages for [$NAMESPACE] namespace but limit Kibana access to READ-ONLY =="
fi
log_notice "============================================================================================================================"
