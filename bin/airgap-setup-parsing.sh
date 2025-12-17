#!/usr/bin/env bash

source bin/common.sh

TMP_DIR=$(mktemp -d -t sas.mon.XXXXXXXX)

required_vars=("AIRGAP_REGISTRY" "CR_USERNAME" "CR_PASSWORD")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        log_error "ERROR: Environment variable $var is not set."
        log_error "Please set it using: export $var=VALUE"
        exit 1
    fi
done

COMPONENT_FILE=$(find "$HOME" -type f -name "component_versions.env" | head -n 1)
ARTIFACT_FILE=$(find "$HOME" -type f -name "ARTIFACT_INVENTORY.md" | head -n 1)

if [[ ! -f $COMPONENT_FILE ]]; then
    log_error "ERROR: component_versions.env not found: $COMPONENT_FILE"
    exit 1
fi

if [[ ! -f $ARTIFACT_FILE ]]; then
    log_error "ERROR: ARTIFACT_INVENTORY.md not found: $ARTIFACT_FILE"
    exit 1
fi

log_info "docker login ""$AIRGAP_REGISTRY"" -u ""$CR_USERNAME"" -p ___"
docker login "$AIRGAP_REGISTRY" -u "$CR_USERNAME" -p "$CR_PASSWORD"

log_info "Parsing $COMPONENT_FILE"
echo

log_notice "# Step 1 - Import Images"
echo

TABLE1_CONTENTS=$(awk '
    /Table 1\./ {found=1}
    found && /Fully Qualified Container-Image Name/ {start=1; next}
    start && /^\|/ {
        if ($0 ~ /^[[:space:]]*\|[[:space:]\-|:]*\|[[:space:]\-|:]*\|/) next
        print
    }
    start && NF==0 { exit }
' "$ARTIFACT_FILE")

while IFS='|' read -r _ _ _ fullimage _; do
    full_image=$(echo "$fullimage" | xargs)

    [[ $full_image == "Full Qualified Container-Image Name"* ]] && continue
    [[ -z $full_image ]] && continue

    if [[ $full_image == "registry.redhat.io/openshift4/ose-oauth-proxy:latest" ]]; then
        log_warn "Skipping image: $full_image"
        echo
        continue
    fi

    repo_image="${full_image#*/}"

    log_verbose "docker pull ""${full_image}"""
    docker pull "${full_image}"
    echo
    log_verbose "docker tag ""${full_image}"" ""$AIRGAP_REGISTRY""/""${repo_image}"""
    docker tag "${full_image}" "$AIRGAP_REGISTRY"/"${repo_image}"
    echo
    log_verbose "docker push ""$AIRGAP_REGISTRY""/""${repo_image}"""
    docker push "$AIRGAP_REGISTRY"/"${repo_image}"
    echo
done <<< "$TABLE1_CONTENTS"
echo

log_notice "# Step 2 - Helm Repo Add Commands"
echo

declare -A REPO_URLS

TABLE2_CONTENTS=$(awk '
    /Table 2\./ {found=1}
    found && /^\| Subsystem \| Component \| Helm Repository \| Helm Repository URL \|/ {start=1; next}
    start && NF==0 {exit}
    start
' "$ARTIFACT_FILE")

while IFS='|' read -r _ _ _ repo url _; do
    repo=$(echo "$repo" | xargs)
    url=$(echo "$url" | xargs)

    [[ $repo == "Helm Repository" ]] && continue
    [[ -z $repo || -z $url ]] && continue

    REPO_URLS["$repo"]="$url"
done <<< "$TABLE2_CONTENTS"
echo

grep -E "_CHART_REPO" "$COMPONENT_FILE" | while IFS='=' read -r _ val; do
    repo_name="${val%%|*}"
    repo_url="${REPO_URLS[$repo_name]}"

    if [[ -z $repo_url ]]; then
        log_warn "No URL for repo '$repo_name'. Skipping."
        echo
        continue
    fi

    log_info "helm repo add ""${repo_name}"" ""${repo_url}"""
    helm repo add "${repo_name}" "${repo_url}"
done
echo

log_notice "# Step 3 - Helm Pull Commands"
echo

TABLE3_CONTENTS=$(awk '
    /Table 3\./ {found=1}
    found && /Helm Chart Repository/ && /Helm Chart Name/ {start=1; next}
    start && /^\|/ {
        if ($0 ~ /^[[:space:]]*\|[[:space:]\-|:]*\|[[:space:]\-|:]*\|/) next
        print
    }
    start && NF==0 { exit }
' "$ARTIFACT_FILE")

log_info "helm repo update"
helm repo update
echo

while IFS='|' read -r _ _ _ repo chart version archive _; do
    repo_name=$(echo "$repo" | xargs)
    chart_name=$(echo "$chart" | xargs)
    version=$(echo "$version" | xargs)

    [[ $repo_name == "Helm Chart Repository" ]] && continue
    [[ -z $repo_name || -z $chart_name || -z $version ]] && continue

    log_verbose "helm pull --destination ""$TMP_DIR"" --version ""${version}"" ""${repo_name}""/""${chart_name}"""
    helm pull --destination "$TMP_DIR" --version "${version}" "${repo_name}"/"${chart_name}"
done <<< "$TABLE3_CONTENTS"
echo

log_notice "# Step 4 - Helm Chart Push"
echo

log_info "helm registry login ""$AIRGAP_REGISTRY"" -u ""$CR_USERNAME"" -p ___"
helm registry login "$AIRGAP_REGISTRY" -u "$CR_USERNAME" -p "$CR_PASSWORD"
echo

while IFS='|' read -r _ _ _ repo chart version archive _; do
    repo_name=$(echo "$repo" | xargs)
    archive_name=$(basename "$(echo "$archive" | xargs)")

    [[ $repo_name == "Helm Chart Repository" ]] && continue
    [[ -z $repo_name || -z $archive_name ]] && continue

    log_verbose "helm push ""$TMP_DIR""/""${archive_name}"" oci://""$AIRGAP_REGISTRY""/""${repo_name}"""
    helm push "$TMP_DIR"/"${archive_name}" oci://"$AIRGAP_REGISTRY"/"${repo_name}"
done <<< "$TABLE3_CONTENTS"
echo

cleanup

echo
log_notice "Script Complete."
echo
