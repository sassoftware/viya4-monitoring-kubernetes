#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh

helm2ReleaseCheck prometheus-$MON_NS
helm3ReleaseCheck prometheus-operator $MON_NS

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
  kubectl label secret -n $MON_NS grafana-datasource-es grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring
else
  log_debug "ELASTICSEARCH_DATASOURCE not set"
  log_debug "Skipping creation of Elasticsearch datasource for Grafana"
fi

# Check if Prometheus Operator CRDs are already installed
createPromCRDs=true
if [ "$(kubectl get crd prometheuses.monitoring.coreos.com -o name 2>/dev/null)" ]; then
  log_debug "Found existing Prometheus CRDs. Skipping creation."
  createPromCRDs=false
fi

# Optional TLS Support
if [ "$MON_TLS_ENABLE" == "true" ]; then
  # Create issuers if needed
  # Issuers and certs honor USER_DIR for overrides/customizations
  
  if [ -z "$(kubectl get issuer -n $MON_NS selfsigning-issuer -o name 2>/dev/null)" ]; then
    log_info "Creating selfsigning-issuer for the [$MON_NS] namespace..."
    selfsignIssuer=monitoring/tls/selfsigning-issuer.yaml
    if [ -f "$USER_DIR/monitoring/tls/selfsigning-issuer.yaml" ]; then
      selfsignIssuer="$USER_DIR/monitoring/tls/selfsigning-issuer.yaml"
    fi
    log_debug "Self-sign issuer yaml is [$selfsignIssuer]"
    kubectl apply -n $MON_NS -f "$selfsignIssuer"
    sleep 5
  fi
  if [ -z "$(kubectl get secret -n $MON_NS ca-certificate -o name 2>/dev/null)" ]; then
    log_info "Creating self-signed CA certificate for the [$MON_NS] namespace..."
    caCert=monitoring/tls/ca-certificate.yaml
    if [ -f "$USER_DIR/monitoring/tls/ca-certificate.yaml" ]; then
      caCert="$USER_DIR/monitoring/tls/ca-certificate.yaml"
    fi
    log_debug "CA cert yaml file is [$caCert]"
    kubectl apply -n $MON_NS -f "$caCert"
    sleep 5
  fi
  if [ -z "$(kubectl get issuer -n $MON_NS namespace-issuer -o name 2>/dev/null)" ]; then
    log_info "Creating namespace-issuer for the [$MON_NS] namespace..."
    namespaceIssuer=monitoring/tls/namespace-issuer.yaml
    if [ -f "$USER_DIR/monitoring/tls/namespace-issuer.yaml" ]; then
      namespaceIssuer="$USER_DIR/monitoring/tls/namespace-issuer.yaml"
    fi
    log_debug "Namespace issuer yaml is [$namespaceIssuer]"
    kubectl apply -n $MON_NS -f "$namespaceIssuer"
    sleep 5
  fi

  apps=( prometheus alertmanager grafana )
  for app in "${apps[@]}"; do
    # Only create the secrets if they do not exist
    TLS_SECRET_NAME=$app-tls-secret
    if [ -z "$(kubectl get secret -n $MON_NS $TLS_SECRET_NAME -o name 2>/dev/null)" ]; then
      # Create the certificate using cert-manager
      certyaml=monitoring/tls/$app-tls-cert.yaml
      if [ -f "$USER_DIR/monitoring/tls/$app-tls-cert.yaml" ]; then
        certyaml="$USER_DIR/monitoring/tls/$app-tls-cert.yaml"
      fi
      log_debug "Creating cert-manager certificate custom resource for [$app] using [$certyaml]"
      kubectl apply -n $MON_NS -f "$certyaml"
    else
      log_debug "Using existing $TLS_SECRET_NAME for [$app]"
    fi
  done

  log_debug "Appending monitoring/tls/values-prom-operator-tls.yaml to $genValuesFile"
  cat monitoring/tls/values-prom-operator-tls.yaml >> $genValuesFile

  log_info "Provisioning TLS-enabled Prometheus datasource for Grafana..."
  cp monitoring/tls/grafana-datasource-prom-https.yaml $TMP_DIR/grafana-datasource-prom-https.yaml
  if [ "$HELM_VER_MAJOR" == "3" ]; then
    kubectl delete cm -n $MON_NS --ignore-not-found prometheus-operator-grafana-datasource
    echo "      url: https://prometheus-operator-prometheus" >> $TMP_DIR/grafana-datasource-prom-https.yaml
  else
    kubectl delete cm -n $MON_NS --ignore-not-found prometheus-$MON_NS-grafana-datasource
    echo "      url: https://prometheus-$MON_NS-prom-prometheus" >> $TMP_DIR/grafana-datasource-prom-https.yaml
  fi

  kubectl delete cm -n $MON_NS --ignore-not-found grafana-datasource-prom-https
  kubectl create cm -n $MON_NS grafana-datasource-prom-https --from-file $TMP_DIR/grafana-datasource-prom-https.yaml
  kubectl label cm -n $MON_NS grafana-datasource-prom-https grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring

  # node-exporter TLS
  log_info "Enabling Prometheus node-exporter for TLS..."
  kubectl delete cm -n $MON_NS node-exporter-tls-web-config --ignore-not-found
  sleep 1
  kubectl create cm -n $MON_NS node-exporter-tls-web-config --from-file monitoring/tls/node-exporter-web.yaml
  kubectl label cm -n $MON_NS node-exporter-tls-web-config sas.com/monitoring-base=kube-viya-monitoring
fi

log_info "Deploying Prometheus Operator. This may take a few minutes (15min timeout)..."
log_info "User response file: [$PROM_OPER_USER_YAML]"
if [ "$HELM_VER_MAJOR" == "3" ]; then
  log_debug "Installing via Helm 3..."
  promRelease=prometheus-operator
  helm $helmDebug upgrade --install $promRelease \
    --namespace $MON_NS \
    -f monitoring/values-prom-operator.yaml \
    -f $genValuesFile \
    -f $PROM_OPER_USER_YAML \
    --atomic \
    --timeout 15m \
    stable/prometheus-operator
else
  log_debug "Installing via Helm 2..."
  promRelease=prometheus-$MON_NS
  helm $helmDebug upgrade --install $promRelease \
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
