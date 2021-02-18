# Copyright © 20201 SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

if [ "$SAS_COMMON_SOURCED" = "" ]; then
    # Includes
    source bin/colors-include.sh
    source bin/log-include.sh

    export USER_DIR=${USER_DIR:-$(pwd)}
    if [ -f "$USER_DIR/user.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' $USER_DIR/user.env | grep -v '^#' | xargs)
        if [ "$userEnv" != "" ]; then
          log_debug "Loading global user environment file: $USER_DIR/user.env"
          if [ "$userEnv" != "" ]; then
            export $userEnv
          fi
        fi
    fi

    log_debug "Working directory: $(pwd)"
    log_debug "User directory: $USER_DIR"

    export TMP_DIR=$(mktemp -d -t sas.mon.XXXXXXXX)
    if [ ! -d "$TMP_DIR" ]; then
      log_error "Could not create temporary directory [$TMP_DIR]"
      exit 1
    fi
    log_debug "Temporary directory: [$TMP_DIR]"
    echo "# This file intentionally empty" > $TMP_DIR/empty.yaml

    # Delete the temp directory on exit
    function cleanup {
      KEEP_TMP_DIR=${KEEP_TMP_DIR:-false}
      if [ "$KEEP_TMP_DIR" != "true" ]; then
        rm -rf "$TMP_DIR"
        log_debug "Deleted temporary directory: [$TMP_DIR]"
      else
        log_info "TMP_DIR [$TMP_DIR] was not removed"
      fi
    }
    trap cleanup EXIT

    export SAS_COMMON_SOURCED=true
fi
