#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh
source bin/openshift-include.sh

if [ "$OPENSHIFT_CLUSTER" != "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should only be run on OpenShift clusters"
    log_error "Run monitoring/bin/deploy_monitoring_cluster.sh instead"
    exit 1
  fi
fi

checkDefaultStorageClass

export HELM_DEBUG="${HELM_DEBUG:-false}"
if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

if [ -z "$(kubectl get ns $MON_NS -o name 2>/dev/null)" ]; then
  kubectl create ns $MON_NS
fi

set -e
log_notice "Deploying monitoring to the [$MON_NS] namespace..."

# Add the grafana helm chart repo
helmRepoAdd grafana https://grafana.github.io/helm-charts
log_info "Updating helm repositories..."
helm repo update

if kubectl get cm -n openshift-monitoring cluster-monitoring-config 1>/dev/null 2>&1; then
  log_debug "Configmap [openshift-monitoring/cluster-monitoring-config] exists"
  log_debug "The configmap may need to be manually modified to enable"
  log_debug "OpenShift user workload monitoring."
else
  log_info "Enabling OpenShift user workload monitoring..."
  kubectl apply -f monitoring/openshift/cluster-monitoring-config.yaml
  log_info "Waiting 30 seconds for pods to deploy..."
  sleep 30
fi

# TODO: Retries + fail?
if [ -n "$(kubectl get po -n openshift-user-workload-monitoring 2>/dev/null)" ]; then
  log_debug "User workload monitoring is ready"
else
  log_warn "User workload monitoring pods not detected in the openshift-user-workload-monitoring namespace"
  log_warn "Ensure that user workload monitoring is enabled"
fi

log_info "Enabling Grafana to access OpenShift Prometheus instances..."
if [ -z "$(kubectl get serviceAccount -n $MON_NS grafana-serviceaccount -o name 2>/dev/null)" ]; then
  log_info "Creating Grafana serviceAccount..."
  kubectl create serviceaccount -n $MON_NS grafana-serviceaccount
fi
log_debug "Adding cluster role..."
oc adm policy add-cluster-role-to-user cluster-monitoring-view -z grafana-serviceaccount -n $MON_NS
log_debug "Obtaining token..."
grafanaToken=$(oc serviceaccounts get-token grafana-serviceaccount -n $MON_NS)
if [ "$grafanaToken" == "" ]; then
  log_error "Unable to obtain authentication token for [grafana-serviceaccount]"
  exit 1
fi

log_info "Deploying Grafana..."
userGrafanaYAML=$TMP_DIR/empty.yaml
if [ -f "$USER_DIR/monitoring/user-values-openshift-grafana.yaml" ]; then
  userGrafanaYAML="$USER_DIR/monitoring/user-values-openshift-grafana.yaml"
  log_debug "User response file for Grafana found at [$userGrafanaYAML]"
fi

# Access token to OpenShift Prometheus instances
grafanaYAML=$TMP_DIR/grafana-values.yaml
cp monitoring/openshift/grafana-values.yaml $grafanaYAML
if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
  sed -i '' "s/__BEARER_TOKEN__/$grafanaToken/g" $grafanaYAML
else
  sed -i "s/__BEARER_TOKEN__/$grafanaToken/g" $grafanaYAML
fi

OPENSHIFT_TLS_PROXY_ENABLE=${OPENSHIFT_TLS_PROXY_ENABLE:-true}
grafanaProxyYAML=$TMP_DIR/empty.yaml
if [ "$OPENSHIFT_TLS_PROXY_ENABLE" == "true" ]; then
  extraArgs="--set service.targetPort=3001"
  grafanaProxyYAML="monitoring/openshift/grafana-proxy-values.yaml"
fi

if ! helm3ReleaseExists v4m-grafana $MON_NS; then
  firstTimeGrafana=true
fi

GRAFANA_CHART_VERSION=${GRAFANA_CHART_VERSION:-6.9.1}
helm upgrade --install $helmDebug \
  -n "$MON_NS" \
  -f "$grafanaYAML" \
  -f "$grafanaProxyYAML" \
  -f "$userGrafanaYAML" \
  --version "$GRAFANA_CHART_VERSION" \
  $extraArgs \
  v4m-grafana \
  grafana/grafana

if [ "$OPENSHIFT_TLS_PROXY_ENABLE" == "true" ]; then
  log_info "Enabling Grafana OpenShift proxy..."
  log_debug "Annotating grafana-serviceaccount to auto-generate TLS certs..."
  kubectl annotate serviceaccount -n $MON_NS --overwrite grafana-serviceaccount 'serviceaccounts.openshift.io/oauth-redirectreference.primary={"kind":"OAuthRedirectReference","apiVersion":"v1","reference":{"kind":"Route","name":"v4m-grafana"}}'

  log_debug "Adding ClusterRoleBinding for grafana-serviceaccount..."
  crbYAML=$TMP_DIR/grafana-serviceaccount-binding.yaml
  cp monitoring/openshift/grafana-serviceaccount-binding.yaml $crbYAML
  if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
    sed -i '' "s/__MON_NS__/$MON_NS/g" $crbYAML
  else
    sed -i "s/__MON_NS__/$MON_NS/g" $crbYAML
  fi

  kubectl apply -f $crbYAML

  kubectl apply -n $MON_NS -f monitoring/openshift/grafana-proxy-secret.yaml
  
  grafanaProxyPatchYAML=$TMP_DIR/grafana-proxy-patch.yaml
  cp monitoring/openshift/grafana-proxy-patch.yaml $grafanaProxyPatchYAML
  
  log_debug "Deploying cert-manager issuers and certificates..."
  kubectl apply -n $MON_NS -f monitoring/openshift/grafana-trusted-ca-bundle.yaml
  
  log_info "Patching Grafana service for auto-generated TLS certs"
  kubectl annotate service -n $MON_NS --overwrite v4m-grafana 'service.beta.openshift.io/serving-cert-secret-name=grafana-tls'

  log_info "Patching Grafana pod with authenticating TLS proxy..."
  kubectl patch deployment -n $MON_NS v4m-grafana --patch "$(cat $grafanaProxyPatchYAML)"
else
  log_debug "Grafana proxy container disabled"
fi

log_info "Deploying SAS Viya Grafana dashboards..."
DASH_NS=$MON_NS LOGGING_DASH=${LOGGING_DASH:-false} KUBE_DASH=${KUBE_DASH:-false} NGINX_DASH=${NGINX_DASH:-false} \
  monitoring/bin/deploy_dashboards.sh

log_info "Adding SAS Viya recording rules..."
for f in monitoring/rules/viya/rules-*.yaml; do
  kubectl apply -n $MON_NS -f $f
done

if ! kubectl get route -n $MON_NS v4m-grafana 1>/dev/null 2>&1; then
  log_info "Exposing Grafana service as a route..."
  if [ "$OPENSHIFT_TLS_PROXY_ENABLE" == "true" ]; then  
    oc create route reencrypt --service=v4m-grafana
  else
    oc create route edge --service=v4m-grafana
  fi
fi

scheme="https"
if [ ! "$OPENSHIFT_TLS_PROXY_ENABLE" == "true" ]; then
  if [ "$firstTimeGrafana" == "true" ]; then
    log_notice "Obtain the inital Grafana password by running:"
    log_notice "kubectl get secret --namespace monitoring v4m-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo"
  fi
fi
log_notice "Grafana URL: $scheme://$(kubectl get route -n $MON_NS | grep v4m-grafana | awk '{printf $2}')"

log_message ""
log_notice "Successfully deployed SAS Viya monitoring for OpenShift"
