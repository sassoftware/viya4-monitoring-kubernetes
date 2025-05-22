#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

if [ "$SAS_LOGGING_COMMON_SOURCED" = "" ]; then
    source bin/common.sh

    if [ -f "$USER_DIR/logging/user.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' "$USER_DIR/logging/user.env" | grep -v '^#' | xargs)

        log_verbose "Loading user environment file: $USER_DIR/logging/user.env"
        if [ "$userEnv" ]; then
         # shellcheck disable=SC2086,SC2163
          export $userEnv
        fi
    fi

    #Check for obsolete env var
    if [  -n "$LOG_SEARCH_BACKEND" ]; then
        log_error "Support for the LOG_SEARCH_BACKEND environment variable has been removed."
        log_error "This script is only appropriate for use with OpenSearch as the search back-end."
        log_error "The LOG_SEARCH_BACKEND environment variable is currently set to [$LOG_SEARCH_BACKEND]"
        exit 1
    fi

    export LOG_NS="${LOG_NS:-logging}"

    #if TLS (w/in cluster; for all monitoring components) is requested, require TLS into OSD pod, too
    export TLS_ENABLE="${TLS_ENABLE:-true}"
    log_debug "logging/common.sh (incoming): TLS_ENABLE=$TLS_ENABLE"

    export OSD_TLS_ENABLE=${TLS_ENABLE:-true}
    # TLS is required for logging components so hard-code to 'true'
    export TLS_ENABLE="true"

    # set some OpenSearch/OSD env vars
    export ES_SERVICENAME="v4m-search"
    export ES_INGRESSNAME="v4m-search"

    export KB_SERVICENAME="v4m-osd"
    export KB_INGRESSNAME="v4m-osd"
    export KB_SERVICEPORT="http"

    export ES_PLUGINS_DIR="_plugins"
    export LOG_XSRF_HEADER="osd-xsrf:true"

    export V4M_NS=$LOG_NS

    if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
       source bin/airgap-include.sh
    fi

    source bin/version-include.sh

    export SAS_LOGGING_COMMON_SOURCED=true

fi
echo ""

