#! /bin/bash

# Copyright © 2020-2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# deploy_monitoring_cluster.sh
# Thin Helm wrapper that deploys the full LGTM monitoring stack:
#   1. k8s-monitoring (Alloy-based collection)
#   2. Grafana Loki (log storage)
#   3. Grafana Tempo (trace storage)
#   4. Prometheus (remote-write TSDB + AlertManager)
#   5. Grafana (dashboards + datasources)
#   6. Prometheus Pushgateway (optional)
#   7. Grafana datasource + dashboard ConfigMaps

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source monitoring/bin/common.sh
source bin/service-url-include.sh

# Confirm NOT on OpenShift (unless overridden)
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" = "true" ]; then
        log_error "This script should not be run on OpenShift clusters"
        log_error "Run monitoring/bin/deploy_monitoring_openshift.sh instead"
        exit 1
    fi
fi

checkDefaultStorageClass

export HELM_DEBUG="${HELM_DEBUG:-false}"
if [ "$HELM_DEBUG" == "true" ]; then
    helmDebug="--debug"
fi

# Create namespace if it doesn't exist
if [ -z "$(kubectl get ns "$MON_NS" -o name 2> /dev/null)" ]; then
    kubectl create ns "$MON_NS"
    disable_sa_token_automount "$MON_NS" default
fi

log_notice "Deploying monitoring components to the [$MON_NS] namespace [$(date)]"

set -e

# ============================
# Resolve namespace placeholders in values files
# ============================
# Values files use __MON_NS__, __LOG_NS__ and __RELEASE_PREFIX__ placeholders.
# Create runtime copies with actual values substituted.
LOG_NS="${LOG_NS:-logging}"
HELM_RELEASE_PREFIX="${HELM_RELEASE_PREFIX:-v4m}"

k8sMonValues="$TMP_DIR/values-k8s-monitoring.yaml"
cp monitoring/values-k8s-monitoring.yaml "$k8sMonValues"
sed -i "s/__MON_NS__/$MON_NS/g; s/__LOG_NS__/$LOG_NS/g; s/__RELEASE_PREFIX__/$HELM_RELEASE_PREFIX/g" "$k8sMonValues"

tempoValues="$TMP_DIR/values-tempo.yaml"
cp monitoring/values-tempo.yaml "$tempoValues"
sed -i "s/__MON_NS__/$MON_NS/g; s/__RELEASE_PREFIX__/$HELM_RELEASE_PREFIX/g" "$tempoValues"

promValues="$TMP_DIR/values-prometheus.yaml"
cp monitoring/values-prometheus.yaml "$promValues"
sed -i "s/__RELEASE_PREFIX__/$HELM_RELEASE_PREFIX/g" "$promValues"

# Grafana ingress placeholders
ROUTING="${ROUTING:-host}"
GRAFANA_INGRESS_ENABLE="${GRAFANA_INGRESS_ENABLE:-true}"
if [ -n "$BASE_DOMAIN" ] && [ "$GRAFANA_INGRESS_ENABLE" == "true" ]; then
    if [ "$ROUTING" == "host" ]; then
        GRAFANA_HOST="${GRAFANA_HOST:-${HELM_RELEASE_PREFIX}-grafana.$BASE_DOMAIN}"
    else
        GRAFANA_HOST="${GRAFANA_HOST:-$BASE_DOMAIN}"
    fi
    INGRESS_CLASS="${INGRESS_CLASS:-nginx}"
    TLS_SECRET_NAME="${GRAFANA_TLS_SECRET:-grafana-tls-secret}"
    GRAFANA_INGRESS_ENABLED_VAL="true"

    # Create TLS secret from certs if provided
    if [ -n "$INGRESS_CERT" ] && [ -n "$INGRESS_KEY" ] && [ -f "$INGRESS_CERT" ] && [ -f "$INGRESS_KEY" ]; then
        kubectl delete secret "$TLS_SECRET_NAME" --namespace "$MON_NS" --ignore-not-found
        kubectl create secret tls "$TLS_SECRET_NAME" --namespace "$MON_NS" \
            --key="$INGRESS_KEY" --cert="$INGRESS_CERT"
    fi
    log_info "Grafana ingress will be created at: $GRAFANA_HOST"
else
    GRAFANA_HOST="chart-example.local"
    INGRESS_CLASS="nginx"
    TLS_SECRET_NAME="grafana-tls-secret"
    GRAFANA_INGRESS_ENABLED_VAL="false"
fi

grafanaValues="$TMP_DIR/values-grafana.yaml"
cp monitoring/values-grafana.yaml "$grafanaValues"
sed -i "s/__GRAFANA_INGRESS_ENABLED__/$GRAFANA_INGRESS_ENABLED_VAL/g; s/__GRAFANA_HOST__/$GRAFANA_HOST/g; s/__INGRESS_CLASS__/$INGRESS_CLASS/g; s/__TLS_SECRET_NAME__/$TLS_SECRET_NAME/g; s/__RELEASE_PREFIX__/$HELM_RELEASE_PREFIX/g" "$grafanaValues"

# ============================
# Add Helm repositories
# ============================
helmRepoAdd prometheus-community https://prometheus-community.github.io/helm-charts
helmRepoAdd grafana https://grafana.github.io/helm-charts
helmRepoAdd grafana-community https://grafana-community.github.io/helm-charts

log_info "Updating helm repositories..."
helm repo update

# ============================
# User override files
# ============================
PROMETHEUS_USER_YAML="${PROMETHEUS_USER_YAML:-$USER_DIR/monitoring/user-values-prometheus.yaml}"
if [ ! -f "$PROMETHEUS_USER_YAML" ]; then
    PROMETHEUS_USER_YAML=$TMP_DIR/empty.yaml
fi

GRAFANA_USER_YAML="${GRAFANA_USER_YAML:-$USER_DIR/monitoring/user-values-grafana.yaml}"
if [ ! -f "$GRAFANA_USER_YAML" ]; then
    GRAFANA_USER_YAML=$TMP_DIR/empty.yaml
fi

K8S_MONITORING_USER_YAML="${K8S_MONITORING_USER_YAML:-$USER_DIR/monitoring/user-values-k8s-monitoring.yaml}"
if [ ! -f "$K8S_MONITORING_USER_YAML" ]; then
    K8S_MONITORING_USER_YAML=$TMP_DIR/empty.yaml
fi

LOKI_USER_YAML="${LOKI_USER_YAML:-$USER_DIR/monitoring/user-values-loki.yaml}"
if [ ! -f "$LOKI_USER_YAML" ]; then
    LOKI_USER_YAML=$TMP_DIR/empty.yaml
fi

TEMPO_USER_YAML="${TEMPO_USER_YAML:-$USER_DIR/monitoring/user-values-tempo.yaml}"
if [ ! -f "$TEMPO_USER_YAML" ]; then
    TEMPO_USER_YAML=$TMP_DIR/empty.yaml
fi

PUSHGATEWAY_USER_YAML="${PUSHGATEWAY_USER_YAML:-$USER_DIR/monitoring/user-values-pushgateway.yaml}"
if [ ! -f "$PUSHGATEWAY_USER_YAML" ]; then
    PUSHGATEWAY_USER_YAML=$TMP_DIR/empty.yaml
fi

# ============================
# Auto-generated storage class overrides
# ============================
autogeneratedYAMLFile="$TMP_DIR/autogenerate-prometheus.yaml"
autogeneratedGrafanaYAML="$TMP_DIR/autogenerate-grafana.yaml"
autogeneratedLokiYAML="$TMP_DIR/autogenerate-loki.yaml"
autogeneratedTempoYAML="$TMP_DIR/autogenerate-tempo.yaml"

AUTOGENERATE_STORAGECLASS="${AUTOGENERATE_STORAGECLASS:-false}"
if [ "$AUTOGENERATE_STORAGECLASS" == "true" ]; then
    touch "$autogeneratedYAMLFile" "$autogeneratedGrafanaYAML" "$autogeneratedLokiYAML" "$autogeneratedTempoYAML"

    # Prometheus storageClass
    storageClass="${PROMETHEUS_STORAGECLASS:-$STORAGECLASS}"
    if [ -n "$storageClass" ]; then
        sc="$storageClass" yq -i '.server.persistentVolume.storageClass=env(sc)' "$autogeneratedYAMLFile"
    fi

    # AlertManager storageClass
    storageClass="${ALERTMANAGER_STORAGECLASS:-$STORAGECLASS}"
    if [ -n "$storageClass" ]; then
        sc="$storageClass" yq -i '.alertmanager.persistence.storageClass=env(sc)' "$autogeneratedYAMLFile"
    fi

    # Grafana storageClass
    storageClass="${GRAFANA_STORAGECLASS:-$STORAGECLASS}"
    if [ -n "$storageClass" ]; then
        sc="$storageClass" yq -i '.persistence.storageClassName=env(sc)' "$autogeneratedGrafanaYAML"
    fi

    # Loki storageClass (SingleBinary mode)
    storageClass="${LOKI_STORAGECLASS:-$STORAGECLASS}"
    if [ -n "$storageClass" ]; then
        sc="$storageClass" yq -i '.singleBinary.persistence.storageClassName=env(sc)' "$autogeneratedLokiYAML"
    fi

    # Tempo storageClass
    storageClass="${TEMPO_STORAGECLASS:-$STORAGECLASS}"
    if [ -n "$storageClass" ]; then
        sc="$storageClass" yq -i '.persistence.storageClassName=env(sc)' "$autogeneratedTempoYAML"
    fi
else
    autogeneratedYAMLFile="$TMP_DIR/empty.yaml"
    autogeneratedGrafanaYAML="$TMP_DIR/empty.yaml"
    autogeneratedLokiYAML="$TMP_DIR/empty.yaml"
    autogeneratedTempoYAML="$TMP_DIR/empty.yaml"
fi

# ============================
# Storage size overrides
# ============================
storageSizeOverrides="$TMP_DIR/storage-overrides.yaml"
touch "$storageSizeOverrides"

if [ -n "$PROMETHEUS_STORAGE_SIZE" ]; then
    size="$PROMETHEUS_STORAGE_SIZE" yq -i '.server.persistentVolume.size=env(size)' "$storageSizeOverrides"
fi

lokiStorageSizeOverrides="$TMP_DIR/loki-storage-overrides.yaml"
touch "$lokiStorageSizeOverrides"
if [ -n "$LOKI_STORAGE_SIZE" ]; then
    size="$LOKI_STORAGE_SIZE" yq -i '.singleBinary.persistence.size=env(size)' "$lokiStorageSizeOverrides"
fi

tempoStorageSizeOverrides="$TMP_DIR/tempo-storage-overrides.yaml"
touch "$tempoStorageSizeOverrides"
if [ -n "$TEMPO_STORAGE_SIZE" ]; then
    size="$TEMPO_STORAGE_SIZE" yq -i '.persistence.size=env(size)' "$tempoStorageSizeOverrides"
fi

# ============================
# OpenShift platform overlay
# ============================
openshiftOverlay="$TMP_DIR/empty.yaml"
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    openshiftOverlay="$TMP_DIR/openshift-overlay.yaml"
    echo 'global:' > "$openshiftOverlay"
    echo '  platform: openshift' >> "$openshiftOverlay"
fi

# ============================
# OpenSearch dual-export toggle
# ============================
OPENSEARCH_DUAL_EXPORT_ENABLE="${OPENSEARCH_DUAL_EXPORT_ENABLE:-true}"
k8sMonitoringDualExportOverlay="$TMP_DIR/empty.yaml"
if [ "$OPENSEARCH_DUAL_EXPORT_ENABLE" == "false" ]; then


    k8sMonitoringDualExportOverlay="$TMP_DIR/disable-opensearch-gateway.yaml"
    cat > "$k8sMonitoringDualExportOverlay" <<EOF
# Remove OpenSearch gateway destination and extraObjects (v4 map format)
destinations:
  prometheus:
    type: prometheus
    url: http://${HELM_RELEASE_PREFIX}-prometheus-server.${MON_NS}:80/api/v1/write
  loki:
    type: loki
    url: http://${HELM_RELEASE_PREFIX}-loki-gateway.${MON_NS}:80/loki/api/v1/push
  tempo:
    type: otlp
    url: http://${HELM_RELEASE_PREFIX}-tempo.${MON_NS}:4317
    protocol: grpc
    tls:
      insecure: true
    metrics: { enabled: false }
    logs: { enabled: false }
    traces: { enabled: true }
podLogsViaLoki:
  destinations: [loki]
clusterEvents:
  destinations: [loki]
extraObjects: []
EOF
fi

# ============================
# 0a. Install Alloy Operator CRD (required by k8s-monitoring v4)
# ============================
log_info "Ensuring Alloy Operator CRD is installed..."
kubectl apply -f https://github.com/grafana/alloy-operator/releases/latest/download/collectors.grafana.com_alloy.yaml 2>/dev/null || true

# ============================
# 0b. Install Prometheus Operator CRDs (required for prometheusOperatorObjects)
# ============================
# k8s-monitoring v4 no longer bundles these CRDs; they must be installed separately.
log_info "Ensuring Prometheus Operator CRDs are installed..."
helm upgrade --install prometheus-operator-crds \
    --repo https://prometheus-community.github.io/helm-charts \
    prometheus-operator-crds \
    --namespace "$MON_NS" \
    --wait --timeout 2m 2>/dev/null || true

# ============================
# 1. Deploy k8s-monitoring (Alloy collection)
# ============================
log_info "Deploying k8s-monitoring (Alloy collection layer)..."

chart2install="$(get_helmchart_reference "$K8S_MONITORING_CHART_REPO" "$K8S_MONITORING_CHART_NAME" "$K8S_MONITORING_CHART_VERSION")"
versionstring="$(get_helm_versionstring "$K8S_MONITORING_CHART_VERSION")"

# shellcheck disable=SC2086
helm $helmDebug upgrade --install "${HELM_RELEASE_PREFIX}-k8s-monitoring" \
    --namespace "$MON_NS" \
    -f "$k8sMonValues" \
    -f "$openshiftOverlay" \
    -f "$k8sMonitoringDualExportOverlay" \
    -f "$K8S_MONITORING_USER_YAML" \
    --atomic \
    --timeout 10m \
    $versionstring \
    "$chart2install"

# ============================
# 1a. Patch Alloy receiver ConfigMap with custom connectors
# ============================
# The k8s-monitoring chart cannot natively configure the service graph
# connector or HTTP route normalization transforms.  Apply a patched
# ConfigMap that adds these, then restart the receiver pods.
log_info "Applying custom Alloy receiver ConfigMap..."

receiverCM="$TMP_DIR/alloy-receiver-configmap.yaml"
cp monitoring/alloy-receiver-configmap.yaml "$receiverCM"

CLUSTER_NAME="${CLUSTER_NAME:-${HELM_RELEASE_PREFIX}-cluster}"
sed -i "s/__MON_NS__/$MON_NS/g; s/__RELEASE_PREFIX__/$HELM_RELEASE_PREFIX/g; s/__CLUSTER_NAME__/$CLUSTER_NAME/g" "$receiverCM"

kubectl apply -n "$MON_NS" -f "$receiverCM"
kubectl rollout restart daemonset "${HELM_RELEASE_PREFIX}-k8s-monitoring-alloy-receiver" -n "$MON_NS" 2>/dev/null || true

# ============================
# 2. Deploy Grafana Loki
# ============================
LOKI_ENABLE="${LOKI_ENABLE:-true}"
if [ "$LOKI_ENABLE" == "true" ]; then
    log_info "Deploying Grafana Loki..."

    chart2install="$(get_helmchart_reference "$LOKI_CHART_REPO" "$LOKI_CHART_NAME" "$LOKI_CHART_VERSION")"
    versionstring="$(get_helm_versionstring "$LOKI_CHART_VERSION")"

    # shellcheck disable=SC2086
    helm $helmDebug upgrade --install "${HELM_RELEASE_PREFIX}-loki" \
        --namespace "$MON_NS" \
        -f monitoring/values-loki.yaml \
        -f "$autogeneratedLokiYAML" \
        -f "$lokiStorageSizeOverrides" \
        -f "$LOKI_USER_YAML" \
        --atomic \
        --timeout 10m \
        $versionstring \
        "$chart2install"
fi

# ============================
# 3. Deploy Grafana Tempo
# ============================
TRACING_ENABLE="${TRACING_ENABLE:-true}"
if [ "$TRACING_ENABLE" == "true" ]; then
    log_info "Deploying Grafana Tempo..."

    chart2install="$(get_helmchart_reference "$TEMPO_CHART_REPO" "$TEMPO_CHART_NAME" "$TEMPO_CHART_VERSION")"
    versionstring="$(get_helm_versionstring "$TEMPO_CHART_VERSION")"

    # shellcheck disable=SC2086
    helm $helmDebug upgrade --install "${HELM_RELEASE_PREFIX}-tempo" \
        --namespace "$MON_NS" \
        -f "$tempoValues" \
        -f "$autogeneratedTempoYAML" \
        -f "$tempoStorageSizeOverrides" \
        -f "$TEMPO_USER_YAML" \
        --atomic \
        --timeout 10m \
        $versionstring \
        "$chart2install"
fi

# ============================
# 4. Deploy Prometheus (remote-write TSDB + AlertManager)
# ============================
log_info "Deploying Prometheus..."

promRelease="${HELM_RELEASE_PREFIX}-prometheus"

chart2install="$(get_helmchart_reference "$PROMETHEUS_CHART_REPO" "$PROMETHEUS_CHART_NAME" "$PROMETHEUS_CHART_VERSION")"
versionstring="$(get_helm_versionstring "$PROMETHEUS_CHART_VERSION")"

# shellcheck disable=SC2086
helm $helmDebug upgrade --install "$promRelease" \
    --namespace "$MON_NS" \
    -f "$promValues" \
    -f "$autogeneratedYAMLFile" \
    -f "$storageSizeOverrides" \
    -f "$PROMETHEUS_USER_YAML" \
    --atomic \
    --timeout 10m \
    $versionstring \
    "$chart2install"

# ============================
# 5. Deploy Grafana
# ============================
log_info "Deploying Grafana..."

grafanaRelease="${HELM_RELEASE_PREFIX}-grafana"

# Grafana admin password
grafanaPwd="$GRAFANA_ADMIN_PASSWORD"
if ! helm3ReleaseExists "$grafanaRelease" "$MON_NS"; then
    if [ -z "$grafanaPwd" ]; then
        log_debug "Generating random Grafana admin password"
        showPass="true"
        grafanaPwd="$(randomPassword)"
    fi
fi

# Alerts ConfigMap
CUSTOM_ALERT_CONFIG_DIR="$USER_DIR/monitoring/alerting/"
if [ -d "$CUSTOM_ALERT_CONFIG_DIR" ] && [ "$(ls -A "$CUSTOM_ALERT_CONFIG_DIR" 2> /dev/null)" ]; then
    kubectl create configmap grafana-alert-rules \
        --from-file="$CUSTOM_ALERT_CONFIG_DIR" \
        -n "$MON_NS" \
        --dry-run=client -o yaml | kubectl apply -f -
else
    kubectl create configmap grafana-alert-rules \
        -n "$MON_NS" \
        --from-literal=_README.txt="Copy alert rules from samples/alerts to $USER_DIR/monitoring/alerting/ to enable them." \
        --dry-run=client -o yaml | kubectl apply -f -
fi

chart2install="$(get_helmchart_reference "$GRAFANA_CHART_REPO" "$GRAFANA_CHART_NAME" "$GRAFANA_CHART_VERSION")"
versionstring="$(get_helm_versionstring "$GRAFANA_CHART_VERSION")"

# shellcheck disable=SC2086
helm $helmDebug upgrade --install "$grafanaRelease" \
    --namespace "$MON_NS" \
    -f "$grafanaValues" \
    -f "$autogeneratedGrafanaYAML" \
    -f "$GRAFANA_USER_YAML" \
    --set adminPassword="$grafanaPwd" \
    --atomic \
    --timeout 10m \
    $versionstring \
    "$chart2install"

# ============================
# 6. Deploy Pushgateway (optional)
# ============================
PUSHGATEWAY_ENABLED=${PUSHGATEWAY_ENABLED:-true}
if [ "$PUSHGATEWAY_ENABLED" == "true" ]; then
    log_info "Deploying Prometheus Pushgateway..."

    chart2install="$(get_helmchart_reference "$PUSHGATEWAY_CHART_REPO" "$PUSHGATEWAY_CHART_NAME" "$PUSHGATEWAY_CHART_VERSION")"
    versionstring="$(get_helm_versionstring "$PUSHGATEWAY_CHART_VERSION")"

    # shellcheck disable=SC2086
    helm $helmDebug upgrade --install prometheus-pushgateway \
        --namespace "$MON_NS" \
        -f monitoring/values-pushgateway.yaml \
        -f "$PUSHGATEWAY_USER_YAML" \
        $versionstring \
        "$chart2install"
fi

# ============================
# 7. Deploy Grafana datasource ConfigMaps
# ============================
log_info "Deploying Grafana datasource ConfigMaps..."
for f in monitoring/grafana/datasource-*.yaml; do
    if [ -f "$f" ]; then
        sed "s/__RELEASE_PREFIX__/$HELM_RELEASE_PREFIX/g" "$f" | kubectl apply -n "$MON_NS" -f -
    fi
done

# ============================
# 8. Deploy Prometheus rules
# ============================
log_info "Deploying Prometheus recording rules..."
for f in monitoring/rules/viya/rules-*.yaml; do
    if [ -f "$f" ]; then
        kubectl apply -n "$MON_NS" -f "$f"
    fi
done

# ============================
# 9. Deploy dashboards
# ============================
log_info "Deploying Grafana dashboards..."
monitoring/bin/deploy_dashboards.sh

# ============================
# Version info
# ============================
if helm3ReleaseExists "$HELM_RELEASE_PREFIX" "$MON_NS"; then
    helm uninstall -n "$MON_NS" "$HELM_RELEASE_PREFIX"
fi

if ! deployV4MInfo "$MON_NS" "${HELM_RELEASE_PREFIX}-metrics"; then
    log_warn "Unable to update SAS Viya Monitoring Helm chart release"
fi

# ============================
# Print access URLs
# ============================
set +e
get_ingress_ports 2>/dev/null
gf_url=$(get_service_url "$MON_NS" "${HELM_RELEASE_PREFIX}-grafana" "$TLS_ENABLE" 2>/dev/null)
set -e

log_notice ""
log_notice "GRAFANA: "
if [ -n "$gf_url" ]; then
    log_notice "  $gf_url"
else
    log_notice "  It was not possible to determine the URL needed to access Grafana."
    log_notice "  This is not necessarily a problem; it may reflect an incomplete ingress configuration."
fi

if [ "$showPass" == "true" ]; then
    log_notice ""
    log_notice "Generated Grafana admin password: $grafanaPwd"
    log_notice "To change the password, run: monitoring/bin/change_grafana_admin_password.sh"
fi

display_notices

log_message ""
log_notice "The deployment of monitoring components has completed [$(date)]"
