#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh
source logging/bin/secrets-include.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

ELASTICSEARCH_EXPORTER_ENABLED=${ELASTICSEARCH_EXPORTER_ENABLED:-true}

if [ "$ELASTICSEARCH_EXPORTER_ENABLED" != "true" ]; then
    log_verbose "Environment variable [ELASTICSEARCH_EXPORTER_ENABLED] is not set to 'true'; exiting WITHOUT deploying Elasticsearch Exporter"
    exit
fi

set -e

log_info "Deploying Elasticsearch metric exporter ..."

# check for pre-reqs

# Confirm namespace exists
if [ -z "$(kubectl get ns "$LOG_NS" -o name 2> /dev/null)" ]; then
    log_error "Namespace [$LOG_NS] does NOT exist."
    exit 1
fi

# get credentials
get_credentials_from_secret metricgetter
rc=$?
if [ "$rc" != "0" ]; then
    log_debug "RC=$rc"
    exit $rc
fi

if helm3ReleaseExists es-exporter "$LOG_NS"; then
    #remove an existing instance if it does NOT have the most current set of labels
    # NOTE: pod label 'app' changed to 'app.kubernetes.io/name' w/Helm chart 6.x
    if [ -z "$(kubectl -n "$LOG_NS" get pods -l "app.kubernetes.io/name=prometheus-elasticsearch-exporter,searchbackend=opensearch" -o name 2> /dev/null)" ]; then
        log_debug "Removing an outdated version of Helm release [es-exporter]"
        helm -n "$LOG_NS" delete es-exporter
    fi

    if kubectl get crd servicemonitors.monitoring.coreos.com > /dev/null 2>&1; then
        #serviceMonitor CRD may not be present if metric monitoring stack is not deployed
        monNamespace=$(kubectl get servicemonitor -A --field-selector=metadata.name=elasticsearch -l sas.com/monitoring-base=kube-viya-monitoring -o=custom-columns=NAMESPACE:.metadata.namespace --no-headers)
        if [ -n "$monNamespace" ]; then
            log_debug "Removing obsolete serviceMonitor [$monNamespace/elasticsearch]"
            kubectl delete -n "$monNamespace" servicemonitor elasticsearch
            log_debug "Deploying an updated serviceMonitor for Elasticsearch  [$monNamespace/elasticsearch-v2]"
            kubectl apply -n "$monNamespace" -f monitoring/monitors/logging/serviceMonitor-elasticsearch-v2.yaml
        else
            log_debug "No instance of the obsolete elasticsearch serviceMonitor found."
        fi
    else
        log_debug "No serviceMonitor CRD detected; skipping check for obsolete elasticseach serviceMonitor instance."
    fi
else
    log_debug "No existing Helm release [es-exporter] found."
fi

# enable debug on Helm via env var
export HELM_DEBUG="${HELM_DEBUG:-false}"

if [ "$HELM_DEBUG" == "true" ]; then
    helmDebug="--debug"
fi

helmRepoAdd prometheus-community https://prometheus-community.github.io/helm-charts

primaryValuesFile="logging/esexporter/values-es-exporter.yaml"
log_debug "Deploying Elasticsearch Exporter"

#Generate yaml file with all container-related keys
generateImageKeysFile "$ES_EXPORTER_FULL_IMAGE" "logging/esexporter/es-exporter_container_image.template"

# Load any user customizations/overrides
ES_OPEN_EXPORTER_USER_YAML="${ES_OPEN_EXPORTER_USER_YAML:-$USER_DIR/logging/user-values-es-exporter.yaml}"
if [ ! -f "$ES_OPEN_EXPORTER_USER_YAML" ]; then
    log_debug "[$ES_OPEN_EXPORTER_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
    ES_OPEN_EXPORTER_USER_YAML=$TMP_DIR/empty.yaml
fi

# Enable workload node placement?
LOG_NODE_PLACEMENT_ENABLE=${LOG_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}

# Optional workload node placement support
if [ "$LOG_NODE_PLACEMENT_ENABLE" == "true" ]; then
    log_verbose "Enabling elasticsearch exporter for workload node placement"
    wnpValuesFile="logging/node-placement/values-elasticsearch-exporter-wnp.yaml"
else
    log_debug "Workload node placement support is disabled for the elasticsearch exporter"
    wnpValuesFile="$TMP_DIR/empty.yaml"
fi

# Point to OpenShift response file or dummy as appropriate
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    log_verbose "Deploying Elasticsearch metric exporter onto OpenShift cluster"
    openshiftValuesFile="logging/openshift/values-elasticsearch-exporter.yaml"
else
    log_debug "Elasticsearch metric exporter is NOT being deployed on OpenShift cluster"
    openshiftValuesFile="$TMP_DIR/empty.yaml"
fi

# Elasticsearch metric exporter
helm2ReleaseCheck es-exporter-"$LOG_NS"

## Get Helm Chart Name
log_debug "Elasticsearch Exporter Helm Chart: repo [$ESEXPORTER_HELM_CHART_REPO] name [$ESEXPORTER_HELM_CHART_NAME] version [$ESEXPORTER_HELM_CHART_VERSION]"
chart2install="$(get_helmchart_reference "$ESEXPORTER_HELM_CHART_REPO" "$ESEXPORTER_HELM_CHART_NAME" "$ESEXPORTER_HELM_CHART_VERSION")"
versionstring="$(get_helm_versionstring "$ESEXPORTER_HELM_CHART_VERSION")"

log_debug "Installing Helm chart from artifact [$chart2install]"

# shellcheck disable=SC2086
helm $helmDebug upgrade --install es-exporter \
    --namespace "$LOG_NS" \
    -f "$imageKeysFile" \
    -f "$primaryValuesFile" \
    -f "$wnpValuesFile" \
    -f "$openshiftValuesFile" \
    -f "$ES_OPEN_EXPORTER_USER_YAML" \
    --set fullnameOverride=v4m-es-exporter \
    $versionstring \
    "$chart2install"

log_info "Elasticsearch metric exporter has been deployed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
