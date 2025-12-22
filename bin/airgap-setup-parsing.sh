#! /bin/bash

source bin/common.sh

required_vars=(
    "AIRGAP_REGISTRY"
    "AIRGAP_REGISTRY_USERNAME"
    "AIRGAP_REGISTRY_PASSWORD"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        log_error "Environment variable $var is not set."
        log_error "Please set it using: export $var=VALUE OR..."
        log_error "...Set it in USER_DIR/user.env file."
        exit 1
    fi
done

if [[ -n $AIRGAP_HELM_REPO && $AIRGAP_HELM_REPO != "$AIRGAP_REGISTRY" ]]; then
    log_warn "AIRGAP_HELM_REPO ($AIRGAP_HELM_REPO) does not match AIRGAP_REGISTRY ($AIRGAP_REGISTRY)."
    log_warn "This script currently does not support the storing of two types of different artifacts in different locations."
fi

get_chart_info() {
    local chart_name_var="$1"

    prefix=${chart_name_var%_CHART_NAME}
    chart_name="${!chart_name_var}"
    repo_name_var="${prefix}_CHART_REPO"
    version_var="${prefix}_CHART_VERSION"

    repo_name="${!repo_name_var:-}"
    version="${!version_var:-}"

    if [[ -z $repo_name || -z $chart_name || -z $version ]]; then
        log_error "Missing at least one of the following values:"
        log_error "Repo's Name: ${repo_name}"
        log_error "Chart's Name: ${chart_name}"
        log_error "Version number: ${version}"
        exit 1
    fi
}

log_info "docker login ""$AIRGAP_REGISTRY"" -u ""$AIRGAP_REGISTRY_USERNAME"" -p ___"
docker login "$AIRGAP_REGISTRY" -u "$AIRGAP_REGISTRY_USERNAME" -p "$AIRGAP_REGISTRY_PASSWORD"

log_notice "Step 1 - Import Images"

while IFS='=' read -r var _; do
    full_image="${!var}"

    if [[ -z $full_image ]]; then
        log_error "Failure when getting full image value: ${full_image}"
        exit 1
    fi

    if [[ $full_image == "registry.redhat.io/openshift4/ose-oauth-proxy:latest" ]]; then
        log_warn "Skipping image: $full_image"
        continue
    fi

    parseFullImage "$full_image"

    # shellcheck disable=2153
    repo_image="$REPOS/$IMAGE:$VERSION"

    log_verbose "docker pull ""${full_image}"""
    docker pull "${full_image}"
    log_verbose "docker tag ""${full_image}"" ""$AIRGAP_REGISTRY""/""${repo_image}"""
    docker tag "${full_image}" "$AIRGAP_REGISTRY"/"${repo_image}"
    log_verbose "docker push ""$AIRGAP_REGISTRY""/""${repo_image}"""
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
        log_error "No URL for repo '$repo_name'"
        exit 1
    fi

    log_info "helm repo add ""${repo_name}"" ""${repo_url}"""
    helm repo add "${repo_name}" "${repo_url}"
done < <(env | grep '_CHART_REPO=')

log_notice "Step 3 - Helm Pull Commands"

log_info "helm repo update"
helm repo update

while IFS='=' read -r var _; do
    get_chart_info "$var"

    log_verbose "helm pull --destination ""$TMP_DIR"" --version ""${version}"" ""${repo_name}""/""${chart_name}"""
    helm pull --destination "$TMP_DIR" --version "${version}" "${repo_name}"/"${chart_name}"
done < <(env | grep '_CHART_NAME=')

log_notice "Step 4 - Helm Chart Push"

log_info "Logging into the private registry, ""$AIRGAP_REGISTRY"", with ""$AIRGAP_REGISTRY_USERNAME"" as the username"
helm registry login "$AIRGAP_REGISTRY" -u "$AIRGAP_REGISTRY_USERNAME" -p "$AIRGAP_REGISTRY_PASSWORD"

while IFS='=' read -r var _; do
    get_chart_info "$var"

    archive_path="${TMP_DIR}/${chart_name}-${version}.tgz"

    if [[ -z $archive_path ]]; then
        log_error "Chart archive not found: ${archive_path}"
        exit 1
    fi

    log_info "helm push \"${archive_path}\" oci://$AIRGAP_REGISTRY/${repo_name}"
    helm push "${archive_path}" "oci://$AIRGAP_REGISTRY/${repo_name}"
done < <(env | grep '_CHART_NAME=')

log_notice "Script Complete."
