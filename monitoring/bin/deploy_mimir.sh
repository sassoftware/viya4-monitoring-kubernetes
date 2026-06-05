#! /bin/bash

# Copyright © 2020-2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source monitoring/bin/common.sh

export MIMIR_NS="${MIMIR_NS:-mimir}"
export HELM_DEBUG="${HELM_DEBUG:-false}"

# Mimir chart defaults — override via user.env
MIMIR_CHART_REPO="${MIMIR_CHART_REPO:-grafana}"
MIMIR_CHART_NAME="${MIMIR_CHART_NAME:-mimir-distributed}"
MIMIR_CHART_VERSION="${MIMIR_CHART_VERSION:-5.6.0}"

MIMIR_USER_YAML="${MIMIR_USER_YAML:-$USER_DIR/monitoring/user-values-mimir.yaml}"
if [ ! -f "$MIMIR_USER_YAML" ]; then
    log_debug "[$MIMIR_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
    MIMIR_USER_YAML=$TMP_DIR/empty.yaml
fi

if [ "$HELM_DEBUG" == "true" ]; then
    helmDebug="--debug"
fi

set -e

# Create the Mimir namespace
if [ -z "$(kubectl get ns "$MIMIR_NS" -o name 2>/dev/null)" ]; then
    log_info "Creating namespace [$MIMIR_NS]"
    kubectl create ns "$MIMIR_NS"
fi

# Add the Grafana helm chart repository
helmRepoAdd grafana https://grafana.github.io/helm-charts
helm repo update

# Resolve the chart reference
log_debug "Mimir Helm Chart: repo [$MIMIR_CHART_REPO] name [$MIMIR_CHART_NAME] version [$MIMIR_CHART_VERSION]"
chart2install="$(get_helmchart_reference "$MIMIR_CHART_REPO" "$MIMIR_CHART_NAME" "$MIMIR_CHART_VERSION")"
versionstring="$(get_helm_versionstring "$MIMIR_CHART_VERSION")"
log_debug "Installing Helm chart from artifact [$chart2install]"

log_notice "Deploying Mimir to the [$MIMIR_NS] namespace..."

# shellcheck disable=SC2086
helm $helmDebug upgrade --install v4m-mimir \
    $helm4opts \
    --namespace "$MIMIR_NS" \
    -f monitoring/values-mimir.yaml \
    -f "$MIMIR_USER_YAML" \
    --rollback-on-failure \
    --timeout 10m \
    $versionstring \
    "$chart2install"

# Provision the Mimir datasource in Grafana
log_info "Provisioning Mimir datasource for Grafana"
kubectl delete cm -n "$MON_NS" --ignore-not-found grafana-datasource-mimir
kubectl create cm -n "$MON_NS" grafana-datasource-mimir \
    --from-file monitoring/grafana-datasource-mimir.yaml
kubectl label cm -n "$MON_NS" grafana-datasource-mimir \
    grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring

# Configure Prometheus remoteWrite to push metrics to Mimir
PROM_CR=$(kubectl get prometheus -n "$MON_NS" -o name 2>/dev/null | head -1 | cut -d/ -f2)
if [ -n "$PROM_CR" ]; then
    log_info "Configuring Prometheus CR [$PROM_CR] remoteWrite -> Mimir"
    kubectl patch prometheus "$PROM_CR" -n "$MON_NS" --type=merge -p \
        "{\"spec\":{\"remoteWrite\":[{\"url\":\"http://v4m-mimir-nginx.$MIMIR_NS:80/api/v1/push\",\"headers\":{\"X-Scope-OrgID\":\"anonymous\"}}]}}"
    log_notice "remoteWrite configured. Prometheus will begin forwarding metrics to Mimir."
    log_notice "Note: this patch is overwritten on the next kube-prometheus-stack helm upgrade."
    log_notice "To make it permanent, add the following to your user-values-prom-operator.yaml:"
    log_notice ""
    log_notice "  prometheus:"
    log_notice "    prometheusSpec:"
    log_notice "      remoteWrite:"
    log_notice "        - url: http://v4m-mimir-nginx.$MIMIR_NS:80/api/v1/push"
    log_notice "          headers:"
    log_notice "            X-Scope-OrgID: anonymous"
    log_notice ""
else
    log_warn "No Prometheus CR found in namespace [$MON_NS]. Skipping automatic remoteWrite configuration."
    log_warn "Add the following to your user-values-prom-operator.yaml and redeploy monitoring:"
    log_warn ""
    log_warn "  prometheus:"
    log_warn "    prometheusSpec:"
    log_warn "      remoteWrite:"
    log_warn "        - url: http://v4m-mimir-nginx.$MIMIR_NS:80/api/v1/push"
    log_warn "          headers:"
    log_warn "            X-Scope-OrgID: anonymous"
    log_warn ""
fi

log_notice "Successfully deployed Mimir to the [$MIMIR_NS] namespace"
log_notice "Mimir query endpoint: http://v4m-mimir-nginx.$MIMIR_NS:80/prometheus"
log_notice "Grafana datasource 'Mimir' has been provisioned"
