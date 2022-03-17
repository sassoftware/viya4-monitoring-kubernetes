#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

# Confirm NOT on OpenShift
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should NOT be run on OpenShift clusters"
    log_error "Run logging/bin/deploy_logging_open_openshift.sh instead"
    exit 1
  fi
fi

# set flag indicating wrapper/driver script being run
export LOGGING_DRIVER=true

##################################
# Check pre-reqs                 #
##################################

checkDefaultStorageClass

# Create namespace if it doesn't exist
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  kubectl create ns $LOG_NS
fi


log_notice "Deploying logging components to the [$LOG_NS] namespace [$(date)]"

set -e

##################################
# Event Router                   #
##################################

# Collect Kubernetes events as pseudo-log messages?

logging/bin/deploy_eventrouter.sh

##################################
# Open Distro for Elasticsearch  #
##################################

logging/bin/deploy_elasticsearch_open.sh

##################################
# Open Distro Content            #
##################################

logging/bin/deploy_elasticsearch_content_open.sh

##################################
# Elasticsearch Metric Exporter  #
##################################

logging/bin/deploy_esexporter.sh

##################################
# Fluent Bit                     #
##################################

logging/bin/deploy_fluentbit_open.sh

##################################
# Kibana Content                 #
##################################

# NOTE: For ODFE, Kibana is deployed as part of ES Helm chart

logging/bin/deploy_kibana_content.sh

##################################
# Display Kibana URL             #
##################################
set +e
bin/show_app_url.sh KIBANA ELASTICSEARCH
set -e


##################################
# Version Info                   #
##################################

if ! deployV4MInfo "$LOG_NS" "v4m-logging"; then
  log_warn "Unable to update SAS Viya Monitoring version information"
fi

# Write any "notices" to console
log_message ""
display_notices

log_message ""
log_notice "The deployment of logging components has completed [$(date)]"
echo ""

