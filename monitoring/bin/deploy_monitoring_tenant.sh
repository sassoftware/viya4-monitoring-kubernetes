#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh
source bin/openshift-include.sh

set -e

if [ "$VIYA_NS" == "" ]; then
  log_error "VIYA_NS must be set to the namespace of an existing Viya deployment"
  exit 1
fi

if [ "$VIYA_TENANT" == "" ]; then
  log_error "VIYA_TENANT must be set to the name of an existing Viya tenant"
  exit 1
fi

if [ "$V4M_FEATURE_MULTITENANT_ENABLE" == "true" ]; then
  log_debug "Multi-tenant feature flag is enabled"
else
  log_error "Multi-tenant support is under active development and is not yet fully    "
  log_error "functional. Set V4M_FEATURE_MULTITENANT_ENABLE=true to continue anyway.  "
  log_message ""
  exit 1
fi

checkDefaultStorageClass

HELM_DEBUG="${HELM_DEBUG:-false}"
if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

log_notice "Enabling tenant monitoring for [$VIYA_NS/$VIYA_TENANT]"
helmRepoAdd grafana https://grafana.github.io/helm-charts

log_info "Updating helm repositories..."
helm repo update

# Copy template files to temp
tenantDir=$TMP_DIR/$VIYA_TENANT
mkdir -p $tenantDir
cp monitoring/multitenant/*.yaml $tenantDir/

# Replace placeholders
log_debug "Replacing __TENANT__ for files in [$tenantDir]"
for f in $tenantDir/*; do
  if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
    sed -i '' "s/__TENANT__/$VIYA_TENANT/g" $f
    sed -i '' "s/__TENANT_NS__/$VIYA_NS/g" $f
    sed -i '' "s/__MON_NS__/$MON_NS/g" $f
  else
    sed -i "s/__TENANT__/$VIYA_TENANT/g" $f
    sed -i "s/__TENANT_NS__/$VIYA_NS/g" $f
    sed -i "s/__MON_NS__/$MON_NS/g" $f
  fi
done

# Grafana options
grafanaYAML=$tenantDir/mt-grafana-values.yaml

# TLS
grafanaTLSYAML=$TMP_DIR/empty.yaml
if [ "$MON_TLS_ENABLE" == "true" ] || [ "$TLS_ENABLE" == "true" ]; then
  grafanaTLSYAML=$tenantDir/mt-grafana-tls-values.yaml
fi

# USER_DIR customizations
userGrafanaYAML=$TMP_DIR/empty.yaml
if [ -f "$USER_DIR/monitoring/user-values-multitenant-grafana.yaml" ]; then
  userGrafanaYAML="$USER_DIR/monitoring/user-values-multitenant-grafana.yaml"
  log_debug "User response file for Grafana found at [$userGrafanaYAML]"
fi

# Optional workload node placement support
MON_NODE_PLACEMENT_ENABLE=${MON_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}
if [ "$MON_NODE_PLACEMENT_ENABLE" == "true" ]; then
  log_info "Enabling monitoring components for workload node placement"
  wnpGrafanaValuesFile="monitoring/node-placement/values-grafana-wnp.yaml"
else
  log_debug "Workload node placement support is disabled"
  wnpGrafanaValuesFile="$TMP_DIR/empty.yaml"
fi

# Deploy additional scrape configs for Prometheus
log_info "Creating federation scrape config secret"
kubectl delete secret --ignore-not-found -n $VIYA_NS prometheus-federate-$VIYA_TENANT
kubectl create secret generic \
  -n $VIYA_NS \
  prometheus-federate-$VIYA_TENANT \
  --from-file cluster-federate-job=$tenantDir/mt-federate-secret.yaml

# Deploy Prometheus
log_info "Deploying Prometheus"
kubectl apply -n $VIYA_NS -f $tenantDir/mt-prometheus.yaml

# Deploy Prometheus Grafana datasource
kubectl delete secret -n $VIYA_NS --ignore-not-found grafana-datasource-v4m
kubectl create secret generic -n $VIYA_NS grafana-datasource-v4m --from-file $tenantDir/grafana-datasource-v4m.yaml
kubectl label secret -n $VIYA_NS grafana-datasource-v4m grafana_tenant_datasource=1

# Grafana password
if helm3ReleaseExists grafana-$VIYA_TENANT $VIYA_NS; then
  log_info "Upgrading Grafana via Helm...($(date) - timeout 10m)"
else
  grafanaPwd="$GRAFANA_ADMIN_PASSWORD"
  if [ "$grafanaPwd" == "" ]; then
    log_debug "Generating random Grafana admin password..."
    showPass="true"
    grafanaPwd="$(randomPassword)"
  fi
  log_info "Deploying Grafana via Helm...($(date) - timeout 10m)"
fi

# Deploy Grafana
GRAFANA_CHART_VERSION_TENANT=${GRAFANA_CHART_VERSION_TENANT:-6.9.1}
helm upgrade --install $helmDebug \
  -n "$VIYA_NS" \
  -f "$wnpGrafanaValuesFile" \
  -f "$grafanaYAML" \
  -f "$grafanaTLSYAML" \
  -f "$userGrafanaYAML" \
  --set "extraLabels.sas\\.com/tenant=$VIYA_TENANT" \
  --set adminPassword="$grafanaPwd" \
  --version "$GRAFANA_CHART_VERSION_TENANT" \
  --atomic \
  --timeout "10m" \
  $extraArgs \
  grafana-$VIYA_TENANT \
  grafana/grafana

# Deploy ServiceMonitors
kubectl apply -n $VIYA_NS -f $tenantDir/serviceMonitor-sas-cas-tenant.yaml
kubectl apply -n $VIYA_NS -f $tenantDir/serviceMonitor-sas-pushgateway-tenant.yaml

function deploy_tenant_dashboards {
   dir=$1
   
   log_message "--------------------------------"
   for f in $dir/*.json; do
     # Need to check existence because if there are no matching files,
     # f will include the wildcard character (*)
     if [ -f "$f" ]; then
       log_debug "Deploying dashboard from file [$f]"
       name=$(basename $f .json)
      
       kubectl create cm -n $DASH_NS $name --dry-run=client --from-file $f -o yaml | kubectl apply -f -
       kubectl label cm -n $DASH_NS $name --overwrite grafana_tenant_dashboard=1 sas.com/monitoring-base=kube-viya-monitoring
     fi
   done
   log_message "--------------------------------"
}

# Deploy dashboards
DASH_NS=$VIYA_NS
DASH_BASE=$tenantDir/dashboards
deploy_tenant_dashboards monitoring/multitenant/dashboards

if [ "$showPass" == "true" ]; then
  # Find the grafana pod
  grafanaPod="$(kubectl get po -n $VIYA_NS -l app.kubernetes.io/name=grafana --template='{{range .items}}{{.metadata.name}}{{end}}')"

  log_notice "====================================================================="
  log_notice "Generated Grafana admin password is: $grafanaPwd"
  log_notice "Change the password at any time by running (replace password):       "
  log_notice "kubectl exec -n $VIYA_NS $grafanaPod -c grafana -- bin/grafana-cli admin reset-admin-password myNewPassword"
  log_notice "====================================================================="
  log_message ""
fi

log_notice "Tenant monitoring is now enabled for [$VIYA_NS/$VIYA_TENANT]"