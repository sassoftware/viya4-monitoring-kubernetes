#! /bin/bash

# Copyright © 2020-2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# remove_monitoring_cluster.sh
# Removes the full LGTM monitoring stack deployed by deploy_monitoring_cluster.sh

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source monitoring/bin/common.sh

HELM_RELEASE_PREFIX="${HELM_RELEASE_PREFIX:-v4m}"

if [ "$OPENSHIFT_CLUSTER" = "true" ]; then
    if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" = "true" ]; then
        log_error "This script should not be run on OpenShift clusters"
        log_error "Run monitoring/bin/remove_monitoring_openshift.sh instead"
        exit 1
    fi
fi

MON_DELETE_PVCS_ON_REMOVE=${MON_DELETE_PVCS_ON_REMOVE:-false}
MON_DELETE_NAMESPACE_ON_REMOVE=${MON_DELETE_NAMESPACE_ON_REMOVE:-false}

helm2ReleaseCheck "prometheus-$MON_NS"
helm2ReleaseCheck "${HELM_RELEASE_PREFIX}-$MON_NS"

log_notice "Removing monitoring components from the [$MON_NS] namespace..."

# ============================
# 1. Remove Grafana
# ============================
if helm3ReleaseExists "${HELM_RELEASE_PREFIX}-grafana" "$MON_NS"; then
    log_info "Removing Grafana..."
    if ! helm uninstall --namespace "$MON_NS" "${HELM_RELEASE_PREFIX}-grafana"; then
        log_warn "Uninstall of [${HELM_RELEASE_PREFIX}-grafana] was not successful."
    fi
fi

# ============================
# 2. Remove Prometheus (+ AlertManager)
# ============================
if helm3ReleaseExists "${HELM_RELEASE_PREFIX}-prometheus" "$MON_NS"; then
    log_info "Removing Prometheus..."
    if ! helm uninstall --namespace "$MON_NS" "${HELM_RELEASE_PREFIX}-prometheus"; then
        log_warn "Uninstall of [${HELM_RELEASE_PREFIX}-prometheus] was not successful."
    fi
fi

# ============================
# 2. Remove Pushgateway
# ============================
if helm3ReleaseExists prometheus-pushgateway "$MON_NS"; then
    log_info "Removing Prometheus Pushgateway..."
    helm uninstall --namespace "$MON_NS" prometheus-pushgateway
fi

# ============================
# 3. Remove Tempo
# ============================
if helm3ReleaseExists "${HELM_RELEASE_PREFIX}-tempo" "$MON_NS"; then
    log_info "Removing Tempo..."
    helm uninstall --namespace "$MON_NS" "${HELM_RELEASE_PREFIX}-tempo"
fi

# ============================
# 4. Remove Loki
# ============================
if helm3ReleaseExists "${HELM_RELEASE_PREFIX}-loki" "$MON_NS"; then
    log_info "Removing Loki..."
    helm uninstall --namespace "$MON_NS" "${HELM_RELEASE_PREFIX}-loki"
fi

# ============================
# 5. Remove k8s-monitoring
# ============================
if helm3ReleaseExists "${HELM_RELEASE_PREFIX}-k8s-monitoring" "$MON_NS"; then
    log_info "Removing k8s-monitoring (Alloy)..."
    helm uninstall --namespace "$MON_NS" "${HELM_RELEASE_PREFIX}-k8s-monitoring"
fi

# ============================
# Delete namespace or cleanup
# ============================
if [ "$MON_DELETE_NAMESPACE_ON_REMOVE" == "true" ]; then
    log_info "Deleting the [$MON_NS] namespace..."
    if kubectl delete namespace "$MON_NS" --timeout "$KUBE_NAMESPACE_DELETE_TIMEOUT"; then
        log_info "[$MON_NS] namespace and monitoring components successfully removed"
        exit 0
    else
        log_error "Unable to delete the [$MON_NS] namespace"
        exit 1
    fi
fi

# Remove dashboards
monitoring/bin/remove_dashboards.sh

# Remove Prometheus rules (ConfigMap-based)
log_verbose "Removing Prometheus rules"
kubectl delete cm --ignore-not-found -n "$MON_NS" -l sas.com/monitoring-base=kube-viya-monitoring,app=prometheus-rules

# Remove ConfigMaps and Secrets
log_verbose "Removing configmaps and secrets"
kubectl delete cm --ignore-not-found -n "$MON_NS" -l sas.com/monitoring-base=kube-viya-monitoring
kubectl delete secret --ignore-not-found -n "$MON_NS" -l sas.com/monitoring-base=kube-viya-monitoring
kubectl delete cm --ignore-not-found -n "$MON_NS" grafana-alert-rules

# Remove datasource ConfigMaps
kubectl delete cm --ignore-not-found -n "$MON_NS" grafana-datasource-loki
kubectl delete cm --ignore-not-found -n "$MON_NS" grafana-datasource-tempo
kubectl delete cm --ignore-not-found -n "$MON_NS" grafana-datasource-prometheus
kubectl delete cm --ignore-not-found -n "$MON_NS" grafana-datasource-opensearch

if [ "$MON_DELETE_PVCS_ON_REMOVE" == "true" ]; then
    log_verbose "Removing known monitoring PVCs"
    kubectl delete pvc --ignore-not-found -n "$MON_NS" -l app=alertmanager
    kubectl delete pvc --ignore-not-found -n "$MON_NS" -l app.kubernetes.io/name=grafana
    kubectl delete pvc --ignore-not-found -n "$MON_NS" -l app=prometheus
    kubectl delete pvc --ignore-not-found -n "$MON_NS" -l app.kubernetes.io/name=loki
    kubectl delete pvc --ignore-not-found -n "$MON_NS" -l app.kubernetes.io/name=tempo
fi

# Check for and remove any v4m deployments with old naming convention
removeV4MInfo "$MON_NS" "$HELM_RELEASE_PREFIX"
removeV4MInfo "$MON_NS" "${HELM_RELEASE_PREFIX}-metrics"

# Wait for resources to terminate
log_info "Waiting 60 sec for resources to terminate"
sleep 60

log_info "Checking contents of the [$MON_NS] namespace:"
crds=(all pvc cm)
empty="true"
for crd in "${crds[@]}"; do
    out=$(kubectl get -n "$MON_NS" "$crd" 2>&1)
    if [[ $out =~ 'No resources found' ]]; then
        :
    else
        empty="false"
        log_warn "Found [$crd] resources in the [$MON_NS] namespace:"
        echo "$out"
    fi
done
if [ "$empty" = "true" ]; then
    log_info "  The [$MON_NS] namespace is empty and should be safe to delete."
else
    log_warn "  The [$MON_NS] namespace is not empty."
    log_warn "  Examine the resources above before deleting the namespace."
fi
