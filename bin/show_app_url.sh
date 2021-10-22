#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/.."
source bin/common.sh
source bin/service-url-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

# Fixed-width version of add_notice
function add_notice_wide {
  width=$(tput cols 2>/dev/null)
  if [ "$width" == "" ]; then
    width=80
  fi
  n=$(expr $width - $(echo "$1" | wc -c))
  if [ $n -lt 0 ]; then
     n=0
  fi
  # Fill remaining characters with spaces
  add_notice "$1$(printf %$(eval 'echo $n')s |tr ' ' ' ')"
}

set +e

# call function to get HTTP/HTTPS ports from ingress controller
get_ingress_ports

add_notice_wide ""
add_notice_wide "Accessing the monitoring applications"
add_notice_wide ""

#start looping through services
servicelist=${@:-"ALL"}
if [ "$servicelist" == "ALL" ]; then
   servicelist="KIBANA ELASTICSEARCH GRAFANA"
fi

log_debug "Application URLs requested for [$servicelist]"

for service in $servicelist
do
   case  "$service" in
     KIBANA)
        namespace=${LOG_NS:-"logging"}
        servicename="v4m-es-kibana-svc"
        ingressname="v4m-es-kibana"
        tls_flag="$LOG_KB_TLS_ENABLE"
        ;;
     ELASTICSEARCH)
        namespace=${LOG_NS:-"logging"}
        servicename="v4m-es-client-service"
        ingressname=""
        tls_flag="true"
        ;;
     GRAFANA)
        namespace=${MON_NS:-"monitoring"}
        servicename="v4m-grafana"
        ingressname="v4m-grafana"
        tls_flag="$TLS_ENABLE"
        ;;
     PROMETHEUS)
        namespace=${MON_NS:-"monitoring"}
        servicename="v4m-prometheus"
        ingressname="v4m-prometheus"
        tls_flag="$TLS_ENABLE"
        ;;
     ALERTMANAGER)
        namespace=${MON_NS:-"monitoring"}
        servicename="v4m-alertmanager"
        ingressname="v4m-alertmanager"
        tls_flag="$TLS_ENABLE"
        ;;

     *)
        log_error "Invalid service [$service] specified; valid values are [GRAFANA, KIBANA, ELASTICSEARCH or ALL]"
        exit 1
        ;;
   esac

   # get URLs for requested services
   log_debug "Function call: get_service_url $namespace $servicename $tls_flag $ingressname"
   service_url=$(get_service_url "$namespace" "$servicename"  "$tls_flag" "$ingressname")

   # Print URLs
   add_notice_wide "*** $service ***"
   if [ ! -z "$service_url" ]; then
      add_notice_wide "  You can access $service via the following URL:"
      add_notice_wide "    $service_url"
      add_notice_wide ""
   else
      add_notice_wide "  It was not possible to determine the URL needed to access $service"
      add_notice_wide ""
   fi
done


add_notice_wide " Note: These URLs may be incorrect if your ingress and/or other network"
add_notice_wide "       configuration includes options this script does not handle."
add_notice_wide ""

LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
   echo ""
   display_notices
   echo ""
fi

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
