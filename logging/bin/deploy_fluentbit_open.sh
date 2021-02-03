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

# check for pre-reqs

# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "Namespace [$LOG_NS] does NOT exist."
  exit 1
fi

# get credentials
get_credentials_from_secret logcollector
rc=$?
if [ "$rc" != "0" ] ;then log_info "RC=$rc"; exit $rc;fi


HELM_DEBUG="${HELM_DEBUG:-false}"
if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi


helmRepoAdd fluent https://fluent.github.io/helm-charts
#log_info "Updating helm repositories..."
#helm repo update


helm2ReleaseCheck fb-$LOG_NS

# Check for an existing Helm release of stable/fluent-bit
if helm3ReleaseExists fb $LOG_NS; then
   log_info "Removing an existing release of deprecated stable/fluent-bit Helm chart from from the [$LOG_NS] namespace [$(date)]"
   helm  $helmDebug  delete -n $LOG_NS fb

   add_notice ""
   add_notice "================================================================================"
   add_notice "==                                                                            =="
   add_notice "== If you have deployed the metric monitoring components of Viya 4 Monitoring =="
   add_notice "== for Kubernetes, you *MAY* need to deploy an updated serviceMonitor to      =="
   add_notice "== collect metrics from Fluent Bit after this update.                         =="
   add_notice "==                                                                            =="
   add_notice "== Review the 'Logging - Fluent Bit' dashboard within Grafana to determine    =="
   add_notice "== if metrics are still being collected.  If metrics are NOT being collected, =="
   add_notice "== you should update your ServiceMonitors by running the following command:   =="
   add_notice "==                                                                            =="
   add_notice "==            monitoring/bin/deploy_monitoring_cluster.sh                     =="
   add_notice "==                                                                            =="
   add_notice "================================================================================"
   add_notice ""
   serviceMonitorNotice=true
else
  log_debug "No existing release of the deprecated stable/fluent-bit Helm chart was found"
   serviceMonitorNotice=false
fi

log_info "Deploying Fluent Bit"


# Fluent Bit user customizations
FB_OPEN_USER_YAML="${FB_OPEN_USER_YAML:-$USER_DIR/logging/user-values-fluent-bit-open.yaml}"
if [ ! -f "$FB_OPEN_USER_YAML" ]; then
  log_debug "[$FB_OPEN_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  FB_OPEN_USER_YAML=$TMP_DIR/empty.yaml
fi

if [ -f "$USER_DIR/logging/fluent-bit_config.configmap_open.yaml" ]; then
   # use copy in USER_DIR
   FB_CONFIGMAP="$USER_DIR/logging/fluent-bit_config.configmap_open.yaml"
else
   # use copy in repo
   FB_CONFIGMAP="logging/fb/fluent-bit_config.configmap_open.yaml"
fi
log_info "Using FB ConfigMap:" $FB_CONFIGMAP


# Create ConfigMap containing Fluent Bit configuration
kubectl -n $LOG_NS apply -f $FB_CONFIGMAP

# Create ConfigMap containing Viya-customized parsers (delete it first)
kubectl -n $LOG_NS delete configmap fb-viya-parsers --ignore-not-found
kubectl -n $LOG_NS create configmap fb-viya-parsers  --from-file=logging/fb/viya-parsers.conf

# Delete any existing Fluent Bit pods in the $LOG_NS namepace (otherwise Helm chart may assume an upgrade w/o reloading updated config
kubectl -n $LOG_NS delete pods -l "app=fluent-bit, fbout=es"

# Deploy Fluent Bit via Helm chart
helm $helmDebug upgrade --install --namespace $LOG_NS v4m-fb --values logging/fb/fluent-bit_helm_values_open.yaml --values $FB_OPEN_USER_YAML  --set fullnameOverride=v4m-fb fluent/fluent-bit

if [ "$serviceMonitorNotice" == "true" ]; then
   LOGGING_DRIVER=${LOGGING_DRIVER:-false}
   if [ "$LOGGING_DRIVER" != "true" ]; then
      echo ""
      display_notices
      echo ""
   fi
fi

log_info "Fluent Bit deployment completed"


log_debug "Script [$this_script] has completed [$(date)]"
echo ""

