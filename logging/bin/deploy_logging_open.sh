#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

log_info "On branch: geturlbug"  # REMOVE

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

set -e

log_notice "Deploying logging components to the [$LOG_NS] namespace [$(date)]"


##################################
# Event Router                   #
##################################

# Collect Kubernetes events as pseudo-log messages?

log_info "STEP 1: Event Router"
logging/bin/deploy_eventrouter.sh

##################################
# Open Distro for Elasticsearch  #
##################################

log_info "STEP 2: Elasticsearch"
logging/bin/deploy_elasticsearch_open.sh

##################################
# Open Distro Content            #
##################################

log_info "STEP 2a: Loading Content into Elasticsearch"
logging/bin/deploy_elasticsearch_content_open.sh

##################################
# Elasticsearch Metric Exporter  #
##################################

log_info "STEP 3: Elasticsearch metric exporter"
logging/bin/deploy_esexporter.sh

##################################
# Kibana Content                 #
##################################

# NOTE: For ODFE, Kibana is deployed as part of ES Helm chart

log_info "STEP 4: Configuring Kibana"
logging/bin/deploy_kibana_content.sh


##################################
# Display Kibana URL             #
##################################
log_info "STEP 4a: Display Application URLs"
bin/show_app_url.sh KIBANA ELASTICSEARCH


##################################
# Fluent Bit                     #
##################################

log_info "STEP 5: Deploying Fluent Bit"
logging/bin/deploy_fluentbit_open.sh


##################################
# Version Info                   #
##################################
log_info "STEP 6: Updating version info"
if ! deployV4MInfo "$LOG_NS"; then
  log_warn "Unable to update SAS Viya Monitoring version info"
fi

# Write any "notices" to console
echo ""
display_notices

echo ""
log_notice "The deployment of logging components has completed [$(date)]"
echo ""

