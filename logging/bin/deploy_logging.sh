#! /bin/bash

# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

#Fail if not using OpenSearch back-end
require_opensearch

# Confirm NOT on OpenShift
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should NOT be run on OpenShift clusters"
    log_error "Run logging/bin/deploy_logging_openshift.sh instead"
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
fi

log_notice "Deploying logging components to the [$LOG_NS] namespace [$(date)]"

set -e

##################################
# Event Router                   #
##################################

logging/bin/deploy_eventrouter.sh

##################################
# OpenSearch Dashboards (Kibana) #
##################################
# OSD take a while to spin up...deploying it first

logging/bin/deploy_osd.sh

##################################
# OpenSearch                     #
##################################

logging/bin/deploy_opensearch.sh

##################################
# Elasticsearch Metric Exporter  #
##################################

logging/bin/deploy_esexporter.sh

##################################
# OpenSearch Content             #
##################################

logging/bin/deploy_opensearch_content.sh

##################################
# OSD Content                    #
##################################

logging/bin/deploy_osd_content.sh

##################################
# Fluent Bit                     #
##################################

logging/bin/deploy_fluentbit_opensearch.sh

##################################
# Display Kibana URL             #
##################################
set +e
bin/show_app_url.sh OSD OS
set -e


##################################
# Version Info                   #
##################################

# If a deployment with the old name exists, remove it first
if helm3ReleaseExists v4m $LOG_NS; then
  log_verbose "Removing outdated SAS Viya Monitoring Helm chart release from [$LOG_NS] namespace"
  helm uninstall -n "$LOG_NS" "v4m"
fi

if ! deployV4MInfo "$LOG_NS" "v4m-logs"; then
  log_warn "Unable to update SAS Viya Monitoring Helm chart release"
fi


# Write any "notices" to console
log_message ""
display_notices

log_message ""
log_notice "The deployment of logging components has completed [$(date)]"
echo ""

