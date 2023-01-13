#! /bin/bash

# Copyright Â© 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/.."

source bin/common.sh
source bin/tls-include.sh

export LOG_NS="${LOG_NS:-logging}"
export MON_NS="${MON_NS:-monitoring}"

set -e

function restart-resources {
  app=$1
  case "$app" in
     "OPENSEARCH"|"OS")
        namespace=$LOG_NS
        resourceName=${OS_RESOURCENAME:-"v4m-search"}

        kubectl rollout restart statefulset "$resourceName" -n "$namespace"

        log_info "[Opensearch] statefulset restarted"
        ;;
     "OPENSEARCHDASHBOARDS"|"DASHBOARDS"|"OSD")
        namespace=$LOG_NS
        resourceName=${OSD_RESOURCENAME:-"v4m-osd"}

        kubectl rollout restart deployment "$resourceName" -n "$namespace"

        log_info "[Opensearch Dashboard] deployment restarted"
        ;;
     "ALERTMANAGER"|"AM")
        namespace=$MON_NS
        resourceName=${AM_RESOURCENAME:-"alertmanager-v4m-alertmanager"}

        kubectl rollout restart statefulset "$resourceName" -n "$namespace"

        log_info "[Alertmanager] statefulset restarted"
        ;;
     "PROMETHEUS"|"PROM"|"PRO"|"PR")
        namespace=$MON_NS
        resourceName=${PROM_RESOURCENAME:-"prometheus-v4m-prometheus"}

        kubectl rollout restart statefulset "$resourceName" -n "$namespace"

        log_info "[Prometheus] statefulset restarted"
        ;;
     "GRAFANA"|"GRAF"|"GR")
        namespace=$MON_NS
        resourceName=${GR_RESOURCENAME:-"v4m-grafana"}

        kubectl rollout restart deployment "$resourceName" -n "$namespace"

        log_info "[Grafana] deployment restarted"
        ;;
     "ALL-MON")
        namespace=$MON_NS
        alertmanagerResourceName=${AM_RESOURCENAME:-"alertmanager-v4m-alertmanager"}
        prometheusResourceName=${PROM_RESOURCENAME:-"prometheus-v4m-prometheus"}
        grafanaResourceName=${GR_RESOURCENAME:-"v4m-grafana"}

        kubectl rollout restart statefulset "$alertmanagerResourceName" -n "$namespace"
        kubectl rollout restart statefulset "$prometheusResourceName" -n "$namespace"
        kubectl rollout restart deployment "$grafanaResourceName" -n "$namespace"

        log_info "[Altermanager, Prometheus, Grafana] have been restarted"
        ;;
     "ALL-LOG")
        namespace=$LOG_NS
        osdResourceName=${OSD_RESOURCENAME:-"v4m-osd"}
        osResourceName=${OS_RESOURCENAME:-"v4m-search"}

        kubectl rollout restart deployment "$osdResourceName" -n "$namespace"
        kubectl rollout restart statefulset "$osResourceName" -n "$namespace"

        log_info "[OpenSearch, OpenSearch Dashboard] have been restarted"
        ;;
     "ALL")
        logNamespace=$LOG_NS
        osdResourceName=${OSD_RESOURCENAME:-"v4m-osd"}
        osResourceName=${OS_RESOURCENAME:-"v4m-search"}

        kubectl rollout restart deployment "$osdResourceName" -n "$logNamespace"
        kubectl rollout restart statefulset "$osResourceName" -n "$logNamespace"

        log_info "[OpenSearch, OpenSearch Dashboard] have been restarted"

        monNamespace=$MON_NS
        alertmanagerResourceName=${AM_RESOURCENAME:-"alertmanager-v4m-alertmanager"}
        prometheusResourceName=${PROM_RESOURCENAME:-"prometheus-v4m-prometheus"}
        grafanaResourceName=${GR_RESOURCENAME:-"v4m-grafana"}

        kubectl rollout restart statefulset "$alertmanagerResourceName" -n "$monNamespace"
        kubectl rollout restart statefulset "$prometheusResourceName" -n "$monNamespace"
        kubectl rollout restart deployment "$grafanaResourceName" -n "$monNamespace"

        log_info "[OpenSearch, OpenSearch Dashboard, Altermanager, Prometheus, Grafana] have been restarted"
        ;;
    ""|*)
        log_error "Must Specify which resources to restart"
        log_error "Valid values are:"
        log_error "OPENSEARCH, OPENSEARCHDASHBOARDS, GRAFANA, PROMETHEUS, ALERTMANAGER, ALL-MON, ALL-LOG, or ALL"
        exit 1
        ;;
  esac
}

function renew-certs {
  app=$1
  case "$app" in
     "ALL-MON")
        log_info "Generating new certs for [Altermanager, Prometheus, Grafana]"
        log_info "Deleting existing secrets for [Altermanager, Prometheus, Grafana]"

        kubectl delete secret -n "$MON_NS" "prometheus-tls-secret"
        kubectl delete secret -n "$MON_NS" "alertmanager-tls-secret"
        kubectl delete secret -n "$MON_NS" "grafana-tls-secret"

        log_info "Generating new certs for [Altermanager, Prometheus, Grafana]"
        create_tls_certs_openssl "$MON_NS" prometheus alertmanager grafana

        restart-resources "$app"
        ;;
     "ALL-LOG")
        log_info "Generating new certs for [Altermanager, Prometheus, Grafana]"
        log_info "Deleting existing secrets for [Altermanager, Prometheus, Grafana]"

        kubectl delete secret -n "$LOG_NS" 'kibana-tls-secret'
        kubectl delete secret -n "$LOG_NS" 'es-transport-tls-secret'
        kubectl delete secret -n "$LOG_NS" 'es-rest-tls-secret'
        kubectl delete secret -n "$LOG_NS" 'es-admin-tls-secret'

        log_info "Generating new certs for [Opensearch and Opensearch Dashboard]"
        create_tls_certs_openssl "$LOG_NS" kibana es-transport es-rest es-admin

        restart-resources "$app"
        ;;
    ""|*)
        log_error "Valid target values for certificate renewal:"
        log_error "[ALL-MON] or [ALL-LOG]"
        exit 1
        ;;
  esac
}

restartOnly=false

while getopts 't:rh' OPTION; do
  case "$OPTION" in
    t)
      targetOpt=$OPTARG
      log_info "Target resources: $targetOpt"
      ;;
    r)
      # Restart resource without renewing certs
      restartOnly=true
      log_info "Restarting the target resources without renewing certs"
      ;;
    h)
      log_info "script usage: ./bin/renew-tls-certs.sh [-t [REQUIRED](target resource)] [-r]"
      log_info "-t REQUIRED Options: [OPENSEARCH, OPENSEARCHDASHBOARDS, GRAFANA, PROMETHEUS, ALERTMANAGER, ALL-MON, ALL-LOG, or ALL]"
      log_info "-r Only restarts the target resources and does not generate new certs. Useful for those managing their own certs"
      ;;
    ?)
      log_error "script usage: ./bin/renew-tls-certs.sh [-t [REQUIRED](target resource)] [-r]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if ! [ "$targetOpt" ]; then
  log_error "Missing required target option, use [-h] to see how to use this script"
fi

if [ $restartOnly == true ]; then
  restart-resources "$targetOpt"
else
  renew-certs "$targetOpt"
fi

