# shellcheck disable=SC2148
# Copyright © 2023-2024, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo


if [ "$AIRGAP_SOURCED" == "" ]; then
    ## Check for AIRGAP_REGISTRY, if null/empty, error out.  Otherwise set and create HELM_URL_BASE.
    if [ -z "$AIRGAP_REGISTRY" ]; then
        log_error "AIRGAP_REGISTRY has not been set"
        log_error "Please provide the URL for the private image registry and try again"
        exit 1
    else

        AIRGAP_IMAGE_PULL_SECRET_NAME=${AIRGAP_IMAGE_PULL_SECRET_NAME:-"v4m-image-pull-secret"}

        # Check for the image pull secret for the air gap environment
        if [ -z "$(kubectl get secret -n "$V4M_NS" "$AIRGAP_IMAGE_PULL_SECRET_NAME" -o name --ignore-not-found)" ]; then
            log_error "The image pull secret, [$AIRGAP_IMAGE_PULL_SECRET_NAME], was not detected"
            log_error "Please add the image pull secret to the [$V4M_NS] namespace and run the deployment script again"
            exit 1
        fi

        AIRGAP_HELM_REPO=${AIRGAP_HELM_REPO:-"$AIRGAP_REGISTRY"}
        AIRGAP_HELM_FORMAT=${AIRGAP_HELM_FORMAT:-"oci"}

        if [ "$AIRGAP_HELM_FORMAT" == "tgz" ]; then
            if [ ! -d "$AIRGAP_HELM_REPO" ]; then
                log_error "When AIRGAP_HELM_FORMAT is 'tgz', AIRGAP_HELM_REPO is expected to be a directory."
                log_error "The specified AIRGAP_HELM_REPO directory [$AIRGAP_HELM_REPO] does NOT exist."
                exit 1
            else
                log_debug "Confirmed AIRGAP_HELM_REPO [$AIRGAP_HELM_REPO] exists"
            fi
        fi
    fi

    log_info "Deploying into an 'air-gapped' cluster from private registry [$AIRGAP_REGISTRY]"

    airgapDir="$TMP_DIR/airgap"
    mkdir -p "$airgapDir"

    export AIRGAP_SOURCED=true
fi
