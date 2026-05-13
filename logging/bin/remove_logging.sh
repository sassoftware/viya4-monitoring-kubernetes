#! /bin/bash

# Copyright © 2022-2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# remove_logging.sh
# Simplified removal — removes only OpenSearch and OpenSearch Dashboards.
# Log collection (Alloy) is removed via remove_monitoring_cluster.sh.

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh

# Confirm NOT on OpenShift
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
        log_error "This script should NOT be run on OpenShift clusters"
        log_error "Run logging/bin/remove_logging_openshift.sh instead"
        exit 1
    fi
fi

LOG_DELETE_CONFIGMAPS_ON_REMOVE=${LOG_DELETE_CONFIGMAPS_ON_REMOVE:-true}
LOG_DELETE_SECRETS_ON_REMOVE=${LOG_DELETE_SECRETS_ON_REMOVE:-true}
LOG_DELETE_PVCS_ON_REMOVE=${LOG_DELETE_PVCS_ON_REMOVE:-false}
LOG_DELETE_NAMESPACE_ON_REMOVE=${LOG_DELETE_NAMESPACE_ON_REMOVE:-false}

helm2ReleaseCheck odfe-"$LOG_NS"

log_notice "Removing logging components from the [$LOG_NS] namespace [$(date)]"

# Remove OpenSearch Dashboards
logging/bin/remove_osd.sh

# Remove OpenSearch
logging/bin/remove_opensearch.sh

if [ "$LOG_DELETE_PVCS_ON_REMOVE" == "true" ]; then
    log_verbose "Removing known logging PVCs..."
    kubectl delete pvc --ignore-not-found -n "$LOG_NS" -l app.kubernetes.io/name=opensearch
fi

if [ "$LOG_DELETE_SECRETS_ON_REMOVE" == "true" ]; then
    log_verbose "Removing known logging secrets..."
    kubectl delete secret --ignore-not-found -n "$LOG_NS" -l managed-by=v4m-es-script
fi

if [ "$LOG_DELETE_CONFIGMAPS_ON_REMOVE" == "true" ]; then
    log_verbose "Removing known logging configmaps..."
    kubectl delete configmap --ignore-not-found -n "$LOG_NS" -l managed-by=v4m-es-script
fi

# Check for and remove any v4m deployments with old naming convention
removeV4MInfo "$LOG_NS" "v4m"
removeV4MInfo "$LOG_NS" "v4m-logs"

if [ "$LOG_DELETE_NAMESPACE_ON_REMOVE" == "true" ]; then
    log_info "Deleting the [$LOG_NS] namespace..."
    if kubectl delete namespace "$LOG_NS" --timeout "$KUBE_NAMESPACE_DELETE_TIMEOUT"; then
        log_info "[$LOG_NS] namespace and logging components successfully removed"
        exit 0
    else
        log_error "Unable to delete the [$LOG_NS] namespace"
        exit 1
    fi
fi

log_info "Waiting 60 sec for resources to terminate..."
sleep 60

log_info "Checking contents of the [$LOG_NS] namespace:"
objects=(all pvc secret configmap)
empty="true"
for object in "${objects[@]}"; do
    out=$(kubectl get -n "$LOG_NS" "$object" 2>&1)
    if [[ $out =~ 'No resources found' ]]; then
        :
    else
        empty="false"
        log_warn "Found [$object] resources in the [$LOG_NS] namespace:"
        echo "$out"
    fi
done
if [ "$empty" == "true" ]; then
    log_info "  The [$LOG_NS] namespace is empty and should be safe to delete."
else
    log_warn "  The [$LOG_NS] namespace is not empty."
    log_warn "  Examine the resources above before deleting the namespace."
fi
