#! /bin/bash

# Copyright ©2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

source bin/common.sh

required_vars=(
    "AIRGAP_REGISTRY"
    "AIRGAP_REGISTRY_USERNAME"
    "AIRGAP_REGISTRY_PASSWORD"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        log_error "Environment variable ""${var}"" is not set."
        log_error "Please set it using: export ""${var}""=VALUE OR..."
        log_error "...Set it in USER_DIR/user.env file."
        exit 1
    fi
done

AIRGAP_HELM_REPO="${AIRGAP_HELM_REPO:-$AIRGAP_REGISTRY}"
AIRGAP_HELM_USERNAME="${AIRGAP_HELM_USERNAME:-$AIRGAP_REGISTRY_USERNAME}"
AIRGAP_HELM_PASSWORD="${AIRGAP_HELM_PASSWORD:-$AIRGAP_REGISTRY_PASSWORD}"

if [[ ${LOG_VERBOSE_ENABLE} == "false" ]]; then
    log_info "The script may take a few minutes to complete. Thank you for your patience."
    log_info "If you want to see detailed progress of Step 1, set LOG_VERBOSE_ENABLE to true."
fi

log_info "Logging into the private registry ""$AIRGAP_REGISTRY"", with ""$AIRGAP_REGISTRY_USERNAME"" as the username"
docker login "$AIRGAP_REGISTRY" -u "$AIRGAP_REGISTRY_USERNAME" -p "$AIRGAP_REGISTRY_PASSWORD"

log_notice "Step 1 - Import Images"

while IFS='=' read -r var _; do
    full_image="${!var}"

    if [[ -z $full_image ]]; then
        log_error "Unable to extract container image from value [""${var}""]"
        exit 1
    fi

    if [[ $full_image == "registry.redhat.io/openshift4/ose-oauth-proxy:latest" ]]; then
        log_info "Skipping image: ""${full_image}"""
        continue
    fi

    parseFullImage "$full_image"

    # shellcheck disable=2153
    repo_image="$REPOS/$IMAGE:$VERSION"

    log_verbose "Importing image ""${full_image}"" into ""$AIRGAP_REGISTRY""/""${repo_image}"""
    docker pull "${full_image}"
    docker tag "${full_image}" "$AIRGAP_REGISTRY"/"${repo_image}"
    docker push "$AIRGAP_REGISTRY"/"${repo_image}"
done < <(env | grep '_FULL_IMAGE=')

log_notice "Step 2 - Helm Repo Add Commands"

declare -A REPO_URLS=(
    ["prometheus-community"]="https://prometheus-community.github.io/helm-charts"
    ["grafana"]="https://grafana.github.io/helm-charts"
    ["fluent"]="https://fluent.github.io/helm-charts"
    ["opensearch"]="https://opensearch-project.github.io/helm-charts"
)

while IFS='=' read -r var _; do
    repo_name="${!var}"
    repo_url=${REPO_URLS[$repo_name]:-}

    if [[ -z $repo_url ]]; then
        log_error "No URL for repo ""${repo_name}"""
        exit 1
    fi

    log_verbose "Adding Helm repo ""${repo_name}"" from ""${repo_url}"""
    helm repo add "${repo_name}" "${repo_url}"
done < <(env | grep '_CHART_REPO=')

log_notice "Step 3 - Helm Pull and Push Commands"

helm repo update

log_info "Logging into the private repository, ""$AIRGAP_HELM_REPO"", with ""$AIRGAP_HELM_USERNAME"" as the username"
helm registry login "$AIRGAP_HELM_REPO" -u "$AIRGAP_HELM_USERNAME" -p "$AIRGAP_HELM_PASSWORD"

while IFS='=' read -r var _; do
    prefix=${var%_CHART_NAME}
    chart_name="${!var}"
    repo_name_var="${prefix}_CHART_REPO"
    version_var="${prefix}_CHART_VERSION"

    repo_name="${!repo_name_var:-}"
    version="${!version_var:-}"

    if [[ -z $repo_name || -z $chart_name || -z $version ]]; then
        log_error "Missing at least one of the following values:"
        log_error "Repo's Name: ""${repo_name}"""
        log_error "Chart's Name: ""${chart_name}"""
        log_error "Version number: ""${version}"""
        exit 1
    fi

    log_verbose "Writing Helm chart ""${chart_name}"" version ""${version}"" from repository ""${repo_name}"" to ""$TMP_DIR"""
    helm pull --destination "$TMP_DIR" --version "${version}" "${repo_name}"/"${chart_name}"

    archive_path="${TMP_DIR}/${chart_name}-${version}.tgz"
    if [[ -z $archive_path ]]; then
        log_error "Chart archive not found: ${archive_path}"
        exit 1
    fi

    log_verbose "Uploading Helm chart archive ""${chart_name}""-""${version}"".tgz found in ""$TMP_DIR"" to the ""${repo_name}"" repository in [""$AIRGAP_REGISTRY""]"
    helm push "${archive_path}" "oci://$AIRGAP_REGISTRY/${repo_name}"
done < <(env | grep '_CHART_NAME=')

log_notice "Script Complete."
