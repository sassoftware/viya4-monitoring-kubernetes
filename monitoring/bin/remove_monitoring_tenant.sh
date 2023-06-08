#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh
source bin/openshift-include.sh

if [ "$OPENSHIFT_CLUSTER" == "true" ]; then  
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should not be run on OpenShift clusters"
    log_error "Run monitoring/bin/remove_monitoring_openshift.sh instead"
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

v4mGrafanaReleasePrefix=v4m-grafana
# Check for existing tenant instance with the old name
if helm3ReleaseExists grafana-$VIYA_TENANT $VIYA_NS; then
  v4mGrafanaReleasePrefix=grafana
fi

if helm3ReleaseExists $v4mGrafanaReleasePrefix-$VIYA_TENANT $VIYA_NS; then
  log_info "Removing Grafana..."
  helm uninstall -n $VIYA_NS $v4mGrafanaReleasePrefix-$VIYA_TENANT
else
  log_debug "Grafana helm release [$v4mGrafanaReleasePrefix-$VIYA_TENANT] not found. Skipping uninstall."
fi

log_info "Removing Grafana dashboards..."
kubectl delete cm -n $VIYA_NS --ignore-not-found -l grafana_dashboard-$VIYA_TENANT

log_info "Removing Grafana datasource..."
kubectl delete secret -n $VIYA_NS --ignore-not-found -l grafana_datasource-$VIYA_TENANT

log_info "Removing Prometheus"
kubectl delete -n $VIYA_NS --ignore-not-found -f $tenantDir/mt-prometheus.yaml
kubectl delete -n $VIYA_NS --ignore-not-found -f $tenantDir/serviceMonitor-sas-cas-tenant.yaml
kubectl delete -n $VIYA_NS --ignore-not-found -f $tenantDir/serviceMonitor-sas-pushgateway-tenant.yaml
kubectl delete -n $VIYA_NS --ignore-not-found secret prometheus-federate-$VIYA_TENANT

# Remove non-user-provided certificates
kubectl delete -n $VIYA_NS --ignore-not-found certificate -l "v4m.sas.com/tenant=$VIYA_TENANT" 2>/dev/null

if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
  log_info "Deleting route for $VIYA_NS/$v4mGrafanaReleasePrefix-$VIYA_TENANT..."
  kubectl delete route -n $VIYA_NS $v4mGrafanaReleasePrefix-$VIYA_TENANT
fi

# Check for and remove any v4m deployments with old naming convention
removeV4MInfo "$VIYA_NS" "v4m-tenant-$VIYA_TENANT"

removeV4MInfo "$VIYA_NS" "v4m-metrics-${VIYA_TENANT}"

log_notice "Uninstalled monitoring for [$VIYA_NS/$VIYA_TENANT]"
