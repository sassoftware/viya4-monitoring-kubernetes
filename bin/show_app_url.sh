#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/.."
source bin/common.sh
source bin/service-url-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

set +e

# call function to get HTTP/HTTPS ports from ingress controller
get_ingress_ports

add_notice ""
add_notice "**Accessing the monitoring applications**"
add_notice ""

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
        ingressname="v4m-es-kibana-ing"
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
   # add_notice "*** $service ***"
   if [ ! -z "$service_url" ]; then
      add_notice "  You can access $service via the following URL:"
      add_notice "    $service_url"
      add_notice ""
   else
      add_notice "  It was not possible to determine the URL needed to access $service"
      add_notice ""
   fi
done


add_notice " Note: These URLs may be incorrect if your ingress and/or other network"
add_notice "       configuration includes options this script does not handle."
add_notice ""

LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
   echo ""
   display_notices
   echo ""
fi

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
