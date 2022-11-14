#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh

if [ "$OPENSHIFT_CLUSTER" == "true" ]; then  
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should not be run on OpenShift clusters"
    log_error "Run monitoring/bin/remove_monitoring_openshift.sh instead"
    exit 1
  fi
fi

MON_DELETE_PVCS_ON_REMOVE=${MON_DELETE_PVCS_ON_REMOVE:-false}
MON_DELETE_NAMESPACE_ON_REMOVE=${MON_DELETE_NAMESPACE_ON_REMOVE:-false}

# Check for existing incompatible helm releases up front
helm2ReleaseCheck prometheus-$MON_NS
helm2ReleaseCheck v4m-$MON_NS

log_notice "Removing components from the [$MON_NS] namespace..."

if helm3ReleaseExists prometheus-operator $MON_NS; then
  promRelease=prometheus-operator
elif helm3ReleaseExists v4m-prometheus-operator $MON_NS; then  
  promRelease=v4m-prometheus-operator
else
  promRelease=
fi

if [ ! -z $promRelease ]; then
  log_info "Removing the kube-prometheus stack..."
  helm uninstall --namespace $MON_NS $promRelease
fi 

if [ $? != 0 ]; then
  log_warn "Uninstall of [$promRelease] was not successful. Check output above for details."
fi

log_verbose "Removing v4m-kubelet service"
kubectl delete service --ignore-not-found -n kube-system v4m-kubelet

if [ "$MON_DELETE_NAMESPACE_ON_REMOVE" == "true" ]; then
  log_info "Deleting the [$MON_NS] namespace..."
  if kubectl delete namespace $MON_NS --timeout $KUBE_NAMESPACE_DELETE_TIMEOUT; then
    log_info "[$MON_NS] namespace and monitoring components successfully removed"
    exit 0
  else
    log_error "Unable to delete the [$MON_NS] namespace"
    exit 1
  fi
fi

monitoring/bin/remove_dashboards.sh

log_verbose "Removing Prometheus rules"
rules=( sas-launcher-job-rules )
for rule in "${rules[@]}"
do
  kubectl delete --ignore-not-found -n $MON_NS prometheusrule $rule
done

log_verbose "Removing configmaps and secrets"
kubectl delete cm --ignore-not-found -n $MON_NS -l sas.com/monitoring-base=kube-viya-monitoring
kubectl delete secret --ignore-not-found -n $MON_NS -l sas.com/monitoring-base=kube-viya-monitoring

if [ "$MON_DELETE_PVCS_ON_REMOVE" == "true" ]; then
  log_verbose "Removing known monitoring PVCs"
  kubectl delete pvc --ignore-not-found -n $MON_NS -l app=alertmanager
  kubectl delete pvc --ignore-not-found -n $MON_NS -l app.kubernetes.io/name=grafana
  kubectl delete pvc --ignore-not-found -n $MON_NS -l app=prometheus
fi

# Check for and remove any v4m deployments with old naming convention
removeV4MInfo "$MON_NS" "v4m"

removeV4MInfo "$MON_NS" "v4m-metrics"

# Wait for resources to terminate
log_info "Waiting 60 sec for resources to terminate"
sleep 60

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
