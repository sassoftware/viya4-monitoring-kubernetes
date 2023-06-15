#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source logging/bin/secrets-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

# Enable Fluent Bit?
FLUENT_BIT_ENABLED=${FLUENT_BIT_ENABLED:-true}

if [ "$FLUENT_BIT_ENABLED" != "true" ]; then
   log_info "Environment variable [FLUENT_BIT_ENABLED] is not set to 'true'; existing WITHOUT deploying Fluent Bit"
   exit
fi

set -e

#Fail if not using OpenSearch back-end
require_opensearch

log_info "Deploying Fluent Bit ..."

# check for pre-reqs
# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "Namespace [$LOG_NS] does NOT exist."
  exit 1
fi

# get credentials
get_credentials_from_secret logcollector
rc=$?
if [ "$rc" != "0" ] ;then log_debug "RC=$rc"; exit $rc;fi


HELM_DEBUG="${HELM_DEBUG:-false}"
if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi


helmRepoAdd fluent https://fluent.github.io/helm-charts
#log_verbose "Updating Helm repositories..."
#helm repo update


helm2ReleaseCheck fb-$LOG_NS

# Check for an existing Helm release of stable/fluent-bit
if helm3ReleaseExists fb $LOG_NS; then
   log_verbose "Removing an existing release of deprecated stable/fluent-bit Helm chart from from the [$LOG_NS] namespace [$(date)]"
   helm  $helmDebug  delete -n $LOG_NS fb

   if [ $(kubectl get servicemonitors -A |grep fluent-bit-v2 -c) -ge 1 ]; then
      log_debug "Updated serviceMonitor [fluent-bit-v2] appears to be deployed."
   elif [ $(kubectl get servicemonitors -A |grep fluent-bit -c) -ge 1 ]; then
      log_warn "You appear to have an obsolete service monitor in place for monitoring Fluent Bit."
      log_warn "Run monitoring/bin/deploy_monitoring_cluster.sh to deploy the current set of service monitors."
   fi
else
  log_debug "No existing release of the deprecated stable/fluent-bit Helm chart was found"
fi


# Fluent Bit user customizations
FB_OPENSEARCH_USER_YAML="${FB_OPENSEARCH_USER_YAML:-$USER_DIR/logging/user-values-fluent-bit-opensearch.yaml}"
if [ ! -f "$FB_OPENSEARCH_USER_YAML" ]; then
  log_debug "[$FB_OPENSEARCH_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  FB_OPENSEARCH_USER_YAML=$TMP_DIR/empty.yaml
fi


# Point to OpenShift response file or dummy as appropriate
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
  log_info "Deploying Fluent Bit on OpenShift cluster"
  openshiftValuesFile="logging/openshift/values-fluent-bit.yaml"
else
  log_debug "Fluent Bit is NOT being deployed on OpenShift cluster"
  openshiftValuesFile="$TMP_DIR/empty.yaml"
fi


if [ -f "$USER_DIR/logging/fluent-bit_config.configmap_opensearch.yaml" ]; then
   # use copy in USER_DIR
   FB_CONFIGMAP="$USER_DIR/logging/fluent-bit_config.configmap_opensearch.yaml"
else
   # use copy in repo
   FB_CONFIGMAP="logging/fb/fluent-bit_config.configmap_opensearch.yaml"


fi
log_debug "Using FB ConfigMap:" $FB_CONFIGMAP

# Multiline parser setup
LOG_MULTILINE_ENABLED=${LOG_MULTILINE_ENABLED}
if [ "$LOG_MULTILINE_ENABLED" == "true" ]; then
  LOG_MULTILINE_PARSER="docker, cri"
else
  LOG_MULTILINE_PARSER=""
fi

# Create ConfigMap containing Fluent Bit configuration
kubectl -n $LOG_NS apply -f $FB_CONFIGMAP

# Create ConfigMap containing Viya-customized parsers (delete it first)
kubectl -n $LOG_NS delete configmap fb-viya-parsers --ignore-not-found
kubectl -n $LOG_NS create configmap fb-viya-parsers  --from-file=logging/fb/viya-parsers.conf

# Check for Kubernetes container runtime log format info
KUBERNETES_RUNTIME_LOGFMT="${KUBERNETES_RUNTIME_LOGFMT}"
if [ -z "$KUBERNETES_RUNTIME_LOGFMT" ]; then
   somenode=$(kubectl get nodes | awk 'NR==2 { print $1 }')
   runtime=$(kubectl get node $somenode -o jsonpath={.status.nodeInfo.containerRuntimeVersion} | awk -F: '{print $1}')
   log_debug "Kubernetes container runtime [$runtime] found on node [$somenode]"
   case $runtime in
    docker)
      KUBERNETES_RUNTIME_LOGFMT="docker"
      ;;
    containerd|cri-o)
      KUBERNETES_RUNTIME_LOGFMT="criwithlog"
      ;;
    *)
      log_warn "Unrecognized Kubernetes container runtime [$runtime]; using default parser"
      KUBERNETES_RUNTIME_LOGFMT="docker"
      ;;
   esac
fi


# Create ConfigMap containing Kubernetes container runtime log format
kubectl -n $LOG_NS delete configmap fb-env-vars --ignore-not-found
kubectl -n $LOG_NS create configmap fb-env-vars \
                   --from-literal=KUBERNETES_RUNTIME_LOGFMT="$KUBERNETES_RUNTIME_LOGFMT" \
                   --from-literal=LOG_MULTILINE_PARSER="${LOG_MULTILINE_PARSER}"         \
                   --from-literal=SEARCH_SERVICENAME="${ES_SERVICENAME}"

kubectl -n $LOG_NS label configmap fb-env-vars   managed-by=v4m-es-script

#Pin to a specific Helm chart version
FLUENTBIT_HELM_CHART_VERSION=${FLUENTBIT_HELM_CHART_VERSION:-"0.30.4"}

# Deploy Fluent Bit via Helm chart
helm $helmDebug upgrade --install --namespace $LOG_NS v4m-fb  \
  --version $FLUENTBIT_HELM_CHART_VERSION \
  --values logging/fb/fluent-bit_helm_values_opensearch.yaml  \
  --values $openshiftValuesFile \
  --values $FB_OPENSEARCH_USER_YAML   \
  --set fullnameOverride=v4m-fb fluent/fluent-bit

#Container Security: Disable Token Automounting at ServiceAccount; enable for Pod
disable_sa_token_automount $LOG_NS v4m-fb
enable_pod_token_automount $LOG_NS daemonset v4m-fb

# Force restart of daemonset to ensure we pick up latest config changes
# since Helm won't notice if the only changes are in the configMap
kubectl -n "$LOG_NS" rollout restart daemonset v4m-fb

log_info "Fluent Bit deployment completed"


log_debug "Script [$this_script] has completed [$(date)]"
echo ""

