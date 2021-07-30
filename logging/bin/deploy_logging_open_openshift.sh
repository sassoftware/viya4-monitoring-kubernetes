#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

##################################
# Confirm on OpenShift           #
##################################

if [ "$OPENSHIFT_CLUSTER" != "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should only be run on OpenShift clusters"
    log_error "Run logging/bin/deploy_logging_open.sh instead"
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
# OpenShift-specific Set-up      #
##################################
log_info "STEP 0: OpenShift Setup"
logging/bin/deploy_openshift_prereqs.sh

# On OpenShift force "full" TLS
export LOG_KB_TLS_ENABLE=true

##################################
# Event Router                   #
##################################
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
# Create OpenShift Route(s)      #
# and display app URL(s)         #
##################################
log_info "STEP 4a: Create OpenShift Route(s) & Application URL(s)"

OPENSHIFT_ROUTES_ENABLE=${OPENSHIFT_ROUTES_ENABLE:-true}

if [ "$OPENSHIFT_ROUTES_ENABLE" == "true" ]; then

   servicelist="KIBANA"
   logging/bin/create_openshift_route.sh KIBANA

   OPENSHIFT_ES_ROUTE_ENABLE=${OPENSHIFT_ES_ROUTE_ENABLE:-false}
   if [ "$OPENSHIFT_ES_ROUTE_ENABLE" == "true" ]; then
      logging/bin/create_openshift_route.sh ELASTICSEARCH

      servicelist="KIBANA ELASTICSEARCH"
   fi

   bin/show_app_url.sh $servicelist

else
   log_info "Environment variable [OPENSHIFT_ROUTES_ENABLE] is not set to 'true'; continuing WITHOUT deploying OpenShift Routes"
fi


##################################
# Kibana Content                 #
##################################
log_info "STEP 4b: Configuring Kibana"

KB_KNOWN_NODEPORT_ENABLE=false logging/bin/deploy_kibana_content.sh


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
logging/bin/deploy_servicemonitors_open_openshift.sh

##################################
# Version Info                   #
##################################
log_info "STEP 7: Updating version info"
deployV4MInfo "$LOG_NS"

##################################
# Display Notices                #
##################################
# Write any "notices" to console
echo ""
display_notices


echo ""
log_notice "The deployment of logging components has completed [$(date)]"
echo ""
