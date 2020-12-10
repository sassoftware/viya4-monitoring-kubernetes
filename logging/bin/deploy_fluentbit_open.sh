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

helm2ReleaseCheck fb-$LOG_NS


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
helm $helmDebug upgrade --install --namespace $LOG_NS fb --values logging/fb/fluent-bit_helm_values_open.yaml --values $FB_OPEN_USER_YAML  --set fullnameOverride=v4m-fb stable/fluent-bit

log_info "Fluent Bit deployment completed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""

