#! /bin/bash

# Copyright Â© 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

# Confirm NOT on OpenShift
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should NOT be run on OpenShift clusters"
    log_error "Run 'logging/bin/create_openshift_route.sh' instead"
    exit 1
  fi
fi

set -e

namespace="$LOG_NS"

app=${1}
arg2=${2}

if [[ "$arg2" -ge 30000 ]] && [[ "$arg2" -le 32767 ]]; then
   target_port="$arg2"
elif [ "$arg2" == "DISABLE" ] || [ "$arg2" == "0" ] || [ -z "$arg2" ]; then
   log_debug "2nd argument: $arg2"
else
   log_error "Invalid port number provided."
   log_error "Value must be: a number between 30000 and 32767,  0 (a random port will be assigned) or DISABLE (disable the current nodePort). "
   exit 1
fi

app=$(echo "$app"| tr '[:lower:]' '[:upper:]')
case "$app" in
   "OPENSEARCH"|"OS"|"ELASTICSEARCH"|"ES")
      SVC=$ES_SERVICENAME
      target_port="${target_port:-0}"
      ;;
   "OPENSEARCHDASHBOARDS"|"DASHBOARDS"|"OSD"|"KIBANA"|"KB")
      SVC=$KB_SERVICENAME
      target_port="${target_port:-31033}"
      ;;
  ""|*)
      log_error "Application name is invalid or missing."
      log_error "The APPLICATION NAME is required; valid values are: OPENSEARCH, OPENSEARCHDASHBOARDS, ELASTICSEARCH or KIBANA"
      exit 1
      ;;
esac

if [ "$arg2" == "DISABLE" ];then
   log_info "Removing NodePort for [$SVC] in [$LOG_NS]"
   kubectl -n "$LOG_NS" patch svc "$SVC" --type='json' -p '[{"op":"replace","path":"/spec/type","value":"ClusterIP"}]'
   exit
elif [ "$target_port" != "0" ]; then
   log_info "Making [$SVC] in [$LOG_NS] namespace available on port [$target_port]"
   echo
else
   log_debug "No specific port was provided, will make [$SVC] available on a random port"
fi

kubectl -n "$LOG_NS" patch svc "$SVC" --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'
kubectl -n "$LOG_NS" patch svc "$SVC" --type='json' -p '[{"op":"replace","path":"/spec/ports/0/nodePort","value":'${target_port}'}]'

SHOW_ES_URL="${SHOW_ES_URL:-true}"
if [ "$SHOW_ES_URL" == "true" ]; then
   bin/show_app_url.sh $app
fi
