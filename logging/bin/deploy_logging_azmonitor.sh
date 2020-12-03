#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

# temp file used to capture command output
tmpfile=$TMP_DIR/output.txt
rm -f tmpfile

if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  kubectl create ns $LOG_NS
fi

set -e

log_notice "Deploying logging components to the [$LOG_NS] namespace [$(date)]"

# Event Router
log_info "STEP 1: Event Router"
logging/bin/deploy_eventrouter.sh


# Fluent Bit
log_info "STEP 2: Deploying Fluent Bit"
logging/bin/deploy_fluentbit_azmonitor.sh


log_notice "The deployment of logging components has completed [$(date)]"
echo ""
