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

logging/bin/create_openshift_route.sh KIBANA

ES_ENDPOINT_ENABLE=${ES_ENDPOINT_ENABLE:-false}
if [ "$ES_ENDPOINT_ENABLE" == "true" ]; then
   logging/bin/create_openshift_route.sh ELASTICSEARCH
fi

log_info "OpenShift Routes have been deployed."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
