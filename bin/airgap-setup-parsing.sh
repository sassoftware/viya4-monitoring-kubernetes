#! /bin/bash

# Copyright ©2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

export CHECK_KUBERNETES=FALSE
export OPENSHIFT_VERSION_CHECK=FALSE
export CHECK_HELM=TRUE
export MON_NS="${MON_NS:-monitoring}"
export LOG_NS="${LOG_NS:-logging}"
export AIRGAP_IMAGE_PULL_SECRET_NAME="${AIRGAP_IMAGE_PULL_SECRET_NAME:-v4m-image-pull-secret}"

source bin/common.sh

if ! command -v docker > /dev/null 2>&1; then
    log_error "Docker not found on the current PATH."
    exit 1
fi

required_vars=(
    "AIRGAP_REGISTRY"
    "AIRGAP_REGISTRY_USERNAME"
    "AIRGAP_REGISTRY_PASSWORD"
    "EMAIL_ORGANIZATION"
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
printf '%s\n' "$AIRGAP_REGISTRY_PASSWORD" | docker login "$AIRGAP_REGISTRY" -u "$AIRGAP_REGISTRY_USERNAME" --password-stdin

log_notice "Step 1 - Import Images"

while IFS='=' read -r var _; do
    full_image="${!var}"

    if [[ -z $full_image ]]; then
        log_error "Unable to extract container image from [""${var}""]"
        exit 1
    fi

    if [[ $full_image == "registry.redhat.io/openshift4/ose-oauth-proxy:latest" ]]; then
        log_info "Skipping image: ""${full_image}"""
        continue
    fi

    parseFullImage "$full_image"

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
printf '%s\n' "$AIRGAP_HELM_PASSWORD" | helm registry login "$AIRGAP_HELM_REPO" -u "$AIRGAP_HELM_USERNAME" --password-stdin

while IFS='=' read -r var _; do
    prefix=${var%_CHART_NAME}
    chart_name="${!var}"
    repo_name_var="${prefix}_CHART_REPO"
    version_var="${prefix}_CHART_VERSION"

    repo_name="${!repo_name_var:-}"
    version_number="${!version_var:-}"

    if [[ -z $repo_name || -z $chart_name || -z $version_number ]]; then
        log_error "Missing at least one of the following values:"
        log_error "Repo's Name: ""${repo_name}"""
        log_error "Chart's Name: ""${chart_name}"""
        log_error "Version number: ""${version_number}"""
        exit 1
    fi

    log_verbose "Writing Helm chart ""${chart_name}"" version ""${version_number}"" from repository ""${repo_name}"" to ""$TMP_DIR"""
    helm pull --destination "$TMP_DIR" --version "${version_number}" "${repo_name}"/"${chart_name}"

    archive_path="${TMP_DIR}/${chart_name}-${version_number}.tgz"
    if [[ -z $archive_path ]]; then
        log_error "Chart archive not found: ${archive_path}"
        exit 1
    fi

    log_verbose "Uploading Helm chart archive ""${chart_name}""-""${version_number}"".tgz found in ""$TMP_DIR"" to the ""${repo_name}"" repository in [""$AIRGAP_HELM_REPO""]"
    helm push "${archive_path}" "oci://$AIRGAP_HELM_REPO/${repo_name}"
done < <(env | grep '_CHART_NAME=')

log_notice "Step 4 - Download Prometheus Operator CRDs"

promop_image="$PROMOP_FULL_IMAGE"
if [[ -z $promop_image ]]; then
    log_error "Unable to extract prometheus operator image from PROMOP_FULL_IMAGE: [""${PROMOP_FULL_IMAGE}""]"
    exit 1
fi

promop_version="${promop_image##*:}"
log_verbose "Promethues Operator version: ""${promop_version}"""
promop_dir="$USER_DIR/monitoring/prometheus-operator-crd/${promop_version}"
mkdir -p "${promop_dir}"
base_url="https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/${promop_version}/example/prometheus-operator-crd"
crds=(
    alertmanagerconfigs
    alertmanagers
    prometheuses
    prometheusrules
    podmonitors
    servicemonitors
    thanosrulers
    probes
)

for crd in "${crds[@]}"; do
    crd_file="monitoring.coreos.com_${crd}.yaml"
    crd_url="${base_url}/${crd_file}"
    log_verbose "Downloading CRD [$crd_file]"
    curl -fS "${crd_url}" -o "${promop_dir}/${crd_file}" || {
        log_error "Failed to download CRD [$crd_file]"
        log_error "URL: ${crd_url}"
        exit 1
    }
done

log_notice "Step 5 - Download OpenSearch Grafana Datasource Plugin"

plugin_version="$GRAFANA_DATASOURCE_PLUGIN_VERSION"
if [[ -z $plugin_version ]]; then
    log_error "Unable to extract grafana plugin version from GRAFANA_DATASOURCE_PLUGIN_VERSION: [""${GRAFANA_DATASOURCE_PLUGIN_VERSION}""]"
    exit 1
fi

plugin_dir="$USER_DIR/monitoring"
plugin_file="grafana-opensearch-datasource-${plugin_version}.linux_amd64.zip"
plugin_url="https://github.com/grafana/opensearch-datasource/releases/download/v${plugin_version}/${plugin_file}"

log_verbose "Downloading Grafana Opensearch datasource plugin version ${plugin_version}"
mkdir -p "$plugin_dir"

curl -fS "${plugin_url}" -o "${plugin_dir}/${plugin_file}" || {
    log_error "Failed to download Grafana datasource plugin"
    exit 1
}

log_notice "Step 6 - Prepare to Deploy"

for ns in "$LOG_NS" "$MON_NS"; do
    if ! kubectl get namespace "$ns" > /dev/null 2>&1; then
        log_verbose "Creating namespace [$ns]"
        kubectl create namespace "$ns"
    else
        log_debug "Namespace [$ns] already exists"
    fi
done

for ns in "$LOG_NS" "$MON_NS"; do
    if ! kubectl -n "$ns" get secret "$AIRGAP_IMAGE_PULL_SECRET_NAME" > /dev/null 2>&1; then
        log_verbose "Creating secret [$AIRGAP_IMAGE_PULL_SECRET_NAME] in namespace [$ns]"
        kubectl create secret docker-registry "$AIRGAP_IMAGE_PULL_SECRET_NAME" -n "$ns" --docker-server="$AIRGAP_REGISTRY" --docker-username="$AIRGAP_REGISTRY_USERNAME" --docker-password="$AIRGAP_REGISTRY_PASSWORD" --docker-email="$EMAIL_ORGANIZATION"
    else
        log_verbose "Secret [$AIRGAP_IMAGE_PULL_SECRET_NAME] already exists in [$ns]"
    fi
done

log_notice "Script Complete."
