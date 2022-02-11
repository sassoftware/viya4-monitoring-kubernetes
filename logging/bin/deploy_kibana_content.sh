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
  log_verbose "Environment variable [KIBANA_CONTENT_DEPLOY] is not set to 'true'; exiting WITHOUT deploying content into Kibana"
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
if [ "$rc" != "0" ] ;then log_debug "RC=$rc"; exit $rc;fi

set -e

log_info "Configuring Kibana...this may take a few minutes"

#### TEMP:  Remove if/when Helm chart supports defining nodePort
KB_KNOWN_NODEPORT_ENABLE=${KB_KNOWN_NODEPORT_ENABLE:-true}

if [ "$KB_KNOWN_NODEPORT_ENABLE" == "true" ]; then
   SVC=v4m-es-kibana-svc
   SVC_TYPE=$(kubectl get svc -n $LOG_NS $SVC -o jsonpath='{.spec.type}')

   if [ "$SVC_TYPE" == "NodePort" ]; then
     KIBANA_PORT=31033
     kubectl -n "$LOG_NS" patch svc "$SVC" --type='json' -p '[{"op":"replace","path":"/spec/ports/0/nodePort","value":31033}]'
     log_verbose "Setting Kibana service NodePort to 31033"
   fi
else
  log_debug "Kibana service NodePort NOT changed to 'known' port because KB_KNOWN_NODEPORT_ENABLE set to [$KB_KNOWN_NODEPORT_ENABLE]."
fi


# wait up to 10 minutes for pod to show as "running" and "ready"
log_info "Waiting for Kibana pods to be ready."
kubectl -n logging wait pods --selector app=v4m-es,role=kibana --for condition=Ready --timeout=10m

set +e
get_kb_api_url

set -e

if [ "$kibanaready" != "TRUE" ]; then
   log_error "The Kibana REST endpoint has NOT become accessible in the expected time; exiting."
   log_error "Review the Kibana pod's events and log to identify the issue and resolve it before trying again."
   exit 1
fi

set +e  # disable exit on error

# get Security API URL
get_sec_api_url

# Create cluster_admins Kibana tenant space (if it doesn't exist)
#   Should only be true during UIP scenario b/c our updated securityconfig processing
#   is bypassed (to prevent clobbering post-deployment changes made via Kibana).
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

#Migrating from ODFE 1.7.0 to ODFE 1.13.x (file should only exist during migration)
if [ -f "$KB_GLOBAL_EXPORT_FILE" ]; then

   # delete 'demo' Kibana tenant space created (but not used) prior to V4m version 1.1.0
   if kibana_tenant_exists "admin_tenant"; then

      delete_kibana_tenant "admin_tenant"

      rc=$?
      if [ "$rc" == "0" ]; then
         log_debug "The Kibana tenant space [admin_tenant] was deleted."
      else
         log_debug "Problems were encountered while attempting to delete tenant space [admin_tenant]."
      fi
   fi

   log_verbose "Will attempt to migrate Kibana content from previous deployment."

   kb_migrate_response="$TMP_DIR/kb_migrate_response.json"

   #import previously exported content from global tenant
   response=$(curl -s -o $kb_migrate_response  -w  "%{http_code}" -XPOST "${kb_api_url}/api/saved_objects/_import?overwrite=false" -H "kbn-xsrf: true"  -H 'securitytenant: cluster_admins'  --form file="@$KB_GLOBAL_EXPORT_FILE"  -u $ES_ADMIN_USER:$ES_ADMIN_PASSWD -k)

   if [[ $response != 2* ]]; then
      log_warn "There was an issue importing the cached existing Kibana content into the Kibana tenant space [cluster_admins]. [$response]"
      log_warn "Some of your existing content may need to be recreated or restored from your backup files."
      log_debug "Failed response details: $(tail -n1 $kb_migrate_response)"
   else
      log_info "Existing Kibana imported to [cluster_admins] Kibana tenant space. [$response]"
      log_debug "Import details: $(tail -n1 $kb_migrate_response)"
   fi
else
   log_debug "Migration from ODFE 1.7.0 to ODFE 1.13.x *NOT* detected"
fi

# Import Kibana Searches, Visualizations and Dashboard Objects using curl
./logging/bin/import_kibana_content.sh logging/kibana/common          cluster_admins
./logging/bin/import_kibana_content.sh logging/kibana/cluster_admins  cluster_admins
./logging/bin/import_kibana_content.sh logging/kibana/namespace       cluster_admins
./logging/bin/import_kibana_content.sh logging/kibana/tenant          cluster_admins



# create the all logs RBACs
add_notice "**Elasticsearch/Kibana Access Controls**"
LOGGING_DRIVER=true ./logging/bin/security_create_rbac.sh _all_ _all_

# Create the 'logadm' Kibana user who can access all logs
LOG_CREATE_LOGADM_USER=${LOG_CREATE_LOGADM_USER:-true}
if [ "$LOG_CREATE_LOGADM_USER" == "true" ]; then

   if user_exists logadm; then
      log_warn "A user 'logadm' already exists; leaving that user as-is.  Review its definition in Kibana and update it, or create another user, as needed."
   else
      log_debug "Creating the 'logadm' user"

      LOG_LOGADM_PASSWD=${LOG_LOGADM_PASSWD:-$ES_ADMIN_PASSWD}
      if [ -z "$LOG_LOGADM_PASSWD" ]; then
         log_debug "Creating a random password for the 'logadm' user"
         LOG_LOGADM_PASSWD="$(randomPassword)"
         add_notice ""
         add_notice "**The Kibana 'logadm' Account**"
         add_notice "Generated 'logadm' password:  $LOG_LOGADM_PASSWD"
      fi

      #create the user
      LOGGING_DRIVER=true ./logging/bin/user.sh CREATE -ns _all_ -t _all_ -u logadm -p $LOG_LOGADM_PASSWD
   fi
else
   log_debug "Skipping creation of 'logadm' user because LOG_CREATE_LOGADM_USER not 'true' [$LOG_CREATE_LOGADM_USER]"
fi

LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
   echo ""
   display_notices
   echo ""
fi

log_info "Configuring Kibana has been completed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
