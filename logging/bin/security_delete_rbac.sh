#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#
# Deletes the following RBAC structure
#
#                                   /-- [ROLE: kibana_user]           |only link to backend role is deleted; kibana_user role NOT deleted
# [BACKEND_ROLE: {NS}_kibana_user]<-                                  |{NS}_kibana_user backend-role IS deleted
#                                   \-- [ROLE: search_index_{NS}]     |search_index_{NS} role IS deleted
#
#

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

NAMESPACE=${1}

if [ -z "$NAMESPACE" ]; then
  log_error "Required argument NAMESPACE not specified"
  log_info  ""
  log_info  "Usage: $this_script NAMESPACE"
  log_info  ""
  log_info  "Deletes access control artifacts (e.g. roles, role-mappings, etc.) previously created to limit access to the specified namespace."
  log_info  ""
  log_info  "        NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace for which access controls should be deleted"

  exit 4
else
  log_notice "Deleting access controls for namespace [$NAMESPACE] [$(date)]"
fi


ROLENAME=search_index_$NAMESPACE
BACKENDROLE=${NAMESPACE}_kibana_users
BACKENDROROLE=${NAMESPACE}_kibana_ro_users

log_debug "NAMESPACE: $NAMESPACE ROLENAME: $ROLENAME BACKENDROLE: $BACKENDROLE"


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



# Delete role-mappings for Viya deployment-restricted role
response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/$ROLENAME"   --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue deleting the rolemappings for [$ROLENAME] [$response]"
   kill -9 $pfPID
   exit 17
else
   log_info "Security rolemappings for [$ROLENAME]. [$response]"
fi


# Delete Viya deployment-restricted role
response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "https://localhost:$TEMP_PORT/_opendistro/_security/api/roles/$ROLENAME"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue deleting the security role [$ROLENAME] [$response]"
   kill -9 $pfPID
   exit 16
else
   log_info "Security role [$ROLENAME] deleted [$response]"
fi


#
# handle KIBANA_USER
#

# get existing rolemappings for kibana_user
response=$(curl -s -o $TMP_DIR/ku_rm.json -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/kibana_user"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

if [[ $response != 2* ]]; then
   log_error "There was an issue getting the existing rolemappings for [kibana_user]. [$response]"
   kill -9 $pfPID
   exit 17
else
   log_info "Existing rolemappings for [kibana_user] obtained. [$response]"
fi

# Extract and reconstruct backend_roles array from rolemapping json
newroles=$(grep -oP '"backend_roles":\[(.*)\],"h' $TMP_DIR/ku_rm.json | grep -oP '\[.*\]' | sed "s/\"$BACKENDROLE\"//;s/\"$BACKENDROROLE\"//;s/,,,/,/;s/,,/,/; s/,]/]/" )
log_debug "Updated Back-end Roles (kibana_user): $newroles"

# Copy RBAC template
cp logging/es/odfe/rbac/backend_rolemapping_delete.json $TMP_DIR/kibana_user_backend_rolemapping_delete.json

#update json template file w/revised list of backend roles
sed -i "s/xxBACKENDROLESxx/$newroles/gI"     $TMP_DIR/kibana_user_backend_rolemapping_delete.json # BACKENDROLES

# Replace the rolemappings for the kibana_user with the revised list of backend roles
response=$(curl -s -o /dev/null -w "%{http_code}" -XPATCH "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/kibana_user"  -H 'Content-Type: application/json' -d @$TMP_DIR/kibana_user_backend_rolemapping_delete.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue updating the rolesmapping for [kibana_user] to remove link with backend-role(s) [$BACKENDROLE]. [$response]"
   kill -9 $pfPID
   exit 17
else
   log_info "Security rolemapping deleted between [kibana_user] and backend-role(s) [$BACKENDROLE]. [$response]"
fi

#
# handle KIBANA_READ_ONLY
#

# get existing rolemappings for kibana_read_only
response=$(curl -s -o $TMP_DIR/kr_rm.json -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/kibana_read_only"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

if [[ $response != 2* ]]; then
   log_error "There was an issue getting the existing rolemappings for [kibana_read_only]. [$response]"
   kill -9 $pfPID
   exit 17
else
   log_info "Existing rolemappings for [kibana_read_only] obtained. [$response]"
fi

# Extract and reconstruct backend_roles array from rolemapping json
newroles=$(grep -oP '"backend_roles":\[(.*)\],"h' $TMP_DIR/kr_rm.json | grep -oP '\[.*\]' | sed "s/\"$BACKENDROLE\"//;s/\"$BACKENDROROLE\"//;s/,,,/,/;s/,,/,/; s/,]/]/" )
log_debug "Updated Back-end Roles (kibana_read_only): $newroles"

# Copy RBAC template
cp logging/es/odfe/rbac/backend_rolemapping_delete.json $TMP_DIR/kibana_ro_backend_rolemapping_delete.json

#update json template file w/revised list of backend roles
sed -i "s/xxBACKENDROLESxx/$newroles/gI"     $TMP_DIR/kibana_ro_backend_rolemapping_delete.json # BACKENDROLES

# Replace the rolemappings for the kibana_user with the revised list of backend roles
response=$(curl -s -o /dev/null -w "%{http_code}" -XPATCH "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/kibana_read_only"  -H 'Content-Type: application/json' -d @$TMP_DIR/kibana_ro_backend_rolemapping_delete.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue updating the rolesmapping for [kibana_read_only] to remove link with backend-role [$BACKENDROROLE]. [$response]"
   kill -9 $pfPID
   exit 17
else
   log_info "Security rolemapping deleted between [kibana_read_only] and backend-role [$BACKENDROROLE]. [$response]"
fi

#
# handle CLUSTER_RO_PERMS
#

#Check if CLUSTER_RO_PERMS role exists 
response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/roles/cluster_ro_perms"   --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response == 2* ]]; then

  # get existing rolemappings for cluster_ro_perms
  response=$(curl -s -o $TMP_DIR/cr_rm.json -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/cluster_ro_perms"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

  if [[ $response != 2* ]]; then
     log_error "There was an issue getting the existing rolemappings for [cluster_ro_perms]. [$response]"
     kill -9 $pfPID
     exit 17
  else
     log_info "Existing rolemappings for [cluster_ro_perms] obtained. [$response]"
  fi

  # Extract and reconstruct backend_roles array from rolemapping json
  newroles=$(grep -oP '"backend_roles":\[(.*)\],"h' $TMP_DIR/cr_rm.json | grep -oP '\[.*\]' | sed "s/\"$BACKENDROLE\"//;s/\"$BACKENDROROLE\"//;s/,,,/,/;s/,,/,/; s/,]/]/" )
  log_debug "Updated Back-end Roles (cluster_ro_perms): $newroles"

  # Copy RBAC template
  cp logging/es/odfe/rbac/backend_rolemapping_delete.json $TMP_DIR/cluster_ro_rolemapping_delete.json

  #update json template file w/revised list of backend roles
  sed -i "s/xxBACKENDROLESxx/$newroles/gI"     $TMP_DIR/cluster_ro_rolemapping_delete.json # BACKENDROLES

  # Replace the rolemappings for the cluster_ro with the revised list of backend roles
  response=$(curl -s -o /dev/null -w "%{http_code}" -XPATCH "https://localhost:$TEMP_PORT/_opendistro/_security/api/rolesmapping/cluster_ro_perms"  -H 'Content-Type: application/json' -d @$TMP_DIR/cluster_ro_rolemapping_delete.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
  if [[ $response != 2* ]]; then
     log_error "There was an issue updating the rolesmapping for [cluster_ro_perms] to remove link with backend-role [$BACKENDROROLE]. [$response]"
     kill -9 $pfPID
     exit 17
  else
     log_info "Security rolemapping deleted between [cluster_ro_perms] and backend-role [$BACKENDROROLE]. [$response]"
  fi

fi # cluster_ro_perms role exists

# terminate port-forwarding and remove tmpfile
log_info "You may see a message below about a process being killed; it is expected and can be ignored."
kill  -9 $pfPID
rm -f $tmpfile

#pause to allow port-forward kill message to appear
sleep 7s

log_notice "Access controls deleted [$(date)]"
echo ""
log_notice "==============================================================================================================="
log_notice "== You should delete any users whose only purpose was to access log messages from the [$NAMESPACE] namespace =="
log_notice "==============================================================================================================="

