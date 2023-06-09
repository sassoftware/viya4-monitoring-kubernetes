#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh
source bin/openshift-include.sh
source bin/tls-include.sh
export TLS_DEPLOY_SELFSIGNED_ISSUERS="false"

set -e

if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should not be run on OpenShift clusters"
    log_error "Run monitoring/bin/deploy_monitoring_openshift.sh instead"
    exit 1
  fi
fi

if [ "$VIYA_NS" == "" ]; then
  log_error "VIYA_NS must be set to the namespace of an existing SAS Viya deployment"
  exit 1
fi

if [ "$VIYA_TENANT" == "" ]; then
  log_error "VIYA_TENANT must be set to the name of a current or planned SAS Viya tenant"
  exit 1
fi

# EXPERIMENTAL Notice
log_notice  "***Experimental - This script may be removed or undergo significant changes in the future***"
log_message " " #blank line to improve readability

# Validate tenant name
validateTenantID $VIYA_TENANT

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
cp -R monitoring/multitenant/* $tenantDir/

# Replace placeholders
log_debug "Replacing __TENANT__ for files in [$tenantDir]"
for f in $(find $tenantDir -name '*.yaml'); do
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

# TLS - Rename certificate files in $TMP_DIR
if [ "$MON_TLS_ENABLE" == "true" ] || [ "$TLS_ENABLE" == "true" ]; then
  log_debug "TLS support is enabled"
  export TLS_CONTEXT_DIR=$tenantDir/tls
  mv $tenantDir/tls/grafana-tls-cert.yaml $tenantDir/tls/grafana-$VIYA_TENANT-tls-cert.yaml
  mv $tenantDir/tls/prometheus-tls-cert.yaml $tenantDir/tls/prometheus-$VIYA_TENANT-tls-cert.yaml
fi

# Grafana options
v4mGrafanaReleasePrefix=v4m-grafana
# Check for existing tenant instance with the old name
if helm3ReleaseExists grafana-$VIYA_TENANT $VIYA_NS; then
  v4mGrafanaReleasePrefix=grafana
fi

grafanaYAML=$tenantDir/mt-grafana-values.yaml

# Grafana TLS
grafanaTLSYAML=$TMP_DIR/empty.yaml
if [ "$MON_TLS_ENABLE" == "true" ] || [ "$TLS_ENABLE" == "true" ]; then
  grafanaTLSYAML=$tenantDir/tls/mt-grafana-tls-values.yaml
fi

# USER_DIR customizations
userGrafanaYAML=$TMP_DIR/empty.yaml
if [ -f "$USER_DIR/monitoring/user-values-grafana-$VIYA_TENANT.yaml" ]; then
  userGrafanaYAML="$USER_DIR/monitoring/user-values-grafana-$VIYA_TENANT.yaml"
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
log_info "Configuring secret for Prometheus federation"
kubectl delete secret --ignore-not-found -n $VIYA_NS prometheus-federate-$VIYA_TENANT
kubectl create secret generic \
  -n $VIYA_NS \
  prometheus-federate-$VIYA_TENANT \
  --from-file cluster-federate-job=$tenantDir/mt-federate-secret.yaml

if [ "$TLS_ENABLE" == "true" ]; then
  apps=( v4m-prometheus-$VIYA_TENANT $v4mGrafanaReleasePrefix-$VIYA_TENANT )
  create_tls_certs $VIYA_NS monitoring ${apps[@]}
fi

# Deploy Prometheus
log_info "Deploying Prometheus"
kubectl apply -n $VIYA_NS -f $tenantDir/mt-prometheus-common.yaml
if [ "$TLS_ENABLE" == "true" ]; then
  kubectl apply -n $VIYA_NS -f $tenantDir/tls/mt-prometheus-tls.yaml
else
  kubectl apply -n $VIYA_NS -f $tenantDir/mt-prometheus.yaml
fi

# Deploy Prometheus Grafana datasource
if [ "$TLS_ENABLE" == "true" ]; then
  grafanaDatasource=$tenantDir/tls/grafana-datasource-tenant-tls.yaml
else
  grafanaDatasource=$tenantDir/grafana-datasource-tenant.yaml
fi
kubectl delete secret -n $VIYA_NS --ignore-not-found grafana-datasource-$VIYA_TENANT
kubectl create secret generic -n $VIYA_NS grafana-datasource-$VIYA_TENANT --from-file $grafanaDatasource
kubectl label secret -n $VIYA_NS grafana-datasource-$VIYA_TENANT grafana_datasource-$VIYA_TENANT=1

# Grafana
if helm3ReleaseExists $v4mGrafanaReleasePrefix-$VIYA_TENANT $VIYA_NS; then
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

# Deploy Grafana using Helm
GRAFANA_CHART_VERSION_TENANT=${GRAFANA_CHART_VERSION_TENANT:-6.56.4}
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
  $v4mGrafanaReleasePrefix-$VIYA_TENANT \
  grafana/grafana

# Deploy ServiceMonitors
kubectl apply -n $VIYA_NS -f $tenantDir/serviceMonitor-sas-cas-tenant.yaml
kubectl apply -n $VIYA_NS -f $tenantDir/serviceMonitor-sas-pushgateway-tenant.yaml

# Elasticsearch Datasource for Grafana
# Moved down to make sure Grafana pods exist
LOGGING_DATASOURCE="${LOGGING_DATASOURCE:-false}"
if [ "$LOGGING_DATASOURCE" == "true" ]; then
  set +e
  log_debug "Creating the logging datasource using the create_logging_datasource script"
  monitoring/bin/create_logging_datasource.sh -ns ${VIYA_NS} -t ${VIYA_TENANT}
  if (( $? == 1 )); then
    log_warn "Unable to configure the logging data source at this time."
    log_warn "Please address the errors and re-run the follow command to create the data source at a later time:"
    log_warn "monitoring/bin/create_logging_datasource.sh -ns ${VIYA_NS} -t ${VIYA_TENANT}"
  fi
  set -e
else
  log_debug "LOGGING_DATASOURCE not set"
  log_debug "Skipping creation of logging data source for Grafana"
fi

function deploy_tenant_dashboards {
   dir=$1
   
   log_message "--------------------------------"
   for f in $dir/*.json; do
     # Need to check existence because if there are no matching files,
     # f will include the wildcard character (*)
     if [ -f "$f" ]; then
       log_debug "Deploying dashboard from file [$f]"
       name=$(basename $f .json)-$VIYA_TENANT
      
       kubectl create cm -n $DASH_NS $name --dry-run=client --from-file $f -o yaml | kubectl apply -f -
       kubectl label cm -n $DASH_NS $name --overwrite grafana_dashboard-$VIYA_TENANT=1 sas.com/monitoring-base=kube-viya-monitoring
     fi
   done
   log_message "--------------------------------"
}

# Deploy dashboards
DASH_NS=$VIYA_NS
DASH_BASE=$tenantDir/dashboards
deploy_tenant_dashboards monitoring/multitenant/dashboards

# If a deployment with the old name exists, remove it first
if helm3ReleaseExists "v4m-tenant-$VIYA_TENANT" $MON_NS; then
  log_verbose "Removing outdated SAS Viya Monitoring Helm chart release for tenant [${VIYA_NS}/${VIYA_TENANT}]"
  helm uninstall -n "$MON_NS" "v4m-tenant-$VIYA_TENANT"
fi

deployV4MInfo "$VIYA_NS" "v4m-metrics-${VIYA_TENANT}"

if [ "$showPass" == "true" ]; then
  # Find the grafana pod
  grafanaPod="$(kubectl get pods -n $VIYA_NS -l app.kubernetes.io/name=grafana -l app.kubernetes.io/instance=v4m-grafana-${VIYA_TENANT} --template='{{range .items}}{{.metadata.name}}{{end}}')"

  log_notice "====================================================================="
  log_notice "Generated Grafana admin password is: $grafanaPwd"
  log_notice "To change the password, run the following script (replace myNewPassword with an updated password):"
  log_notice "monitoring/bin/change_grafana_admin_password.sh -p myNewPassword -ns $VIYA_NS -t $VIYA_TENANT"
  log_notice "====================================================================="
  log_message ""
fi

log_notice "Tenant monitoring is now enabled for [$VIYA_NS/$VIYA_TENANT]"
