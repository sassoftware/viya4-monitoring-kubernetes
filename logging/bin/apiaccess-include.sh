#! /bin/bash

# Copyright Â© 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

source bin/service-url-include.sh
trap_add() {
 # based on https://stackoverflow.com/questions/3338030/multiple-bash-traps-for-the-same-signal
 # but prepends new cmd rather than append it

    local cmd_to_add signal

    cmd_to_add=$1; shift
    for signal in "$@"; do
        trap -- "$(
            # print the new trap command
            printf '%s\n' "${cmd_to_add}"
            # helper fn to get existing trap command from output
            # of trap -p
            extract_trap_cmd() { printf '%s\n' "$3"; }
            # print existing trap command with newline
            eval "extract_trap_cmd $(trap -p "${signal}")"
        )" "${signal}" 
    done
}
export -f  trap_add


function stop_portforwarding {
   # terminate port-forwarding process if PID was cached

   local pfpid
   pfpid=${1:-$pfPID}

   if [ -n "$pfpid" ]; then
      log_debug "Killing port-forwarding process [$pfpid]"
      kill  -9 $pfpid
      wait $pfpid 2>/dev/null
   else
      log_debug "No portforwarding processID found; nothing to terminate."
   fi
}

function stop_es_portforwarding {
   if [ -n "$espfpid" ]; then
      log_debug "ES PF PID for stopping: $espfpid"
      stop_portforwarding $espfpid
      unset espfpid
   fi
}

function stop_kb_portforwarding {
   if [ -n "$kbpfpid" ]; then
      log_debug "KB PF PID for stopping: $kbpfpid"
      stop_portforwarding $kbpfpid
      unset kbpfpid
   fi
 }

function get_api_url {

   local servicename portpath usetls serviceport
   servicename=$1
   portpath=$2
   usetls=${3:-false}

   api_url=$(get_service_url "$LOG_NS" "$servicename" "/" "$usetls")

   if [ -z "$api_url" ] || [ "$LOG_ALWAYS_PORT_FORWARD" == "true" ]; then
      # set up temporary port forwarding to allow curl access
      log_debug "Will use Kubernetes port-forwarding to access"

      serviceport=$(kubectl -n $LOG_NS get service $servicename -o=jsonpath=$portpath)

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
      api_url="https://localhost:$TEMP_PORT/"

   fi
   log_debug "API Endpoint for [$servicename]: $api_url"
}


function get_es_api_url {

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

   if [ -n "$kb_api_url" ]; then
      log_debug "Kibana API Endpoint already set [$kb_api_url]"
      return 0
   fi

   pfPID=""
   get_api_url "v4m-es-kibana-svc" '{.spec.ports[?(@.name=="kibana-svc")].port}' false
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
 if [ -n "$sec_api_url" ]; then
    log_debug "Security API Endpoint already set [$sec_api_url]"
    return 0
 fi

 get_es_api_url
 rc=$?

 if [ "$rc" == "0" ]; then
    sec_api_url="${es_api_url}_opendistro/_security/api"
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
   tmpfile=$TMP_DIR/output.txt
fi
