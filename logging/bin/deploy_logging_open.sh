#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source bin/tls-include.sh

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
EVENTROUTER_ENABLE=${EVENTROUTER_ENABLE:-true}

if [ "$EVENTROUTER_ENABLE" == "true" ]; then
   log_info "STEP 1: Deploying Event Router"
   logging/bin/deploy_eventrouter.sh
else
   log_info "Skipping Event Router install - EVENTROUTER_ENABLE=[$EVENTROUTER_ENABLE]"
fi


##################################
# Open Distro for Elasticsearch  #
##################################

# TO DO: Add enable/disable flag?

log_info "STEP 2: Deploying Elasticsearch"

logging/bin/deploy_odfe.sh

# TO DO: NEED TO CHECK FOR SUCCESS?  CHECK FOR HEALTHY ES?  PAUSE FOR INITIALIZATION?

##################################
# ODFE Content                   #
##################################

# TO DO: Add enable/disable flag?

log_info "STEP 2a: Loading Content into Elasticsearch"

logging/bin/deploy_odfe_content.sh


##################################
# Elasticsearch Metric Exporter  #
##################################

ELASTICSEARCH_EXPORTER_ENABLED=${ELASTICSEARCH_EXPORTER_ENABLED:-true}
if [ "$ELASTICSEARCH_EXPORTER_ENABLED" == "true" ]; then
   log_info "STEP 3: Deploying Elasticsearch metric exporter"
   logging/bin/deploy_esexporter.sh
else
   log_info "Skipping Fluent Bit install - ELASTICSEARCH_EXPORTER_ENABLED=[$ELASTICSEARCH_EXPORTER_ENABLED]"
fi


##################################
# Kibana Content                 #
##################################

# TO DO: Add enable/disable flag?

log_info "STEP 4: Configuring Kibana"

# NOTE: For ODFE, Kibana is deployed as part of ES Helm chart

# TO DO: Need to pause here?
# Need to wait for Kibana to complete initialization after ES security script runs
#log_msg "Waiting [3] minutes for Kibana to complete initialization before loading content"
#sleep 180s

logging/bin/deploy_kibana_content.sh


##################################
# Fluent Bit                     #
##################################

# Enable Fluent Bit?
FLUENT_BIT_ENABLED=${FLUENT_BIT_ENABLED:-true}

if [ "$FLUENT_BIT_ENABLED" == "true" ]; then
   log_info "STEP 5: Deploying Fluent Bit"

   # Call separate Fluent Bit deployment script
   logging/bin/deploy_fluentbit_open.sh
else
  log_info "Skipping Fluent Bit install - FLUENT_BIT_ENABLED=[$FLUENT_BIT_ENABLED]"
fi

log_notice "The deployment of logging components has completed [$(date)]"
echo ""