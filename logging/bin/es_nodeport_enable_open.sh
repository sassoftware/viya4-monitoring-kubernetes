#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

# Confirm NOT on OpenShift
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should NOT be run on OpenShift clusters"
    log_error "Run 'logging/bin/create_openshift_route.sh ELASTICSEARCH' instead"
    exit 1
  fi
fi

set -e

# set env var with desired port
# default value returns random available port
export ES_PORT="${ES_PORT:-0}"

# set env var with service name
#export SVC=elasticsearch-master
export SVC=v4m-es-client-service

if [ "$ES_PORT" != "0" ]; then
   log_info "Making Elasticsearch instance [$SVC] in [$LOG_NS] namespace available on port [$ES_PORT]"
   echo
fi

# set env var to a node in cluster
export NODE_NAME=$(kubectl get nodes | awk 'NR==2 { print $1 }')

# Change port to a "NodePort"
kubectl -n "$LOG_NS" patch svc "$SVC" --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"},{"op":"replace","path":"/spec/ports/0/nodePort","value":'${ES_PORT}'}]'

# Determine which port was ultimately used
ACTUAL_ES_PORT=$(kubectl -n $LOG_NS get service v4m-es-client-service -o=jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
log_debug "ES NodePort enabled on [$ACTUAL_ES_PORT]"

# Print URL to access Elasticsearch
SHOW_ES_URL="${SHOW_ES_URL:-true}"
if [ "$SHOW_ES_URL" == "true" ]; then
   bin/show_app_url.sh ELASTICSEARCH
fi

