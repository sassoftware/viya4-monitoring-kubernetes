#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

# Deploy OpenShift-specific pre-reqs?
OPENSHIFT_PREREQS_ENABLE=${OPENSHIFT_PREREQS_ENABLE:-true}

if [ "$OPENSHIFT_PREREQS_ENABLE" != "true" ]; then
    log_info "Environment variable [OPENSHIFT_PREREQS_ENABLE] is not set to 'true'; exiting WITHOUT deploying OpenShift Prerequisites"
    exit
fi

# link OpenSearch serviceAccounts to 'privileged' scc
oc adm policy add-scc-to-user privileged -z v4m-os -n "$LOG_NS"

# create the 'v4m-logging-v2' SCC, if it does not already exist
if oc get scc v4m-logging-v2 > /dev/null 2>&1; then
    log_info "Skipping scc creation; using existing scc [v4m-logging-v2]"
else
    oc create -f logging/openshift/fb_v4m-logging-v2_scc.yaml
fi

# create the 'v4m-k8sevents' SCC, if it does not already exist
if oc get scc v4m-k8sevents > /dev/null 2>&1; then
    log_info "Skipping scc creation; using existing scc [v4m-k8sevents]"
else
    oc create -f logging/openshift/fb_v4m-k8sevents_scc.yaml
fi

log_info "OpenShift Prerequisites have been deployed."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
