#! /bin/bash

# Copyright © 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/.." || exit 1
source bin/common.sh

this_script=$(basename "$0")
log_debug "Script [$this_script] has started [$(date)]"

if [ "$AUTOGENERATE_SOURCED" != "true" ]; then
    # shellcheck disable=SC2034
    AUTOGENERATE_INGRESS="true"

    # shellcheck disable=SC2034
    INGRESS_TYPE="ingress-nginx"
else
    log_debug "Script [create_httpproxy.sh] running within another script execution"
    if [ "$ROUTING" != "path" ] && [ "${1}" == "ROOT" ]; then
        log_debug "ROOT HTTPProxy resources are only appropriate when path-based routing is used. Nothing to do; exiting."
        exit
    fi
fi

source bin/autogenerate-include.sh

app="${1}"   #AM|GR|OS|OSD|PR|ROOT|LOG|MON|ALL|ALL_LOG|ALL_MON|
app="$(echo "$app" | tr '[:lower:]' '[:upper:]')"

arg2="${2}"   #ROOT: appgroup  All others: path
arg3="${3}"   #ROOT: appgroup2 All others: fqdn
arg4="${4}"   #ROOT: n/a       All others: secret

case "$app" in
"ALERTMANAGER" | "AM")
    enable_alertmanager="true"
    ;;
"GRAFANA" | "GR")
    enable_grafana="true"
    ;;
"OPENSEARCH" | "OS")
    enable_opensearch="true"
    ;;
"OSD" | "OPENSEARCHDASHBOARD" | "OPENSEARCHDASHBOARDS")
    enable_osd="true"
    ;;
"PROMETHEUS" | "PR")
    enable_prometheus="true"
    ;;
"ROOT")
    ### create_root_httpproxy  "logging"
    ### create_root_httpproxy  APP_GROUP
    if [ "$ROUTING" != "path" ]; then
        log_warn "Root HTTPProxy requested but ROUTING is currently set to [host]."
        log_warn "Root HTTPProxy resources are only appropriate when path-based routing is used. Nothing to do; exiting."
        exit 0
    fi

    case "$arg3" in
    ALL_MON)
        if [ "$arg2" == "logging" ]; then
            log_error "Invalid argument [$arg3] included in request to generate ROOT HTTPProxy resource for 'logging' resources."
            exit 1
        fi
        ;;
    ALL_LOG)
        if [ "$arg2" == "monitoring" ] ; then
            log_error "Invalid argument [$arg3] included in request to generate ROOT HTTPProxy resource for 'monitoring' resources."
            exit 1
        fi
        ;;
    ALL)
        :  #do nothing, "ALL"is a valid value for arg3
        ;;
    "" )
        :  #do nothing, arg3 NOT required
        ;;
    *)
        log_error "Unrecognized argument [$arg3] included in request to generate ROOT HTTPProxy resource."
        exit 1
        ;;
    esac

    if [ "$arg3" == "ALL_MON" ] || [ "$arg3" == "ALL" ]; then
        # shellcheck disable=SC2034
        GRAFANA_INGRESS_ENABLE=true
        # shellcheck disable=SC2034
        ALERTMANAGER_INGRESS_ENABLE=true
        # shellcheck disable=SC2034
        PROMETHEUS_INGRESS_ENABLE=true
    fi

    if [ "$arg3" == "ALL_LOG" ] || [ "$arg3" == "ALL" ]; then
        # shellcheck disable=SC2034
        OPENSEARCH_INGRESS_ENABLE=true
        # shellcheck disable=SC2034
        OSD_INGRESS_ENABLE=true
    fi

    create_root_httpproxy  "$arg2"
    ;;
"ALL")
    log_debug "Creating HTTPProxy resources for *all* monitoring web applications"
    enable_alertmanager="true"
    enable_grafana="true"
    enable_prometheus="true"
    enable_opensearch="true"
    enable_osd="true"
    arg3=""
    arg4=""
    ;;
"ALL_MON" | "ALL_MONITORING" )
    log_debug "Creating HTTPProxy resources for *all* metric monitoring web applications"
    enable_alertmanager="true"
    enable_grafana="true"
    enable_prometheus="true"
    arg3=""
    arg4=""
    ;;
"ALL_LOG" | "ALL_LOGGING" )
    log_debug "Creating HTTPProxy resources for *all* log monitoring web applications"
    enable_opensearch="true"
    enable_osd="true"
    arg3=""
    arg4=""
    ;;
"MON" | "MONITORING" )
    log_debug "Creating HTTPProxy resources for metric monitoring web applications"
    enable_alertmanager="${ALERTMANAGER_INGRESS_ENABLE}"
    enable_grafana="${GRAFANA_INGRESS_ENABLE}"
    enable_prometheus="${PROMETHEUS_INGRESS_ENABLE}"

    arg3=""
    arg4=""

    create_root_httpproxy  "monitoring"

    ;;
"LOG" | "LOGGING" )
    log_debug "Creating HTTPProxy resources for log monitoring web applications"
    enable_opensearch="${OPENSEARCH_INGRESS_ENABLE}"
    enable_osd="${OSD_INGRESS_ENABLE}"
    arg3=""
    arg4=""

    create_root_httpproxy  "logging"

    ;;

"" | *)
    log_error "Application name is invalid or missing."
    log_error "The APPLICATION NAME is required; valid values are: Grafana, OpenSearch, OpenSearchDashboards, Prometheus or Alertmanager"
    exit 1
    ;;
esac

if [ "$enable_alertmanager" == "true" ]; then
    amPath="${arg2:-$ALERTMANAGER_PATH}"
    amFqdn="${arg3:-$ALERTMANAGER_FQDN}"
    amSecret="${arg4:-alertmanager-ingress-tls-secret}"

    if [ -z "$amPath" ]; then
        amPath="alertmanager"
    fi

    create_httpproxy  "monitoring" "alertmanager" "$amPath" "$amFqdn" "$amSecret"
fi

if [ "$enable_grafana" == "true" ]; then
    grPath="${arg2:-$GRAFANA_PATH}"
    grFqdn="${arg3:-$GRAFANA_FQDN}"
    grSecret="${arg4:-grafana-ingress-tls-secret}"

    if [ -z "$grPath" ]; then
        grPath="grafana"
    fi
    create_httpproxy  "monitoring" "grafana" "$grPath" "$grFqdn" "$grSecret"
fi

if [ "$enable_opensearch" == "true" ]; then
    osPath="${arg2:-$OPENSEARCH_PATH}"
    osFqdn="${arg3:-$OPENSEARCH_FQDN}"
    osSecret="${arg4:-elasticsearch-ingress-tls-secret}"

    if [ -z "$osPath" ]; then
        osPath="search"
    fi
    create_httpproxy  "logging" "opensearch" "$osPath" "$osFqdn" "$osSecret"
fi

if [ "$enable_osd" == "true" ]; then
    osdPath="${arg2:-$OSD_PATH}"
    osdFqdn="${arg3:-$OSD_FQDN}"
    osdSecret="${arg4:-kibana-ingress-tls-secret}"

    if [ -z "$osdPath" ]; then
        osdPath="dashboards"
    fi
    create_httpproxy  "logging" "osd" "$osdPath" "$osdFqdn" "$osdSecret"
fi

if [ "$enable_prometheus" == "true" ]; then
    prPath="${arg2:-$PROMETHEUS_PATH}"
    prFqdn="${arg3:-$PROMETHEUS_FQDN}"
    prSecret="${arg4:-prometheus-ingress-tls-secret}"

    if [ -z "$prPath" ]; then
        prPath="prometheus"
    fi
    create_httpproxy  "monitoring" "prometheus" "$prPath" "$prFqdn" "$prSecret"
fi

    ### create_httpproxy       "monitoring" "prometheus" "$PROMETHEUS_FQDN" "$targetPath" "$ingress_tls_secret"
    ### create_httpproxy       APP_GROUP    APP_PREFIX   FQDN               PATH           SECRETNAME

    ### create_root_httpproxy  "logging"
    ### create_root_httpproxy  APP_GROUP

### 03FEB26
##  Still *requires* following environment variables be set:
##      no more: AUTOGENERATE_INGRESS
##      no more: INGRESS_TYPE
##      BASE_DOMAIN
##      LOG_NS
##      MON_NS
##  Still reacts to the following environment variables:
##      ROUTING
##      INGRESS_USE_SEPARATE_CERTS
##
##  TO DO: HTTPProxy resources report as invalid when secret does not exist.
##  TO DO: Feature-flag non-critical-path options?
##  TO DO: Do status-check before exiting?  All HTTPProxy resources in namespace?  Only one created?
