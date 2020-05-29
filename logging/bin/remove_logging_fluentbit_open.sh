#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

source logging/bin/common.sh

log_info "Removing Fluent Bit components from the [$LOG_NS] namespace"

if [ "$HELM_VER_MAJOR" == "3" ]; then
    helm delete -n $LOG_NS fb
else
    helm delete --purge fb-$LOG_NS
fi
