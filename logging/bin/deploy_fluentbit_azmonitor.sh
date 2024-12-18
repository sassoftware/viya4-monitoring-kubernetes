#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

# Enable Fluent Bit?
FLUENT_BIT_ENABLED=${FLUENT_BIT_ENABLED:-true}

if [ "$FLUENT_BIT_ENABLED" != "true" ]; then
   log_info "Environment variable [FLUENT_BIT_ENABLED] is not set to 'true'; existing WITHOUT deploying Fluent Bit"
   exit
fi


set -e

HELM_DEBUG="${HELM_DEBUG:-false}"
if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

helm2ReleaseCheck fb-$LOG_NS

helmRepoAdd fluent https://fluent.github.io/helm-charts

# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "The specified namespace [$LOG_NS] does not exist."
  exit 1
fi

log_info "Deploying Fluent Bit (Azure Monitor)"

#Generate yaml file with all container-related keys#Generate yaml file with all container-related keys
generateImageKeysFile "$FB_FULL_IMAGE"               "logging/fb/fb_container_image.template"
generateImageKeysFile "$FB_INITCONTAINER_FULL_IMAGE" "logging/fb/fb_initcontainer_image.template"

# Fluent Bit user customizations
FB_AZMONITOR_USER_YAML="${FB_AZMONITOR_USER_YAML:-$USER_DIR/logging/user-values-fluent-bit-azmonitor.yaml}"
if [ ! -f "$FB_AZMONITOR_USER_YAML" ]; then
  log_debug "[$FB_AZMONITOR_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  FB_AZMONITOR_USER_YAML=$TMP_DIR/empty.yaml
fi

if [ -f "$USER_DIR/logging/fluent-bit_config.configmap_azmonitor.yaml" ]; then
   # use copy in USER_DIR
   FB_CONFIGMAP="$USER_DIR/logging/fluent-bit_config.configmap_azmonitor.yaml"
else
   # use copy in repo
   FB_CONFIGMAP="logging/fb/fluent-bit_config.configmap_azmonitor.yaml"
fi
log_info "Using FB ConfigMap:" $FB_CONFIGMAP


# Check/Create Connection Info Secret
if [ "$(kubectl -n $LOG_NS get secret connection-info-azmonitor -o name 2>/dev/null)" == "" ]; then

   export AZMONITOR_CUSTOMER_ID="${AZMONITOR_CUSTOMER_ID:-NotProvided}"
   export AZMONITOR_SHARED_KEY="${AZMONITOR_SHARED_KEY:-NotProvided}"

   if [ "$AZMONITOR_CUSTOMER_ID" != "NotProvided"  ] && [ "$AZMONITOR_SHARED_KEY" != "NotProvided" ]; then
      log_info "Creating secret [connection-info-azmonitor] in [$LOG_NS] namespace to hold Azure connection information."
      kubectl -n $LOG_NS create secret generic connection-info-azmonitor --from-literal=customer_id=$AZMONITOR_CUSTOMER_ID --from-literal=shared_key=$AZMONITOR_SHARED_KEY
   else
      log_error "Unable to create secret [$LOG_NS/connection-info-azmonitor] because missing required information: [AZMONITOR_CUSTOMER_ID: $AZMONITOR_CUSTOMER_ID ; AZMONITOR_SHARED_KEY: $AZMONITOR_SHARED_KEY]."
      log_error "You must provide this information via environment variables or create the secret [connection-info-azmonitor] before running this script."
      exit 1
   fi
else
   log_info "Obtaining connection information from existing secret [$LOG_NS/connection-info-azmonitor]"
   export AZMONITOR_CUSTOMER_ID=$(kubectl -n $LOG_NS get secret connection-info-azmonitor -o=jsonpath="{.data.customer_id}" |base64 --decode)
   export AZMONITOR_SHARED_KEY=$(kubectl -n $LOG_NS get secret connection-info-azmonitor -o=jsonpath="{.data.shared_key}" |base64 --decode)
fi

# Check for an existing Helm release of stable/fluent-bit
if helm3ReleaseExists fbaz $LOG_NS; then
   log_info "Removing an existing release of deprecated stable/fluent-bit Helm chart from from the [$LOG_NS] namespace [$(date)]"
   helm  $helmDebug  delete -n $LOG_NS fbaz

   if [ $(kubectl get servicemonitors -A |grep fluent-bit-v2 -c) -ge 1 ]; then
      log_debug "Updated serviceMonitor [fluent-bit-v2] appears to be deployed."
   elif [ $(kubectl get servicemonitors -A |grep fluent-bit -c) -ge 1 ]; then
      log_warn "You appear to have an obsolete service monitor in place for monitoring Fluent Bit."
      log_warn "Run monitoring/bin/deploy_monitoring_cluster.sh to deploy the current set of service monitors."
   fi
else
   log_debug "No existing release of the deprecated stable/fluent-bit Helm chart was found"
fi

# Multiline parser setup
LOG_MULTILINE_ENABLED="${LOG_MULTILINE_ENABLED:-true}"
if [ "$LOG_MULTILINE_ENABLED" == "true" ]; then
  LOG_MULTILINE_PARSER="docker, cri"
else
  LOG_MULTILINE_PARSER=""
fi

# Create ConfigMap containing Fluent Bit configuration
kubectl -n $LOG_NS apply -f $FB_CONFIGMAP

# Create ConfigMap containing Viya-customized parsers (delete it first)
kubectl -n $LOG_NS delete configmap fbaz-viya-parsers --ignore-not-found
kubectl -n $LOG_NS create configmap fbaz-viya-parsers  --from-file=logging/fb/viya-parsers.conf

TRACING_ENABLE="${TRACING_ENABLE:-false}"
if [ "$TRACING_ENABLE" == "true" ]; then
  # Create ConfigMap containing tracing config
  kubectl -n "$LOG_NS" delete configmap fbaz-viya-tracing --ignore-not-found
  kubectl -n "$LOG_NS" create configmap fbaz-viya-tracing  --from-file=logging/fb/viya-tracing.conf

  tracingValuesFile="logging/fb/fluent-bit_helm_values_tracing.yaml"
else 
  # Create empty ConfigMap for tracing since it is expected to exist in main config
  kubectl -n "$LOG_NS" delete configmap fbaz-viya-tracing --ignore-not-found
  kubectl -n "$LOG_NS" create configmap fbaz-viya-tracing  --from-file="$TMP_DIR"/empty.yaml

  tracingValuesFile=$TMP_DIR/empty.yaml
fi

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

MON_NS="${MON_NS:-monitoring}"

# Create ConfigMap containing Kubernetes container runtime log format
kubectl -n $LOG_NS delete configmap fbaz-env-vars --ignore-not-found
kubectl -n $LOG_NS create configmap fbaz-env-vars \
                   --from-literal=KUBERNETES_RUNTIME_LOGFMT=$KUBERNETES_RUNTIME_LOGFMT \
                   --from-literal=LOG_MULTILINE_PARSER="${LOG_MULTILINE_PARSER}" \
                   --from-literal=MON_NS="${MON_NS}"

kubectl -n $LOG_NS label configmap fbaz-env-vars   managed-by=v4m-es-script

# Check to see if we are upgrading from earlier version requiring root access
if [ "$( kubectl -n $LOG_NS get configmap fbaz-dbmigrate-script -o name --ignore-not-found)" != "configmap/fbaz-dbmigrate-script" ]; then
   log_debug "Removing FB pods (if they exist) to allow migration."
   kubectl -n "$LOG_NS" delete daemonset v4m-fbaz --ignore-not-found
fi

# Create ConfigMap containing Fluent Bit database migration script
kubectl -n $LOG_NS delete configmap fbaz-dbmigrate-script --ignore-not-found
kubectl -n $LOG_NS create configmap fbaz-dbmigrate-script --from-file logging/fb/migrate_fbstate_db.sh
kubectl -n $LOG_NS label  configmap fbaz-dbmigrate-script managed-by=v4m-es-script


 ## Get Helm Chart Name
 log_debug "Fluent Bit Helm Chart: repo [$FLUENTBIT_HELM_CHART_REPO] name [$FLUENTBIT_HELM_CHART_NAME] version [$FLUENTBIT_HELM_CHART_VERSION]"
 chart2install="$(get_helmchart_reference $FLUENTBIT_HELM_CHART_REPO $FLUENTBIT_HELM_CHART_NAME $FLUENTBIT_HELM_CHART_VERSION)"
 versionstring="$(get_helm_versionstring  $FLUENTBIT_HELM_CHART_VERSION)"
 log_debug "Installing Helm chart from artifact [$chart2install]"

# Deploy Fluent Bit via Helm chart
helm $helmDebug upgrade --install v4m-fbaz  --namespace $LOG_NS  \
  $versionstring \
  --values $imageKeysFile \
  --values logging/fb/fluent-bit_helm_values_azmonitor.yaml \
  --values $FB_AZMONITOR_USER_YAML \
  --values $tracingValuesFile \
  --set fullnameOverride=v4m-fbaz \
  $chart2install

#pause to allow migration script to complete (if necessary)
sleep 20

#Container Security: Disable Token Automounting at ServiceAccount; enable for Pod
disable_sa_token_automount $LOG_NS v4m-fbaz
# FB pods will restart after following call if automount is not already enabled
enable_pod_token_automount $LOG_NS daemonset v4m-fbaz

# Force restart of daemonset to ensure we pick up latest config changes
# since Helm won't notice if the only changes are in the configMap
kubectl -n "$LOG_NS" rollout restart daemonset v4m-fbaz

log_info "Fluent Bit deployment (Azure Monitor) completed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
