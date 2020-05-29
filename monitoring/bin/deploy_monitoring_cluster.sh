#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

source monitoring/bin/common.sh

export HELM_DEBUG="${HELM_DEBUG:-false}"
export NGINX_NS="${NGINX_NS:-ingress-nginx}"

PROM_OPER_USER_YAML="${PROM_OPER_USER_YAML:-monitoring/user-values-prom-operator.yaml}"

if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

if [ "$(kubectl get ns $MON_NS -o name 2>/dev/null)" == "" ]; then
  kubectl create ns $MON_NS
fi

set -e
log_notice "Deploying monitoring to the [$MON_NS] namespace..."

log_info "Updating local helm repository..."
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update

# Create a temporary yaml file for optional components/settings
genValuesFile=$TMP_DIR/values-prom-operator-tmp.yaml
rm -f $genValuesFile
touch $genValuesFile

# Istio
if [ "$ISTIO_ENABLED" == "true" ]; then
  cat monitoring/values-prom-operator-istio.yaml >> $genValuesFile
else
  log_debug "ISTIO_ENABLED flag not set"
  log_debug "Skipping deployment of federated scrape of Istio Prometheus instance"
fi

ELASTICSEARCH_DATASOURCE="${ELASTICSEARCH_DATASOURCE:-true}"

if [ "$ELASTICSEARCH_DATASOURCE" == "true" ]; then
  log_info "Provisioning Elasticsearch datasource for Grafana..."
  kubectl delete secret -n $MON_NS --ignore-not-found grafana-datasource-es
  kubectl create secret generic -n $MON_NS grafana-datasource-es --from-file monitoring/grafana-datasource-es.yaml
  kubectl label secret -n $MON_NS grafana-datasource-es grafana_datasource=1
else
  log_debug "ELASTICSEARCH_DATASOURCE not set"
  log_debug "Skipping creation of Elasticsearch datasource for Grafana"
fi

# Check if Prometheus Operator CRDs are already installed
createPromCRDs=true
if [ "$(kubectl get crd prometheuses.monitoring.coreos.com -o name 2>/dev/null)" != "" ]; then
  log_debug "Found existing Prometheus CRDs. Skipping creation."
  createPromCRDs=false
fi

log_info "Deploying Prometheus Operator. This may take a few minutes..."
log_info "User response file: [$PROM_OPER_USER_YAML]"
if [ "$HELM_VER_MAJOR" == "3" ]; then
  log_debug "Installing via Helm 3..."
  PROM_RELEASE=${PROM_RELEASE:-prometheus-operator}
  helm $helmDebug upgrade --install $PROM_RELEASE \
    --namespace $MON_NS \
    -f monitoring/values-prom-operator.yaml \
    -f $genValuesFile \
    -f $PROM_OPER_USER_YAML \
    --atomic \
    --timeout 15m \
    stable/prometheus-operator
else
  log_debug "Installing via Helm 2..."
  PROM_RELEASE=${PROM_RELEASE:-prometheus-$MON_NS}
  helm $helmDebug upgrade --install $PROM_RELEASE \
    --namespace $MON_NS \
    -f monitoring/values-prom-operator.yaml \
    -f $genValuesFile \
    -f $PROM_OPER_USER_YAML \
    --atomic \
    --timeout 900 \
    --set prometheusOperator.createCustomResource=$createPromCRDs \
    stable/prometheus-operator
fi

rm -f $genValuesFile

sleep 2

log_info "Deploying cluster ServiceMonitors..."

# NGINX
set +e
kubectl get ns $NGINX_NS 2>/dev/null
if [ $? == 0 ]; then
  nginxFound=true
fi
set -e

if [ "$nginxFound" == "true" ]; then
  log_info "NGINX found. Deploying podMonitor to [$NGINX_NS] namespace..."
  kubectl apply -n $NGINX_NS -f monitoring/monitors/kube/podMonitor-nginx.yaml 2>/dev/null
fi
# Elasticsearch
kubectl apply -n $MON_NS -f monitoring/monitors/logging/serviceMonitor-elasticsearch.yaml
# Fluent Bit
kubectl apply -n $MON_NS -f monitoring/monitors/logging/serviceMonitor-fluent-bit.yaml

echo ""
monitoring/bin/deploy_dashboards.sh

log_notice "Successfully deployed components to the [$MON_NS] namespace"
