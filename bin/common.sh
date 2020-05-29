# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

if [ "$SAS_COMMON_SOURCED" = "" ]; then
    if [ -f "user.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' user.env | grep -v '^#' | xargs)
        if [ "$userEnv" != "" ]; then
          echo "Loading user environment file: user.env"
          if [ "$userEnv" != "" ]; then
            export $userEnv
          fi
        fi
    fi

    source bin/.colors
    source bin/.logging

    source bin/helm_ver.sh
    source bin/kube_ver.sh

    log_info "Helm client version: $HELM_VER_FULL"
    if [ "$HELM_VER_MAJOR" == "2" ] && [ "$HELM_SERVER_VER_FULL" != "" ]; then
      log_info "Helm server version: $HELM_SERVER_VER_FULL"
    fi

    log_info KUBE_CLIENT_VER="$KUBE_CLIENT_VER"
    log_info KUBE_SERVER_VER="$KUBE_SERVER_VER"

    export TMP_DIR=${TMP_DIR:-/tmp}
    if [ ! -d "$TMP_DIR" ]; then
      log_error "TMP_DIR [$TMP_DIR] does not exist"
      exit 1
    fi

    export SAS_COMMON_SOURCED=true
fi
