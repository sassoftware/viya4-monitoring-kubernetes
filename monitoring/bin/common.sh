#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

if [ "$SAS_MONITORING_COMMON_SOURCED" = "" ]; then
    source bin/common.sh

    if [ -f "$USER_DIR/monitoring/user.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' "$USER_DIR/monitoring/user.env" | grep -v '^#' | xargs)
        log_verbose "Loading user environment file: $USER_DIR/monitoring/user.env"
        if [ -n "$userEnv" ]; then
            # shellcheck disable=SC2086,SC2163
            export $userEnv
        fi
    fi

    export MON_NS="${MON_NS:-monitoring}"
    export TLS_ENABLE="${MON_TLS_ENABLE:-${TLS_ENABLE:-true}}"

    if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then

        #Special processing to handle Viya-level deployment script
        if [ "$(basename "$0")" == "deploy_monitoring_viya.sh" ]; then
            V4M_NS="$VIYA_NS"
        else
            export V4M_NS=$MON_NS
        fi

        source bin/airgap-include.sh

    fi

    #(Re)Set V4M_NS to point to "monitoring" namespace
    export V4M_NS=$MON_NS

    source bin/version-include.sh
    export SAS_MONITORING_COMMON_SOURCED=true

fi
echo ""
