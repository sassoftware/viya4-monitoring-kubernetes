#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

# Collect Kubernetes events as pseudo-log messages?
EVENTROUTER_ENABLE=${EVENTROUTER_ENABLE:-true}

# Deploy Fluent Bit?
FLUENT_BIT_ENABLED=${FLUENT_BIT_ENABLED:-true}

# temp file used to capture command output
tmpfile=$TMP_DIR/output.txt
rm -f tmpfile

if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  kubectl create ns $LOG_NS
fi

set -e

log_notice "Deploying logging components to the [$LOG_NS] namespace [$(date)]"

# Event Router
if [ "$EVENTROUTER_ENABLE" == "true" ]; then
  log_info "STEP 1: Deploying eventrouter..."
  kubectl apply -f logging/eventrouter.yaml
fi


# Fluent Bit
if [ "$FLUENT_BIT_ENABLED" == "true" ]; then
   log_info "STEP 2: Deploying Fluent Bit"

   # Call separate Fluent Bit deployment script
   logging/bin/deploy_fluentbit_azmonitor.sh
else
  log_info "FLUENT_BIT_ENABLED=[$FLUENT_BIT_ENABLED] - Skipping Fluent Bit install"
fi

log_notice "The deployment of logging components has completed [$(date)]"
echo ""
