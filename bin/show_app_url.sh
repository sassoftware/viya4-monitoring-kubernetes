#! /bin/bash

# Copyright © 2021-2026 SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
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

    if [ -n "$(get_k8s_info "$namespace" "httpproxy/$servicename" "$metadata_name")" ]; then

        status="$(check_httpproxy_status "$namespace" "$servicename")"
        if [ "$status" != "valid" ]; then
            msg="$(get_httpproxy_error "$namespace" "$servicename")"

            add_noticew "--------------------------------------------------------------------------------------------------------"
            add_noticew "  WARNING: ***** Access to [$service] may not be available until the following issue is addressed. *****"
            add_noticew ""
            add_noticew "  NOTE: The HTTPProxy resource [$namespace/$servicename] reports an [$status] status"
            add_noticew "        The issue reported is [$msg]"

            root_httpproxy="$(get_root_httpproxy "$namespace" "$servicename")"
            if [ "$root_httpproxy" = "$last_root_httpproxy" ]; then
                log_debug "Have already reported on state of this 'root' HTTPProxy [$root_httpproxy]"
            elif [ "$root_httpproxy" != " " ]; then

                last_root_httpproxy="$root_httpproxy"

                IFS=/ read -r rootnamespace rootservicename <<< "$root_httpproxy"

                root_status="$(check_httpproxy_status "$rootnamespace" "$rootservicename")"

                if [ "$root_status" != "valid" ]; then
                    root_msg="$(get_httpproxy_error "$rootnamespace" "$rootservicename")"

                    add_noticew " "
                    add_noticew "  WARNING: In addition, the associated 'root' HTTPProxy resource [$rootnamespace/$rootservicename] reports an [$root_status] status"
                    add_noticew "        The issue reported is [$root_msg]"
                    add_noticew " "
                fi
            fi

            add_noticew "--------------------------------------------------------------------------------------------------------"
            add_notice ""
        else
            log_debug "HTTPProxy [$namespace/$servicename] is valid"
        fi
    fi
done

add_notice " Note: The URL(s) shown might be incorrect if your ingress controller or other"
add_notice "       network configuration include options that this script does not process."
add_notice ""

LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
    echo ""
    display_notices
    echo ""
fi

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
