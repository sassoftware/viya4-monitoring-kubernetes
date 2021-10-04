# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

if [ "$SAS_COMMON_SOURCED" = "" ]; then
    # Save standard out to a new descriptor
    exec 3>&1
    
    # Includes
    source bin/colors-include.sh
    source bin/log-include.sh
    source bin/openshift-include.sh

    export USER_DIR=${USER_DIR:-$(pwd)}
    if [ -d "$USER_DIR" ]; then
      # Resolve full path
      export USER_DIR=$(cd "$(dirname "$USER_DIR")"; pwd)/$(basename "$USER_DIR")
    fi
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

    CHECK_HELM=${CHECK_HELM:-true}
    if [ "$CHECK_HELM" == "true" ]; then
       source bin/helm-include.sh
       log_info "Helm client version: $HELM_VER_FULL"
    fi

    CHECK_KUBERNETES=${CHECK_KUBERNETES:-true}
    if [ "$CHECK_KUBERNETES" == "true" ]; then
       source bin/kube-include.sh

       log_info Kubernetes client version: "$KUBE_CLIENT_VER"
       log_info Kubernetes server version: "$KUBE_SERVER_VER"

       # Check that the current KUBECONFIG has admin access
       CHECK_ADMIN=${CHECK_ADMIN:-true}
       if [ "$CHECK_ADMIN" == "true" ]; then
          if [ "$(kubectl auth can-i create namespace --all-namespaces)" == "no" ]; then
             ctx=$(kubectl config current-context)
             log_error "The current kubectl context [$ctx] does not have cluster admin access"
             exit 1
          else
             log_debug "Cluster admin check OK"
          fi
       else
          log_debug "Cluster admin check disabled"
       fi
    fi

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

function checkDefaultStorageClass {
    if [ -z "$defaultStorageClass" ]; then
      # Check for kubernetes environment conflicts/requirements
      defaultStorageClass=$(kubectl get storageclass -o jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.metadata.annotations..storageclass\.kubernetes\.io/is-default-class}{'\n'}{end}" | grep true | awk '{print $1}')
      if [ "$defaultStorageClass" ]; then
        log_debug "Found default storageClass: [$defaultStorageClass]"
      else
        # Try again with beta storageclass annotation key
        defaultStorageClass=$(kubectl get storageclass -o jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.metadata.annotations..storageclass\.beta\.kubernetes\.io/is-default-class}{'\n'}{end}" | grep true | awk '{print $1}')
        if [ "$defaultStorageClass" ]; then
          log_debug "Found default storageClass: [$defaultStorageClass]"
        else
          log_warn "This cluster does not have a default storageclass defined"
          log_warn "This may cause errors unless storageclass values are explicitly defined"
          defaultStorageClass=_NONE_
        fi
      fi
    fi
}

function randomPassword {
  date +%s | sha256sum | base64 | head -c 32 ; echo
}

export -f checkDefaultStorageClass
export -f randomPassword

