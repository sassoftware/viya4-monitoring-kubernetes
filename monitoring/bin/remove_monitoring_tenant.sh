#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh
source bin/openshift-include.sh

if [ "$VIYA_NS" == "" ]; then
  log_error "VIYA_NS must be set to the namespace of an existing Viya deployment"
  exit 1
fi

if [ "$VIYA_TENANT" == "" ]; then
  log_error "VIYA_TENANT must be set to the name of an existing Viya tenant"
  exit 1
fi

# Copy template files to temp
tenantDir=$TMP_DIR/$VIYA_TENANT
mkdir -p $tenantDir
cp monitoring/multitenant/*.yaml $tenantDir/

# Replace placeholders
log_debug "Replacing __TENANT__ for files in [$tenantDir]"
for f in $tenantDir/*; do 
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

if helm3ReleaseExists grafana-$VIYA_TENANT $VIYA_NS; then
  log_info "Removing Grafana..."
  helm uninstall -n $VIYA_NS grafana-$VIYA_TENANT
else
  log_debug "Grafana helm release [grafana-$VIYA_TENANT] not found. Skipping uninstall."
fi

log_info "Removing Grafana dashboards..."
kubectl delete cm -n $VIYA_NS --ignore-not-found -l grafana_dashboard-$VIYA_TENANT

log_info "Removing Grafana datasource..."
kubectl delete secret -n $VIYA_NS --ignore-not-found -l grafana_datasource-$VIYA_TENANT

log_info "Removing Prometheus"
kubectl delete -n $VIYA_NS --ignore-not-found -f $tenantDir/mt-prometheus.yaml
kubectl delete -n $VIYA_NS --ignore-not-found -f $tenantDir/servicemonitor-sas-cas-tenant.yaml
kubectl delete -n $VIYA_NS --ignore-not-found -f $tenantDir/servicemonitor-sas-pushgateway-tenant.yaml
kubectl delete -n $VIYA_NS --ignore-not-found secret prometheus-federate-$VIYA_TENANT

log_notice "Uninstalled monitoring for [$VIYA_NS/$VIYA_TENANT]"
