#! /bin/bash

# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

log_info "Removing OpenSearch Dashboards [$(date)]"
helm delete -n "$LOG_NS" v4m-osd

kubectl -n "$LOG_NS" delete secret v4m-osd-tls-enabled --ignore-not-found

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
