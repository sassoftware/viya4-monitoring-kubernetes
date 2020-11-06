#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

set -e

HELM_DEBUG="${HELM_DEBUG:-false}"

# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "The specified namespace [$LOG_NS] does not exist."
  exit 9
fi


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
      exit 88
   fi
else
   log_info "Obtaining connection information from existing secret [$LOG_NS/connection-info-azmonitor]"
   export AZMONITOR_CUSTOMER_ID=$(kubectl -n $LOG_NS get secret connection-info-azmonitor -o=jsonpath="{.data.customer_id}" |base64 --decode)
   export AZMONITOR_SHARED_KEY=$(kubectl -n $LOG_NS get secret connection-info-azmonitor -o=jsonpath="{.data.shared_key}" |base64 --decode)
fi


# Fluent Bit
# Create ConfigMap containing Fluent Bit configuration
kubectl -n $LOG_NS apply -f $FB_CONFIGMAP

# Create ConfigMap containing Viya-customized parsers (delete it first)
kubectl -n $LOG_NS delete configmap fbaz-viya-parsers --ignore-not-found
kubectl -n $LOG_NS create configmap fbaz-viya-parsers  --from-file=logging/fb/viya-parsers.conf

# Delete any existing Fluent Bit pods in the $LOG_NS namepace (otherwise Helm chart may assume an upgrade w/o reloading updated config
kubectl -n $LOG_NS delete pods -l "app=fluent-bit, fbout=azuremonitor"

# Deploy Fluent Bit via Helm chart
if [ "$HELM_VER_MAJOR" == "3" ]; then
   helm2ReleaseCheck fb-$LOG_NS
   helm $helmDebug upgrade --install fbaz         --namespace $LOG_NS --values logging/fb/fluent-bit_helm_values_azmonitor.yaml --values $FB_AZMONITOR_USER_YAML  --set fullnameOverride=v4m-fbaz stable/fluent-bit
else
   helm3ReleaseCheck fb $LOG_NS
   helm $helmDebug upgrade --install fbaz-$LOG_NS --namespace $LOG_NS --values logging/fb/fluent-bit_helm_values_azmonitor.yaml   --values $FB_AZMONITOR_USER_YAML --set fullnameOverride=v4m-fbaz stable/fluent-bit
fi

log_info "Fluent Bit deployment completed"
