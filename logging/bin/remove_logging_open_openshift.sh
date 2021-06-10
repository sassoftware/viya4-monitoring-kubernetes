#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

# Confirm on OpenShift
if [ "$OPENSHIFT_CLUSTER" != "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should only be run on OpenShift clusters"
    log_error "Run logging/bin/remove_logging_open.sh instead"
    exit 1
  fi
fi


# remove OpenShift-specific content not removed by primary removal script
logging/bin/remove_openshift_artifacts.sh

# remove ServiceMonitors
export DEPLOY_SERVICEMONITORS=${DEPLOY_SERVICEMONITORS:-true}
logging/bin/remove_servicemonitors_open_openshift.sh

#
# remove logging components
#
# override-openshift check
export CHECK_OPENSHIFT_CLUSTER=false
logging/bin/remove_logging_open.sh


log_info "Log monitoring component removal script has completed."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
