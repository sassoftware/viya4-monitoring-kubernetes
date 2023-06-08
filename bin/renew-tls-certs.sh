#! /bin/bash

# Copyright Â© 2023, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
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

        log_info "Restarting [OpenSearch]"
        kubectl rollout restart statefulset "$resourceName" -n "$namespace"
        ;;
     "OPENSEARCHDASHBOARDS"|"DASHBOARDS"|"OSD")
        namespace=$LOG_NS
        resourceName=${OSD_RESOURCENAME:-"v4m-osd"}

        log_info "Restarting [OpenSearch Dashboards]"
        kubectl rollout restart deployment "$resourceName" -n "$namespace"
        ;;
     "ALERTMANAGER"|"AM")
        namespace=$MON_NS
        resourceName=${AM_RESOURCENAME:-"alertmanager-v4m-alertmanager"}

        log_info "Restarting [Alertmanager]"
        kubectl rollout restart statefulset "$resourceName" -n "$namespace"
        ;;
     "PROMETHEUS"|"PROM"|"PRO"|"PR")
        namespace=$MON_NS
        resourceName=${PROM_RESOURCENAME:-"prometheus-v4m-prometheus"}

        log_info "Restarting [Prometheus]"
        kubectl rollout restart statefulset "$resourceName" -n "$namespace"
        ;;
     "GRAFANA"|"GRAF"|"GR")
        namespace=$MON_NS
        resourceName=${GR_RESOURCENAME:-"v4m-grafana"}

        log_info "Restarting [Grafana]"
        kubectl rollout restart deployment "$resourceName" -n "$namespace"
        ;;
     "ALL-MON")
        namespace=$MON_NS
        alertmanagerResourceName=${AM_RESOURCENAME:-"alertmanager-v4m-alertmanager"}
        prometheusResourceName=${PROM_RESOURCENAME:-"prometheus-v4m-prometheus"}
        grafanaResourceName=${GR_RESOURCENAME:-"v4m-grafana"}

        log_info "Restarting [Alertmanager, Prometheus, Grafana]"
        kubectl rollout restart statefulset "$alertmanagerResourceName" -n "$namespace"
        kubectl rollout restart statefulset "$prometheusResourceName" -n "$namespace"
        kubectl rollout restart deployment "$grafanaResourceName" -n "$namespace"
        ;;
     "ALL-LOG")
        namespace=$LOG_NS
        osdResourceName=${OSD_RESOURCENAME:-"v4m-osd"}
        osResourceName=${OS_RESOURCENAME:-"v4m-search"}

        log_info "Restarting [OpenSearch, OpenSearch Dashboards]"
        kubectl rollout restart deployment "$osdResourceName" -n "$namespace"
        kubectl rollout restart statefulset "$osResourceName" -n "$namespace"
        ;;
     "ALL")
        logNamespace=$LOG_NS
        osdResourceName=${OSD_RESOURCENAME:-"v4m-osd"}
        osResourceName=${OS_RESOURCENAME:-"v4m-search"}

        log_info "Restarting [OpenSearch, OpenSearch Dashboards]"
        kubectl rollout restart deployment "$osdResourceName" -n "$logNamespace"
        kubectl rollout restart statefulset "$osResourceName" -n "$logNamespace"

        monNamespace=$MON_NS
        alertmanagerResourceName=${AM_RESOURCENAME:-"alertmanager-v4m-alertmanager"}
        prometheusResourceName=${PROM_RESOURCENAME:-"prometheus-v4m-prometheus"}
        grafanaResourceName=${GR_RESOURCENAME:-"v4m-grafana"}

        log_info "Restarting [Alertmanager, Prometheus, Grafana]"
        kubectl rollout restart statefulset "$alertmanagerResourceName" -n "$monNamespace"
        kubectl rollout restart statefulset "$prometheusResourceName" -n "$monNamespace"
        kubectl rollout restart deployment "$grafanaResourceName" -n "$monNamespace"
        ;;
    ""|*)
        log_error "Must Specify which resources to restart"
        log_error "Valid values are:"
        log_error "[OPENSEARCH, OPENSEARCHDASHBOARDS, GRAFANA, PROMETHEUS, ALERTMANAGER, ALL-MON, ALL-LOG, or ALL]"
        exit 1
        ;;
  esac
}

function renew-certs {
  app=$1
  case "$app" in
     "ALL-MON")
        log_info "Generating new certs for [Alertmanager, Prometheus, Grafana]"
        log_info "Deleting existing secrets for [Alertmanager, Prometheus, Grafana]"

        for secretName in prometheus-tls-secret alertmanager-tls-secret grafana-tls-secret; do
          if [ -n "$(kubectl get secret -n $MON_NS $secretName -o name 2>/dev/null)" ]; then
            if (tls_cert_managed_by_v4m "$MON_NS" "$secretName") then
              kubectl delete secret -n "$MON_NS" $secretName
            else
              log_error "[$secretName] is not managed by SAS Viya Monitoring. Delete certs not managed by SAS Viya Monitoring or update certs and restart applications by re-running this script using the [-r] flag"
              exit 1
            fi
          fi
        done

        log_info "Generating new certs for [Alertmanager, Prometheus, Grafana]"
        create_tls_certs_openssl "$MON_NS" prometheus alertmanager grafana

        restart-resources "ALL-MON" # WIP: Move restarts to create_tls_certs_openssl function?
        ;;
     "ALL-LOG")
       log_info "Generating new certs for [OpenSearch, OpenSearch Dashboards]"
       log_info "Deleting existing secrets for [OpenSearch, OpenSearch Dashboards]"

        for secretName in kibana-tls-secret es-transport-tls-secret es-rest-tls-secret es-admin-tls-secret; do
          if [ -n "$(kubectl get secret -n $LOG_NS $secretName -o name 2>/dev/null)" ]; then
            if (tls_cert_managed_by_v4m "$LOG_NS" "$secretName") then
              kubectl delete secret -n "$LOG_NS" $secretName
            else
              log_error "[$secretName] is not managed by SAS Viya Monitoring. Delete certs not managed by SAS Viya Monitoring or update certs and restart applications by re-running this script using the [-r] flag"
              exit 1
            fi
          fi
        done

        log_info "Generating new certs for [OpenSearch and OpenSearch Dashboards]"
        create_tls_certs_openssl "$LOG_NS" kibana es-transport es-rest es-admin

        restart-resources "ALL-LOG" # WIP: Move restarts to create_tls_certs_openssl function?
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
      log_message "script usage: ./bin/renew-tls-certs.sh [-t [REQUIRED](target resource)] [-r]"
      log_message "-t (REQUIRED) Options: [ALL-MON, ALL-LOG]"
      log_message "-r Only restarts the target resources and does not generate new certs. Useful for those managing their own certs"
      log_message "Running with [-r] allows the following targets [-t]: [OPENSEARCH, OPENSEARCHDASHBOARDS, GRAFANA, PROMETHEUS, ALERTMANAGER, ALL-MON, ALL-LOG, or ALL]"
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

