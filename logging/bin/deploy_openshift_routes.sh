#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

# Deploy OpenShift-specific pre-reqs?
OPENSHIFT_ROUTES_ENABLE=${OPENSHIFT_ROUTES_ENABLE:-true}

if [ "$OPENSHIFT_ROUTES_ENABLE" != "true" ]; then
  log_info "Environment variable [OPENSHIFT_ROUTES_ENABLE] is not set to 'true'; exiting WITHOUT deploying OpenShift Routes"
  exit
fi

if [ "$LOG_KB_TLS_ENABLE" != "true" ]; then
   # oc -n $LOG_NS expose service v4m-es-kibana-svc
   tls_mode=edge
else
   # NOTE: use of passthrough is a temp fix; will need to work with reencrypt eventually
   tls_mode=passthrough
fi
oc -n $LOG_NS create route $tls_mode v4m-es-kibana-svc  --service v4m-es-kibana-svc     --port=kibana-svc


ES_ENDPOINT_ENABLE=${ES_ENDPOINT_ENABLE:-false}
if [ "$ES_ENDPOINT_ENABLE" == "true" ]; then
   # NOTE: use of passthrough is a temp fix; will need to work with reencrypt eventually
   oc -n $LOG_NS create route passthrough v4m-es-client-service --service=v4m-es-client-service --port=http
fi

log_info "OpenShift Routes have been deployed."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
