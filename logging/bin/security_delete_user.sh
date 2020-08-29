#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

USERNAME=${1}

log_debug "USERNAME: $USERNAME"


if [ -z "$USERNAME" ]; then
  log_error "Required argument USERNAME not specified"
  log_info  ""
  log_info  "Usage: $this_script USERNAME"
  log_info  ""
  log_info  "Removes the specified user from the internal user database"
  log_info  ""
  log_info  "        USERNAME  - (Required) The username to be deleted"
  exit 4
else
  log_notice "Removing user [$USERNAME] from the internal user database [$(date)]"
fi


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
response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "https://localhost:$TEMP_PORT/_opendistro/_security/api/internalusers/$USERNAME"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response == 404 ]]; then
   log_error "There was an issue deleting the user [$USERNAME]; the user does NOT exists. [$response]"
   kill -9 $pfPID
   exit 20
else
   log_debug "User [$USERNAME] exists. [$response]"
fi

# Delete user
response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "https://localhost:$TEMP_PORT/_opendistro/_security/api/internalusers/$USERNAME"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue deleting the user [$USERNAME]. [$response]"
   kill -9 $pfPID
   exit 17
else
   log_info "User [$USERNAME] deleted. [$response]"
fi


# terminate port-forwarding and remove tmpfile
log_info "You may see a message below about a process being killed; it is expected and can be ignored."
kill  -9 $pfPID
rm -f $tmpfile


log_notice "User [$USERNAME] removed from internal user database [$(date)]"
