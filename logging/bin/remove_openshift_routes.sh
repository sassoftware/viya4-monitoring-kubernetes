#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

oc -n $LOG_NS delete route v4m-es-kibana-svc --ignore-not-found
oc -n $LOG_NS delete route v4m-es-client-service --ignore-not-found

log_info "OpenShift Routes have been removed."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
