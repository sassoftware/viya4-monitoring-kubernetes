# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

if [ "$SAS_LOGGING_COMMON_SOURCED" = "" ]; then
    source bin/common.sh

    if [ -f "$USER_DIR/logging/user.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' $USER_DIR/logging/user.env | grep -v '^#' | xargs)
        log_verbose "Loading user environment file: $USER_DIR/logging/user.env"
        if [ "$userEnv" ]; then
          export $userEnv
        fi
    fi

    export LOG_NS="${LOG_NS:-logging}"

    #if TLS (w/in cluster; for all monitoring components) is requested, require TLS into Kibana pod, too
    # DEPRECATION: use of the LOG_KB_TLS_ENABLE env var has been deprecated with release 1.1.14 (14FEB22)
    #              with support removed completely in a subsequent release
    export TLS_ENABLE="${TLS_ENABLE:-false}"
    log_debug "logging/common.sh (incoming): TLS_ENABLE=$TLS_ENABLE"
    export LOG_KB_TLS_ENABLE=${LOG_KB_TLS_ENABLE:-$TLS_ENABLE}
    # TLS is required for logging components so hard-code to 'true'
    export TLS_ENABLE="true"

    export V4M_NS=$LOG_NS
    source bin/version-include.sh

    export SAS_LOGGING_COMMON_SOURCED=true

    #Environment vars related to upgrading ODFE 1.7.0 to ODFE 1.13.2
    export KB_GLOBAL_EXPORT_FILE=${KB_GLOBAL_EXPORT_FILE:-"$TMP_DIR/kibana_global_content.ndjson"}
fi
echo ""

