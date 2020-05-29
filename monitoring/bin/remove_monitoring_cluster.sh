#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

source monitoring/bin/common.sh

log_info "Removing dashboards..."
monitoring/bin/remove_dashboards.sh

log_info "Removing service monitors..."
kubectl delete --ignore-not-found servicemonitor -n $MON_NS elasticsearch
kubectl delete --ignore-not-found servicemonitor -n $MON_NS fluent-bit

log_info "Removing the Prometheus Operator..."
if [ "$HELM_VER_MAJOR" == "3" ]; then
  PROM_RELEASE=${PROM_RELEASE:-prometheus-operator}
  helm uninstall --namespace $MON_NS $PROM_RELEASE
  if [ $? != 0 ]; then
    log_warn "Uninstall of [$PROM_RELEASE] was not successful. Check output above for details."
  fi
else
  PROM_RELEASE=${PROM_RELEASE:-prometheus-$MON_NS}
  helm delete --purge $PROM_RELEASE
  if [ $? != 0 ]; then
    log_warn "Deletion of [$PROM_RELEASE] was not successful. Check output above for details."
  fi
fi

# Wait for resources to terminate
log_info "Waiting 30 sec for resources to terminate..."
sleep 30

log_info "Checking contents of the [$MON_NS] namespace:"
crds=( all pvc servicemonitor podmonitor prometheus alertmanager prometheusrule thanosrulers )
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
