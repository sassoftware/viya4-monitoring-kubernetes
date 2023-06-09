#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh
source bin/openshift-include.sh

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
  log_error "VIYA_TENANT must be set to the name of an existing SAS Viya tenant"
  exit 1
fi

# Validate tenant name
validateTenantID $VIYA_TENANT

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

if helm3ReleaseExists v4m-grafana-$VIYA_NS-$VIYA_TENANT $VIYA_NS; then
  log_info "Uninstalling Grafana helm chart..."
  helm uninstall -n $VIYA_NS v4m-grafana-$VIYA_NS-$VIYA_TENANT
else
  log_debug "Grafana helm release [v4m-grafana-$VIYA_NS-$VIYA_TENANT] not found. Skipping uninstall."
fi
log_info "Removing other resources..."

log_debug "Removing Grafana datasource..."
kubectl delete secret -n $VIYA_NS --ignore-not-found -l grafana_datasource-$VIYA_TENANT >/dev/null

log_debug "Removing namespace resources..."
types=( route prometheus prometheusrule servicemonitor podmonitor service configmap serviceaccount )
for type in "${types[@]}"; do
  log_debug "  Removing [$type] resources..."
  kubectl delete --ignore-not-found $type -n $VIYA_NS -l "v4m.sas.com/tenant=$VIYA_TENANT" >/dev/null
done

# Check for and remove any v4m deployments with old naming convention
removeV4MInfo "$VIYA_NS" "v4m-tenant-$VIYA_TENANT"

removeV4MInfo "$VIYA_NS" "v4m-metrics-${VIYA_TENANT}"

log_notice "Successfully removed OpenShift tenant monitoring for [$VIYA_NS/$VIYA_TENANT]"
