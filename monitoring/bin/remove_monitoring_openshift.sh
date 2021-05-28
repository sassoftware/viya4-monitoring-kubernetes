#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh
source bin/openshift-include.sh

if [ "$OPENSHIFT_CLUSTER" != "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should only be run on OpenShift clusters"
    log_error "Run monitoring/bin/remove_monitoring_cluster.sh instead"
    exit 1
  fi
fi

MON_DELETE_PVCS_ON_REMOVE=${MON_DELETE_PVCS_ON_REMOVE:-false}
MON_DELETE_NAMESPACE_ON_REMOVE=${MON_DELETE_NAMESPACE_ON_REMOVE:-false}

log_info "Removing the Grafana route..."
kubectl delete route --ignore-not-found -n $MON_NS v4m-grafana

if helm3ReleaseExists v4m-grafana $MON_NS; then
  log_info "Removing Grafana..."
  helm uninstall --namespace $MON_NS v4m-grafana
  if [ $? != 0 ]; then
    log_warn "Uninstall of [v4m-grafana] was not successful. Check output above for details."
  fi
else
  log_debug "Helm release of [v4m-grafana] not found"
fi

log_info "Removing clusterrole and clusterrolebinding..."
kubectl delete --ignore-not-found clusterrole v4m-grafana-clusterrole
kubectl delete --ignore-not-found clusterrolebinding v4m-grafana-clusterrolebinding

if [ "$MON_DELETE_NAMESPACE_ON_REMOVE" == "true" ]; then
  log_info "Deleting the [$MON_NS] namespace..."
  if kubectl delete namespace $MON_NS; then
    log_info "[$MON_NS] namespace and monitoring components successfully removed"
    exit 0
  else
    log_error "Unable to delete the [$MON_NS] namespace"
    exit 1
  fi
fi

log_info "Removing components from the [$MON_NS] namespace..."

log_info "Removing CA bundle..."
kubectl delete --ignore-not-found cm grafana-trusted-ca-bundle

log_info "Removing dashboards..."
monitoring/bin/remove_dashboards.sh

log_info "Removing service monitors..."
kubectl delete --ignore-not-found podmonitor -n $MON_NS eventrouter
kubectl delete --ignore-not-found servicemonitor -n $MON_NS elasticsearch
kubectl delete --ignore-not-found servicemonitor -n $MON_NS fluent-bit
kubectl delete --ignore-not-found servicemonitor -n $MON_NS fluent-bit-v2

log_info "Removing Prometheus rules..."
rules=( sas-launcher-job-rules )
for rule in "${rules[@]}"
do
  kubectl delete --ignore-not-found -n $MON_NS prometheusrule $rule
done

log_info "Removing Grafana service account..."
kubectl delete --ignore-not-found serviceAccount -n $MON_NS grafana-serviceaccount

if [ "$MON_DELETE_PVCS_ON_REMOVE" == "true" ]; then
  log_info "Removing known monitoring PVCs..."
  kubectl delete pvc --ignore-not-found -n $MON_NS -l app.kubernetes.io/name=grafana
fi

# Wait for resources to terminate
log_info "Waiting 10 sec for resources to terminate..."
sleep 10

log_info "Checking contents of the [$MON_NS] namespace:"
crds=( all pvc cm servicemonitor podmonitor prometheus alertmanager prometheusrule thanosrulers )
empty="true"
for crd in "${crds[@]}"
do
  out=$(kubectl get -n $MON_NS $crd 2>&1)
  if [[ "$out" =~ 'No resources found' ]]; then
    :
  else
    empty="false"
    log_warn "Found [$crd] resources in the [$MON_NS] namespace:"
    echo "$out"
  fi
done
if [ "$empty" == "true" ]; then
  log_info "  The [$MON_NS] namespace is empty and should be safe to delete."
else
  log_warn "  The [$MON_NS] namespace is not empty."
  log_warn "  Examine the resources above before deleting the namespace."
fi
