#! /bin/bash

# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Prerequisites:
# If cluster, cluster level needs to be deployed.  Uses $LOG_NS and $MON_NS.  If tenant, provide namespace, tenant name, user, password.
# If tenant, tenant needs to be onboarded.  Need to provide namespace (default to usual monitoring/logging), tenant, user, password.


cd "$(dirname $BASH_SOURCE)/../.."
CHECK_HELM=false
source monitoring/bin/common.sh
source logging/bin/common.sh

# Check to see if monitoring namespace provided exists and components have already been deployed
log_info "Checking for Grafana pods in the $MON_NS namespace ..."
if [[ $(kubectl get pods -n $MON_NS -l app.kubernetes.io/instance=v4m-prometheus-operator -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
  log_error "No monitoring components found in the $MON_NS namespace."
  log_error "Monitoring needs to be deployed in this namespace in order to configure Elasticsearch with this script.";
  exit 1
else
  log_debug "Monitoring found in $MON_NS namespace.  Continuing."
fi

# Check to see if logging namespace provided exists and components have already been deployed
log_info "Checking for Elasticsearch pods in the $LOG_NS namespace ..."
if [[ $(kubectl get pods -n $LOG_NS -l app=v4m-es -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
  log_error "No logging components found in the $LOG_NS namespace."
  log_error "Logging needs to be deployed in this namespace in order to configure Elasticsearch with this script.";
  exit 1
else
  log_debug "Logging found in $LOG_NS namespace.  Continuing."
fi

# Create temporary directory for string replacement in the grafana-datasource-es.yaml file
  monDir=$TMP_DIR/$MON_NS
  mkdir -p $monDir
  cp monitoring/grafana-datasource-es.yaml $monDir/grafana-datasource-es.yaml

# Retrieving Elasticsearch password for data source setup
adminPass="$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" | base64 --decode)"

# Replace placeholders
log_debug "Replacing variables in $monDir/grafana-datasource-es.yaml file"
if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
  sed -i '' "s/__sourceName__/Elastic/g" $monDir/grafana-datasource-es.yaml
  sed -i '' "s/__namespace__/$LOG_NS/g" $monDir/grafana-datasource-es.yaml
  sed -i '' "s/__userID__/admin/g" $monDir/grafana-datasource-es.yaml
  sed -i '' "s/__passwd__/$adminPass/g" $monDir/grafana-datasource-es.yaml
else
  sed -i "s/__sourceName__/Elastic/g" $monDir/grafana-datasource-es.yaml
  sed -i "s/__namespace__/$LOG_NS/g" $monDir/grafana-datasource-es.yaml
  sed -i "s/__userID__/admin/g" $monDir/grafana-datasource-es.yaml
  sed -i "s/__passwd__/$adminPass/g" $monDir/grafana-datasource-es.yaml
fi

if [[ -n "$(kubectl get secret -n $MON_NS grafana-datasource-es -o custom-columns=:metadata.name --no-headers --ignore-not-found)" ]]; then
  log_info "Removing existing Elasticsearch data source ..."
  kubectl delete secret -n $MON_NS --ignore-not-found grafana-datasource-es
fi

log_info "Provisioning Elasticsearch datasource for Grafana"
kubectl create secret generic -n $MON_NS grafana-datasource-es --from-file $monDir/grafana-datasource-es.yaml
kubectl label secret -n $MON_NS grafana-datasource-es grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring

# Delete pods so that they can be restarted with the change.
log_info "Elasticsearch data source provisioned.  Restarting pods to apply the change"
kubectl delete pods -n $MON_NS -l "app.kubernetes.io/instance=v4m-prometheus-operator" -l "app.kubernetes.io/name=grafana"
kubectl -n $MON_NS wait pods --selector "app.kubernetes.io/instance=v4m-prometheus-operator","app.kubernetes.io/name=grafana" --for condition=Ready --timeout=2m
log_info "Elasticsearch data source has been configured."