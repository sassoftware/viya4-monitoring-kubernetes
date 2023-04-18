#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh
source bin/openshift-include.sh

# If openshift deployment, ensure user-workload monitoring is enabled
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
  if [ -n "$(kubectl get po -n openshift-user-workload-monitoring -o name 2>/dev/null)" ]; then
    log_debug "User workload monitoring is enabled"
  else
    log_error "User workload monitoring pods not detected in the openshift-user-workload-monitoring namespace"
    log_error "Ensure that user workload monitoring is enabled"
    log_error "See more here: https://github.com/sassoftware/viya4-monitoring-kubernetes/blob/stable/monitoring/OpenShift.md#azure-red-hat-openshift-experimental"
    exit 1
  fi
fi

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
  PUSHGATEWAY_CHART_VERSION=${PUSHGATEWAY_CHART_VERSION:-2.0.3}
  if helm3ReleaseExists prometheus-pushgateway $VIYA_NS; then
    kubectl delete deployment -n $VIYA_NS prometheus-pushgateway
    svcClusterIP=$(kubectl get svc -n $VIYA_NS prometheus-pushgateway -o 'jsonpath={.spec.clusterIP}')
  fi
  log_info "Installing the Prometheus Pushgateway to the [$VIYA_NS] namespace"
  helm2ReleaseCheck pushgateway-$VIYA_NS
  helm $helmDebug upgrade --install prometheus-pushgateway \
  --namespace $VIYA_NS \
  --version $PUSHGATEWAY_CHART_VERSION \
  --set service.clusterIP=$svcClusterIP \
  -f monitoring/values-pushgateway.yaml \
  -f $wnpValuesFile \
  -f $PUSHGATEWAY_USER_YAML \
  prometheus-community/prometheus-pushgateway
fi

if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
  # By default, do not validate monitors on OpenShift due to
  # the older Prometheus Operator CRDs
  VALIDATE_MONITORS=${VALIDATE_MONITORS:-false}
else
  VALIDATE_MONITORS=${VALIDATE_MONITORS:-true}
fi
if [ "$(kubectl get crd servicemonitors.monitoring.coreos.com -o name 2>/dev/null)" ]; then
  log_info "Adding monitors for resources in the [$VIYA_NS] namespace..."
  for f in monitoring/monitors/viya/serviceMonitor-*.yaml; do
    kubectl apply -n $VIYA_NS -f "$f" --validate=$VALIDATE_MONITORS
  done
  for f in monitoring/monitors/viya/podMonitor-*.yaml; do
    kubectl apply -n $VIYA_NS -f "$f" --validate=$VALIDATE_MONITORS
  done
  log_notice "Monitoring components successfully deployed into the [$VIYA_NS] namespace"

  # Temporary - Remove obsolete ServiceMonitors
  kubectl delete --ignore-not-found ServiceMonitor -n $VIYA_NS sas-java-services
  kubectl delete --ignore-not-found ServiceMonitor -n $VIYA_NS sas-go-services
  kubectl delete --ignore-not-found ServiceMonitor -n $VIYA_NS sas-deployment-operator
else
  log_warn "Prometheus Operator not found. Skipping deployment of ServiceMonitors."
fi

# If a deployment with the old name exists, remove it first
if helm3ReleaseExists "v4m-viya" $VIYA_NS; then
  log_verbose "Removing outdated SAS Viya Monitoring Helm chart release from [$VIYA_NS] namespace"
  helm uninstall -n "$VIYA_NS" "v4m-viya"
fi

deployV4MInfo "$VIYA_NS" "v4m-metrics-viya"

