#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh

source bin/tls-include.sh
verify_cert_manager

helm2ReleaseCheck v4m-$MON_NS
helm2ReleaseCheck prometheus-$MON_NS
checkDefaultStorageClass

export HELM_DEBUG="${HELM_DEBUG:-false}"
export NGINX_NS="${NGINX_NS:-ingress-nginx}"

PROM_OPER_USER_YAML="${PROM_OPER_USER_YAML:-$USER_DIR/monitoring/user-values-prom-operator.yaml}"
if [ ! -f "$PROM_OPER_USER_YAML" ]; then
  log_debug "[$PROM_OPER_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  PROM_OPER_USER_YAML=$TMP_DIR/empty.yaml
fi

if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

if [ -z "$(kubectl get ns $MON_NS -o name 2>/dev/null)" ]; then
  kubectl create ns $MON_NS
fi

set -e
log_notice "Deploying monitoring to the [$MON_NS] namespace..."

# The stable repo is used indirectly by prometheus-community/kube-prometheus-stack
helmRepoAdd stable https://charts.helm.sh/stable
helmRepoAdd prometheus-community https://prometheus-community.github.io/helm-charts

log_info "Updating helm repositories..."
helm repo update

# Create a temporary yaml file for optional components/settings
genValuesFile=$TMP_DIR/values-prom-operator-tmp.yaml
rm -f $genValuesFile
touch $genValuesFile

# Istio - Federate data from Istio's Prometheus instance
if [ "$ISTIO_ENABLED" == "true" ]; then
  log_info "Including Istio metric federation"
  cat monitoring/values-prom-operator-istio.yaml >> $genValuesFile
else
  log_debug "ISTIO_ENABLED flag not set"
  log_debug "Skipping deployment of federated scrape of Istio Prometheus instance"
fi

# Elasticsearch Datasource for Grafana
ELASTICSEARCH_DATASOURCE="${ELASTICSEARCH_DATASOURCE:-false}"
if [ "$ELASTICSEARCH_DATASOURCE" == "true" ]; then
  log_info "Provisioning Elasticsearch datasource for Grafana..."
  kubectl delete secret -n $MON_NS --ignore-not-found grafana-datasource-es
  kubectl create secret generic -n $MON_NS grafana-datasource-es --from-file monitoring/grafana-datasource-es.yaml
  kubectl label secret -n $MON_NS grafana-datasource-es grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring
else
  log_debug "ELASTICSEARCH_DATASOURCE not set"
  log_debug "Skipping creation of Elasticsearch datasource for Grafana"
fi

# Check if Prometheus Operator CRDs are already installed
PROM_OPERATOR_CRD_UPDATE=${PROM_OPERATOR_CRD_UPDATE:-true}
PROM_OPERATOR_CRD_VERSION=${PROM_OPERATOR_CRD_VERSION:-v0.43.0}
if [ "$PROM_OPERATOR_CRD_UPDATE" == "true" ]; then
  log_info "Updating Prometheus Operator custom resource definitions"
  kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$PROM_OPERATOR_CRD_VERSION/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
  kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$PROM_OPERATOR_CRD_VERSION/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
  kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$PROM_OPERATOR_CRD_VERSION/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
  kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$PROM_OPERATOR_CRD_VERSION/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
  kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$PROM_OPERATOR_CRD_VERSION/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
  kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$PROM_OPERATOR_CRD_VERSION/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
  kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$PROM_OPERATOR_CRD_VERSION/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
  kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$PROM_OPERATOR_CRD_VERSION/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
else
  log_debug "Prometheus Operator CRD update disabled"
fi

# Optional workload node placement support
MON_NODE_PLACEMENT_ENABLE=${MON_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}
if [ "$MON_NODE_PLACEMENT_ENABLE" == "true" ]; then
  log_info "Enabling monitoring components for workload node placement"
  wnpValuesFile="monitoring/node-placement/values-prom-operator-wnp.yaml"
else
  log_debug "Workload node placement support is disabled"
  wnpValuesFile="$TMP_DIR/empty.yaml"
fi

# Optional TLS Support
if [ "$TLS_ENABLE" == "true" ]; then
  apps=( prometheus alertmanager grafana )
  create_tls_certs $MON_NS monitoring ${apps[@]}

  log_debug "Appending monitoring/tls/values-prom-operator-tls.yaml to $genValuesFile"
  cat monitoring/tls/values-prom-operator-tls.yaml >> $genValuesFile

  log_info "Provisioning TLS-enabled Prometheus datasource for Grafana..."
  kubectl delete cm -n $MON_NS --ignore-not-found grafana-datasource-prom-https
  kubectl create cm -n $MON_NS grafana-datasource-prom-https --from-file monitoring/tls/grafana-datasource-prom-https.yaml
  kubectl label cm -n $MON_NS grafana-datasource-prom-https grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring

  # node-exporter TLS
  log_info "Enabling Prometheus node-exporter for TLS..."
  kubectl delete cm -n $MON_NS node-exporter-tls-web-config --ignore-not-found
  sleep 1
  kubectl create cm -n $MON_NS node-exporter-tls-web-config --from-file monitoring/tls/node-exporter-web.yaml
  kubectl label cm -n $MON_NS node-exporter-tls-web-config sas.com/monitoring-base=kube-viya-monitoring
fi

log_info "Deploying the Kube Prometheus Stack. This may take a few minutes..."
log_info "User response file: [$PROM_OPER_USER_YAML]"

log_info "Installing via Helm 3...($(date) - timeout 20m)"
if helm3ReleaseExists prometheus-operator $MON_NS; then
  promRelease=prometheus-operator
  promName=prometheus-operator
else
  promRelease=v4m-prometheus-operator
  promName=v4m
fi
KUBE_PROM_STACK_CHART_VERSION=${KUBE_PROM_STACK_CHART_VERSION:-11.0.0}
helm $helmDebug upgrade --install $promRelease \
  --namespace $MON_NS \
  -f monitoring/values-prom-operator.yaml \
  -f $genValuesFile \
  -f $wnpValuesFile \
  -f $PROM_OPER_USER_YAML \
  --atomic \
  --timeout 20m \
  --set nameOverride=$promName \
  --set fullnameOverride=$promName \
  --set prometheus-node-exporter.fullnameOverride=$promName-node-exporter \
  --set kube-state-metrics.fullnameOverride=$promName-kube-state-metrics \
  --set grafana.fullnameOverride=$promName-grafana \
  --version $KUBE_PROM_STACK_CHART_VERSION \
  prometheus-community/kube-prometheus-stack

rm -f $genValuesFile

sleep 2

if [ "$TLS_ENABLE" == "true" ]; then
  log_info "Patching Grafana ServiceMonitor for TLS..."
  kubectl patch servicemonitor -n $MON_NS $promName-grafana --type=json \
    -p='[{"op": "replace", "path": "/spec/endpoints/0/scheme", "value":"https"},{"op": "replace", "path": "/spec/endpoints/0/tlsConfig", "value":{}},{"op": "replace", "path": "/spec/endpoints/0/tlsConfig/insecureSkipVerify", "value":true}]'
fi

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

# Eventrouter
kubectl apply -n $MON_NS -f monitoring/monitors/kube/podMonitor-eventrouter.yaml 2>/dev/null

# Elasticsearch
kubectl apply -n $MON_NS -f monitoring/monitors/logging/serviceMonitor-elasticsearch.yaml

# Fluent Bit
kubectl apply -n $MON_NS -f monitoring/monitors/logging/serviceMonitor-fluent-bit.yaml

# Rules
log_info "Adding Prometheus recording rules..."
for f in monitoring/rules/viya/rules-*.yaml; do
  kubectl apply -n $MON_NS -f $f
done

echo ""
monitoring/bin/deploy_dashboards.sh

log_notice "Successfully deployed components to the [$MON_NS] namespace"
