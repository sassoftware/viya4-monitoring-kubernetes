#! /bin/bash

# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source logging/bin/secrets-include.sh
source bin/tls-include.sh
source logging/bin/apiaccess-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

OPENSEARCHDASH_ENABLE=${OPENSEARCHDASH_ENABLE:-true}

if [ "$OPENSEARCHDASH_ENABLE" != "true" ]; then
  log_verbose "Environment variable [OPENSEARCHDASH_ENABLE] is not set to 'true'; exiting WITHOUT deploying OpenSearch Dashboards"
  exit 0
fi

set -e

#
# check for pre-reqs
#

# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "Namespace [$LOG_NS] does NOT exist."
  exit 1
fi

# get credentials
export ES_KIBANASERVER_PASSWD=${ES_KIBANASERVER_PASSWD}

# Create secrets containing internal user credentials
create_user_secret internal-user-kibanaserver kibanaserver "$ES_KIBANASERVER_PASSWD"  managed-by=v4m-es-script

# Verify cert-manager is available (if necessary)
if verify_cert_manager $LOG_NS kibana; then
  log_debug "cert-manager check OK"
else
  log_error "One or more required TLS certs do not exist and cert-manager is not available to create the missing certs"
  exit 1
fi

# Create/Get necessary TLS certs
apps=( kibana )
create_tls_certs $LOG_NS logging ${apps[@]}


# Need to retrieve these from secrets in case secrets pre-existed
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)


# enable debug on Helm via env var
export HELM_DEBUG="${HELM_DEBUG:-false}"

if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

helmRepoAdd opensearch  https://opensearch-project.github.io/helm-charts
log_verbose "Updating Helm repositories"
helm repo update


KB_KNOWN_NODEPORT_ENABLE=${KB_KNOWN_NODEPORT_ENABLE:-false}

if [ "$KB_KNOWN_NODEPORT_ENABLE" == "true" ]; then
   KIBANA_PORT=31034
   log_verbose "Setting Kibana service NodePort to $KIBANA_PORT"
   nodeport_yaml=logging/opensearch/osd_helm_values_nodeport.yaml
else
   nodeport_yaml=$TMP_DIR/empty.yaml
   log_debug "Kibana service NodePort NOT changed to 'known' port because KB_KNOWN_NODEPORT_ENABLE set to [$KB_KNOWN_NODEPORT_ENABLE]."
fi


# OpenSearch Dashboards user customizations
OSD_USER_YAML="${OSD_USER_YAML:-$USER_DIR/logging/user-values-osd.yaml}"
if [ ! -f "$OSD_USER_YAML" ]; then
  log_debug "[$OSD_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  OSD_USER_YAML=$TMP_DIR/empty.yaml
fi

# Require TLS into OpenSearch Dashboards (nee Kibana)?
LOG_KB_TLS_ENABLE=${LOG_KB_TLS_ENABLE:-false}

# Enable TLS for East/West Kibana traffic (inc. requiring HTTPS from browser if using NodePorts)
if [ "$LOG_KB_TLS_ENABLE" == "true" ]; then
   # w/TLS: use HTTPS in curl commands
   KB_CURL_PROTOCOL=https
   log_debug "TLS enabled for Kibana"
else
   # w/o TLS: use HTTP in curl commands
   KB_CURL_PROTOCOL=http
   log_debug "TLS not enabled for Kibana"
fi
#(Re)Create secret containing OSD TLS Setting
kubectl -n $LOG_NS delete secret          v4m-osd-tls-enabled  --ignore-not-found
kubectl -n $LOG_NS create secret generic  v4m-osd-tls-enabled  --from-literal enable_tls="$LOG_KB_TLS_ENABLE"

# OpenSearch Dashboards
log_info "Deploying OpenSearch Dashboards"

# Enable workload node placement?
LOG_NODE_PLACEMENT_ENABLE=${LOG_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}

# Optional workload node placement support
if [ "$LOG_NODE_PLACEMENT_ENABLE" == "true" ]; then
  log_verbose "Enabling OpenSearch Dashboards for workload node placement"
  wnpValuesFile="logging/node-placement/values-osd-wnp.yaml"
else
  log_debug "Workload node placement support is disabled for OpenSearch Dashboards"
  wnpValuesFile="$TMP_DIR/empty.yaml"
fi

#11FEB22 TODO: OpenShift
OSD_PATH_INGRESS_YAML=$TMP_DIR/empty.yaml
if [ "$OPENSHIFT_CLUSTER:$OPENSHIFT_PATH_ROUTES" == "true:true" ]; then
    OSD_PATH_INGRESS_YAML=logging/openshift/values-osd-path-route-openshift.yaml
fi


OPENSHIFT_SPECIFIC_YAML=$TMP_DIR/empty.yaml
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    OPENSHIFT_SPECIFIC_YAML=logging/openshift/values-osd-openshift.yaml
fi


# Deploy Elasticsearch via Helm chart
helm $helmDebug upgrade --install v4m-osd \
    --namespace $LOG_NS \
    --values logging/opensearch/osd_helm_values.yaml \
    --values "$wnpValuesFile" \
    --values "$nodeport_yaml" \
    --values "$OSD_USER_YAML" \
    --values "$OPENSHIFT_SPECIFIC_YAML" \
    --values "$OSD_PATH_INGRESS_YAML" \
    --set fullnameOverride=v4m-osd opensearch/opensearch-dashboards

log_info "OpenSearch Dashboards has been deployed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
