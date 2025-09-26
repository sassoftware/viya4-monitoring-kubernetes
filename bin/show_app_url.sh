#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/.." || exit
source bin/common.sh
source bin/service-url-include.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

#Set TLS_ENABLE to 'true' if not explictly set already
TLS_ENABLE=${TLS_ENABLE:-true}

set +e

# call function to get HTTP/HTTPS ports from ingress controller
get_ingress_ports

add_notice ""
add_notice "**Accessing the monitoring applications**"
add_notice ""

#start looping through services
servicelist=${*:-"ALL"}
servicelist=$(echo "$servicelist" | tr '[:lower:]' '[:upper:]')

if [ "$servicelist" == "ALL" ]; then
    servicelist="GRAFANA OS OSD"
fi

log_debug "Application URLs requested for [$servicelist]"

for service in $servicelist; do
    case "$service" in
    OPENSEARCHDASHBOARDS | OPENSEARCHDASHBOARD | OSD)
        service="OpenSearch Dashboards"
        namespace=${LOG_NS:-"logging"}
        servicename="v4m-osd"
        ingressname="v4m-osd"
        tls_flag=$(kubectl -n "$namespace" get secret v4m-osd-tls-enabled -o=jsonpath="{.data.enable_tls}" --ignore-not-found | base64 --decode)
        ;;
    OPENSEARCH | OS)
        service="OpenSearch"
        namespace=${LOG_NS:-"logging"}
        servicename="v4m-search"
        ingressname="v4m-search"
        tls_flag="true"
        ;;
    GRAFANA | GRAF | GR)
        namespace=${MON_NS:-"monitoring"}
        service="Grafana"
        servicename="v4m-grafana"
        ingressname="v4m-grafana"
        tls_flag="$TLS_ENABLE"
        ;;
    PROMETHEUS | PROM | PR)
        namespace=${MON_NS:-"monitoring"}
        service="Prometheus"
        servicename="v4m-prometheus"
        ingressname="v4m-prometheus"
        tls_flag="$TLS_ENABLE"
        ;;
    ALERTMANAGER | AM)
        namespace=${MON_NS:-"monitoring"}
        service="Alertmanager"
        servicename="v4m-alertmanager"
        ingressname="v4m-alertmanager"
        tls_flag="$TLS_ENABLE"
        ;;

    *)
        log_error "Invalid application [$service] specified".
        log_error "Valid values are [GRAFANA, OPENSEARCH, OPENSEARCHDASHBOARDS or ALL]"
        exit 1
        ;;
    esac

    # get URLs for requested services
    log_debug "Function call: get_service_url $namespace $servicename $tls_flag $ingressname"

    service_url=$(get_service_url "$namespace" "$servicename" "$tls_flag" "$ingressname")

    # Print URLs
    # add_notice "*** $service ***"
    if [ -n "$service_url" ]; then
        add_notice "  You can access $service via the following URL:"
        add_notice "    $service_url"
        add_notice ""
    else
        add_notice "  It was not possible to determine the URL needed to access $service"
        add_notice ""
    fi
done

add_notice " Note: The URL might be incorrect if your Ingress configuration, another network"
add_notice "       configuration, or both include options that this script does not process."
add_notice ""

LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
    echo ""
    display_notices
    echo ""
fi

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
