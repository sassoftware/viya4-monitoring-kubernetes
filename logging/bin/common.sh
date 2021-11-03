# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

if [ "$SAS_LOGGING_COMMON_SOURCED" = "" ]; then
    source bin/common.sh

    if [ -f "$USER_DIR/logging/user.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' $USER_DIR/logging/user.env | grep -v '^#' | xargs)
        log_info "Loading user environment file: $USER_DIR/logging/user.env"
        if [ "$userEnv" ]; then
          export $userEnv
        fi
    fi

    export LOG_NS="${LOG_NS:-logging}"

    #if TLS (w/in cluster; for all monitoring components) is requested, require TLS into Kibana pod, too
    export TLS_ENABLE="${TLS_ENABLE:-false}"
    log_debug "logging/common.sh (incoming): TLS_ENABLE=$TLS_ENABLE"
    # defaulting LOG_KB_TLS_ENABLE to 'false' for now, probably should default to TLS_ENABLE
    export LOG_KB_TLS_ENABLE=${LOG_KB_TLS_ENABLE:-false}
    # TLS is required for logging components so hard-code to 'true'
    export TLS_ENABLE="true"

    export V4M_NS=$LOG_NS
    source bin/version-include.sh

    export SAS_LOGGING_COMMON_SOURCED=true

    export V4M_FEATURE_MULTITENANT_ENABLE=${V4M_FEATURE_MULTITENANT_ENABLE:-true}

    #Environment vars related to upgrading ODFE 1.7.0 to ODFE 1.13.2
    #ODFE_UPGRADE_IN_PROGRESS will be set to 'true' by deploy_elasticsearch_open.sh if needed
    ODFE_UPGRADE_IN_PROGRESS=${ODFE_UPGRADE_IN_PROGRESS:-false}
    KB_GLOBAL_EXPORT_FILE=${KB_GLOBAL_EXPORT_FILE:-"$TMP_DIR/kibana_global_content.ndjson"}
fi
echo ""

