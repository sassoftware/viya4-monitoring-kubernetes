#! /bin/bash

# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

##################################
# Confirm using OpenSearch       #
##################################
require_opensearch


##################################
# Confirm on OpenShift           #
##################################

if [ "$OPENSHIFT_CLUSTER" != "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should only be run on OpenShift clusters"
    log_error "Run logging/bin/deploy_logging.sh instead"
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

  #Container Security: Disable serviceAccount Token Automounting
  disable_sa_token_automount $LOG_NS default
  disable_sa_token_automount $LOG_NS builder
  disable_sa_token_automount $LOG_NS deployer
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
# OpenSearch                     #
##################################
log_info "STEP 2: OpenSearch"
logging/bin/deploy_opensearch.sh


##################################
# OpenSearch Dashboards (Kibana) #
##################################
log_info "STEP 3: OpenSearch Dashboards"
logging/bin/deploy_osd.sh


##################################
# Elasticsearch Metric Exporter  #
##################################
log_info "STEP 4: Elasticsearch metric exporter"
logging/bin/deploy_esexporter.sh


##################################
# OpenSearch Content (OpenShift) #
##################################
log_info "STEP 5: Loading Content into OpenSearch"
logging/bin/deploy_opensearch_content.sh


##################################
# OSD Content                    #
##################################
log_info "STEP 6: Configuring OpenSearch Dashboards"

KB_KNOWN_NODEPORT_ENABLE=false logging/bin/deploy_osd_content.sh


##################################
# Fluent Bit                     #
##################################
log_info "STEP 7: Deploying Fluent Bit"
logging/bin/deploy_fluentbit_opensearch.sh


##################################
# Create OpenShift Route(s)      #
# and display app URL(s)         #
##################################
log_info "STEP 8: Create OpenShift Route(s) & Application URL(s)"

OPENSHIFT_ROUTES_ENABLE=${OPENSHIFT_ROUTES_ENABLE:-true}

if [ "$OPENSHIFT_ROUTES_ENABLE" == "true" ]; then

   servicelist="OSD"
   logging/bin/create_openshift_route.sh OSD

   OPENSHIFT_ES_ROUTE_ENABLE=${OPENSHIFT_ES_ROUTE_ENABLE:-false}
   if [ "$OPENSHIFT_ES_ROUTE_ENABLE" == "true" ]; then
      logging/bin/create_openshift_route.sh OS OSD

      servicelist="OS OSD"
   fi

   bin/show_app_url.sh $servicelist

else
   log_info "Environment variable [OPENSHIFT_ROUTES_ENABLE] is not set to 'true'; continuing WITHOUT deploying OpenShift Routes"
fi


##################################
# Service Monitors               #
##################################
log_info "STEP 9: Deploying Service Monitors"
export DEPLOY_SERVICEMONITORS=${DEPLOY_SERVICEMONITORS:-true}
logging/bin/deploy_servicemonitors_openshift.sh


##################################
# Version Info                   #
##################################
log_info "STEP 10: Updating version info"

# If a deployment with the old name exists, remove it first
if helm3ReleaseExists v4m $LOG_NS; then
  log_verbose "Removing outdated SAS Viya Monitoring Helm chart release from [$LOG_NS] namespace"
  helm uninstall -n "$LOG_NS" "v4m"
fi

if ! deployV4MInfo "$LOG_NS" "v4m-logs"; then
  log_warn "Unable to update SAS Viya Monitoring version info"
fi


##################################
# Display Notices                #
##################################
# Write any "notices" to console
echo ""
display_notices


echo ""
log_notice "The deployment of logging components has completed [$(date)]"
echo ""
