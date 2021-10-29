#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source logging/bin/secrets-include.sh
source bin/service-url-include.sh
source logging/bin/apiaccess-include.sh
source logging/bin/rbac-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

KIBANA_CONTENT_DEPLOY=${KIBANA_CONTENT_DEPLOY:-${ELASTICSEARCH_ENABLE:-true}}

if [ "$KIBANA_CONTENT_DEPLOY" != "true" ]; then
  log_info "Environment variable [KIBANA_CONTENT_DEPLOY] is not set to 'true'; exiting WITHOUT deploying content into Kibana"
  exit 0
fi

# temp file used to capture command output
tmpfile=$TMP_DIR/output.txt

# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "Namespace [$LOG_NS] does NOT exist."
  exit 1
fi

# Require TLS into Kibana?
LOG_KB_TLS_ENABLE=${LOG_KB_TLS_ENABLE:-false}

if [ "$LOG_KB_TLS_ENABLE" == "true" ]; then
   # w/TLS: use HTTPS in curl commands
   KB_CURL_PROTOCOL=https
   log_debug "TLS enabled for Kibana"
else
   # w/o TLS: use HTTP in curl commands
   KB_CURL_PROTOCOL=http
   log_debug "TLS not enabled for Kibana"
fi

# get credentials
get_credentials_from_secret admin
rc=$?
if [ "$rc" != "0" ] ;then log_info "RC=$rc"; exit $rc;fi

set -e

log_info "Configuring Kibana"

#### TEMP:  Remove if/when Helm chart supports defining nodePort
KB_KNOWN_NODEPORT_ENABLE=${KB_KNOWN_NODEPORT_ENABLE:-true}

if [ "$KB_KNOWN_NODEPORT_ENABLE" == "true" ]; then
   SVC=v4m-es-kibana-svc
   SVC_TYPE=$(kubectl get svc -n $LOG_NS $SVC -o jsonpath='{.spec.type}')

   if [ "$SVC_TYPE" == "NodePort" ]; then
     KIBANA_PORT=31033
     kubectl -n "$LOG_NS" patch svc "$SVC" --type='json' -p '[{"op":"replace","path":"/spec/ports/0/nodePort","value":31033}]'
     log_info "Setting Kibana service NodePort to 31033"
   fi
else
  log_debug "Kibana service NodePort NOT changed to 'known' port because KB_KNOWN_NODEPORT_ENABLE set to [$KB_KNOWN_NODEPORT_ENABLE]."
fi


# Need to wait 2-3 minutes for kibana to come up and
# and be ready to accept the curl commands below
# wait for pod to show as "running" and "ready"

log_debug "Checking status of Kibana pod"
podready="FALSE"

for pause in 40 30 20 15 10 10 10 15 15 15 30 30 30 30
do
   if [[ "$( kubectl -n $LOG_NS get pod -l 'role=kibana' -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}')" == *"True"* ]]; then
      log_info "The Kibana pod is ready...continuing"
      podready="TRUE"
      break
   else
      log_info "The Kibana pod is not ready yet...sleeping for [$pause] more seconds before checking again."
      sleep ${pause}s
   fi
done

if [ "$podready" != "TRUE" ]; then
   log_error "The Kibana pod has NOT reached [Ready] status in the expected time; exiting."
   log_error "Review the Kibana pod's events and log to identify the issue and resolve it; run the remove_logging.sh script and try again."
   kill -9 $pfPID
   exit 1
fi

get_kb_api_url

# Confirm Kibana is ready
set +e
for pause in 30 30 30 30 30 30
do
   response=$(curl -s -o /dev/null -w  "%{http_code}" -XGET  "${kb_api_url}/api/status"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD  --insecure)
   # returns 503 (and outputs "Kibana server is not ready yet") when Kibana isn't ready yet
   # TO DO: check for 503 specifically?

   if [[ $response != 2* ]]; then
      log_info "The Kibana REST endpoint does not appear to be quite ready [$response]; sleeping for [$pause] more seconds before checking again."
      sleep ${pause}s
   else
      log_info "The Kibana REST endpoint appears to be ready...continuing"
      kibanaready="TRUE"
      break
   fi
done
set -e

if [ "$kibanaready" != "TRUE" ]; then
   log_error "The Kibana REST endpoint has NOT become accessible in the expected time; exiting."
   log_error "Review the Kibana pod's events and log to identify the issue and resolve it before trying again."
   exit 1
fi

if [ "$V4M_FEATURE_MULTITENANT_ENABLE" == "true" ]; then

   set +e  # disable exit on error

   # Need to create cluster_admins Kibana tenant space?
   # Should only be true during UIP scenario b/c our updated
   # securityconfig processing is bypassed (to prevent
   # clobbering post-deployment changes made via Kibana).

   # get Security API URL
   get_sec_api_url 

   # Create cluster_admins Kibana tenant space (if it doesn't exist)
   if ! kibana_tenant_exists "cluster_admins"; then
      create_kibana_tenant "cluster_admins" "Kibana tenant space for Cluster Administrators"
      rc=$?
      if [ "$rc" != "0" ]; then
         log_error "Problems were encountered while attempting to create tenant space [cluster_admins]."
         exit 1
      fi
   else
      log_debug "The Kibana tenant space [cluster_admins] exists."
   fi

   # Import Kibana Searches, Visualizations and Dashboard Objects using curl
   ./logging/bin/import_kibana_content.sh logging/kibana/common          cluster_admins
   ./logging/bin/import_kibana_content.sh logging/kibana/cluster_admins  cluster_admins
   ./logging/bin/import_kibana_content.sh logging/kibana/namespace       cluster_admins
   ./logging/bin/import_kibana_content.sh logging/kibana/tenant          cluster_admins


   # delete "demo" Kibana tenant space created (but not used) prior to version 1.1.0
   if kibana_tenant_exists "admin_tenant"; then

      delete_kibana_tenant "admin_tenant"

      rc=$?
      if [ "$rc" == "0" ]; then
         log_debug "The Kibana tenant space [admin_tenant] was deleted."
      else
         log_debug "Problems were encountered while attempting to delete tenant space [admin_tenant]."
      fi
   fi

else
   # Importing content into Global tenant for continuity, to be removed in future
   log_debug "Deploying content into Global tenant (multi-tenancy NOT enabled)"
   response=$(curl -s -o /dev/null -w "%{http_code}" -XPOST "${kb_api_url}/api/saved_objects/_import?overwrite=true"  -H "kbn-xsrf: true"   --form file=@logging/kibana/kibana_saved_objects_7.6.1_210809.ndjson --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )

   if [[ $response != 2* ]]; then
      log_error "There was an issue loading content into Kibana [$response]"
      exit 1
   else
      log_info "Content loaded into Kibana [$response]"
   fi

fi

log_info "Configuring Kibana has been completed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
