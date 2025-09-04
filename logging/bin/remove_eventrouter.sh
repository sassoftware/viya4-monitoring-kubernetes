#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit
source logging/bin/common.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

# Copy template files to temp
logDir=$TMP_DIR/$LOG_NS
mkdir -p "$logDir"
cp -R logging/eventrouter/eventrouter.yaml "$logDir"/eventrouter.yaml

# Replace placeholders
log_debug "Replacing logging namespace for files in [$logDir]"
v4m_replace "__LOG_NS__" "$LOG_NS" "$logDir"/eventrouter.yaml

log_info "Removing Event Router [$(date)]"
# Remove existing instance of Event Router in the kube-system namespace (if present).
if [[ $V4M_CURRENT_VERSION_FULL =~ 1.0 || $V4M_CURRENT_VERSION_FULL =~ 1.1.[0-2] ]]; then
    # Remove existing instance of Event Router in the kube-system namespace (if present).
    log_info "Removing instance of Event Router in the kube-system namespace"
    kubectl delete --ignore-not-found -f logging/eventrouter/eventrouter_kubesystem.yaml
else
    kubectl delete --ignore-not-found -f "$logDir"/eventrouter.yaml
fi

log_debug "Script [$this_script] has completed [$(date)]"
