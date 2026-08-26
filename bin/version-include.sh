# Copyright © 2021,2026 SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# shellcheck disable=SC2148
# This script is not intended to be run directly

function populateValuesYAML() {
    v4mValuesYAML=$1
    rm -f "$v4mValuesYAML"
    touch "$v4mValuesYAML"

    # Attempt to obtain current git commit hash
    gitCommit=$(git rev-parse --short HEAD 2> /dev/null)
    if [ -n "$gitCommit" ]; then
        echo "gitCommit: $gitCommit" >> "$v4mValuesYAML"
        gitStatus=$(git status -s | sed 's/^ M/M/' | sed 's/^/  /')
        if [ -n "$gitStatus" ]; then
            echo "gitStatus: |" >> "$v4mValuesYAML"
            echo "$gitStatus" >> "$v4mValuesYAML"
        fi
    fi

    # List contents of USER_DIR
    if ! [[ $USER_DIR -ef "$(pwd)" ]]; then
        if [ -d "$USER_DIR" ]; then
            # shellcheck disable=SC2129
            echo '"user_dir":' >> "$v4mValuesYAML"
            echo "  path: $USER_DIR" >> "$v4mValuesYAML"
            echo '  files: |' >> "$v4mValuesYAML"
            # shellcheck disable=SC2207
            l=($(find "$USER_DIR" -type f | sort))
            for ((i = 0; i < ${#l[@]}; i++)); do
                fullPath=${l[i]}
                path=${fullPath#"$USER_DIR/"}
                echo "      $path" >> "$v4mValuesYAML"
            done
        fi

        # Top-level user.env contents
        if [ -f "$USER_DIR/user.env" ]; then
            echo '  "user.env": |' >> "$v4mValuesYAML"
            sed 's/^/      /' "$USER_DIR/user.env" >> "$v4mValuesYAML"
        fi
        # Monitoring user.env contents
        if [ -f "$USER_DIR/monitoring/user.env" ]; then
            echo '  "monitoring_user.env": |' >> "$v4mValuesYAML"
            sed 's/^/      /' "$USER_DIR/monitoring/user.env" >> "$v4mValuesYAML"
        fi
        # Logging user.env contents
        if [ -f "$USER_DIR/logging/user.env" ]; then
            echo '  "logging_user.env": |' >> "$v4mValuesYAML"
            sed 's/^/      /' "$USER_DIR/logging/user.env" >> "$v4mValuesYAML"
        fi
    fi

    # Encrypt passwords stored in V4M Helm Chart
    v4m_replace "GRAFANA_ADMIN_PASSWORD=.*" "GRAFANA_ADMIN_PASSWORD=***" "$v4mValuesYAML"
    v4m_replace "ES_ADMIN_PASSWD=.*" "ES_ADMIN_PASSWD=***" "$v4mValuesYAML"
    v4m_replace "LOG_LOGADM_PASSWD=.*" "LOG_LOGADM_PASSWD=***" "$v4mValuesYAML"
}

function deployV4MInfo() {
    NS=$1
    releaseName=${2:-'v4m'}
    if [ -z "$NS" ]; then
        log_error "No namespace specified for deploying SAS Viya Monitoring for Kubernetes version information"
        return 1
    fi

    valuesYAML=$TMP_DIR/v4mValues.yaml
    populateValuesYAML "$valuesYAML"

    log_info "Updating SAS Viya Monitoring for Kubernetes version information"
    # shellcheck disable=SC2086
    helm upgrade --install \
        -n "$NS" \
        --values $valuesYAML \
        $releaseName ./v4m-chart

    getHelmReleaseVersion "$NS" "$releaseName"
}

function removeV4MInfo() {
    NS=$1
    releaseName=${2:-'v4m'}
    if [ -z "$NS" ]; then
        log_error "No namespace specified for removing SAS Viya Monitoring for Kubernetes version information"
        return 1
    fi

    if [ -n "$(helm list -n "$NS" --filter "^$releaseName\$" -q)" ]; then
        log_info "Removing SAS Viya Monitoring for Kubernetes version information"
        helm uninstall -n "$NS" "$releaseName"
    fi
}

function getHelmReleaseVersion() {
    local namespace releaseName releaseVer

    namespace=$1
    releaseName=$2

    #(re-)initialize "output" vars
    helmchart_release_version_full=""
    helmchart_release_status=""

    if [ -z "$(helm list -n "$namespace" --filter "^$releaseName\$" -q)" ]; then
        log_debug "No [$releaseName] release found in [$namespace] namespace"
        helmchart_release_status="NOT FOUND"
    else
        releaseVer=$(helm list -n "$namespace" --filter "^$releaseName\$" -o yaml | yq '.[].chart')

        helmchart_release_version_full=$(semver_parse "$releaseVer" FULL)
        helmchart_release_status=$(helm list -n "$namespace" --filter "^$releaseName\$" -o yaml | yq '.[].status')
    fi
}
function getV4MVersion() {

    local namespace releaseName

    namespace=$1
    releaseName=$2

    getHelmReleaseVersion "$namespace" "$releaseName"

    V4M_CURRENT_STATUS="$helmchart_release_status"
    V4M_CURRENT_VERSION_FULL="$helmchart_release_version_full"
    V4M_CURRENT_VERSION_MAJOR=$(semver_parse "$helmchart_release_version_full" MAJOR)
    V4M_CURRENT_VERSION_MINOR=$(semver_parse "$helmchart_release_version_full" MINOR)
    V4M_CURRENT_VERSION_PATCH=$(semver_parse "$helmchart_release_version_full" PATCH)

    log_debug "V4M Release [$releaseName] version [$V4M_CURRENT_VERSION_FULL] current status [$V4M_CURRENT_STATUS]"
}

if [ -z "$V4M_VERSION_INCLUDE" ]; then

    export V4M_CURRENT_VERSION_FULL V4M_CURRENT_VERSION_MAJOR V4M_CURRENT_VERSION_MINOR V4M_CURRENT_VERSION_PATCH
    export V4M_CURRENT_STATUS
    export helmchart_release_version_full helmchart_release_status

    export -f deployV4MInfo removeV4MInfo getHelmReleaseVersion
    export V4M_VERSION_INCLUDE=true
fi
