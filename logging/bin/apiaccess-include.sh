#! /bin/bash

# Copyright Â© 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

source bin/service-url-include.sh

function get_sec_api_url {

   sec_api_url=$(get_service_url "$LOG_NS" "v4m-es-client-service" "/_opendistro/_security/api" true)

   if [ -z "$sec_api_url" ]; then
      # set up temporary port forwarding to allow curl access
      log_debug "Will use Kubernetes port-forwarding to access security API endpoint"

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
      sec_api_url="https://localhost:$TEMP_PORT/_opendistro/_security/api"

      trap_add stop_portforwarding EXIT
   fi
   log_debug "Security API Endpoint: [$sec_api_url]"

}

function stop_portforwarding {
   # terminate port-forwarding process if PID was cached

   if [ -n "$pfPID" ]; then
      log_debug "Killing port-forwarding process [$pfPID]"
      kill  -9 $pfPID
   else
      log_debug "No portforwarding processID found; nothing to terminate."
   fi
}

#initialize "global" vars
pfPID=""
sec_api_url=""

export -f get_sec_api_url stop_portforwarding
