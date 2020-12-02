#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

# Output Kubernetes events as pseudo-log messages?
EVENTROUTER_ENABLE=${EVENTROUTER_ENABLE:-true}

if [ "$EVENTROUTER_ENABLE" != "true" ]; then
  log_info "Environment variable [EVENTROUTER_ENABLE] is not set to 'true'; exiting WITHOUT deploying Event Router"
  exit
fi

set -e

# Enable workload node placement?
LOG_NODE_PLACEMENT_ENABLE=${LOG_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}

log_info "Deploying eventrouter..."

if [ "$LOG_NODE_PLACEMENT_ENABLE" == "true" ]; then
   log_info "Enabling eventrouter for workload node placement"
   kubectl apply -f logging/node-placement/eventrouter-wnp.yaml
else
   log_debug "Workload node placement support is disabled for eventrouter"
   kubectl apply -f logging/eventrouter.yaml
fi

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
