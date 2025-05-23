#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1

source logging/bin/common.sh
source logging/bin/secrets-include.sh
source bin/service-url-include.sh
source logging/bin/apiaccess-include.sh
source logging/bin/rbac-include.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

KIBANA_CONTENT_DEPLOY=${KIBANA_CONTENT_DEPLOY:-${ELASTICSEARCH_ENABLE:-true}}

if [ "$KIBANA_CONTENT_DEPLOY" != "true" ]; then
    log_verbose "Environment variable [KIBANA_CONTENT_DEPLOY] is not set to 'true'; exiting WITHOUT deploying content into OpenSearch Dashboards"
    exit 0
fi

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

set -e

log_info "Configuring OpenSearch Dashboards...this may take a few minutes"

# wait for pod to show as "running" and "ready"
log_info "Waiting for OpenSearch Dashboards pods to be ready ($(date) - timeout 10m)"
osdlabels="$(kubectl -n "$LOG_NS" get deployment v4m-osd -o=jsonpath='{.spec.selector.matchLabels}' | tr -d '{}"' | tr : '=')"

kubectl -n "$LOG_NS" wait pods --selector "$osdlabels" --for condition=Ready --timeout=10m

set +e # disable exit on error

# Need to wait 2-3 minutes for OSD to come up and
# and be ready to accept the curl commands below
# Confirm OSD is ready
log_info "Waiting (up to more 8 minutes) for OpenSearch Dashboards API endpoint to be ready"
for pause in 30 30 60 30 30 30 30 30 30 60 60 60; do

    get_kb_api_url
    response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "${kb_api_url}/api/status" --user "$ES_ADMIN_USER":"$ES_ADMIN_PASSWD" --insecure)

    # returns 503 (and outputs "Kibana server is not ready yet") when Kibana isn't ready yet
    # TO DO: check for 503 specifically?
    rc=$?
    if [[ $response != 2* ]]; then
        log_debug "The OpenSearch Dashboards REST endpoint does not appear to be quite ready [$response/$rc]; sleeping for [$pause] more seconds before checking again."
        stop_kb_portforwarding
        sleep ${pause}
    else
        log_verbose "The OpenSearch Dashboards REST endpoint appears to be ready...continuing"
        kibanaready="TRUE"
        break
    fi
done

set -e

if [ "$kibanaready" != "TRUE" ]; then
    log_error "The OpenSearch Dashboards REST endpoint has NOT become accessible in the expected time; exiting."
    log_error "Review the OpenSearch Dashboards pod's events and log to identify the issue and resolve it before trying again."
    exit 1
fi

set +e # disable exit on error

# get Security API URL
get_sec_api_url

# Create cluster_admins OSD tenant space (if it doesn't exist)
#   Should only be true during UIP scenario b/c our updated securityconfig processing
#   is bypassed (to prevent clobbering post-deployment changes made via OSD).
if ! kibana_tenant_exists "cluster_admins"; then
    create_kibana_tenant "cluster_admins" "Tenant space for Cluster Administrators"
    rc=$?
    if [ "$rc" != "0" ]; then
        log_error "Problems were encountered while attempting to create tenant space [cluster_admins]."
        exit 1
    fi
else
    log_debug "The OpenSearch Dashboards tenant space [cluster_admins] exists."
fi

# Import OSD Searches, Visualizations and Dashboard Objects using curl
# shfmt: ignoring suggested reformat to maintain readability
./logging/bin/import_osd_content.sh logging/osd/common          cluster_admins
./logging/bin/import_osd_content.sh logging/osd/cluster_admins  cluster_admins
./logging/bin/import_osd_content.sh logging/osd/namespace       cluster_admins
./logging/bin/import_osd_content.sh logging/osd/tenant          cluster_admins

log_info "Configuring OpenSearch Dashboards has been completed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
