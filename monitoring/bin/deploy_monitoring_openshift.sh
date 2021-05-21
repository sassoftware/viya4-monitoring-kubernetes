#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh
source bin/openshift-include.sh
source bin/service-url-include.sh

source bin/tls-include.sh
if verify_cert_manager $MON_NS prometheus alertmanager grafana; then
  log_debug "cert-manager check OK"
else
  log_error "cert-manager is required but is not available"
  exit 1
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

# The stable repo is used indirectly by prometheus-community/kube-prometheus-stack
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
if [ -f "$USER_DIR/monitoring/user-values-grafana.yaml" ]; then
  userGrafanaYAML="$USER_DIR/monitoring/user-values-grafana.yaml"
  log_debug "User response file for Grafana found at [$userGrafanaYAML]"
fi

grafanaYAML=$TMP_DIR/grafana-values.yaml
cp monitoring/openshift/grafana-values.yaml $grafanaYAML
if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
  sed -i '' "s/__BEARER_TOKEN__/$grafanaToken/g" $grafanaYAML
else
  sed -i "s/__BEARER_TOKEN__/$grafanaToken/g" $grafanaYAML
fi

if ! helm3ReleaseExists v4m-grafana $MON_NS; then
  firstTimeGrafana=true
fi
helm upgrade --install --namespace $helmDebug $MON_NS v4m-grafana \
  -f "$grafanaYAML" \
  -f "$userGrafanaYAML" grafana/grafana

log_info "Deploying SAS Viya Grafana dashboards..."
DASH_NS=$MON_NS LOGGING_DASH=${LOGGING_DASH:-false} KUBE_DASH=${KUBE_DASH:-false} NGINX_DASH=${NGINX_DASH:-false} \
  monitoring/bin/deploy_dashboards.sh

# Rules for SAS Jobs dashboards
for f in monitoring/rules/viya/rules-*.yaml; do
  kubectl apply -n $MON_NS -f $f
done

if ! kubectl get route -n $MON_NS v4m-grafana 1>/dev/null 2>&1; then
  oc expose service -n $MON_NS v4m-grafana
fi
log_notice "Grafana URL: http://$(kubectl get route -n $MON_NS | grep v4m-grafana | awk '{printf $2}')"

if [ "$firstTimeGrafana" == "true" ]; then
  log_notice "Obtain the inital Grafana password by running:"
  log_notice "kubectl get secret --namespace monitoring v4m-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo"
fi

log_message ""
log_notice "Successfully deployed SAS Viya monitoring for OpenShift"
