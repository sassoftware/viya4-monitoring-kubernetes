#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

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

# Set flag for OpenShift cluster
export OPENSHIFT_ENABLE=true


##################################
# OpenShift Set-up               #
##################################

# OpenShift-specific set-up/config
log_info "STEP 0: OpenShift Setup"
logging/bin/deploy_openshift_prereqs.sh

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
# ODFE Content (OpenShift)       #
##################################

log_info "STEP 2a: Loading Content into Elasticsearch"
logging/bin/deploy_elasticsearch_content_open_openshift.sh


##################################
# Elasticsearch Metric Exporter  #
##################################

log_info "STEP 3: Elasticsearch metric exporter"
logging/bin/deploy_esexporter.sh


##################################
# Create OpenShift Routes        #
##################################
log_info "STEP 4a: Create OpenShift Route(s)"
logging/bin/deploy_openshift_routes.sh

##################################
# Kibana Content                 #
##################################

# NOTE: For ODFE, Kibana is deployed as part of ES Helm chart

log_info "STEP 4b: Configuring Kibana"

export KB_KNOWN_NODEPORT_ENABLE=false
logging/bin/deploy_kibana_content.sh


##################################
# Display Kibana URL             #
##################################
log_info "STEP 4c: Display Application URLs"
if [ "$ES_ENDPOINT_ENABLE" == "true" ];then
   servicelist="KIBANA ELASTICSEARCH"
else
   servicelist="KIBANA"
fi

logging/bin/show_app_url.sh $servicelist


##################################
# Fluent Bit                     #
##################################

log_info "STEP 5: Deploying Fluent Bit"
logging/bin/deploy_fluentbit_open.sh


##################################
# Service Monitors               #
##################################

log_info "STEP 6: Deploying Service Monitors"
export DEPLOY_SERVICEMONITORS=${DEPLOY_SERVICEMONITORS:-true}
logging/bin/deploy_servicemonitors_open.sh


##################################
# Display Notices                #
##################################
# Write any "notices" to console
echo ""
display_notices


echo ""
log_notice "The deployment of logging components has completed [$(date)]"
echo ""
