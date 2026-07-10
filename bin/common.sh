# shellcheck disable=SC2148
# Copyright © 2021-2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

function trap_add() {
    # based on https://stackoverflow.com/questions/3338030/multiple-bash-traps-for-the-same-signal
    # but: prepends new cmd rather than append it, changed var names and eliminated messages

    local cmd_to_add signal

    cmd_to_add=$1
    shift
    for signal in "$@"; do
        trap -- "$(
            # print the new trap command
            printf '%s\n' "${cmd_to_add}"
            # helper fn to get existing trap command from output
            # of trap -p
            # shellcheck disable=SC2329,SC2317
            extract_trap_cmd() { printf '%s\n' "$3"; }
            # print existing trap command with newline
            eval "extract_trap_cmd $(trap -p "${signal}")"
        )" "${signal}"
    done
}

function errexit_msg {
    if [ -o errexit ]; then
        log_error "Exiting script [$(basename "$0")] due to an error executing the command [$BASH_COMMAND]."
    else
        log_debug "Trap [ERR] triggered in [$(basename "$0")] while executing the command [$BASH_COMMAND]."
    fi
}

function checkYqVersion {
    # confirm yq installed and correct version
    local yq_version yq_required_version
    yq_required_version="4.45.1"

    if which yq &> /dev/null; then

        yq_version=$(yq --version | sed -n 's!^yq (https://github.com/mikefarah/yq/) version!!p')

        if semver_check "$yq_version" LT "$yq_required_version"; then
            log_error "Incorrect version [$yq_version] found; version [$yq_required_version] or higher required."
            return 1
        else
            log_debug "A valid version [$yq_version] of yq detected"
            return 0
        fi
    else
        log_error "Required component [yq] not available."
        return 1
    fi
}

function semver_parse {
    ## This function returns string values containing the requested
    ## portions of the semantic version string passed to it
    ##
    ## If the passed string is NOT a valid semantic version string,
    ## this function returns nothing and sets a non-zero exit code

    local string fragment
    string=$1
    fragment=${2:-ECHO}

    if [[ $string =~ v?([0-9]+)\.([0-9]+)\.([0-9]+)(-(([0-9]+|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\.([0-9]+|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(\+([0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*))?$ ]]; then
        case "$fragment" in
        major | MAJOR)
            echo "${BASH_REMATCH[1]}"
            ;;
        minor | MINOR)
            echo "${BASH_REMATCH[2]}"
            ;;
        patch | PATCH)
            echo "${BASH_REMATCH[3]}"
            ;;
        prerelease | PRERELEASE)
            # BASH_REMATCH[4] includes the leading "-"
            echo "${BASH_REMATCH[5]}"
            ;;
        buildmeta | BUILDMETA)
            # BASH_REMATCH[9] includes the leading "+"
            echo "${BASH_REMATCH[10]}"
            ;;
        full | FULL)
            echo "${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
            ;;
        ECHO)
            echo "$string"
            ;;
        *)
            #invalid fragment specified
            return 1
            ;;
        esac
    else
        #invalid string (i.e. NOT valid semVer)
        return 1
    fi

}

function semver_check {
    ## This function tests the passed version string to validate it
    ## matches the specified criteria and sets its exit code to indicate
    ## success (returns a 0) or failure (returns a 1)

    local ver2check checkType baseline_ver additional_value
    ver2check=$1             #semver value to check
    checkType=${2:-VALID}    #type of check: VALID|EQ(IS)|NE(NOT)|GE(MIN)|LE(MAX)|GT|LT|MINORSKEW|PATTERN,
    baseline_ver=$3          #"baseline" semver (ver2check is compared against this one)
    additional_value=${4:-0} #additional value (used for some checkType)

    local v1maj v1min v1pat v1full v2maj v2min v2pat v2full minordiff minorskew
    local semver_re='^v?([0-9]+)\.([0-9]+)\.([0-9]+)(-(([0-9]+|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\.([0-9]+|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(\+([0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*))?$'

    # Parse ver2check once
    if [[ $ver2check =~ $semver_re ]]; then
        v1maj=${BASH_REMATCH[1]}
        v1min=${BASH_REMATCH[2]}
        v1pat=${BASH_REMATCH[3]}
        v1full="$v1maj.$v1min.$v1pat"
    else
        return 1
    fi

    if [ -z "$baseline_ver" ] && [ "$checkType" != "PATTERN" ]; then
        if [[ $baseline_ver =~ $semver_re ]]; then
            v2maj=${BASH_REMATCH[1]}
            v2min=${BASH_REMATCH[2]}
            v2pat=${BASH_REMATCH[3]}
            v2full="$v2maj.$v2min.$v2pat"
        else
            return 1
        fi
    fi

    case "$checkType" in
    "GE" | "MIN" | "GT" )
        #NOTE: GE/MIN and GT are NOT synonyms!
        # When baseline and val2check match...
        #   GE/MIN: returns 0 (success)
        #   GT: returns 1 (failure)

        ((v1maj > v2maj)) && return 0
        ((v1maj < v2maj)) && return 1

        ((v1min > v2min)) && return 0
        ((v1min < v2min)) && return 1

        ((v1pat > v2pat)) && return 0
        ((v1pat < v2pat)) && return 1

        if [ "$checkType" == "GT" ]; then
            return 1
        else
            return 0
        fi
        ;;
    "LE" | "MAX" | "LT")
        #NOTE: LE/MAX and LT are NOT synonyms!
        # When baseline and val2check match...
        #   LE/MAX: returns 0 (success)
        #   LT: returns 1 (failure)

        ((v1maj < v2maj)) && return 0
        ((v1maj > v2maj)) && return 1

        ((v1min < v2min)) && return 0
        ((v1min > v2min)) && return 1

        ((v1pat < v2pat)) && return 0
        ((v1pat > v2pat)) && return 1

        if [ "$checkType" == "LT" ]; then
            return 1
        else
            return 0
        fi
        ;;
    "EQ" | "IS")
        # NOTE: Tests that the specified value
        #       matches the baseline

        if [ "$v1full" == "$v2full" ]; then
            return 0
        else
            return 1
        fi
        ;;
    "NE" | "NOT")
        # NOTE: Tests that the specified value
        #       does NOT match the baseline

        if [ "$v1full" == "$v2full" ]; then
            return 1
        else
            return 0
        fi
        ;;
    "MINORSKEW")
        #NOTE: MINORSKEY tests whether the MINOR version
        #      is within the specified range of the baseline

        ((v1maj < v2maj)) && return 1
        minordiff=$((v2min - v1min))
        minorskew=${minordiff#-}
        if ((minorskew > additional_value)); then
            return 1
        else
            return 0
        fi
        ;;
    "PATTERN" )
        # Compares val2check against a pattern
        #   Pattern MUST be 3-level semVer-like value
        #   but can contain 'x' as placeholder for any
        #   level.

        local semver_re2='^v?([x0-9]+)\.([x0-9]+)\.([x0-9]+)$'
        if [[ $baseline_ver =~ $semver_re2 ]]; then
            v2maj=${BASH_REMATCH[1]}
            v2min=${BASH_REMATCH[2]}
            v2pat=${BASH_REMATCH[3]}
        else
            #invalid pattern specified
            return 2
        fi

        if [ "$v2maj" != "x" ]; then
            ((v1maj != v2maj)) && return 1
        fi

        if [ "$v2min" != "x" ]; then
            ((v1min != v2min)) && return 1
        fi

        if [ "$v2pat" != "x" ]; then
            ((v1pat != v2pat)) && return 1
        fi

        return 0
        ;;

    "VALID")
        # NOTE: Tests that the specified value
        #       is a valid semVer value
        # Basically, a no-op since invalid value would have failed above
        return 0
        ;;
    *)
        #invalid/unknown checkType
        return 2
        ;;
    esac
}

export -f semver_parse semver_check

if [ "$SAS_COMMON_SOURCED" = "" ]; then
    # Save standard out to a new descriptor
    exec 3>&1

    # Includes
    source bin/colors-include.sh
    source bin/log-include.sh
    source bin/openshift-include.sh

    if [ ! "$(which sha256sum)" ]; then
        log_error "Missing required utility: sha256sum"
        exit 1
    fi

    # Load component Helm chart version infomation
    # NOTE: This is loaded prior to the USER_DIR to allow
    # overriding these defaults via USER_DIR user.env files
    if [ -f "component_versions.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' component_versions.env | grep -v '^#' | xargs)
        if [ "$userEnv" != "" ]; then
            log_debug "Loading global user environment file: component_versions.env"
            if [ "$userEnv" != "" ]; then
                # shellcheck disable=SC2163,SC2086
                export $userEnv
            fi
        fi
    else
        log_debug "No component_versions.env file found"
    fi

    if [ "$V4M_OMIT_IMAGE_KEYS" == "true" ]; then
        log_warn "******This feature is NOT intended for use outside the project maintainers*******"
        log_warn "Environment variable V4M_OMIT_IMAGE_KEYS set to [true]; container image information from component_versions.env will be ignored."
    fi

    export USER_DIR=${USER_DIR:-$(pwd)}
    if [ -d "$USER_DIR" ]; then
        # Resolve full path
        USER_DIR=$(
            cd "$(dirname "$USER_DIR")" || exit
            pwd
        )/$(basename "$USER_DIR")
        export USER_DIR
    fi
    if [ -f "$USER_DIR/user.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' "$USER_DIR"/user.env | grep -v '^#' | xargs)
        if [ "$userEnv" != "" ]; then
            log_debug "Loading global user environment file: $USER_DIR/user.env"
            if [ "$userEnv" != "" ]; then
                # shellcheck disable=SC2163,SC2086
                export $userEnv
            fi
        fi
    fi

    log_debug "Working directory: $(pwd)"
    log_info "User directory: $USER_DIR"

    export AIRGAP_DEPLOYMENT=${AIRGAP_DEPLOYMENT:-false}

    CHECK_HELM=${CHECK_HELM:-true}
    if [ "$CHECK_HELM" == "true" ]; then
        source bin/helm-include.sh
        log_verbose "Helm client version: $HELM_VER_FULL"
    fi

    CHECK_KUBERNETES=${CHECK_KUBERNETES:-true}
    if [ "$CHECK_KUBERNETES" == "true" ]; then
        source bin/kube-include.sh

        log_verbose Kubernetes client version: "$KUBE_CLIENT_VER"
        log_verbose Kubernetes server version: "$KUBE_SERVER_VER"

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

    # set TLS Cert Generator (cert-manager|openssl)
    export CERT_GENERATOR="${CERT_GENERATOR:-openssl}"

    # Set default timeout for kubectl namespace delete command
    export KUBE_NAMESPACE_DELETE_TIMEOUT=${KUBE_NAMESPACE_DELETE_TIMEOUT:-5m}

    TMP_DIR=$(mktemp -d -t sas.mon.XXXXXXXX)
    export TMP_DIR
    if [ ! -d "$TMP_DIR" ]; then
        log_error "Could not create temporary directory [$TMP_DIR]"
        exit 1
    fi
    log_debug "Temporary directory: [$TMP_DIR]"
    echo "# This file intentionally empty" > "$TMP_DIR"/empty.yaml

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
    trap_add cleanup EXIT

    trap_add errexit_msg ERR

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

function validateTenantID {
    tenantID=$1
    reservedNames=(default provider shared sharedservices spre uaa viya)

    CHECK_TENANT_NAME=${CHECK_TENANT_NAME:-true}
    if [ "$CHECK_TENANT_NAME" == "true" ]; then
        if [[ $tenantID =~ ^[a-z]([a-z0-9]){0,15}$ ]]; then
            if [[ $tenantID =~ ^sas ]]; then
                log_error "Tenant names cannot start with 'sas'"
                exit 1
            fi
            for n in "${reservedNames[@]}"; do
                if [ "$tenantID" == "$n" ]; then
                    log_error "The tenant name [$tenantID] is a reserved name"
                    exit 1
                fi
            done
        else
            log_error "[$tenantID] is not a valid tenant name"
            exit 1
        fi
    else
        log_debug "Tenant name validation is disabled"
    fi
}

function validateNamespace {
    local namespace
    namespace="$1"
    if [[ $namespace =~ ^[a-z0-9]([\-a-z0-9]*[a-z0-9])?$ ]]; then
        log_debug "Namespace [$namespace] passes validation"
    else
        log_error "[$namespace] is not a valid namespace name"
        exit 1
    fi
}

function randomPassword {
    date +%s | sha256sum | base64 | head -c 32
    echo
}

function disable_sa_token_automount {
    local ns sa_name should_disable
    ns=$1
    sa_name=$2
    should_disable=${SEC_DISABLE_SA_TOKEN_AUTOMOUNT:-true}

    if [ "$should_disable" == "true" ]; then
        if [ -n "$(kubectl -n "$ns" get serviceAccount "$sa_name" -o name 2> /dev/null)" ]; then
            log_debug "Disabling automount of API tokens for serviceAccount [$ns/$sa_name]"
            kubectl -n "$ns" patch serviceAccount "$sa_name" -p '{"automountServiceAccountToken":false}'
        else
            log_debug "ServiceAccount [$ns/$sa_name] not found. Skipping patch"
        fi
    else
        log_debug "NOT disabling token automount serviceAccount [$ns/$sa_name]; SEC_DISABLE_SA_TOKEN_AUTOMOUNT set to [$SEC_DISABLE_SA_TOKEN_AUTOMOUNT]"
    fi
}

function enable_pod_token_automount {
    local ns resource_type resource_name should_disable
    ns=$1
    resource_type=$2
    resource_name=$3
    should_disable=${SEC_DISABLE_SA_TOKEN_AUTOMOUNT:-true}

    if [ "$should_disable" == "true" ]; then
        log_debug "Enabling automount of API tokens for pods deployed via [$resource_type/$resource_name]"

        if [ "$resource_type" == "daemonset" ] || [ "$resource_type" == "deployment" ]; then
            kubectl -n "$ns" patch "$resource_type" "$resource_name" -p '{"spec": {"template": {"spec": {"automountServiceAccountToken":true}}}}'
        else
            log_error "Invalid request to function [${FUNCNAME[0]}]; unsupported resource_type [$resource_type]"
            return 1
        fi
    else
        log_debug "NOT enabling token automount on pods for [$ns/$resource_type/$resource_name]; SEC_DISABLE_SA_TOKEN_AUTOMOUNT set to [$SEC_DISABLE_SA_TOKEN_AUTOMOUNT]"
    fi
}

export -f checkDefaultStorageClass
export -f validateTenantID
export -f validateNamespace
export -f randomPassword
export -f trap_add
export -f errexit_msg
export -f disable_sa_token_automount
export -f enable_pod_token_automount
export -f checkYqVersion

function parseFullImage {
    # shellcheck disable=SC2034
    fullImage="$1"
    unset REGISTRY REPOS IMAGE VERSION FULL_IMAGE_ESCAPED

    if [[ $1 =~ (.*)\/(.*)\/(.*)\:(.*) ]]; then
        REGISTRY="${BASH_REMATCH[1]}"
        REPOS="${BASH_REMATCH[2]}"
        IMAGE="${BASH_REMATCH[3]}"
        VERSION="${BASH_REMATCH[4]}"
        # shellcheck disable=SC2034
        FULL_IMAGE_ESCAPED="$REGISTRY\/$REPOS\/$IMAGE\:$VERSION"
        return 0
    else
        log_warn "Invalid value for full container image; does not fit expected pattern [$1]."
        return 1
    fi
}

function v4m_replace {

    if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
        sed -i '' "s;$1;$2;g" "$3"
    else
        sed -i "s;$1;$2;g" "$3"
    fi
}

function generateImageKeysFile {

    #arg1 Full container image
    #arg2 name of template file
    #arg3 prefix to insert in placeholders (optional; defaults to "")
    #arg4 flag to override omit_image_key logic (optional; defaults to "false")

    #NOTE: arg4 is required to handle 2 initContainers (for OpenSearch and Fluent Bit)
    #      for which the template file contains settings other than image specs

    local pullsecret_text

    if ! parseFullImage "$1"; then
        log_error "Unable to parse full image [$1]"
        return 1
    fi

    prefix=${3:-""}
    ignoreOmitImageKeys=${4:-"false"}

    imageKeysFile="$TMP_DIR/imageKeysFile.yaml"
    template_file=$2

    if [ "$template_file" != "$imageKeysFile" ]; then
        rm -f "$imageKeysFile"
        cp "$template_file" "$imageKeysFile"
    else
        log_debug "Modifying an existing imageKeysFile"
    fi

    if [ "$V4M_OMIT_IMAGE_KEYS" == "true" ] && [ "$ignoreOmitImageKeys" != "true" ]; then
        cp "$TMP_DIR"/empty.yaml "$imageKeysFile"
        return 0
    fi

    if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
        GLOBAL_REGISTRY_OSBUG="$AIRGAP_REGISTRY"
        GLOBAL_REGISTRY="$AIRGAP_REGISTRY"
        REGISTRY="$AIRGAP_REGISTRY"

        if [ -n "$AIRGAP_IMAGE_PULL_SECRET_NAME" ]; then
            pullsecrets_text="[name: ""$AIRGAP_IMAGE_PULL_SECRET_NAME""]"
            pullsecret_text="$AIRGAP_IMAGE_PULL_SECRET_NAME"
        else
            pullsecrets_text="[]"
            pullsecret_text="null"
        fi
    else
        GLOBAL_REGISTRY_OSBUG='docker.io'
        GLOBAL_REGISTRY="null"
        pullsecrets_text="[]"
        pullsecret_text="null"
    fi

    v4m_pullPolicy=${V4M_PULL_POLICY:-"IfNotPresent"}

    v4m_replace "__${prefix}GLOBAL_REGISTRY_OSBUG__" "$GLOBAL_REGISTRY_OSBUG" "$imageKeysFile"
    v4m_replace "__${prefix}GLOBAL_REGISTRY__" "$GLOBAL_REGISTRY" "$imageKeysFile"
    v4m_replace "__${prefix}IMAGE_REGISTRY__" "$REGISTRY" "$imageKeysFile"
    v4m_replace "__${prefix}IMAGE_REPO_3LEVEL__" "$REGISTRY\/$REPOS\/$IMAGE" "$imageKeysFile"
    v4m_replace "__${prefix}IMAGE_REPO_2LEVEL__" "$REPOS\/$IMAGE" "$imageKeysFile"
    v4m_replace "__${prefix}IMAGE__" "$IMAGE" "$imageKeysFile"
    v4m_replace "__${prefix}IMAGE_TAG__" "$VERSION" "$imageKeysFile"
    v4m_replace "__${prefix}IMAGE_PULL_POLICY__" "$v4m_pullPolicy" "$imageKeysFile"
    v4m_replace "__${prefix}IMAGE_PULL_SECRET__" "$pullsecret_text" "$imageKeysFile"   #Handle Charts Accepting a Single Image Pull Secret
    v4m_replace "__${prefix}IMAGE_PULL_SECRETS__" "$pullsecrets_text" "$imageKeysFile" #Handle Charts Accepting Multiple Image Pull Secrets

    return 0
}

export -f parseFullImage
export -f v4m_replace
export -f generateImageKeysFile
