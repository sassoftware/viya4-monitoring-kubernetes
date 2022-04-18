#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

log_info "Removing OpenSearch [$(date)]"
helm delete -n $LOG_NS opensearch


log_verbose "Removing ConfigMaps"
kubectl -n $LOG_NS delete configmap run-securityadmin.sh  --ignore-not-found

log_debug "Script [$this_script] has completed [$(date)]"
echo ""

