#! /bin/bash

# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh
source logging/bin/secrets-include.sh
source logging/bin/apiaccess-include.sh
source logging/bin/rbac-include.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

ES_CONTENT_DEPLOY=${ES_CONTENT_DEPLOY:-${ELASTICSEARCH_ENABLE:-true}}

if [ "$ES_CONTENT_DEPLOY" != "true" ]; then
    log_verbose "Environment variable [ES_CONTENT_DEPLOY] is not set to 'true'; exiting WITHOUT deploying content into OpenSearch"
    exit 0
fi

log_info "Loading Content into OpenSearch"

# temp file used to capture command output
tmpfile=$TMP_DIR/output.txt

set -e

# check for pre-reqs

# Confirm namespace exists
if [ -z "$(kubectl get ns "$LOG_NS" -o name 2> /dev/null)" ]; then
    log_error "Namespace [$LOG_NS] does NOT exist."
    exit 1
fi

# get credentials
get_credentials_from_secret admin
rc=$?
if [ "$rc" != "0" ]; then
    log_debug "RC=$rc"
    exit $rc
fi

get_ism_api_url

# Confirm OpenSearch is ready
for pause in 30 30 30 30 30 30 60; do
    response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "$es_api_url" --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
    # returns 503 (and outputs "Open Distro Security not initialized.") when ODFE isn't ready yet
    # TO DO: check for 503 specifically?

    if [[ $response != 2* ]]; then
        log_verbose "The OpenSearch REST endpoint does not appear to be quite ready [$response]; sleeping for [$pause] more seconds before checking again."
        sleep ${pause}
    else
        log_debug "The OpenSearch REST endpoint appears to be ready...continuing"
        esready="TRUE"
        break
    fi
done

if [ "$esready" != "TRUE" ]; then
    log_error "The OpenSearch REST endpoint has NOT become accessible in the expected time; exiting."
    log_error "Review the OpenSearch pod's events and log to identify the issue and resolve it before trying again."
    exit 1
fi

# Create Index Management (I*M) Policy  objects
function set_retention_period {

    #Arguments
    # policy_name            Name of policy...also, used to construct name of json file to load
    # retention_period_var   Name of env var that can be used to specify retention period

    policy_name=$1
    retention_period_var=$2

    # shellcheck disable=2145
    log_debug "Function called: set_retention_perid ARGS: $@"

    retention_period=${!retention_period_var} # Retention Period (unit: days)

    digits_re='^[0-9]+$'

    cp logging/opensearch/"${policy_name}".json "$TMP_DIR"/"$policy_name".json

    # confirm value is number
    if ! [[ $retention_period =~ $digits_re ]]; then
        log_error "An invalid valid was provided for [$retention_period_var]; exiting."
        exit 1
    fi

    #Update retention period in json file prior to loading it
    sed -i'.bak' "s/\"min_index_age\": \"xxxRETENTION_PERIODxxx\"/\"min_index_age\": \"${retention_period}d\"/g" "$TMP_DIR"/"$policy_name".json

    log_debug "Contents of $policy_name.json after substitution:"
    log_debug "$(cat "$TMP_DIR"/"${policy_name}".json)"

    # Load policy into OpenSearch via API
    response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$ism_api_url/policies/$policy_name" -H 'Content-Type: application/json' -d @"$TMP_DIR"/"$policy_name".json --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
    if [[ $response == 409 ]]; then
        log_info "The index management policy [$policy_name] already exist in OpenSearch; skipping load and using existing policy."
    elif [[ $response != 2* ]]; then
        log_error "There was an issue loading index management policy [$policy_name] into OpenSearch [$response]"
        exit 1
    else
        log_debug "Index management policy [$policy_name] loaded into OpenSearch [$response]"
    fi
}

#Patch ODFE 1.7.0 ISM policies to ODFE 1.13.x format
function add_ism_template {
    local policy_name pattern

    #Arguments
    # policy_name        Name of policy
    # pattern            Index pattern to associate with policy
    # priority           Index Priority (Higher values ==> reloaded first)

    policy_name=$1
    pattern=$2
    priority=${3:-100}

    response=$(curl -s -o "$TMP_DIR"/ism_policy_patch.json -w "%{http_code}" -XGET "$ism_api_url/policies/$policy_name" --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
    if [[ $response != 2* ]]; then
        log_debug "No ISM policy [$policy_name] found to patch; moving on.[$response]"
        return
    fi

    if grep -q '"ism_template":null' "$TMP_DIR"/ism_policy_patch.json; then
        log_debug "No ISM Template on policy [$policy_name]; adding one."

        #remove crud returned but not needed
        sed -i'.bak' "s/\"_id\":\"${policy_name}\",//;s/\"_version\":[0-9]*,//;s/\"_seq_no\":[0-9]*,//;s/\"_primary_term\":[0-9]*,//" "$TMP_DIR"/ism_policy_patch.json

        #add ISM_Template to existing ISM policy
        sed -i'.bak' "s/\"ism_template\":null/\"ism_template\": {\"index_patterns\": \[\"${pattern}\"\],\"priority\":${priority}}/g" "$TMP_DIR"/ism_policy_patch.json

        #delete exisiting policy
        response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "$ism_api_url/policies/$policy_name" --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
        if [[ $response != 2* ]]; then
            log_warn "Error encountered deleting index management policy [$policy_name] before patching to add ISM template stanza [$response]."
            log_warn "Review the index managment policy [$policy_name] within OpenSearch Dashboards to ensure it is properly configured and linked to appropriate indexes [$pattern]."
            return
        else
            log_debug "Index policy [$policy_name] deleted [$response]."
        fi

        #handle change in policy name w/ our 1.1.0 release
        if [ "$policy_name" == "viya_infra_idxmgmt_policy" ]; then
            sed -i'.bak' "s/viya_infra_idxmgmt_policy/viya-infra-idxmgmt-policy/g" "$TMP_DIR"/ism_policy_patch.json
            policy_name="viya-infra-idxmgmt-policy"
        fi

        #load revised policy
        response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$ism_api_url/policies/$policy_name" -H 'Content-Type: application/json' -d "@$TMP_DIR/ism_policy_patch.json" --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
        if [[ $response != 2* ]]; then
            log_warn "Unable to update index management policy [$policy_name] to add a ISM_TEMPLATE stanza [$response]"
            log_warn "Review/create the index managment policy [$policy_name] within OpenSearch Dashboards to ensure it is properly configured and linked to appropriate indexes [$pattern]."
            return
        else
            log_info "Index management policy [$policy_name] loaded into OpenSearch [$response]"
        fi
    else
        log_debug "The policy definition for [$policy_name] already includes an ISM Template stanza; no need to patch."
        return
    fi
}

LOG_RETENTION_PERIOD="${LOG_RETENTION_PERIOD:-3}"
set_retention_period viya_logs_idxmgmt_policy LOG_RETENTION_PERIOD
add_ism_template "viya_logs_idxmgmt_policy" "viya_logs-*" 100

# Create Ingest Pipeline to "burst" incoming log messages to separate indexes based on namespace
response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$es_api_url/_ingest/pipeline/viyaburstns" -H 'Content-Type: application/json' -d @logging/opensearch/create_ns_burst_pipeline.json --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
# request returns: {"acknowledged":true}
if [[ $response != 2* ]]; then
    log_error "There was an issue loading ingest pipeline into OpenSearch [$response]"
    exit 1
else
    log_debug "Ingest pipeline definition loaded into OpenSearch [$response]"
fi

# Configure index template settings and link Ingest Pipeline to Index Template
response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$es_api_url/_template/viya-logs-template" -H 'Content-Type: application/json' -d @logging/opensearch/set_index_template_settings_logs.json --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
# request returns: {"acknowledged":true}
if [[ $response != 2* ]]; then
    log_error "There was an issue loading index template settings into OpenSearch [$response]"
    exit 1
else
    log_debug "Index template settings loaded into OpenSearch [$response]"
fi

if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    # INFRASTRUCTURE LOGS
    # Handle "infrastructure" logs differently
    INFRA_LOG_RETENTION_PERIOD="${INFRA_LOG_RETENTION_PERIOD:-1}"
    set_retention_period viya_infra_idxmgmt_policy INFRA_LOG_RETENTION_PERIOD
    add_ism_template "viya_infra_idxmgmt_policy" "viya_logs-openshift-*" 5

    # Link index management policy Index Template
    response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$es_api_url/_template/viya-infra-template" -H 'Content-Type: application/json' -d @logging/opensearch/set_index_template_settings_infra_openshift.json --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
    # request returns: {"acknowledged":true}
    if [[ $response != 2* ]]; then
        log_error "There was an issue loading infrastructure index template settings into OpenSearch [$response]"
        exit 1
    else
        log_info "Infrastructure index template settings loaded into OpenSearch [$response]"
    fi
fi

# METALOGGING: Create index management policy object & link policy to index template
# ...index management policy automates the deletion of indexes after the specified time

OPS_LOG_RETENTION_PERIOD="${OPS_LOG_RETENTION_PERIOD:-1}"
set_retention_period viya_ops_idxmgmt_policy OPS_LOG_RETENTION_PERIOD
add_ism_template "viya_ops_idxmgmt_policy" "viya_ops-*" 50

# Load template
response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$es_api_url/_template/viya-ops-template" -H 'Content-Type: application/json' -d @logging/opensearch/set_index_template_settings_ops.json --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
# request returns: {"acknowledged":true}

if [[ $response != 2* ]]; then
    log_error "There was an issue loading monitoring index template settings into OpenSearch [$response]"
    exit 1
else
    log_debug "Monitoring index template template settings loaded into OpenSearch [$response]"
fi
echo ""

# get Security API URL
get_sec_api_url

# create the all logs RBACs
add_notice "**OpenSearch/OSD Access Controls**"
LOGGING_DRIVER=true ./logging/bin/security_create_rbac.sh _all_ _all_

# Create the 'logadm' OS/OSD user who can access all logs
LOG_CREATE_LOGADM_USER=${LOG_CREATE_LOGADM_USER:-true}
if [ "$LOG_CREATE_LOGADM_USER" == "true" ]; then

    if user_exists logadm; then
        log_warn "A user 'logadm' already exists; leaving that user as-is.  Review its definition in OpenSearch Dashboards and update it, or create another user, as needed."
    else
        log_debug "Creating the 'logadm' user"

        LOG_LOGADM_PASSWD=${LOG_LOGADM_PASSWD:-$ES_ADMIN_PASSWD}
        if [ -z "$LOG_LOGADM_PASSWD" ]; then
            log_debug "Creating a random password for the 'logadm' user"
            LOG_LOGADM_PASSWD="$(randomPassword)"
            add_notice ""
            add_notice "**The OpenSearch 'logadm' Account**"
            add_notice "Generated 'logadm' password: $LOG_LOGADM_PASSWD"
        fi

        #create the user
        LOGGING_DRIVER=true ./logging/bin/user.sh CREATE -ns _all_ -t _all_ -u logadm -p "$LOG_LOGADM_PASSWD"
    fi
else
    log_debug "Skipping creation of 'logadm' user because LOG_CREATE_LOGADM_USER not 'true' [$LOG_CREATE_LOGADM_USER]"
fi

#Initialize OSD Reporting Plugin indices
INIT_OSD_RPT_IDX=${INIT_OSD_RPT_IDX:-true}
if [ "$INIT_OSD_RPT_IDX" == "true" ]; then
    log_debug "Initializing OpenSearch Dashboards Reporting plugin indices"
    response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "$es_api_url/_plugins/_reports/instances" --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
    log_debug "OSD_RPT_IDX (instances) Response [$response]"
    response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "$es_api_url/_plugins/_reports/definitions" --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)
    log_debug "OSD_RPT_IDX (definitions) Response [$response]"
fi

LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
    echo ""
    display_notices
    echo ""
fi

log_info "Content has been loaded into OpenSearch"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
