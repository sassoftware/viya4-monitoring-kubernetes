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

#Fail if not using OpenSearch back-end
require_opensearch

#Generate yaml file with all container-related keys
generateImageKeysFile "$OSD_FULL_IMAGE"         "logging/opensearch/osd_container_image.template"


# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "Namespace [$LOG_NS] does NOT exist."
  exit 1
fi

# get credentials
export ES_KIBANASERVER_PASSWD=${ES_KIBANASERVER_PASSWD}

# Create secrets containing internal user credentials
create_user_secret internal-user-kibanaserver kibanaserver "$ES_KIBANASERVER_PASSWD"  managed-by=v4m-es-script

# Verify cert generator is available (if necessary)
if verify_cert_generator $LOG_NS kibana; then
  log_debug "cert generator check OK [$cert_generator_ok]"
else
  log_error "A required TLS cert does not exist and the expected certificate generator mechanism [$cert_generator] is not available to create the missing cert"
  exit 1
fi

# Create/Get necessary TLS certs
create_tls_certs $LOG_NS logging kibana


# enable debug on Helm via env var
export HELM_DEBUG="${HELM_DEBUG:-false}"

if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

helmRepoAdd opensearch  https://opensearch-project.github.io/helm-charts

KB_KNOWN_NODEPORT_ENABLE=${KB_KNOWN_NODEPORT_ENABLE:-false}

if [ "$KB_KNOWN_NODEPORT_ENABLE" == "true" ]; then
   KIBANA_PORT=31033
   log_verbose "Setting OpenSearch Dashboards service NodePort to $KIBANA_PORT"
   nodeport_yaml=logging/opensearch/osd_helm_values_nodeport.yaml
else
   nodeport_yaml=$TMP_DIR/empty.yaml
   log_debug "OpenSearch Dashboards service NodePort NOT changed to 'known' port because KB_KNOWN_NODEPORT_ENABLE set to [$KB_KNOWN_NODEPORT_ENABLE]."
fi


# OpenSearch Dashboards user customizations
OSD_USER_YAML="${OSD_USER_YAML:-$USER_DIR/logging/user-values-osd.yaml}"
if [ ! -f "$OSD_USER_YAML" ]; then
  log_debug "[$OSD_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  OSD_USER_YAML=$TMP_DIR/empty.yaml
fi

# Require TLS into OpenSearch Dashboards (nee Kibana)?
OSD_TLS_ENABLE=${OSD_TLS_ENABLE:-$TLS_ENABLE}
if [ -z "$OSD_TLS_ENABLE" ]; then
   #set to 'true' if still not set
   OSD_TLS_ENABLE="true"
fi

#(Re)Create secret containing OSD TLS Setting
kubectl -n $LOG_NS delete secret          v4m-osd-tls-enabled  --ignore-not-found
kubectl -n $LOG_NS create secret generic  v4m-osd-tls-enabled  --from-literal enable_tls="$OSD_TLS_ENABLE"

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

OSD_PATH_INGRESS_YAML=$TMP_DIR/empty.yaml
if [ "$OPENSHIFT_CLUSTER:$OPENSHIFT_PATH_ROUTES" == "true:true" ]; then
    OSD_PATH_INGRESS_YAML=logging/openshift/values-osd-path-route-openshift.yaml
fi


OPENSHIFT_SPECIFIC_YAML=$TMP_DIR/empty.yaml
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    OPENSHIFT_SPECIFIC_YAML=logging/openshift/values-osd-openshift.yaml
fi

# Get Helm Chart Name
log_debug "OpenSearch Dashboards Helm Chart: repo [$OSD_HELM_CHART_REPO] name [$OSD_HELM_CHART_NAME] version [$OSD_HELM_CHART_VERSION]"
chart2install="$(get_helmchart_reference $OSD_HELM_CHART_REPO $OSD_HELM_CHART_NAME $OSD_HELM_CHART_VERSION)"
versionstring="$(get_helm_versionstring  $OSD_HELM_CHART_VERSION)"

log_debug "Installing Helm chart from artifact [$chart2install]"

# Deploy Elasticsearch via Helm chart
helm $helmDebug upgrade --install v4m-osd \
    $versionstring \
    --namespace $LOG_NS \
    --values "$imageKeysFile" \
    --values logging/opensearch/osd_helm_values.yaml \
    --values "$wnpValuesFile" \
    --values "$nodeport_yaml" \
    --values "$OSD_USER_YAML" \
    --values "$OPENSHIFT_SPECIFIC_YAML" \
    --values "$OSD_PATH_INGRESS_YAML" \
    --set fullnameOverride=v4m-osd \
   $chart2install

log_info "OpenSearch Dashboards has been deployed"


#Container Security: Disable serviceAccount Token Automounting
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
   disable_sa_token_automount $LOG_NS v4m-os
else
   disable_sa_token_automount $LOG_NS v4m-osd-dashboards
fi

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
