#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

#Fail if not using OpenSearch back-end
require_opensearch

log_debug "Script [$this_script] has started [$(date)]"

# Deploy OpenShift-specific pre-reqs?
OPENSHIFT_PREREQS_ENABLE=${OPENSHIFT_PREREQS_ENABLE:-true}

if [ "$OPENSHIFT_PREREQS_ENABLE" != "true" ]; then
  log_info "Environment variable [OPENSHIFT_PREREQS_ENABLE] is not set to 'true'; exiting WITHOUT deploying OpenShift Prerequisites"
  exit
fi


# link OpenSearch serviceAccounts to 'privileged' scc
oc adm policy add-scc-to-user privileged -z v4m-os -n $LOG_NS

log_info "OpenShift Prerequisites have been deployed."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
