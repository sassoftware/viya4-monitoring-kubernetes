#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
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


##################################
# OpenShift Set-up               #
##################################

# OpenShift-specific set-up/config

log_info "STEP 0: OpenShift Setup"
# link Elasticsearch serviceAccounts to 'privileged' scc
oc adm policy add-scc-to-user privileged -z v4m-es-es -n $LOG_NS

# create the 'v4mlogging' SCC
oc create -f samples/openshift/logging/fb_v4mlogging_scc.yaml

# link Fluent Bit serviceAccount to 'v4mlogging' scc
oc adm policy add-scc-to-user v4mlogging -z v4m-fb    -n $LOG_NS


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
# Create OpenShift Routes        #
##################################
log_info "STEP 4a: Create OpenShift Route(s)"

# TO DO: MOVE TO INGRESS?

if [ "$LOG_KB_TLS_ENABLE" != "true" ]; then
   oc -n $LOG_NS expose service v4m-es-kibana-svc
else
   oc -n $LOG_NS create route passthrough v4m-es-kibana-svc --service=v4m-es-kibana-svc --port=kibana-svc
fi

ES_ENDPOINT_ENABLE=${ES_ENDPOINT_ENABLE:-false}
if [ "$ES_ENDPOINT_ENABLE" == "true" ]; then
   oc -n $LOG_NS create route passthrough v4m-es-api --service=v4m-es-client-service --port=http
fi


##################################
# Kibana Content                 #
##################################

# NOTE: For ODFE, Kibana is deployed as part of ES Helm chart

log_info "STEP 4b: Configuring Kibana"

export KB_NODEPORT_ENABLE=false
logging/bin/deploy_kibana_content.sh


##################################
# Display Kibana URL             #
##################################
log_info "STEP 4c: Display Application URLs"
if [ "$ES_ENDPOINT_ENABLE" == "true" ];then
   servicelist="KIBANA"
else
   servicelist="KIBANA ELASTICSEARCH"
fi

logging/bin/show_app_url.sh $servicelist


#host=$(oc -n $LOG_NS get route v4m-es-kibana-svc -o=jsonpath='{.spec.host}')
#tls_mode=$(oc -n $LOG_NS get route v4m-es-kibana-svc -o=jsonpath='{.spec.tls.termination}')
#if [ -z "$tls_mode" ]; then
 # NOT TLS enables
# protocol="http"
#else
# protocol="https"
#fi
#url="$protocol://$host"

#url=$(get_service_url $LOG_NS v4m-es-kibana-svc "/" $LOG_KB_TLS_ENABLE)
#echo "KIBANA URL: $url"


##################################
# Fluent Bit                     #
##################################

log_info "STEP 5: Deploying Fluent Bit"
logging/bin/deploy_fluentbit_open.sh

# Write any "notices" to console
echo ""
display_notices

echo ""
log_notice "The deployment of logging components has completed [$(date)]"
echo ""
