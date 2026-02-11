# Copyright © 2025-2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# shellcheck disable=SC2148
# This script is not intended to be run directly

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

function checkStorageClass {
    # input parms: $1  *Name of env var* identifying storageClass
    # input parms: $2  storageClass
    # NOTE: Using 2 vars b/c Mac doesn't support indirection (e.g. x="${!1}")

    local storageClass storageClassEnvVar
    storageClassEnvVar="$1"
    storageClass="${2:-$STORAGECLASS}"

    if [ -z "$storageClass" ]; then
        log_error "Required parameter not provided.  Either [$storageClassEnvVar] or [STORAGECLASS] MUST be provided."
        exit 1
    else
        # shellcheck disable=SC2091
        if $(kubectl get storageClass "$storageClass" -o name &> /dev/null); then
            log_debug "The specified StorageClass [$storageClass] exists"
        else
            log_error "The specified StorageClass [$storageClass] does NOT exist"
            exit 1
        fi
    fi

}
export -f checkStorageClass

function checkYqVersion {
    # confirm yq installed and correct version
    local goodver yq_version
    goodver="yq \(.+mikefarah.+\) version (v)?(4\.(3[2-9]|[4-9][0-9])\..+)"
    yq_version=$(yq --version)
    if [ "$?" == "1" ]; then
        log_error "Required component [yq] not available."
        return 1
    elif [[ ! $yq_version =~ $goodver ]]; then
        log_error "Incorrect version [$yq_version] found; version 4.32.2+ required."
        return 1
    else
        log_debug "A valid version [$yq_version] of yq detected"
        return 0
    fi
}
export -f checkYqVersion

function create_ingress_certs {
    local certFile keyFile namespace secretName

    namespace="$1"
    secretName="$2"
    certFile="${3:-$INGRESS_CERT}"
    keyFile="${4:-$INGRESS_KEY}"

    if [ -f "$certFile" ] && [ -f "$keyFile" ]; then
        kubectl delete secret "$secretName" --namespace "$namespace" --ignore-not-found
        kubectl create secret tls "$secretName" --namespace "$namespace" --key="$keyFile" --cert="$certFile"
        kubectl -n "$namespace" label secret "$secretName" managed-by="v4m-es-script"
    elif [ -n "$certFile$keyFile" ]; then
        log_warn "Missing Ingress certificate file; specified Ingress cert [$certFile] and/or key [$keyFile] file is missing."
        log_warn "Create the missing Kubernetes secrets after deployment; use command: kubectl create secret tls $secretName --namespace $namespace --key=cert_key_file --cert=cert_file"
    else
        # shellcheck disable=SC2091
        if $(kubectl get secret "$secretName" --namespace "$namespace" -o name &> /dev/null); then
            log_debug "Confirmed secret [$namespace/$secretName] exists"
        else
            log_warn "Unable to create Kubernetes secret [$namespace/$secretName]; no TLS certificate file information has been provided."
            log_warn "Create the missing Kubernetes secrets after deployment; use command: kubectl create secret tls $secretName --namespace $namespace --key=cert_key_file --cert=cert_file"
        fi
    fi
}
export -f create_ingress_certs

function get_app_ingress_fqdn {
    # Assumes ROUTING and BASE_DOMAIN set
    #
    # Inputs: fqdn, path
    # Returns:  fqdn to applicaiton
    #
    local app_fqdn app_path

    app_fqdn=$1
    app_path=$2

    if [ -z "$app_fqdn" ]; then
        if [ "$ROUTING" == "host" ]; then
            app_fqdn="$app_path.$BASE_DOMAIN"
        else
            app_fqdn="$BASE_DOMAIN"
        fi
    fi

    echo "$app_fqdn"
}
export -f get_app_ingress_fqdn

function create_httpproxy {

    # ################################################### #
    # developed/tested with contour sample version: 0.2.2 #
    # ################################################### #

    local app_group app_prefix fqdn path secretName targetFqdn resourceDefFile routing namespace

    app_group="${1}"
    app_prefix="${2}"
    path="${3}"
    fqdn="${4}"
    secretName="${5:-v4m-ingress-tls-secret}"

    routing="${ROUTING:-host}"

    sampleFile="samples/contour/${routing}-based/$app_group/${app_prefix}_httpproxy.yaml"

    # Construct host for application URL
    targetFqdn="$(get_app_ingress_fqdn "$fqdn" "$path")"

    resourceDefFile="$TMP_DIR/${app_prefix}_httpproxy_def_file.yaml"
    touch "$resourceDefFile"

    #intialized the yaml file w/appropriate contour sample
    # shellcheck disable=SC2016
    yq -i eval-all '. as $item ireduce ({}; . * $item )' "$resourceDefFile" "$sampleFile"

    if [ "$routing" == "host" ]; then

        snippet="$targetFqdn" yq -i '.spec.virtualhost.fqdn=env(snippet)' "$resourceDefFile"

        if [ "$INGRESS_USE_SEPARATE_CERTS" == "true" ]; then
            snippet="$secretName" yq -i '.spec.virtualhost.tls.secretName=env(snippet)' "$resourceDefFile"
        else
            log_debug "Using same ingress TLS certs [v4m-ingress-tls-secret] for all apps"
        fi
    else
        snippet="/$path" yq -i '.spec.routes.[0].conditions.[0].prefix=env(snippet)' "$resourceDefFile"

        if [ "$app_prefix" == "osd" ] || [ "$app_prefix" == "opensearch" ]; then
            snippet="/$path" yq -i '.spec.routes.[0].pathRewritePolicy.replacePrefix.[0].prefix=env(snippet)' "$resourceDefFile"
        fi
    fi

    if [ "$app_group" == "logging" ]; then
        namespace="${LOG_NS:-logging}"
    else
        namespace="${MON_NS:-monitoring}"
    fi

    kubectl apply -f "$resourceDefFile" -n "$namespace"
}
export -f create_httpproxy

function create_root_httpproxy {

    # ################################################### #
    # developed/tested with contour sample version: 0.2.2 #
    # ################################################### #

    ### create_root_httpproxy  APP_GRP  SECRET NAMESPACE
    ### create_root_httpproxy  LOGGING v4m-ingress-tls-secret logging

    ### Assumes set: BASE_DOMAIN
    local app_group secretName namespace

    app_group="${1}" # logging|monitoring
    namespace="${2}" # Namespace for the ROOT HTTPProxy resource

    if [ -n "$namespace" ]; then
        log_debug "Creating ROOT HTTPProxy resource for [$app_group] web apps in [$namespace] namespace"
    elif [ "$app_group" == "logging" ]; then
        namespace="${LOG_NS:-logging}"
    else
        namespace="${MON_NS:-monitoring}"
    fi

    if [ "$ROUTING" != "path" ]; then
        log_debug "Path-based routing not enabled; skipping 'root' HTTPProxy creation and removing any existing one in namespace"
        kubectl -n "$namespace" delete httpproxy v4m-"${app_group}"-root-proxy --ignore-not-found
        return
    fi

    sampleFile="samples/contour/path-based/$app_group/root_httpproxy.yaml"

    resourceDefFile="$TMP_DIR/${app_group}_root_httpproxy_def_file.yaml"
    touch "$resourceDefFile"

    BASE_DOMAIN="${BASE_DOMAIN:-notset}"

    #intialized the yaml file w/appropriate contour sample
    # shellcheck disable=SC2016
    yq -i eval-all '. as $item ireduce ({}; . * $item )' "$resourceDefFile" "$sampleFile"

    snippet="$app_group.$BASE_DOMAIN" yq -i '.spec.virtualhost.fqdn=env(snippet)' "$resourceDefFile"

    if [ "$app_group" == "logging" ]; then

        if [ "$OSD_INGRESS_ENABLE" == "true" ]; then
            if [ "$namespace" != "logging" ]; then
                #need to update the namespace
                yq -i '.spec.includes[] |select(.name == "v4m-osd").namespace= "'"$namespace"'"' "$resourceDefFile"
            fi
        else
            #Access to OpenSearch Dashboards is disabled, delete include block for it
            yq -i e 'del(.spec.includes[] |select(.name == "v4m-osd"))' "$resourceDefFile"
        fi

        if [ "$OPENSEARCH_INGRESS_ENABLE" == "true" ]; then
            yq -i '.spec.includes += [{"name": "v4m-search","namespace": "'"$namespace"'"}]' "$resourceDefFile"
        fi
    elif [ "$app_group" == "monitoring" ]; then

        if [ "$GRAFANA_INGRESS_ENABLE" == "true" ]; then
            if [ "$namespace" != "monitoring" ]; then
                #need to update the namespace
                yq -i '.spec.includes[] |select(.name == "v4m-grafana").namespace= "'"$namespace"'"' "$resourceDefFile"
            fi
        else
             #Access to Grafana is disabled, delete include block for it
            yq -i e 'del(.spec.includes[] |select(.name == "v4m-grafana"))' "$resourceDefFile"
        fi

        if [ "$ALERTMANAGER_INGRESS_ENABLE" == "true" ]; then
            yq -i '.spec.includes += [{"name": "v4m-alertmanager","namespace": "'"$namespace"'"}]' "$resourceDefFile"
        fi

        if [ "$PROMETHEUS_INGRESS_ENABLE" == "true" ]; then
            yq -i '.spec.includes += [{"name": "v4m-prometheus","namespace": "'"$namespace"'"}]' "$resourceDefFile"
        fi
    else
        log_error "Invalid application group [$app_group] passed to function [create_root_httpproxy]"
        return 1
    fi

    kubectl --namespace "$namespace" apply -f "$resourceDefFile"
    kubectl -n "$namespace" label httpproxy "v4m-${app_group}-root-proxy" managed-by="v4m-es-script"
}
export -f create_root_httpproxy

#
# Executing Script starts here
#

AUTOGENERATE_INGRESS="${AUTOGENERATE_INGRESS:-false}"
AUTOGENERATE_STORAGECLASS="${AUTOGENERATE_STORAGECLASS:-false}"
AUTOGENERATE_SMTP="${AUTOGENERATE_SMTP:-false}"

if [ "$AUTOGENERATE_INGRESS" != "true" ] && [ "$AUTOGENERATE_STORAGECLASS" != "true" ] && [ "$AUTOGENERATE_SMTP" != "true" ]; then
    log_debug "No autogeneration of YAML enabled"
    export AUTOGENERATE_SOURCED="NotNeeded"
fi

if [ -z "$AUTOGENERATE_SOURCED" ]; then

    if ! checkYqVersion; then
        exit 1
    fi

    if [ "$AUTOGENERATE_INGRESS" == "true" ]; then

        # Confirm NOT on OpenShift
        if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
            log_error "Setting AUTOGENERATE_INGRESS to 'true' is not valid on OpenShift clusters."
            log_error "Web applications will be made accessible via OpenShift routes instead (if enabled)."

            export AUTOGENERATE_INGRESS="false"
            exit 1
        fi

        #Required inputs:
        #   INGRESS_TYPE (default: ingress-nginx)
        #   BASE_DOMAIN  (default: -none- )
        #   ROUTING      (default: host)
        #   INGRESS_CERT (default: -none- )
        #   INGRESS_KEY  (default: -none- )

        INGRESS_TYPE="${INGRESS_TYPE:-ingress-nginx}"

        if [ "$INGRESS_TYPE" != "ingress-nginx" ] && [ "$INGRESS_TYPE" != "contour" ]; then
            log_error "Invalid INGRESS_TYPE value, valid values are 'ingress-nginx' or 'contour'"
            exit 1
        elif [ "$INGRESS_TYPE" == "contour" ]; then
            # verify Contour HTTPProxy CRDs available
            if kubectl get crd "httpproxies.projectcontour.io" 1> /dev/null 2>&1; then
                log_debug "Contour HTTPProxy CRD installed"
                INGRESS_CREATE_ROOT_PROXY="${INGRESS_CREATE_ROOT_PROXY:-true}"
                INGRESS_USE_SEPARATE_CERTS="${INGRESS_USE_SEPARATE_CERTS:-false}"
            else
                log_error "Ingress type [contour] specified but required CRDs are not installed"
                exit 1
            fi
        elif [ "$INGRESS_TYPE" == "ingress-nginx" ]; then
            INGRESS_CREATE_ROOT_PROXY="${INGRESS_CREATE_ROOT_PROXY:-false}"
            INGRESS_USE_SEPARATE_CERTS="${INGRESS_USE_SEPARATE_CERTS:-true}"
        fi

        if [ -z "$BASE_DOMAIN" ]; then
            log_error "Required parameter [BASE_DOMAIN] not provided"
            exit 1
        fi

        ROUTING="${ROUTING:-host}"

        if [ "$ROUTING" == "path" ]; then
            export MON_TLS_PATH_INGRESS="true"
            log_debug "Path ingress requested, setting MON_TLS_PATH_INGRESS to 'true'"
        elif [ "$ROUTING" != "host" ] && [ "$ROUTING" != "path" ]; then
            log_error "Invalid ROUTING value, valid values are 'host' or 'path'"
            exit 1
        fi

        if [ "$INGRESS_CERT/$INGRESS_KEY" != "/" ]; then
            if [ ! -f "$INGRESS_CERT" ] || [ ! -f "$INGRESS_KEY" ]; then
                # Only WARN b/c missing cert doesn't prevent deployment and it can be created afterwards
                log_warn "Missing Ingress certificate file; specified Ingress cert [$INGRESS_CERT] and/or key [$INGRESS_KEY] file is missing."
                log_warn "You can create the missing Kubernetes secrets after deployment. See Enable TLS for Ingress topic in Help Center documentation."

                #unset variable values to prevent further attempted use
                unset INGRESS_CERT
                unset INGRESS_KEY
            else
                log_debug "Ingress cert [$INGRESS_CERT] and key [$INGRESS_KEY] files exist."
            fi
        fi

        # export ingress-related settings
        export ROUTING INGRESS_TYPE INGRESS_CERT INGRESS_KEY INGRESS_USE_SEPARATE_CERTS INGRESS_CREATE_ROOT_PROXY

        # Set enable/disable flags for apps
        OSD_INGRESS_ENABLE="${OSD_INGRESS_ENABLE:-true}"
        OPENSEARCH_INGRESS_ENABLE="${OPENSEARCH_INGRESS_ENABLE:-false}"

        GRAFANA_INGRESS_ENABLE="${GRAFANA_INGRESS_ENABLE:-true}"
        PROMETHEUS_INGRESS_ENABLE="${PROMETHEUS_INGRESS_ENABLE:-false}"
        ALERTMANAGER_INGRESS_ENABLE="${ALERTMANAGER_INGRESS_ENABLE:-false}"

        #export ingress enable flags to ensure they are accessible to downstream processing
        export OSD_INGRESS_ENABLE OPENSEARCH_INGRESS_ENABLE
        export ALERTMANAGER_INGRESS_ENABLE GRAFANA_INGRESS_ENABLE PROMETHEUS_INGRESS_ENABLE

        log_info "Autogeneration of Ingress definitions has been enabled"

    fi

    if [ "$AUTOGENERATE_STORAGECLASS" == "true" ]; then
        log_info "Autogeneration of StorageClass specfication has been enabled"
    fi

    if [ "$AUTOGENERATE_SMTP" == "true" ]; then

        #required settings
        # SMTP_HOST - no default
        # SMTP_PORT - no default
        # SMTP_FROM_ADDRESS - no default
        # SMTP_FROM_NAME - no default

        #optional settings
        # SMTP_USER - no default
        # SMTP_PASSWORD - no default
        # SMTP_USER_SECRET - no default (default set in code below)
        SMTP_SKIP_VERIFY="${SMTP_SKIP_VERIFY:-false}"
        SMTP_TLS_CERT_FILE="${SMTP_TLS_CERT_FILE:-/cert/tls.crt}"
        SMTP_TLS_KEY_FILE="${SMTP_TLS_KEY_FILE:-/cert/tls.key}"

        log_info "Autogeneration of SMTP Configuration has been enabled"

        if [ -z "$SMTP_HOST" ]; then
            log_error "Required parameter [SMTP_HOST] not provided"
            exit 1
        fi

        if [ -z "$SMTP_PORT" ]; then
            log_error "Required parameter [SMTP_PORT] not provided"
            exit 1
        fi

        if [ -z "$SMTP_FROM_ADDRESS" ]; then
            log_error "Required parameter [SMTP_FROM_ADDRESS] not provided"
            exit 1
        fi

        if [ -z "$SMTP_FROM_NAME" ]; then
            log_error "Required parameter [SMTP_FROM_NAME] not provided"
            exit 1
        fi

        # Handle SMTP user credentials
        if [ -z "$SMTP_USER_SECRET" ] && [ -z "$SMTP_USER" ] && [ -z "$SMTP_PASSWORD" ]; then
            log_debug "SMTP_USER_SECRET, SMTP_USER and SMTP_PASSWORD are NOT set; skipping creation of secret [$SMTP_USER_SECRET]"
            # shellcheck disable=SC2034
            smtpCreateUserSecret="false"
        else
            if [ -z "$SMTP_USER_SECRET" ]; then
                SMTP_USER_SECRET="grafana-smtp-user"
            fi

            if [ -n "$(kubectl get secret -n "$MON_NS" "$SMTP_USER_SECRET" --ignore-not-found -o name 2> /dev/null)" ]; then
                log_debug "Secret [$SMTP_USER_SECRET] exists; will use it for SMTP user credentials"
                # shellcheck disable=SC2034
                smtpCreateUserSecret="false"
            elif [ -n "$SMTP_USER_SECRET" ] && [ -n "$SMTP_USER" ] && [ -n "$SMTP_PASSWORD" ]; then
                log_debug "Secret [$MON_NS/$SMTP_USER_SECRET] will need to be created later."
                # shellcheck disable=SC2034
                smtpCreateUserSecret="true"
            elif [ -n "$SMTP_USER_SECRET" ] && [ -z "$SMTP_USER" ] && [ -z "$SMTP_PASSWORD" ]; then
                log_error "The secret [$SMTP_USER_SECRET] specified in SMTP_USER_SECRET does NOT exist in [$MON_NS] namespace"
                exit 1
            else
                log_error "Complete SMTP Credentials NOT provided; MUST provide BOTH [SMTP_USER] and [SMTP_PASSWORD]"
                log_info "SMTP_USER is set to [$SMTP_USER] and SMTP_PASSWORD is set to [$SMTP_PASSWORD]"
                exit 1
            fi
        fi
    fi

    export AUTOGENERATE_SOURCED="true"

elif [ "$AUTOGENERATE_SOURCED" == "NotNeeded" ]; then
    log_debug "autogenerate-include.sh not needed"
else
    log_debug "autogenerate-include.sh was already sourced [$AUTOGENERATE_SOURCED]"
fi
