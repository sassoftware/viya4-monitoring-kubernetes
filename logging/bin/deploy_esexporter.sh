#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source logging/bin/secrets-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

ELASTICSEARCH_EXPORTER_ENABLED=${ELASTICSEARCH_EXPORTER_ENABLED:-true}

if [ "$ELASTICSEARCH_EXPORTER_ENABLED" != "true" ]; then
  log_warn "Environment variable [ELASTICSEARCH_EXPORTER_ENABLED] is not set to 'true'; exiting WITHOUT deploying Elasticsearch Exporter"
  exit
fi

set -e

# check for pre-reqs

# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "Namespace [$LOG_NS] does NOT exist."
  exit 98
fi

# get credentials
get_credentials_from_secret metricgetter
rc=$?
if [ "$rc" != "0" ] ;then log_info "RC=$rc"; exit $rc;fi


# enable debug on Helm via env var
export HELM_DEBUG="${HELM_DEBUG:-false}"

if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

helmRepoAdd stable https://charts.helm.sh/stable
log_info "Updating helm repositories..."
helm repo update

# Load any user customizations/overrides
ES_OPEN_EXPORTER_USER_YAML="${ES_OPEN_EXPORTER_USER_YAML:-$USER_DIR/logging/user-values-es-exporter.yaml}"
if [ ! -f "$ES_OPEN_EXPORTER_USER_YAML" ]; then
  log_debug "[$ES_OPEN_EXPORTER_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  ES_OPEN_EXPORTER_USER_YAML=$TMP_DIR/empty.yaml
fi


# Enable workload node placement?
LOG_NODE_PLACEMENT_ENABLE=${LOG_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}

# Optional workload node placement support
if [ "$LOG_NODE_PLACEMENT_ENABLE" == "true" ]; then
  log_info "Enabling elasticsearch exporter for workload node placement"
  wnpValuesFile="logging/node-placement/values-elasticsearch-exporter-wnp.yaml"
else
  log_debug "Workload node placement support is disabled for the elasticsearch exporter"
  wnpValuesFile="$TMP_DIR/empty.yaml"
fi


log_info "Deploying Elasticsearch metric exporter"

# Elasticsearch metric exporter
helm2ReleaseCheck es-exporter-$LOG_NS

helm $helmDebug upgrade --install es-exporter \
 --namespace $LOG_NS \
 -f logging/es/odfe/values-es-exporter_open.yaml \
 -f $wnpValuesFile \
 -f $ES_OPEN_EXPORTER_USER_YAML \
 stable/elasticsearch-exporter

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
