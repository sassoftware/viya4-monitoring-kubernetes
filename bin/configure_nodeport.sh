#! /bin/bash

# Copyright ©2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/.."  || exit
source logging/bin/common.sh

#TO DO: Should be done in bin/common?
#export LOG_NS="${LOG_NS:-logging}"
export MON_NS="${MON_NS:-monitoring}"

# Confirm NOT on OpenShift
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
        log_error "This script should NOT be run on OpenShift clusters"
        log_error "Run 'logging/bin/create_openshift_route.sh' instead"
        exit 1
    fi
fi

set -e

app=${1}
arg1=$(echo "$arg1"| tr '[:lower:]' '[:upper:]')

arg2=${2}
arg2=$(echo "$arg2"| tr '[:lower:]' '[:upper:]')

if [[ "$arg2" -ge 30000 ]] && [[ "$arg2" -le 32767 ]]; then
    log_debug "Requested port [$target_port] is within valid range"
    target_port="$arg2"
elif [ "$arg2" == "0" ]; then
    log_debug "Random port requested"
    target_port="0"
elif [ "$arg2" == "DISABLE" ] || [ -z "$arg2" ]; then
    log_debug "2nd argument: $arg2"
else
    log_error "Invalid 2nd argument provided."
    log_error "Value must be: a port number between 30000 and 32767,  0 (a random port will be assigned) or DISABLE (disable the current nodePort). "
    exit 1
fi

app=$(echo "$app"| tr '[:lower:]' '[:upper:]')
case "$app" in
   "OPENSEARCH"|"OS")
      namespace=$LOG_NS
      servicename=$ES_SERVICENAME
      appname="OpenSearch"
      target_port="${target_port:-0}"
      ;;
   "OPENSEARCHDASHBOARDS"|"DASHBOARDS"|"OSD")
      namespace=$LOG_NS
      servicename=$KB_SERVICENAME
      appname="OpenSearchDashboards"
      target_port="${target_port:-31033}"
      ;;
   "ALERTMANAGER"|"AM")
      namespace=$MON_NS
      appname="Alertmanager"
      servicename="v4m-alertmanager"
      target_port="${target_port:-31091}"
      ;;
   "PROMETHEUS"|"PROM"|"PRO"|"PR")
      namespace=$MON_NS
      appname="Prometheus"
      servicename="v4m-prometheus"
      target_port="${target_port:-31090}"
      ;;
   "GRAFANA"|"GRAF"|"GR")
      namespace=$MON_NS
      appname="Grafana"
      servicename="v4m-grafana"
      target_port="${target_port:-31100}"
      ;;
  ""|*)
      log_error "Application name is invalid or missing."
      log_error "The APPLICATION NAME is required; valid values are:"
      log_error "OPENSEARCH, OPENSEARCHDASHBOARDS, GRAFANA, PROMETHEUS or ALERTMANAGER"
      exit 1
      ;;
esac

if [ "$arg2" == "DISABLE" ];then
    log_info "Removing NodePort for [$servicename] in [$LOG_NS]"
    kubectl -n "$namespace" patch svc "$servicename" --type='json' -p '[{"op":"replace","path":"/spec/type","value":"ClusterIP"}]'
    exit
elif [ "$target_port" != "0" ]; then
    log_info "Making [$servicename] in [$namespace] namespace available on port [$target_port]"
    echo
else
    log_debug "No specific port was provided, will make [$servicename] available on a random port"
fi

kubectl -n "$namespace" patch svc "$servicename" --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'
kubectl -n "$namespace" patch svc "$servicename" --type='json' -p '[{"op":"replace","path":"/spec/ports/0/nodePort","value":'"${target_port}"'}]'

show_url="${SHOW_URL:-true}"
if [ "$show_url" == "true" ]; then
    bin/show_app_url.sh $appname
fi
