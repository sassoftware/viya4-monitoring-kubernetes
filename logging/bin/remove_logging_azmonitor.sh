#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit
source logging/bin/common.sh

LOG_DELETE_NAMESPACE_ON_REMOVE=${LOG_DELETE_NAMESPACE_ON_REMOVE:-false}

log_info "Removing logging components [$(date)]"

logging/bin/remove_fluentbit_azmonitor.sh

log_info "Removing eventrouter..."
logging/bin/remove_eventrouter.sh

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

log_info "Removing components from the [$LOG_NS] namespace..."

log_info "Waiting 60 sec for resources to terminate..."
sleep 60

log_info "Checking contents of the [$LOG_NS] namespace:"
crds=(secrets all)
empty="true"
for crd in "${crds[@]}"; do
    out=$(kubectl get -n "$LOG_NS" "$crd" 2>&1)
    if [[ $out =~ 'No resources found' ]]; then
        :
    else
        empty="false"
        log_warn "Found [$crd] resources in the [$LOG_NS] namespace:"
        echo "$out"
    fi
done
if [ "$empty" == "true" ]; then
    log_info "  The [$LOG_NS] namespace is empty and should be safe to delete."
else
    log_warn "  The [$LOG_NS] namespace is not empty."
    log_warn "  Examine the resources above before deleting the namespace."
fi
