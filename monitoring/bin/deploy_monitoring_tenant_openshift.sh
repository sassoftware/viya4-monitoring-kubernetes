#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh

if [ "$OPENSHIFT_TENANT_MONITORING_ENABLE" != "true" ]; then
  log_error "OpenShift tenant monitoring is currently under development and is not supported"
  exit 1
fi

if [ "$OPENSHIFT_CLUSTER" != "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should only be run on OpenShift clusters"
    log_error "Run monitoring/bin/deploy_monitoring_cluster.sh instead"
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


log_notice "Deploying OpenShift tenant monitoring for [$VIYA_TENANT] to the [$VIYA_NS] namespace..."

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

checkDefaultStorageClass
set -e

export HELM_DEBUG="${HELM_DEBUG:-false}"
if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

if [ -z "$(kubectl get ns $VIYA_NS -o name 2>/dev/null)" ]; then
  kubectl create ns $VIYA_NS
fi

v4mGrafanaReleasePrefix=v4m-grafana
# Check for existing tenant instance with the old name
if helm3ReleaseExists grafana-$VIYA_TENANT $VIYA_NS; then
  v4mGrafanaReleasePrefix=grafana
fi

log_info "Deploying Prometheus Operator to the $VIYA_TENANT namespace..."
oc apply -f $tenantDir/openshift/operator-group.yaml
oc apply -f $tenantDir/openshift/operator-subscription.yaml

log_info "Enabling Grafana to access OpenShift Prometheus instances..."
if [ -z "$(kubectl get serviceAccount -n $VIYA_NS grafana-serviceaccount-$VIYA_TENANT -o name 2>/dev/null)" ]; then
  log_info "Creating [$VIYA_TENANT] tenant Grafana serviceAccount..."
  kubectl create serviceaccount -n $VIYA_NS grafana-serviceaccount-$VIYA_TENANT
fi

# Add the grafana helm chart repo
helmRepoAdd grafana https://grafana.github.io/helm-charts
log_info "Updating helm repositories..."
helm repo update

log_info "Deploying [$VIYA_TENANT] tenant monitoring components for OpenShift..."

# Deploy additional scrape configs for Prometheus
log_info "Configuring secret for Prometheus federation"
kubectl delete secret --ignore-not-found -n $VIYA_NS prometheus-federate-$VIYA_TENANT
kubectl create secret generic \
  -n $VIYA_NS \
  prometheus-federate-$VIYA_TENANT \
  --from-file cluster-federate-job=$tenantDir/openshift/mt-federate-secret-openshift.yaml

# Deploy Prometheus
log_info "Deploying Prometheus..."
kubectl apply -n $VIYA_NS -f $tenantDir/openshift/mt-prometheus-openshift.yaml

log_debug "Adding cluster role to Grafana service account..."
oc adm policy add-cluster-role-to-user cluster-monitoring-view -z prometheus-k8s -n $VIYA_NS
oc adm policy add-cluster-role-to-user cluster-monitoring-view -z grafana-serviceaccount-$VIYA_TENANT -n $VIYA_NS
log_debug "Obtaining Grafana serviceaccount token..."

# Deploy Prometheus Grafana datasource
grafanaDatasource=$tenantDir/tls/grafana-datasource-tenant-tls.yaml
kubectl delete secret -n $VIYA_NS --ignore-not-found grafana-datasource-$VIYA_TENANT
kubectl create secret generic -n $VIYA_NS grafana-datasource-$VIYA_TENANT --from-file $grafanaDatasource
kubectl label secret -n $VIYA_NS grafana-datasource-$VIYA_TENANT grafana_datasource-$VIYA_TENANT=1

log_info "Deploying Grafana..."
userGrafanaYAML=$TMP_DIR/empty.yaml
if [ -f "$USER_DIR/monitoring/user-values-openshift-grafana-$VIYA_TENANT.yaml" ]; then
  userGrafanaYAML="$USER_DIR/monitoring/user-values-openshift-grafana-$VIYA_TENANT.yaml"
  log_debug "User response file for Grafana found at [$userGrafanaYAML]"
fi

if ! helm3ReleaseExists $v4mGrafanaReleasePrefix-$VIYA_TENANT $VIYA_NS; then
  firstTimeGrafana=true
fi

OPENSHIFT_AUTH_ENABLE=${OPENSHIFT_AUTH_ENABLE:-true}
log_debug "Creating the Prometheus service to generate TLS certs..."
kubectl apply -n $VIYA_NS -f $tenantDir/openshift/v4m-prometheus-tenant-svc.yaml
log_debug "Creating the Grafana service to generate TLS certs..."
kubectl apply -n $VIYA_NS -f $tenantDir/openshift/v4m-grafana-tenant-svc.yaml
grafanaAuthYAML="monitoring/openshift/grafana-proxy-values.yaml"

if [ -n "$GRAFANA_ADMIN_PASSWORD" ]; then
  grafanaPwd="--set adminPassword=$GRAFANA_ADMIN_PASSWORD"
fi

# Optional workload node placement support
MON_NODE_PLACEMENT_ENABLE=${MON_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}
if [ "$MON_NODE_PLACEMENT_ENABLE" == "true" ]; then
  log_info "Enabling monitoring components for workload node placement"
  wnpValuesFile="monitoring/node-placement/values-grafana-wnp.yaml"
else
  log_debug "Workload node placement support is disabled"
  wnpValuesFile="$TMP_DIR/empty.yaml"
fi

if [ "$OPENSHIFT_PATH_ROUTES" == "true" ]; then
  OPENSHIFT_ROUTE_PATH_GRAFANA=${OPENSHIFT_ROUTE_PATH_GRAFANA:-/grafana}
fi
if [ "$OPENSHIFT_ROUTE_PATH_GRAFANA" != "" ] && [ "$OPENSHIFT_ROUTE_PATH_GRAFANA" != "/" ]; then
  grafanaSubPath="true"
else
  grafanaSubPath="false"
fi

log_info "Deploying Grafana..."
grafanaYAML=$tenantDir/openshift/mt-grafana-openshift-values.yaml
OPENSHIFT_GRAFANA_CHART_VERSION=${OPENSHIFT_GRAFANA_CHART_VERSION:-6.56.4}
helm upgrade --install $helmDebug \
  -n "$VIYA_NS" \
  -f "$wnpValuesFile" \
  -f "$grafanaYAML" \
  -f "$grafanaAuthYAML" \
  -f "$userGrafanaYAML" \
  --set 'grafana\.ini'.server.domain=$OPENSHIFT_ROUTE_DOMAIN \
  --set 'grafana\.ini'.server.root_url=https://v4m-grafana-$VIYA_NS.$OPENSHIFT_ROUTE_DOMAIN$OPENSHIFT_ROUTE_PATH_GRAFANA \
  --set 'grafana\.ini'.server.serve_from_sub_path=$grafanaSubPath \
  --version "$OPENSHIFT_GRAFANA_CHART_VERSION" \
  --atomic \
  $grafanaPwd \
  $extraArgs \
  v4m-grafana-$VIYA_NS-$VIYA_TENANT \
  grafana/grafana

if [ "$OPENSHIFT_AUTH_ENABLE" == "true" ]; then
  log_info "Using OpenShift authentication for [$VIYA_TENANT] tenant instance of Grafana"
  log_debug "Annotating grafana-serviceaccount-$VIYA_TENANT"
  kubectl annotate serviceaccount -n $VIYA_NS --overwrite grafana-serviceaccount-$VIYA_TENANT 'serviceaccounts.openshift.io/oauth-redirectreference.primary={"kind":"OAuthRedirectReference","apiVersion":"v1","reference":{"kind":"Route","name":"v4m-grafana-'$VIYA_TENANT'"}}'

  log_debug "Configuring Grafana proxy"
  kubectl apply -n $VIYA_NS -f monitoring/openshift/grafana-proxy-secret.yaml

  grafanaProxyPatchYAML=$TMP_DIR/grafana-proxy-patch.yaml
  if [ "$OPENSHIFT_PATH_ROUTES" == "true" ]; then
    log_debug "Using path-based version of the OpenShift Grafana proxy patch"
    cp $tenantDir/openshift/grafana-proxy-patch-tenant-path.yaml $grafanaProxyPatchYAML
  else
    log_debug "Using host-based version of the OpenShift Grafana proxy patch"
    cp $tenantDir/openshift/grafana-proxy-patch-tenant-host.yaml $grafanaProxyPatchYAML
  fi

  log_debug "Deploying CA bundle..."
  kubectl apply -n $VIYA_NS -f $tenantDir/openshift/trusted-ca-bundle.yaml

  log_info "Patching Grafana service for auto-generated TLS certs"
  kubectl annotate service -n $VIYA_NS --overwrite $v4mGrafanaReleasePrefix-$VIYA_TENANT "service.beta.openshift.io/serving-cert-secret-name=grafana-tls-$VIYA_TENANT"

  log_info "Patching Grafana pod with authenticating TLS proxy..."
  kubectl patch deployment -n $VIYA_NS v4m-grafana-$VIYA_NS-$VIYA_TENANT --patch "$(cat $grafanaProxyPatchYAML)"
else
  log_info "Using native Grafana authentication"
fi

log_debug "Creating tenant ServiceMonitors..."
kubectl apply -n $VIYA_NS -f $tenantDir/serviceMonitor-sas-cas-tenant.yaml
kubectl apply -n $VIYA_NS -f $tenantDir/serviceMonitor-sas-pushgateway-tenant.yaml

function deploy_tenant_dashboards {
   dir=$1
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
}

# Deploy dashboards
DASH_NS=$VIYA_NS
DASH_BASE=$tenantDir/dashboards
deploy_tenant_dashboards monitoring/multitenant/dashboards

log_debug "Adding SAS Viya recording rules..."
for f in monitoring/rules/viya/rules-*.yaml; do
  kubectl apply -n $VIYA_NS -f $f
done

if [ "$OPENSHIFT_PATH_ROUTES" == "true" ]; then
  routeHost=${OPENSHIFT_ROUTE_HOST_GRAFANA:-v4m-$VIYA_TENANT-$VIYA_NS.$OPENSHIFT_ROUTE_DOMAIN}
else
  routeHost=${OPENSHIFT_ROUTE_HOST_GRAFANA:-$v4mGrafanaReleasePrefix-$VIYA_TENANT-$VIYA_NS.$OPENSHIFT_ROUTE_DOMAIN}
fi

if ! kubectl get route -n $VIYA_NS $v4mGrafanaReleasePrefix-$VIYA_TENANT 1>/dev/null 2>&1; then
  log_debug "Exposing Grafana service as a route..."
  if [ "$OPENSHIFT_PATH_ROUTES" == "true" ]; then
    oc create route reencrypt \
      -n $VIYA_NS \
      --service $v4mGrafanaReleasePrefix-$VIYA_TENANT \
      --hostname "$routeHost" \
      --path $OPENSHIFT_ROUTE_PATH_GRAFANA
  else
    oc create route reencrypt \
      -n $VIYA_NS \
      --service $v4mGrafanaReleasePrefix-$VIYA_TENANT \
      --hostname "$routeHost"
  fi
fi

scheme="https"
if [ ! "$OPENSHIFT_AUTH_ENABLE" == "true" ]; then
  if [ "$firstTimeGrafana" == "true" ]; then
    if [ -z "$GRAFANA_ADMIN_PASSWORD" ]; then
      log_notice "Obtain the inital Grafana password by running:"
      log_notice "kubectl get secret --namespace monitoring $v4mGrafanaReleasePrefix-$VIYA_TENANT -o jsonpath='{.data.admin-password}' | base64 --decode ; echo"
    fi
  fi
fi

# If a deployment with the old name exists, remove it first
if helm3ReleaseExists "v4m-tenant-$VIYA_TENANT" $MON_NS; then
  log_verbose "Removing outdated SAS Viya Monitoring Helm chart release for tenant [${VIYA_NS}/${VIYA_TENANT}]"
  helm uninstall -n "$MON_NS" "v4m-tenant-$VIYA_TENANT"
fi

deployV4MInfo "$VIYA_NS" "v4m-metrics-${VIYA_TENANT}"

log_notice "Grafana URL is https://$(kubectl get route -n $VIYA_NS $v4mGrafanaReleasePrefix-$VIYA_TENANT -o jsonpath='{ .spec.host }/{ .spec.path }')"

log_message ""
log_notice "Successfully deployed SAS Viya tenant monitoring for [$VIYA_TENANT] on OpenShift"
