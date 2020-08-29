#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

NAMESPACE=${1}
USERNAME=${2:-${NAMESPACE}}
PASSWORD=${3:-${PASSWORD:-$USERNAME}}

INDEX_PREFIX=viya_logs
ROLENAME=search_index_$NAMESPACE

log_debug "NAMESPACE: $NAMESPACE USERNAME: $USERNAME PASSWORD: $PASSWORD ROLENAME: $ROLENAME"


if [ -z "$NAMESPACE" ]; then
  log_error "Required argument NAMESPACE no specified"
  log_info  ""
  log_info  "Usage: $this_script NAMESPACE [USERNAME] [PASSWORD]"
  log_info  ""
  log_info  "Creates user in internal user database and grants them permission to access log messages for the specified namespace"
  log_info  ""
  log_info  "        NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace to which this user should be granted access"
  log_info  "        USERNAME  - (Optional) The username to be created (defaults to match NAMESPACE)"
  log_info  "        PASSWORD  - (Optional) The password for the newly created account (defaults to match USERNAME)"

  exit 4
else
  log_notice "Creating user [$USERNAME] with access to namespace [$NAMESPACE] [$(date)]"
fi

cp logging/es/odfe/rbac $TMP_DIR -r

# Replace PLACEHOLDERS
sed -i "s/xxIDXPREFIXxx/$INDEX_PREFIX/gI"  $TMP_DIR/rbac/*.json                  # IDXPREFIX
sed -i "s/xxNAMESPACExx/$NAMESPACE/gI"     $TMP_DIR/rbac/*.json                  # NAMESPACE
sed -i "s/xxPASSWORDxx/$PASSWORD/gI"       $TMP_DIR/rbac/*.json                  # PASSWORD
sed -i "s/xxCREATEDBYxx/$this_script/gI"   $TMP_DIR/rbac/*.json                  # CREATEDBY
sed -i "s/xxDATETIMExx/$(date)/gI"         $TMP_DIR/rbac/*.json                  # DATE


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


# Check if user exists
# Create user
response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/internalusers/$USERNAME"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 404 ]]; then
   log_error "There was an issue creating the user [$USERNAME]; user already exists. [$response]"
   kill -9 $pfPID
   exit 19
else
   log_debug "User [$USERNAME] does not exist. [$response]"
fi

# Create user
response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_opendistro/_security/api/internalusers/$USERNAME"  -H 'Content-Type: application/json' -d @$TMP_DIR/rbac/user.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue creating the user [$USERNAME]. [$response]"
   kill -9 $pfPID
   exit 17
else
   log_info "User [$USERNAME] created. [$response]"
fi


# terminate port-forwarding and remove tmpfile
log_info "You may see a message below about a process being killed; it is expected and can be ignored."
kill  -9 $pfPID
rm -f $tmpfile
