#! /bin/bash

# Copyright Â© 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

# Global variables used/set by functions in this file
#    es_api_url  - URL to access ES API/serivce
#    kb_api_url  - URL to access KB API/serivce
#    espfpid     - process id of ES portforwarding
#    kbpfpid     - process id of KB portforwarding
#    sec_api_url - URL to access ODFE Security API/serivce
#    pfPID       - process id used for portforwardign

source bin/service-url-include.sh

function stop_portforwarding {
   # terminate port-forwarding process if PID was cached

   local pid
   pid=${1:-$pfPID}

   if [ -n "$pid" ]; then
      log_debug "Killing port-forwarding process [$pid]."
      kill  -9 $pid
      wait $pid 2>/dev/null  # suppresses message reporting process has been killed
   else
      log_debug "No portforwarding processID found; nothing to terminate."
   fi
}

function stop_es_portforwarding {
   #
   # terminate ES port-forwarding process
   #
   # Global vars:      espfpid - process id of ES portforwarding

   if [ -n "$espfpid" ]; then
      log_debug "ES PF PID for stopping: $espfpid"
      stop_portforwarding $espfpid
      unset espfpid
   fi
}

function stop_kb_portforwarding {
   #
   # terminate KB port-forwarding process
   #
   # Global vars:      kbpfpid - process id of KB portforwarding

   if [ -n "$kbpfpid" ]; then
      log_debug "KB PF PID for stopping: $kbpfpid"
      stop_portforwarding $kbpfpid
      unset kbpfpid
   fi
 }

function get_api_url {
   #
   # determine URL to access specified API/service
   #
   # Global vars:      api_url - URL to access requested API/serivce
   #                   pfPID   - process id used for portforwarding
   #
   local servicename portpath usetls serviceport
   servicename=$1
   portpath=$2
   usetls=${3:-false}
   ingress=$4

   api_url=$(get_service_url "$LOG_NS" "$servicename" "$usetls" $ingress)

   if [ -z "$api_url" ] || [ "$LOG_ALWAYS_PORT_FORWARD" == "true" ]; then
      # set up temporary port forwarding to allow curl access
      log_debug "Will use Kubernetes port-forwarding to access"
      log_debug "LOG_ALWAYS_PORT_FORWARD: $LOG_ALWAYS_PORT_FORWARD api_url: $api_url"

      serviceport=$(kubectl -n $LOG_NS get service $servicename -o=jsonpath=$portpath)
      log_debug "serviceport: $serviceport"

      # command is sent to run in background
      kubectl -n $LOG_NS port-forward --address localhost svc/$servicename :$serviceport > $tmpfile  &

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
         log_error "Unable to obtain or identify the temporary port used for port-forwarding; exiting script.";
         return 1
      fi

      if [ "$usetls" == "true" ]; then
         protocol="https"
      else
         protocol="http"
      fi

      api_url="$protocol://localhost:$TEMP_PORT"

   fi
   log_debug "API Endpoint for [$servicename]: $api_url"
}


function get_es_api_url {
   #
   # obtain ES API/service URL (establish port-forwarding, if necessary)
   #
   # Global vars:      es_api_url - URL to access ES API/serivce
   #                   espfpid    - process id of ES portforwarding

   if [ -n "$es_api_url" ]; then
      log_debug "Elasticsearch API Endpoint already set [$es_api_url]"
      return 0
   fi

   pfPID=""
   get_api_url "v4m-es-client-service" '{.spec.ports[?(@.name=="http")].port}' true
   rc=$?

   if [ "$rc" == "0" ]; then
      es_api_url=$api_url
      espfpid=$pfPID
      trap_add stop_es_portforwarding EXIT
      return 0
   else
      return 1
   fi
}

function get_kb_api_url {
   #
   # obtain KB API/service URL (establish port-forwarding, if necessary)
   #
   # Global vars:      kb_api_url - URL to access KB API/serivce
   #                   kbpfpid    - process id of KB portforwarding

   if [ -n "$kb_api_url" ]; then
      log_debug "Kibana API Endpoint already set [$kb_api_url]"
      return 0
   fi

   pfPID=""
   get_api_url "v4m-es-kibana-svc" '{.spec.ports[?(@.name=="kibana-svc")].port}' $LOG_KB_TLS_ENABLE v4m-es-kibana-ing
   rc=$?

   if [ "$rc" == "0" ]; then
      kb_api_url=$api_url
      kbpfpid=$pfPID
      trap_add stop_kb_portforwarding EXIT
      return 0
   else
      return 1
   fi
}

function get_sec_api_url {
   #
   # obtain ODFE Security API/service URL (calls get_es_api_url function, if necessary)
   #
   # Global vars:      sec_api_url - URL to access ODFE Security API/serivce

 if [ -n "$sec_api_url" ]; then
    log_debug "Security API Endpoint already set [$sec_api_url]"
    return 0
 fi

 get_es_api_url
 rc=$?

 if [ "$rc" == "0" ]; then
    sec_api_url="${es_api_url}/_opendistro/_security/api"
    log_debug "Security API Endpoint: [$sec_api_url]"
    return 0
 else
    sec_api_url=""
    return 1
 fi
}


export -f get_sec_api_url stop_portforwarding get_es_api_url get_kb_api_url stop_es_portforwarding stop_kb_portforwarding


#initialize "global" vars
export es_api_url kb_api_url espfpid kbpfpid sec_api_url pfPID

#create a temp file to hold curl response
if [ -z "$tmpfile" ]; then
   tmpfile=$TMP_DIR/curl_response.txt
fi
