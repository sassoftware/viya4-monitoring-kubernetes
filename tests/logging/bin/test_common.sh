#! /bin/bash

# Copyright © 2024, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

V4M_REPO=${V4M_REPO:-"../viya4-monitoring-kubernetes"}
LOG_COLOR_ENABLE=false

LOG_VERBOSE_ENABLE=false       #suppress VERBOSE messages
V4M_VERSION_INCLUDE=false      #skip version-include.sh
CHECK_HELM=false               #skip Helm checks
CHECK_KUBERNETES=false         #skip Kubernetes checks
OPENSHIFT_VERSION_CHECK=false  #skip OpenShift checks

cd $V4M_REPO

source $V4M_REPO/logging/bin/common.sh

log_info "LOG_SEARCH_BACKEND set to [$LOG_SEARCH_BACKEND]"

require_opensearch

log_info "Call to require_opensearch function did NOT trigger exit"


#test #1: LOG_SEARCH_BACKEND == 'OPENSEARCH'  - Expected Output
# INFO User directory: /home/sasgzs/repos/viya4-monitoring-kubernetes
# INFO LOG_SEARCH_BACKEND set to [OPENSEARCH]
# INFO Call to require_opensearch function did NOT trigger exit

#test #2: LOG_SEARCH_BACKEND != 'OPENSEARCH'  - Expected Output
# INFO User directory: /home/sasgzs/repos/viya4-monitoring-kubernetes
# INFO LOG_SEARCH_BACKEND set to [foo]
# ERROR This script is only appropriate for use with OpenSearch as the search back-end.
# ERROR The LOG_SEARCH_BACKEND environment variable is currently set to [foo]
