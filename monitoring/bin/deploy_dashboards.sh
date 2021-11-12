#!/bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh

set -e

DASH_NS="${DASH_NS:-$MON_NS}"

WELCOME_DASH="${WELCOME_DASH:-true}"
KUBE_DASH="${KUBE_DASH:-true}"
VIYA_DASH="${VIYA_DASH:-true}"
PGMONITOR_DASH="${PGMONITOR_DASH:-$VIYA_DASH}"
RABBITMQ_DASH="${RABBITMQ_DASH:-$VIYA_DASH}"
NGINX_DASH="${NGINX_DASH:-true}"
LOGGING_DASH="${LOGGING_DASH:-true}"
ISTIO_DASH="${ISTIO_DASH:-${ISTIO_ENABLED:-false}}"
USER_DASH="${USER_DASH:-true}"
TEST_DASH="${TEST_DASH:-false}"

DASH_BASE="${DASH_BASE:-monitoring/dashboards}"

function deploy_dashboards {
   type=$1
   if [ -z "$2" ]; then
     dir=$"$DASH_BASE/$type"
   else
     dir=$2
   fi
   
   for f in $dir/*.json; do
     # Need to check existence because if there are no matching files,
     # f will include the wildcard character (*)
     if [ -f "$f" ]; then
       log_debug "Deploying dashboard from file [$f]"
       name=$(basename $f .json)
       
       kubectl create cm -n $DASH_NS $name --dry-run=client --from-file $f -o yaml | kubectl apply -f -
       kubectl label cm -n $DASH_NS $name --overwrite grafana_dashboard=1 sas.com/monitoring-base=kube-viya-monitoring sas.com/dashboardType=$type
     fi
   done
}

# Single argument supported. If specified, deploy either the specified .json
# file as a dashboard or all .json files in the specified directory

if [ "$1" != "" ]; then
  if [ -f "$1" ]; then
    if [[ $1 =~ .+\.json ]]; then
      # Deploy single dashboard
      f=$1
      log_info "Deploying Grafana dashboard [$f]..."
      name=$(basename $f .json)
      kubectl create cm -n $DASH_NS $name --dry-run=client --from-file $f -o yaml | kubectl apply -f -
      kubectl label cm -n $DASH_NS $name --overwrite grafana_dashboard=1 sas.com/monitoring-base=kube-viya-monitoring sas.com/dashboardType=manual
      exit $?
    else
      log_error "[$1] is not a Grafana dashboard .json file"
      exit 1
    fi
  fi

  if [ -d "$1" ]; then
    # Deploy specified directory of dashboards
    log_verbose "Deploying Grafana dashboards in [$1]..."
    deploy_dashboards "manual" "$1" 
    exit $?
  fi

  log_error "The dashboard path [$1] does not exist"
  exit 1
fi

log_info "Deploying dashboards to the [$DASH_NS] namespace..."
if [ "$WELCOME_DASH" == "true" ]; then
  log_verbose "Deploying welcome dashboards..."
  deploy_dashboards "welcome"
fi

if [ "$KUBE_DASH" == "true" ]; then
  log_verbose "Deploying Kubernetes cluster dashboards..."
  deploy_dashboards "kube"
fi

if [ "$ISTIO_DASH" == "true" ]; then
  log_verbose "Deploying Istio dashboards..."
  deploy_dashboards "istio"
fi

if [ "$LOGGING_DASH" == "true" ]; then
  log_verbose "Deploying Logging dashboards..."
  deploy_dashboards "logging"
fi

if [ "$VIYA_DASH" == "true" ]; then
  log_verbose "Deploying SAS Viya dashboards..."
  deploy_dashboards "viya"
fi

if [ "$PGMONITOR_DASH" == "true" ]; then
  log_verbose "Deploying Postgres dashboards..."  
  deploy_dashboards "pgmonitor"
fi

if [ "$RABBITMQ_DASH" == "true" ]; then
  log_verbose "Deploying RabbitMQ dashboards..."
  deploy_dashboards "rabbitmq"
fi

if [ "$NGINX_DASH" == "true" ]; then
  log_verbose "Deploying NGINX dashboards..."
  deploy_dashboards "nginx"
fi

if [ "$USER_DASH" == "true" ]; then
  userDashDir="$USER_DIR/monitoring/dashboards"
  if [ -d "$userDashDir" ]; then
    log_verbose "Deploying user dashboards from [$userDashDir] ..."
    deploy_dashboards "user" "$userDashDir"
  fi
fi

log_info "Deployed dashboards to the [$DASH_NS] namespace"
