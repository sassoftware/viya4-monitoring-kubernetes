#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

source logging/bin/common.sh

# Check for existing incompatible helm releases up front
helm2ReleaseCheck odfe-$LOG_NS
helm2ReleaseCheck es-exporter-$LOG_NS
helm3ReleaseCheck odfe $LOG_NS
helm3ReleaseCheck es-exporter $LOG_NS

log_info "Removing logging components"

logging/bin/remove_logging_fluentbit_open.sh

if [ "$HELM_VER_MAJOR" == "3" ]; then
    helm delete -n $LOG_NS es-exporter
    helm delete -n $LOG_NS odfe
else
    helm delete --purge es-exporter-$LOG_NS
    helm delete --purge odfe-$LOG_NS
fi

log_info "Waiting 60 sec for resources to terminate..."
sleep 60

log_info "Checking contents of the [$LOG_NS] namespace:"
crds=( all pvc )
empty="true"
for crd in "${crds[@]}"
do
	out=$(kubectl get -n $LOG_NS $crd 2>&1)
  if [[ "$out" =~ 'No resources found' ]]; then
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
