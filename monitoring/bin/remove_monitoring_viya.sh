#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh

MON_DELETE_PVCS_ON_REMOVE=${MON_DELETE_PVCS_ON_REMOVE:-false}

if [ "$VIYA_NS" == "" ]; then
  log_error "VIYA_NS must be set to the Viya deployment namespace"
  exit 1
fi

helm2ReleaseCheck pushgateway-$VIYA_NS

# Delete the old names (will be removed in the future)
log_info "Removing third-party exporters..."
helm delete --namespace $VIYA_NS prometheus-pushgateway 2>/dev/null

log_info "Removing ServiceMonitors in the [$VIYA_NS] namespace..."
monitors=( sas-java-services sas-go-services sas-arke sas-cas-server sas-deployment-operator sas-cas-operator sas-postgres sas-rabbitmq-server pushgateway )
for mon in "${monitors[@]}"
do
  kubectl delete --ignore-not-found -n $VIYA_NS servicemonitor $mon
done
log_info "Removing PodMonitors in the [$VIYA_NS] namespace..."
monitors=( sas-java-pods sas-go-pods sas-deployment-operator )
for mon in "${monitors[@]}"
do
  kubectl delete --ignore-not-found -n $VIYA_NS podmonitor $mon
done

# Catch-all
kubectl delete all --ignore-not-found -n $VIYA_NS -l 'sas.com/monitoring-base=kube-viya-monitoring'

if [ "$MON_DELETE_PVCS_ON_REMOVE" == "true" ]; then
  log_info "Removing known monitoring PVCs..."
  kubectl delete pvc -n $MON_NS -l app=prometheus-pushgateway
fi

# If a deployment with the old name exists, remove it first
if helm3ReleaseExists "v4m-viya" $VIYA_NS; then
  removeV4MInfo "$VIYA_NS" "v4m-viya"
else
  removeV4MInfo "$VIYA_NS" "v4m-metrics-viya"
fi

log_info "Removed monitoring components from the [$VIYA_NS] namespace"
