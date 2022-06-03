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
#    ism_api_url - URL to access Index State Management (ISM) API/serivce
#    sec_api_url - URL to access ODFE Security API/serivce
#    pfPID       - process id used for portforwardign

source bin/service-url-include.sh

function stop_portforwarding {
   # terminate port-forwarding process if PID was cached

   local pid
   pid=${1:-$pfPID}

   if [ -o errexit ]; then
      restore_errexit=Y
      log_debug "Toggling errexit: Off"
      set +e
   fi

   if ps -p "$pid" >/dev/null;  then
      log_debug "Killing port-forwarding process [$pid]."
      kill -9 $pid
      wait $pid 2>/dev/null  # suppresses message reporting process has been killed
   else
      log_debug "No portforwarding processID found; nothing to terminate."
   fi

   if [ -n "$restore_errexit" ]; then
      log_debug "Toggling errexit: On"
      set -e
   fi

}

function stop_es_portforwarding {
   #
   # terminate ES port-forwarding process
   #
   # Global vars:      espfpid    - process id of ES portforwarding
   #                   es_api_url - URL to access ES API/serivce

   if [ -n "$espfpid" ]; then
      log_debug "ES PF PID for stopping: $espfpid"
      stop_portforwarding $espfpid
      unset espfpid
      unset es_api_url
   fi
}

function stop_kb_portforwarding {
   #
   # terminate KB port-forwarding process
   #
   # Global vars:      kbpfpid    - process id of KB portforwarding
   #                   kb_api_url - URL to access KB API/serivce

   if [ -n "$kbpfpid" ]; then
      log_debug "KB PF PID for stopping: $kbpfpid"
      stop_portforwarding $kbpfpid
      unset kbpfpid
      unset kb_api_url
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
      kubectl -n $LOG_NS port-forward --address localhost svc/$servicename :$serviceport > $tmpfile 2>/dev/null &

      # get PID to allow us to kill process later
      pfPID=$!
      log_debug "pfPID: $pfPID"

      # pause to allow port-forwarding messages to appear
      sleep 5

      # determine which port port-forwarding is using
      pfRegex='Forwarding from .+:([0-9]+)'
      myline=$(head -n1  $tmpfile)

      if [[ $myline =~ $pfRegex ]]; then
         TEMP_PORT="${BASH_REMATCH[1]}";
         log_debug "TEMP_PORT=${TEMP_PORT}"
      else
         log_error "Unable to identify the temporary port used for port-forwarding [$servicename]; exiting script.";
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
   get_api_url "$ES_SERVICENAME" '{.spec.ports[?(@.name=="http")].port}' true

   rc=$?

   if [ "$rc" == "0" ]; then
      es_api_url=$api_url
      espfpid=$pfPID
      trap_add stop_es_portforwarding EXIT
      return 0
   else
      log_error "Unable to obtain the URL for the Elasticsearch API Endpoint"
      return 1
   fi
}

function get_kb_api_url {
   #
   # obtain KB API/service URL (establish port-forwarding, if necessary)
   #
   # Global vars:      kb_api_url - URL to access KB API/service
   #                   kbpfpid    - process id of KB portforwarding

   #NOTE: Use of args implemented to support migration of
   # ODFE 1.7 Kibana content to OpenSearch Dashoards ONLY!
   LOG_SEARCH_BACKEND=${1:-$LOG_SEARCH_BACKEND}
   KB_SERVICENAME=${2:-$KB_SERVICENAME}
   KB_SERVICEPORT=${3:-$KB_SERVICEPORT}
   KB_INGRESSNAME=${4:-$KB_INGRESSNAME}
   KB_TLS_ENABLED=${5}

   if [ -n "$kb_api_url" ]; then
      log_debug "Kibana API Endpoint already set [$kb_api_url]"
      return 0
   fi

   pfPID=""

   if [ -n "$KB_TLS_ENABLED" ]; then
      tlsrequired="$KB_TLS_ENABLED"
      log_debug "Kibana TLS setting [$KB_TLS_ENABLED] explicitly passed to get_kb_api_url"
   elif [ "$LOG_SEARCH_BACKEND" != "OPENSEARCH" ]; then
      tlsrequired="$(kubectl -n $LOG_NS get pod -l role=kibana -o=jsonpath='{.items[*].metadata.annotations.tls_required}')"
   else
      tlsrequired="$(kubectl -n $LOG_NS get secret v4m-osd-tls-enabled -o=jsonpath={.data.enable_tls} |base64 --decode)"
   fi
   log_debug "TLS required to connect to Kibana? [$tlsrequired]"

   get_api_url "$KB_SERVICENAME" '{.spec.ports[?(@.name=="'${KB_SERVICEPORT}'")].port}'  $tlsrequired  $KB_INGRESSNAME
   rc=$?

   if [ "$rc" == "0" ]; then
      kb_api_url=$api_url
      kbpfpid=$pfPID
      trap_add stop_kb_portforwarding EXIT
      return 0
   else
      log_error "Unable to obtain the URL for the Kibana API Endpoint"
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
    sec_api_url="${es_api_url}/$ES_PLUGINS_DIR/_security/api"

    log_debug "Security API Endpoint: [$sec_api_url]"
    return 0
 else
    sec_api_url=""
    log_error "Unable to obtain the URL for the Security API Endpoint"
    return 1
 fi
}

function get_ism_api_url {
   #
   # obtain Index State Managment API/service URL (calls get_es_api_url function, if necessary)
   #
   # Global vars:      ism_api_url - URL to access ISM API/serivce

 if [ -n "$ism_api_url" ]; then
    log_debug "Index Statement Management API Endpoint already set [$ism_api_url]"
    return 0
 fi

 get_es_api_url
 rc=$?

 if [ "$rc" == "0" ]; then
    ism_api_url="${es_api_url}/$ES_PLUGINS_DIR/_ism"

    log_debug "Index State Management API Endpoint: [$ism_api_url]"
    return 0
 else
    ism_api_url=""
    log_error "Unable to obtain the URL for the Index State Management API Endpoint"
    return 1
 fi
}


export -f get_ism_api_url get_sec_api_url stop_portforwarding get_es_api_url get_kb_api_url stop_es_portforwarding stop_kb_portforwarding


#initialize "global" vars
LOG_ALWAYS_PORT_FORWARD=${LOG_ALWAYS_PORT_FORWARD:-true}
export es_api_url kb_api_url espfpid kbpfpid sec_api_url pfPID LOG_ALWAYS_PORT_FORWARD

#create a temp file to hold curl response
if [ -z "$tmpfile" ]; then
   tmpfile=$TMP_DIR/curl_response.txt
fi
