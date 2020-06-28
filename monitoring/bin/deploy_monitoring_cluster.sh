#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh

helm2ReleaseCheck prometheus-$MON_NS
helm3ReleaseCheck prometheus-operator $MON_NS

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
  kubectl label secret -n $MON_NS grafana-datasource-es grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring
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

# Optional TLS Support
if [ "$MON_TLS_ENABLE" == "true" ]; then
  if [ ! $(which openssl) ]; then
    echo "openssl not found on the current PATH"
    exit 1
  fi
  if [ -z "$CA_KEY" ] && [ -z "$CA_CERT" ]; then
    CA_SAVE_DIR=${CA_SAVE_DIR:-$HOME/.kube-viya-monitoring}
    mkdir -p "$CA_SAVE_DIR"

    CA_KEY=${CA_KEY:-$CA_SAVE_DIR/rootCA.key}
    CA_CERT=${CA_CERT:-$CA_SAVE_DIR/rootCA.pem}

    CA_PASS=${CA_PASS:-ops4viya}
    CA_DAYS=${CA_DAYS:-1024}
    CA_SUBJ=${CA_SUBJ:-/C=US/ST=North Carolina/O=SAS Institute/distinguished_name=kube-viya-monitoring}

    # Look for saved CAs
    if [ ! -f "$CA_SAVE_DIR/rootCA.key" ]; then
      # Generate new CA key
      openssl genrsa -des3 -out "$CA_KEY" -passout "pass:$CA_PASS" 2048
    fi
    if [ ! -f "$CA_SAVE_DIR/rootCA.pem" ]; then
      # Generate new CA cert
      openssl req -x509 -new -nodes -key "$CA_KEY" -sha256 -days "$CA_DAYS" -out "$CA_CERT" -passin "pass:$CA_PASS" -subj "$CA_SUBJ"
    fi
  elif [ -z "$CA_KEY" ] || [ -z "$CA_CERT" ] || [ -z $"CA_PASS" ]; then
    log_error "Must specify CA_KEY, CA_CERT, and CA_PASS to use an exististing CA"
    log_error "  CA_KEY =[$CA_KEY]"
    log_error "  CA_CERT=[$CA_CERT]"
    exit 1
  else
    log_info "Using existing CA"
    log_info "  CA_KEY =[$CA_KEY]"
    log_info "  CA_CERT=[$CA_CERT]"
    log_info '  CA_PASS=******'
    log_info "  CA_DAYS=[$CA_DAYS]"
  fi

  # Generate server certificates
  KEY_FILE=${KEY_FILE:-$TMP_DIR/tls.key}
  CERT_FILE=${CERT_FILE:-$TMP_DIR/tls.crt}
  CSR_FILE=${CSR_FILE:-$TMP_DIR/server.csr}
  V3_EXT_FILE=$TMP_DIR/v3.ext
  cp monitoring/tls/v3.ext "$V3_EXT_FILE"
  echo "DNS.1 = $MON_INGRESS_HOST" >> "$V3_EXT_FILE"
  echo "DNS.2 = *.$MON_INGRESS_HOST" >> "$V3_EXT_FILE"

  openssl req -new -sha256 -nodes -out "$CSR_FILE" -newkey rsa:2048 -keyout "$KEY_FILE" -config <( cat monitoring/tls/server.csr.cnf )
  openssl x509 -req -in "$CSR_FILE" -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial -out "$CERT_FILE" -days 500 -sha256 -extfile "$V3_EXT_FILE" -passin "pass:$CA_PASS"

  # Prometheus
  TLS_SECRET_NAME=$MON_NS-prometheus-tls-secret
  kubectl delete --ignore-not-found secret -n $MON_NS $TLS_SECRET_NAME
  kubectl create secret tls -n $MON_NS ${TLS_SECRET_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}
  kubectl label secret -n $MON_NS ${TLS_SECRET_NAME} sas.com/monitoring-base=kube-viya-monitoring
  # Grafana
  TLS_SECRET_NAME=$MON_NS-grafana-tls-secret
  kubectl delete --ignore-not-found secret -n $MON_NS $TLS_SECRET_NAME
  kubectl create secret tls -n $MON_NS ${TLS_SECRET_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}
  kubectl label secret -n $MON_NS ${TLS_SECRET_NAME} sas.com/monitoring-base=kube-viya-monitoring

  cat monitoring/tls/values-prom-operator-tls.yaml >> $genValuesFile

  log_info "Provisioning TLS-enabled Prometheus datasource for Grafana..."
  cp monitoring/tls/grafana-datasource-prom-https.yaml $TMP_DIR/grafana-datasource-prom-https.yaml
  if [ "$HELM_VER_MAJOR" == "3" ]; then
    kubectl delete cm -n $MON_NS --ignore-not-found prometheus-operator-grafana-datasource
    echo "      url: https://prometheus-operator-prometheus" >> $TMP_DIR/grafana-datasource-prom-https.yaml
  else
    kubectl delete cm -n $MON_NS --ignore-not-found prometheus-$MON_NS-grafana-datasource
    echo "      url: https://prometheus-$MON_NS-prometheus" >> $TMP_DIR/grafana-datasource-prom-https.yaml
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
