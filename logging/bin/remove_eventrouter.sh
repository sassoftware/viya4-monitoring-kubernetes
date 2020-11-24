#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

log_info "Script [$this_script] has started [$(date)]"

log_info "Removing eventrouter..."
kubectl delete --ignore-not-found -f logging/eventrouter.yaml

log_info "Script [$this_script] has completed [$(date)]"

