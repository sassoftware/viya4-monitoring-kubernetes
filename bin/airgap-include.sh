# Copyright © 2023, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo


if [ "$AIRGAP_SOURCED" == "" ]; then
    ## Check for AIRGAP_REGISTRY, if null/empty, error out.  Otherwise set and create HELM_URL_BASE.
    if [ -z $AIRGAP_REGISTRY ]; then
        log_error "AIRGAP_REGISTRY has not been set"
        log_error "Please provide the URL for the private image registry and try again"
        exit 1
    else
        AIRGAP_IMAGE_PULL_SECRET_NAME=${AIRGAP_IMAGE_PULL_SECRET_NAME:-"v4m-image-pull-secret"}
        AIRGAP_HELM_REPO=${AIRGAP_HELM_REPO:-"$AIRGAP_REGISTRY"}
        AIRGAP_HELM_FORMAT=${AIRGAP_HELM_FORMAT:-"oci"}
    fi

    log_info "Deploying into an 'air-gapped' cluster from private registry [$AIRGAP_REGISTRY]"

    airgapDir="$TMP_DIR/airgap"
    mkdir -p $airgapDir

    export AIRGAP_SOURCED=true
fi

## The user will need to create the namespace and secret before running the deployment scripts.
## This function will produce an error if the secret is not found in the environment.
function checkForAirgapSecretInNamespace {
    secretName="$1"
    namespace="$2" 
    if [ -z "$(kubectl get secret -n $namespace | grep $secretName)" ]; then
        log_error "The image pull secret, [$secretName], was not detected"
        log_error "Please add the image pull secret to the [$namespace] namespace and run the deployment script again"
        exit 1
    fi
}

function replaceAirgapValuesInFiles {
    fileToUpdate=$1
    filename="$(echo $fileToUpdate | sed -n -e 's/^.*airgap\///p')"

    updatedAirgapValuesFile="$airgapDir/$filename"

    cp $fileToUpdate $updatedAirgapValuesFile

    log_debug "Replacing air gap placeholders for [$updatedAirgapValuesFile]"
    if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
      sed -i '' "s/__AIRGAP_REGISTRY__/$AIRGAP_REGISTRY/g" $updatedAirgapValuesFile
      sed -i '' "s/__AIRGAP_IMAGE_PULL_SECRET_NAME__/$AIRGAP_IMAGE_PULL_SECRET_NAME/g" $updatedAirgapValuesFile
    else
      sed -i "s/__AIRGAP_REGISTRY__/$AIRGAP_REGISTRY/g" $updatedAirgapValuesFile
      sed -i "s/__AIRGAP_IMAGE_PULL_SECRET_NAME__/$AIRGAP_IMAGE_PULL_SECRET_NAME/g" $updatedAirgapValuesFile
    fi
}

export -f checkForAirgapSecretInNamespace
export -f replaceAirgapValuesInFiles
