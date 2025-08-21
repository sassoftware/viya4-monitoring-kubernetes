#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit
source logging/bin/common.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

# Deploy ServiceMonitors?
DEPLOY_SERVICEMONITORS=${DEPLOY_SERVICEMONITORS:-false}

if [ "$DEPLOY_SERVICEMONITORS" != "true" ]; then
  log_info "Environment variable [DEPLOY_SERVICEMONITORS] is not set to 'true'; exiting b/c ServiceMonitors were not deployed."
  exit
fi

EVENTROUTER_ENABLE=${EVENTROUTER_ENABLE:-true}
if [ "$EVENTROUTER_ENABLE" == "true" ]; then
   # Eventrouter ServiceMonitor
   kubectl delete --ignore-not-found -n "$LOG_NS" -f monitoring/monitors/kube/podMonitor-eventrouter.yaml
fi

ELASTICSEARCH_ENABLE=${ELASTICSEARCH_ENABLE:-true}
if [ "$ELASTICSEARCH_ENABLE" == "true" ]; then
   # Elasticsearch ServiceMonitor
   kubectl delete --ignore-not-found -n "$LOG_NS" -f monitoring/monitors/logging/serviceMonitor-elasticsearch.yaml
fi

FLUENT_BIT_ENABLED=${FLUENT_BIT_ENABLED:-true}
if [ "$FLUENT_BIT_ENABLED" == "true" ]; then
   # Fluent Bit ServiceMonitors
   kubectl delete --ignore-not-found -n "$LOG_NS" -f monitoring/monitors/logging/serviceMonitor-fluent-bit-v2.yaml
fi

log_info "ServiceMonitors have been removed."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
