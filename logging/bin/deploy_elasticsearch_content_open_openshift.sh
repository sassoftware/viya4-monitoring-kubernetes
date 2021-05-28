#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source logging/bin/secrets-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

ES_CONTENT_DEPLOY=${ES_CONTENT_DEPLOY:-${ELASTICSEARCH_ENABLE:-true}}

if [ "$ES_CONTENT_DEPLOY" != "true" ]; then
  log_info "Environment variable [ES_CONTENT_DEPLOY] is not set to 'true'; exiting WITHOUT deploying content into Open Distro for Elasticsearch"
  exit 0
fi

# Confirm on OpenShift
if [ "$OPENSHIFT_CLUSTER" != "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should only be run on OpenShift clusters"
    log_error "Run logging/bin/deploy_elasticsearch_content_open.sh instead"
    exit 1
  fi
fi

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
if [ "$rc" != "0" ] ;then log_info "RC=$rc"; exit $rc;fi


# set up temporary port forwarding to allow curl access
ES_PORT=$(kubectl -n $LOG_NS get service v4m-es-client-service -o=jsonpath='{.spec.ports[?(@.name=="http")].port}')

# command is sent to run in background
kubectl -n $LOG_NS port-forward --address localhost svc/v4m-es-client-service :$ES_PORT > $tmpfile  &

# get PID to allow us to kill process later
pfPID=$!
log_debug "pfPID: $pfPID"


# pause to allow port-forwarding messages to appear
sleep 5s

# determine which port port-forwarding is using
pfRegex='Forwarding from .+:([0-9]+)'
myline=$(head -n1  $tmpfile)

if [[ $myline =~ $pfRegex ]]; then
   TEMP_PORT="${BASH_REMATCH[1]}";
   log_debug "TEMP_PORT=${TEMP_PORT}"
else
   set +e
   log_error "Unable to obtain or identify the temporary port used for port-forwarding; exiting script.";
   kill -9 $pfPID
   rm -f  $tmpfile
   exit 1
fi

# Confirm Open Distro for Elasticsearch is ready
for pause in 30 30 30 30 30 30 60
do
   response=$(curl -s -o /dev/null -w  "%{http_code}" -XGET  "https://localhost:$TEMP_PORT"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD  --insecure)
   # returns 503 (and outputs "Open Distro Security not initialized.") when ODFE isn't ready yet
   # TO DO: check for 503 specifically?

   if [[ $response != 2* ]]; then
      log_info "The Elasticsearch REST endpoint does not appear to be quite ready [$response]; sleeping for [$pause] more seconds before checking again."
      sleep ${pause}s
   else
      log_info "The Elasticsearch REST endpoint appears to be ready...continuing"
      esready="TRUE"
      break
   fi
done

if [ "$esready" != "TRUE" ]; then
   log_error "The Elasticsearch REST endpoint has NOT become accessible in the expected time; exiting."
   log_error "Review the Elasticsearch pod's events and log to identify the issue and resolve it before trying again."
   kill -9 $pfPID
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
      kill -9 $pfPID
      exit 1
   fi

   #Update retention period in json file prior to loading it
   sed -i'.bak' "s/\"min_index_age\": \"xxxRETENTION_PERIODxxx\"/\"min_index_age\": \"${retention_period}d\"/g" $TMP_DIR/$policy_name.json

   log_debug "Contents of $policy_name.json after substitution:"
   log_debug "$(cat $TMP_DIR/${policy_name}.json)"

   # Load policy into Elasticsearch via API
   response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_opendistro/_ism/policies/$policy_name" -H 'Content-Type: application/json' -d @$TMP_DIR/$policy_name.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
   if [[ $response == 409 ]]; then
      log_info "The index management policy [$policy_name] already exist in Elasticsearch; skipping load and using existing policy."
   elif [[ $response != 2* ]]; then
      log_error "There was an issue loading index management policy [$policy_name] into Elasticsearch [$response]"
      kill -9 $pfPID
      exit 1
   else
      log_info "Index management policy [$policy_name] loaded into Elasticsearch [$response]"
   fi
}

LOG_RETENTION_PERIOD="${LOG_RETENTION_PERIOD:-3}"
set_retention_period viya_logs_idxmgmt_policy LOG_RETENTION_PERIOD

# Create Ingest Pipeline to "burst" incoming log messages to separate indexes based on namespace
response=$(curl  -s -o /dev/null -w "%{http_code}"  -XPUT "https://localhost:$TEMP_PORT/_ingest/pipeline/viyaburstns" -H 'Content-Type: application/json' -d @logging/es/es_create_ns_burst_pipeline.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
# request returns: {"acknowledged":true}
if [[ $response != 2* ]]; then
   log_error "There was an issue loading ingest pipeline into Elasticsearch [$response]"
   kill -9 $pfPID
   exit 1
else
   log_info "Ingest pipeline definition loaded into Elasticsearch [$response]"
fi

# Link index management policy and Ingest Pipeline to Index Template
response=$(curl  -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_template/viya-logs-template "    -H 'Content-Type: application/json' -d @logging/es/odfe/es_set_index_template_settings_logs.json --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )
# request returns: {"acknowledged":true}
if [[ $response != 2* ]]; then
   log_error "There was an issue loading index template settings into Elasticsearch [$response]"
   kill -9 $pfPID
   exit 1
else
   log_info "Index template settings loaded into Elasticsearch [$response]"
fi

# INFRASTRUCTURE LOGS
# Handle "infrastructure" logs differently
INFRA_LOG_RETENTION_PERIOD="${INFRA_LOG_RETENTION_PERIOD:-1}"
set_retention_period viya_infra_idxmgmt_policy INFRA_LOG_RETENTION_PERIOD

# Link index management policy Index Template
response=$(curl  -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_template/viya-infra-template "    -H 'Content-Type: application/json' -d @logging/es/odfe/es_set_index_template_settings_infra_openshift.json --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )
# request returns: {"acknowledged":true}
if [[ $response != 2* ]]; then
   log_error "There was an issue loading infrastructure index template settings into Elasticsearch [$response]"
   kill -9 $pfPID
   exit 1
else
   log_info "Infrastructure index template settings loaded into Elasticsearch [$response]"
fi

# METALOGGING: Create index management policy object & link policy to index template
# ...index management policy automates the deletion of indexes after the specified time

OPS_LOG_RETENTION_PERIOD="${OPS_LOG_RETENTION_PERIOD:-1}"
set_retention_period viya_ops_idxmgmt_policy OPS_LOG_RETENTION_PERIOD

# Load template
response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_template/viya-ops-template " -H 'Content-Type: application/json' -d @logging/es/odfe/es_set_index_template_settings_ops.json --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
# request returns: {"acknowledged":true}

if [[ $response != 2* ]]; then
   log_error "There was an issue loading monitoring index template settings into Elasticsearch [$response]"
   kill -9 $pfPID
   exit 1
else
   log_info "Monitoring index template template settings loaded into Elasticsearch [$response]"
fi
echo ""

# Set ISM Job Interval to 120 minutes (from default 5 minutes)
response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "https://localhost:$TEMP_PORT/_cluster/settings" -H 'Content-Type: application/json' -d @logging/es/odfe/es_set_index_job_interval.json --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
if [[ $response != 2* ]]; then
   log_error "There was an issue loading cluster setttings into Elasticsearch [$response]"
   kill -9 $pfPID
   exit 1
else
   log_info "Cluster settings loaded into Elasticsearch [$response]"
fi

# terminate port-forwarding and remove tmpfile
log_info "You may see a message below about a process being killed; it is expected and can be ignored."
kill  -9 $pfPID
rm -f $tmpfile

sleep 7s

log_info "Content has been loaded into Elasticsearch"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
