#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh

checkDefaultStorageClass

HELM_DEBUG="${HELM_DEBUG:-false}"
if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

helmRepoAdd prometheus-community https://prometheus-community.github.io/helm-charts

log_info "Updating helm repositories..."
helm repo update

PUSHGATEWAY_USER_YAML="${PUSHGATEWAY_USER_YAML:-$USER_DIR/monitoring/user-values-pushgateway.yaml}"
if [ ! -f "$PUSHGATEWAY_USER_YAML" ]; then
  log_debug "[$PUSHGATEWAY_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  PUSHGATEWAY_USER_YAML=$TMP_DIR/empty.yaml
fi

if [ "$VIYA_NS" == "" ]; then
  log_error "VIYA_NS must be set to the namespace of an existing Viya deployment"
  exit 1
fi

# Optional workload node placement support
MON_NODE_PLACEMENT_ENABLE=${MON_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}
if [ "$MON_NODE_PLACEMENT_ENABLE" == "true" ]; then
  log_info "Enabling monitoring components for workload node placement"
  wnpValuesFile="monitoring/node-placement/values-pushgateway-wnp.yaml"
else
  log_debug "Workload node placement support is disabled"
  wnpValuesFile="$TMP_DIR/empty.yaml"
fi

log_notice "Enabling the [$VIYA_NS] namespace for SAS Viya monitoring"

# Exit on failure
set -e

# Prometheus Pushgateway
PUSHGATEWAY_ENABLED=${PUSHGATEWAY_ENABLED:-true}
if [ "$PUSHGATEWAY_ENABLED" == "true" ]; then
  log_info "Installing the Prometheus Pushgateway to the [$VIYA_NS] namespace"
  helm2ReleaseCheck pushgateway-$VIYA_NS
  helm $helmDebug upgrade --install prometheus-pushgateway \
  --namespace $VIYA_NS \
  -f monitoring/values-pushgateway.yaml \
  -f $wnpValuesFile \
  -f $PUSHGATEWAY_USER_YAML \
  prometheus-community/prometheus-pushgateway
fi

if [ "$(kubectl get crd servicemonitors.monitoring.coreos.com -o name 2>/dev/null)" ]; then
  log_info "Adding monitors for resources in the [$VIYA_NS] namespace..."
  for f in monitoring/monitors/viya/serviceMonitor-*.yaml; do
    kubectl apply -n $VIYA_NS -f $f
  done
  for f in monitoring/monitors/viya/podMonitor-*.yaml; do
    kubectl apply -n $VIYA_NS -f $f
  done
  log_notice "Monitoring components successfully deployed into the [$VIYA_NS] namespace"

  # Temporary - Remove obsolete ServiceMonitors
  kubectl delete --ignore-not-found ServiceMonitor -n $VIYA_NS sas-java-services
  kubectl delete --ignore-not-found ServiceMonitor -n $VIYA_NS sas-go-services
else
  log_warn "Prometheus Operator not found. Skipping deployment of ServiceMonitors."
fi
