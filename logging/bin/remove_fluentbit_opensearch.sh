#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

helm2ReleaseCheck fb-$LOG_NS

if helm3ReleaseExists fb $LOG_NS; then
  fbRelease=fb
else
  fbRelease=v4m-fb
fi


log_info "Removing Fluent Bit components [$fbRelease] from the [$LOG_NS] namespace [$(date)]"

helm delete -n $LOG_NS $fbRelease

log_verbose "Removing ConfigMaps"
kubectl -n $LOG_NS delete configmap fb-fluent-bit-config   --ignore-not-found
kubectl -n $LOG_NS delete configmap fb-viya-parsers        --ignore-not-found
kubectl -n $LOG_NS delete configmap fb-env-vars            --ignore-not-found

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
