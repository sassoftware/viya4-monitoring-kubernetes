#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh

if [ "$(kubectl get ns "$LOG_NS" -o name 2> /dev/null)" == "" ]; then
    kubectl create ns "$LOG_NS"
fi

set -e

log_notice "Deploying logging components to the [$LOG_NS] namespace [$(date)]"

# K8S Events
## TO DO: Originally deployed Event Router, deploy Fluent Bit for K8s event Collection?

# Fluent Bit
log_info "STEP 1: Deploying Fluent Bit"
logging/bin/deploy_fluentbit_azmonitor.sh

log_notice "The deployment of logging components has completed [$(date)]"
echo ""
