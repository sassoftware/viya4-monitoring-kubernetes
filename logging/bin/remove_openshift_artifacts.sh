#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh

this_script=$(basename "$0")

log_debug "Script [$this_script] has started [$(date)]"

# Deploy OpenShift-specific pre-reqs?
OPENSHIFT_ARTIFACTS_REMOVE=${OPENSHIFT_ARTIFACTS_REMOVE:-true}

if [ "$OPENSHIFT_ARTIFACTS_REMOVE" != "true" ]; then
    log_info "Environment variable [OPENSHIFT_ARTIFACTS_REMOVE] is not set to 'true'; exiting WITHOUT removing OpenShift Artifacts"
    exit
fi

if [ "$OPENSHIFT_CLUSTER" != "true" ]; then
    if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
        log_error "This script should only be run on OpenShift clusters"
        exit 1
    fi
fi

# remove custom OpenShift SCC
oc delete scc v4mlogging --ignore-not-found
oc delete scc v4m-logging-v2 --ignore-not-found
oc delete scc v4m-k8sevents --ignore-not-found

log_info "OpenShift Prerequisites have been removed."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
