#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

source logging/bin/common.sh

HELM_DEBUG="${HELM_DEBUG:-false}"
NGINX_NS="${NGINX_NS:-ingress-nginx}"

# Fluent Bit user customizations
FB_OPEN_USER_YAML="${FB_OPEN_USER_YAML:-logging/user-values-fluent-bit-open.yaml}"

# Fluent Bit

# Create ConfigMap containing Fluent Bit configuration
kubectl -n $LOG_NS apply -f logging/fb/fluent-bit_config.configmap_open.yaml

# Create ConfigMap containing Viya-customized parsers (delete it first)
kubectl -n $LOG_NS delete configmap fb-viya-parsers --ignore-not-found
kubectl -n $LOG_NS create configmap fb-viya-parsers  --from-file=logging/fb/viya-parsers.conf

# Annotate cluster-level pods with parser suggestions
kubectl -n kube-system annotate pod -l "component=etcd" fluentbit.io/parser=etcd --overwrite

# Handle NGINX
set +e
kubectl get ns $NGINX_NS &>/dev/null
if [ $? == 0 ]; then
  nginxFound=true
fi
set -e

if [ "$nginxFound" == "true" ]; then
  echo "NGINX found; will attempt to annotating pod with parser suggestion..."
  kubectl -n $NGINX_NS  annotate pod -l "app.kubernetes.io/name=ingress-nginx" fluentbit.io/parser=nginx-ingress --overwrite
fi

# Delete any existing Fluent Bit pods in the $LOG_NS namepace (otherwise Helm chart may assume an upgrade w/o reloading updated config
kubectl -n $LOG_NS delete pods -l "app=fluent-bit"

# Deploy Fluent Bit via Helm chart
if [ "$HELM_VER_MAJOR" == "3" ]; then
   helm $helmDebug upgrade --install --namespace $LOG_NS fb --values logging/fb/fluent-bit_helm_values_open.yaml --values $FB_OPEN_USER_YAML  --set fullnameOverride=v4m-fb stable/fluent-bit
else
   helm $helmDebug upgrade --install fb-$LOG_NS --namespace $LOG_NS --values logging/fb/fluent-bit_helm_values_open.yaml   --values $FB_OPEN_USER_YAML --set fullnameOverride=v4m-fb stable/fluent-bit
fi
