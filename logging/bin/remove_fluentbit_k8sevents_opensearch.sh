#! /bin/bash

# Copyright © 2023, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1

source logging/bin/common.sh
this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

log_info "Removing Fluent Bit (for K8s event collection) from the [$LOG_NS] namespace [$(date)]"

helm delete -n "$LOG_NS" v4m-fb-events

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
