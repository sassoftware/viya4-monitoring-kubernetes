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

if [[ -n "$AIRGAP_HELM_REPO" && "$AIRGAP_HELM_REPO" != "$AIRGAP_REGISTRY" ]]; then
    log_warn "AIRGAP_HELM_REPO ($AIRGAP_HELM_REPO) does not match AIRGAP_REGISTRY ($AIRGAP_REGISTRY)."
    log_warn "This script currently does not support the storing of two types of different artifacts in different locations."
    echo
fi

log_info "docker login ""$AIRGAP_REGISTRY"" -u ""$AIRGAP_REGISTRY_USERNAME"" -p ___"
docker login "$AIRGAP_REGISTRY" -u "$AIRGAP_REGISTRY_USERNAME" -p "$AIRGAP_REGISTRY_PASSWORD"

log_info "Parsing $COMPONENT_FILE"
echo

log_notice "Step 1 - Import Images"
echo

for var in $(compgen -A variable | grep '_FULL_IMAGE$'); do
    full_image="${!var}"

    [[ -z $full_image ]] && continue

    if [[ $full_image == "registry.redhat.io/openshift4/ose-oauth-proxy:latest" ]]; then
        log_warn "Skipping image: $full_image"
        echo
        continue
    fi

    parseFullImage "$full_image"

    repo_image="$REPOS/$IMAGE:$VERSION"

    log_verbose "docker pull ""${full_image}"""
    docker pull "${full_image}"
    echo
    log_verbose "docker tag ""${full_image}"" ""$AIRGAP_REGISTRY""/""${repo_image}"""
    docker tag "${full_image}" "$AIRGAP_REGISTRY"/"${repo_image}"
    echo
    log_verbose "docker push ""$AIRGAP_REGISTRY""/""${repo_image}"""
    docker push "$AIRGAP_REGISTRY"/"${repo_image}"
    echo
done
echo

log_notice "Step 2 - Helm Repo Add Commands"
echo

declare -A REPO_URLS=(
    ["prometheus-community"]="https://prometheus-community.github.io/helm-charts"
    ["grafana"]="https://grafana.github.io/helm-charts"
    ["fluent"]="https://fluent.github.io/helm-charts"
    ["opensearch"]="https://opensearch-project.github.io/helm-charts"
)

for var in $(compgen -A variable | grep '_CHART_REPO'); do
    repo_name="${!var}"
    repo_url=${REPO_URLS[$repo_name]:-}

    if [[ -z $repo_url ]]; then
        log_warn "No URL for repo '$repo_name'. Skipping."
        echo
        continue
    fi

    log_info "helm repo add ""${repo_name}"" ""${repo_url}"""
    helm repo add "${repo_name}" "${repo_url}"
done
echo

log_notice "Step 3 - Helm Pull Commands"
echo

log_info "helm repo update"
helm repo update
echo

for var in $(compgen -A variable | grep '_CHART_NAME'); do
    prefix=${var%_CHART_NAME}
    chart_name="${!var}"
    repo_name_var="${prefix}_CHART_REPO"
    version_var="${prefix}_CHART_VERSION"

    repo_name="${!repo_name_var:-}"
    version="${!version_var:-}"

    [[ -z $repo_name || -z $chart_name || -z $version ]] && continue

    log_verbose "helm pull --destination ""$TMP_DIR"" --version ""${version}"" ""${repo_name}""/""${chart_name}"""
    helm pull --destination "$TMP_DIR" --version "${version}" "${repo_name}"/"${chart_name}"
done
echo

log_notice "Step 4 - Helm Chart Push"
echo

log_info "helm registry login ""$AIRGAP_REGISTRY"" -u ""$AIRGAP_REGISTRY_USERNAME"" -p ___"
helm registry login "$AIRGAP_REGISTRY" -u "$AIRGAP_REGISTRY_USERNAME" -p "$AIRGAP_REGISTRY_PASSWORD"
echo

for archive_path in "$TMP_DIR"/*.tgz; do
    [[ -f $archive_path ]] || continue

    archive_name=$(basename "$archive_path")

    if [[ $archive_name == *prometheus* ]]; then
        repo_name="prometheus-community"
    elif [[ $archive_name == *fluent* ]]; then
        repo_name="fluent"
    elif [[ $archive_name == *grafana* || $archive_name == *tempo* ]]; then
        repo_name="grafana"
    elif [[ $archive_name == *opensearch* ]]; then
        repo_name="opensearch"
    else
        log_error "Unknown helm repo for archive: ${archive_name}"
        exit 1
    fi

    log_info "helm push \"${archive_path}\" oci://$AIRGAP_REGISTRY/${repo_name}"
    helm push "${archive_path}" "oci://$AIRGAP_REGISTRY/${repo_name}"
done
echo

echo
log_notice "Script Complete."
echo
