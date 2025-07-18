#!/bin/bash

# Copyright © 2023, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh
source logging/bin/secrets-include.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

# Enable Fluent Bit?
FLUENT_BIT_EVENTS_ENABLED=${FLUENT_BIT_EVENTS_ENABLED:-true}

if [ "$FLUENT_BIT_EVENTS_ENABLED" != "true" ]; then
    log_info "Environment variable [FLUENT_BIT_EVENTS_ENABLED] is not set to 'true'; exiting WITHOUT deploying Fluent Bit deployment"
    exit 0
fi

set -e

# Enable workload node placement?
LOG_NODE_PLACEMENT_ENABLE=${LOG_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}

# Optional workload node placement support
if [ "$LOG_NODE_PLACEMENT_ENABLE" == "true" ]; then
    log_verbose "Enabling Fluent Bit (K8s Event Collector) for workload node placement"
    wnpValuesFile="logging/node-placement/values-fluent-bit-events-wnp.yaml"
else
    log_debug "Workload node placement support is disabled for Fluent Bit (K8s Event Collector)"
    wnpValuesFile="$TMP_DIR/empty.yaml"
fi

log_info "Deploying Fluent Bit for collecting Kubernetes Events..."

#TO DO: Check that OpenSearch is actually deployed and running?

# Remove an existing Event Routher deployment?
REMOVE_EVENTROUTER=${REMOVE_EVENTROUTER:-true}
if [ "$REMOVE_EVENTROUTER" == "true" ]; then
    if [ "$(kubectl get deployment -n "$LOG_NS" -o name -l app=eventrouter 2> /dev/null)" == "" ]; then
        log_debug "No existing instance of Event Router found in namespace [$LOG_NS]."
    else
        log_debug "Removing an existing instance of Event Router found in namespace [$LOG_NS]."
        logging/bin/remove_eventrouter.sh
    fi
fi

# check for pre-reqs
# Confirm namespace exists
if [ "$(kubectl get ns "$LOG_NS" -o name 2> /dev/null)" == "" ]; then
    log_error "Namespace [$LOG_NS] does NOT exist."
    exit 1
fi

# get credentials
if [ "$(kubectl -n "$LOG_NS" get secret internal-user-logcollector -o name 2> /dev/null)" == "" ]; then
    export ES_LOGCOLLECTOR_PASSWD=${ES_LOGCOLLECTOR_PASSWD}
    create_user_secret internal-user-logcollector logcollector "$ES_LOGCOLLECTOR_PASSWD" managed-by=v4m-es-script
else
    get_credentials_from_secret logcollector
    rc=$?
    if [ "$rc" != "0" ]; then
        log_debug "RC=$rc"
        exit "$rc"
    fi
fi

HELM_DEBUG="${HELM_DEBUG:-false}"
helmDebug=""
if [ "$HELM_DEBUG" == "true" ]; then
    helmDebug="--debug"
fi

helmRepoAdd fluent https://fluent.github.io/helm-charts

#Generate yaml file with all container-related keys
generateImageKeysFile "$FB_FULL_IMAGE" "logging/fb/fb_container_image.template"

# Fluent Bit user customizations
FB_EVENTS_USER_YAML="${FB_EVENTS_USER_YAML:-$USER_DIR/logging/user-values-fluent-bit-events.yaml}"
if [ ! -f "$FB_EVENTS_USER_YAML" ]; then
    log_debug "[$FB_EVENTS_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
    FB_EVENTS_USER_YAML=$TMP_DIR/empty.yaml
fi

# Point to OpenShift response file or dummy as appropriate
openshiftValuesFile="$TMP_DIR/empty.yaml"
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    log_info "Deploying Fluent Bit on OpenShift cluster"
    openshiftValuesFile="logging/openshift/values-fluent-bit-events.yaml"
else
    log_debug "Fluent Bit is NOT being deployed on OpenShift cluster"
fi

## Get Helm Chart Name
log_debug "Fluent Bit Helm Chart: repo [$FLUENTBIT_HELM_CHART_REPO] name [$FLUENTBIT_HELM_CHART_NAME] version [$FLUENTBIT_HELM_CHART_VERSION]"
chart2install="$(get_helmchart_reference "$FLUENTBIT_HELM_CHART_REPO" "$FLUENTBIT_HELM_CHART_NAME" "$FLUENTBIT_HELM_CHART_VERSION")"
versionstring="$(get_helm_versionstring "$FLUENTBIT_HELM_CHART_VERSION")"

log_debug "Installing Helm chart from artifact [$chart2install]"

# Deploy Fluent Bit via Helm chart
#shellcheck disable=SC2086
helm $helmDebug upgrade --install --namespace "$LOG_NS" v4m-fb-events \
    $versionstring \
    --values "$imageKeysFile" \
    --values logging/fb/fluent-bit_helm_values_events.yaml \
    --values "$wnpValuesFile" \
    --values "$openshiftValuesFile" \
    --values "$FB_EVENTS_USER_YAML" \
    --set fullnameOverride=v4m-fb-events \
    "$chart2install"

#Container Security: Disable Token Automounting at ServiceAccount; enable for Pod
disable_sa_token_automount "$LOG_NS" v4m-fb-events
enable_pod_token_automount "$LOG_NS" deployment v4m-fb-events

kubectl -n "$LOG_NS" scale deployment v4m-fb-events --replicas 1

log_info "Fluent Bit deployment completed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
