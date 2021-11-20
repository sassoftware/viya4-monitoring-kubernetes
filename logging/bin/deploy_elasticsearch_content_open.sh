#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source logging/bin/secrets-include.sh
source logging/bin/apiaccess-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

ES_CONTENT_DEPLOY=${ES_CONTENT_DEPLOY:-${ELASTICSEARCH_ENABLE:-true}}

if [ "$ES_CONTENT_DEPLOY" != "true" ]; then
  log_verbose "Environment variable [ES_CONTENT_DEPLOY] is not set to 'true'; exiting WITHOUT deploying content into Open Distro for Elasticsearch"
  exit 0
fi

log_info "Loading Content into Elasticsearch"

# temp file used to capture command output
tmpfile=$TMP_DIR/output.txt

set -e

# check for pre-reqs

# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "Namespace [$LOG_NS] does NOT exist."
  exit 1
fi


# get credentials
get_credentials_from_secret admin
rc=$?
if [ "$rc" != "0" ] ;then log_debug "RC=$rc"; exit $rc;fi

get_es_api_url

# Confirm Open Distro for Elasticsearch is ready
for pause in 30 30 30 30 30 30 60
do
   response=$(curl -s -o /dev/null -w  "%{http_code}" -XGET  "$es_api_url"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD  --insecure)
   # returns 503 (and outputs "Open Distro Security not initialized.") when ODFE isn't ready yet
   # TO DO: check for 503 specifically?

   if [[ $response != 2* ]]; then
      log_verbose "The Elasticsearch REST endpoint does not appear to be quite ready [$response]; sleeping for [$pause] more seconds before checking again."
      sleep ${pause}s
   else
      log_debug "The Elasticsearch REST endpoint appears to be ready...continuing"
      esready="TRUE"
      break
   fi
done

if [ "$esready" != "TRUE" ]; then
   log_error "The Elasticsearch REST endpoint has NOT become accessible in the expected time; exiting."
   log_error "Review the Elasticsearch pod's events and log to identify the issue and resolve it before trying again."
   exit 1
fi


# Create Index Management (I*M) Policy  objects
function set_retention_period {

   #Arguments
   policy_name=$1                                   # Name of policy...also, used to construct name of json file to load
   retention_period_var=$2                          # Name of env var that can be used to specify retention period

   log_debug "Function called: set_retention_perid ARGS: $@"

   retention_period=${!retention_period_var}        # Retention Period (unit: days)

   digits_re='^[0-9]+$'

   cp logging/es/odfe/es_${policy_name}.json $TMP_DIR/$policy_name.json

   # confirm value is number
   if ! [[ $retention_period =~ $digits_re ]]; then
      log_error "An invalid valid was provided for [$retention_period_var]; exiting."
      exit 1
   fi

   #Update retention period in json file prior to loading it
   sed -i'.bak' "s/\"min_index_age\": \"xxxRETENTION_PERIODxxx\"/\"min_index_age\": \"${retention_period}d\"/g" $TMP_DIR/$policy_name.json

   log_debug "Contents of $policy_name.json after substitution:"
   log_debug "$(cat $TMP_DIR/${policy_name}.json)"

   # Load policy into Elasticsearch via API
   response=$(curl -s -o /tmp/sasgzs.txt  -w "%{http_code}" -XPUT "$es_api_url/_opendistro/_ism/policies/$policy_name" -H 'Content-Type: application/json' -d @$TMP_DIR/$policy_name.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
   if [[ $response == 409 ]]; then
      log_info "The index management policy [$policy_name] already exist in Elasticsearch; skipping load and using existing policy."
   elif [[ $response != 2* ]]; then
      log_error "There was an issue loading index management policy [$policy_name] into Elasticsearch [$response]"
      exit 1
   else
      log_debug "Index management policy [$policy_name] loaded into Elasticsearch [$response]"
   fi
}

#Patch ODFE 1.7.0 ISM policies to ODFE 1.13.2 format
function add_ism_template {
   local policy_name pattern

   #Arguments
   policy_name=$1                                   # Name of policy
   pattern=$2                                       # Index pattern to associate with policy
   priority=${3:-100}                               # Index Priority (Higher values ==> reloaded first)

   response=$(curl -s -o $TMP_DIR/ism_policy_patch.json -w "%{http_code}" -XGET "$es_api_url/_opendistro/_ism/policies/$policy_name" --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
   if [[ $response != 2* ]]; then
      log_debug "No ISM policy [$policy_name] found to patch; moving on.[$response]"
      return
   fi

   if [ -n "$(cat $TMP_DIR/ism_policy_patch.json |grep '"ism_template":null')" ]; then
      log_debug "No ISM Template on policy [$policy_name]; adding one."

      #remove crud returned but not needed
      sed -i'.bak'  "s/\"_id\":\"${policy_name}\",//;s/\"_version\":[0-9]*,//;s/\"_seq_no\":[0-9]*,//;s/\"_primary_term\":[0-9]*,//" $TMP_DIR/ism_policy_patch.json

      #add ISM_Template to existing ISM policy
      sed -i'.bak'  "s/\"ism_template\":null/\"ism_template\": {\"index_patterns\": \[\"${pattern}\"\],\"priority\":${priority}}/g" $TMP_DIR/ism_policy_patch.json

      #delete exisiting policy
      response=$(curl -s -o /dev/null   -w "%{http_code}" -XDELETE "$es_api_url/_opendistro/_ism/policies/$policy_name" --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
      if [[ $response != 2* ]]; then
         log_warn "Error encountered deleting index management policy [$policy_name] before patching to add ISM template stanza [$response]."
         log_warn "Review the index managment policy [$policy_name] within Kibana to ensure it is properly configured and linked to appropriate indexes [$pattern]."
         return
      else
         log_debug "Index policy [$policy_name] deleted [$response]."
      fi

      #handle change in policy name w/ our 1.1.0 release
      if [ "$policy_name" == "viya_infra_idxmgmt_policy" ]; then
         sed -i'.bak' "s/viya_infra_idxmgmt_policy/viya-infra-idxmgmt-policy/g"  $TMP_DIR/ism_policy_patch.json
         policy_name="viya-infra-idxmgmt-policy"
      fi


      #load revised policy
      response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$es_api_url/_opendistro/_ism/policies/$policy_name"  -H 'Content-Type: application/json' -d "@$TMP_DIR/ism_policy_patch.json" --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
      if [[ $response != 2* ]]; then
         log_warn "Unable to update index management policy [$policy_name] to add a ISM_TEMPLATE stanza [$response]"
         log_warn "Review/create the index managment policy [$policy_name] within Kibana to ensure it is properly configured and linked to appropriate indexes [$pattern]."
         return
      else
         log_info "Index management policy [$policy_name] loaded into Elasticsearch [$response]"
      fi
   else
      log_debug "The policy definition for [$policy_name] already includes an ISM Template stanza; no need to patch."
      return
   fi
}


LOG_RETENTION_PERIOD="${LOG_RETENTION_PERIOD:-3}"
set_retention_period viya_logs_idxmgmt_policy LOG_RETENTION_PERIOD
add_ism_template "viya_logs_idxmgmt_policy" "viya_logs-*"  100

# Create Ingest Pipeline to "burst" incoming log messages to separate indexes based on namespace
response=$(curl  -s -o /dev/null -w "%{http_code}"  -XPUT "$es_api_url/_ingest/pipeline/viyaburstns" -H 'Content-Type: application/json' -d @logging/es/es_create_ns_burst_pipeline.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
# request returns: {"acknowledged":true}
if [[ $response != 2* ]]; then
   log_error "There was an issue loading ingest pipeline into Elasticsearch [$response]"
   exit 1
else
   log_debug "Ingest pipeline definition loaded into Elasticsearch [$response]"
fi

# Configure index template settings and link Ingest Pipeline to Index Template
response=$(curl  -s -o /dev/null -w "%{http_code}" -XPUT "$es_api_url/_template/viya-logs-template "    -H 'Content-Type: application/json' -d @logging/es/odfe/es_set_index_template_settings_logs.json --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )
# request returns: {"acknowledged":true}
if [[ $response != 2* ]]; then
   log_error "There was an issue loading index template settings into Elasticsearch [$response]"
   exit 1
else
   log_debug "Index template settings loaded into Elasticsearch [$response]"
fi

if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
   # INFRASTRUCTURE LOGS
   # Handle "infrastructure" logs differently
   INFRA_LOG_RETENTION_PERIOD="${INFRA_LOG_RETENTION_PERIOD:-1}"
   set_retention_period viya_infra_idxmgmt_policy INFRA_LOG_RETENTION_PERIOD
   add_ism_template "viya_infra_idxmgmt_policy"  "viya_logs-openshift-*"   5

   # Link index management policy Index Template
   response=$(curl  -s -o /dev/null -w "%{http_code}" -XPUT "$es_api_url/_template/viya-infra-template "    -H 'Content-Type: application/json' -d @logging/es/odfe/es_set_index_template_settings_infra_openshift.json --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )
   # request returns: {"acknowledged":true}
   if [[ $response != 2* ]]; then
      log_error "There was an issue loading infrastructure index template settings into Elasticsearch [$response]"
      exit 1
   else
      log_info "Infrastructure index template settings loaded into Elasticsearch [$response]"
  fi
fi


# METALOGGING: Create index management policy object & link policy to index template
# ...index management policy automates the deletion of indexes after the specified time

OPS_LOG_RETENTION_PERIOD="${OPS_LOG_RETENTION_PERIOD:-1}"
set_retention_period viya_ops_idxmgmt_policy OPS_LOG_RETENTION_PERIOD
add_ism_template "viya_ops_idxmgmt_policy"  "viya_ops-*"  50

# Load template
response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$es_api_url/_template/viya-ops-template " -H 'Content-Type: application/json' -d @logging/es/odfe/es_set_index_template_settings_ops.json --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
# request returns: {"acknowledged":true}

if [[ $response != 2* ]]; then
   log_error "There was an issue loading monitoring index template settings into Elasticsearch [$response]"
   exit 1
else
   log_debug "Monitoring index template template settings loaded into Elasticsearch [$response]"
fi
echo ""

# Set ISM Job Interval to 120 minutes (from default 5 minutes)
response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$es_api_url/_cluster/settings" -H 'Content-Type: application/json' -d @logging/es/odfe/es_set_index_job_interval.json --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue loading cluster setttings into Elasticsearch [$response]"
   exit 1
else
   log_debug "Cluster settings loaded into Elasticsearch [$response]"
fi

log_info "Content has been loaded into Elasticsearch"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
