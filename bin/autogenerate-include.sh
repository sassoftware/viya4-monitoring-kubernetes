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
    # Inputs: fqdn, path, [appGroupSegment]
    # Returns:  fqdn to applicaiton
    #
    # appGroupSegment is optional and only used for default FQDN construction
    # (producing "$app.$appGroupSegment.$BASE_DOMAIN" for host-based, or
    # "$appGroupSegment.$BASE_DOMAIN" for path-based, instead of plain
    # "$app.$BASE_DOMAIN"/"$BASE_DOMAIN"). Gateway API's ListenerSet needs it
    # for both routing modes: two namespaces sharing one Gateway each need a
    # distinguishable hostname for their own listener/TLS cert (host-based:
    # SNI can't disambiguate two fully-wildcard listeners on the same port;
    # path-based: two ListenerSets can't claim the identical bare BASE_DOMAIN
    # either -- see create_listenerset), so monitoring's and logging's apps
    # can't share one flat BASE_DOMAIN the way Contour's HTTPProxy allows (it
    # has no equivalent tenant-level listener object to collide). Omit it (as
    # Contour/ingress-nginx callers do) to keep prior behavior unchanged.
    local app_fqdn app_path appGroupSegment

    app_fqdn=$1
    app_path=$2
    appGroupSegment=$3

    if [ -z "$app_fqdn" ]; then
        if [ "$ROUTING" == "host" ]; then
            if [ -n "$appGroupSegment" ]; then
                app_fqdn="$app_path.$appGroupSegment.$BASE_DOMAIN"
            else
                app_fqdn="$app_path.$BASE_DOMAIN"
            fi
        else
            if [ -n "$appGroupSegment" ]; then
                app_fqdn="$appGroupSegment.$BASE_DOMAIN"
            else
                app_fqdn="$BASE_DOMAIN"
            fi
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
    local app_group secretName namespace any_apps_enabled

    any_apps_enabled=false

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
                yq -i '(.spec.includes[] | select(.name == "v4m-osd") | .namespace) = "'"$namespace"'"' "$resourceDefFile"
            fi
            any_apps_enabled="true"

        else
            #Access to OpenSearch Dashboards is disabled, delete include block for it
            yq -i e 'del(.spec.includes[] |select(.name == "v4m-osd"))' "$resourceDefFile"
        fi

        if [ "$OPENSEARCH_INGRESS_ENABLE" == "true" ]; then
            yq -i '.spec.includes += [{"name": "v4m-search","namespace": "'"$namespace"'"}]' "$resourceDefFile"
            any_apps_enabled="true"

        fi
    elif [ "$app_group" == "monitoring" ]; then

        if [ "$GRAFANA_INGRESS_ENABLE" == "true" ]; then
            if [ "$namespace" != "monitoring" ]; then
                #need to update the namespace
                yq -i '(.spec.includes[] | select(.name == "v4m-grafana") | .namespace) = "'"$namespace"'"' "$resourceDefFile"

            fi

            any_apps_enabled="true"
        else
            #Access to Grafana is disabled, delete include block for it
            yq -i e 'del(.spec.includes[] |select(.name == "v4m-grafana"))' "$resourceDefFile"
        fi

        if [ "$ALERTMANAGER_INGRESS_ENABLE" == "true" ]; then
            yq -i '.spec.includes += [{"name": "v4m-alertmanager","namespace": "'"$namespace"'"}]' "$resourceDefFile"
            any_apps_enabled="true"
        fi

        if [ "$PROMETHEUS_INGRESS_ENABLE" == "true" ]; then
            yq -i '.spec.includes += [{"name": "v4m-prometheus","namespace": "'"$namespace"'"}]' "$resourceDefFile"
            any_apps_enabled="true"
        fi
    else
        log_error "Invalid application group [$app_group] passed to function [create_root_httpproxy]"
        return 1
    fi

    if [ "$any_apps_enabled" == "true" ]; then
        kubectl --namespace "$namespace" apply -f "$resourceDefFile"
        kubectl -n "$namespace" label httpproxy "v4m-${app_group}-root-proxy" managed-by="v4m-es-script"
    else
        #remove a root proxy instance created earlier (if it exists)
        kubectl -n "$namespace" delete httpproxy "v4m-${app_group}-root-proxy" --ignore-not-found
    fi
}
export -f create_root_httpproxy

function create_listenerset {

    # ####################################################### #
    # developed/tested with gateway-api sample version: 0.1.0 #
    # ####################################################### #

    ### create_listenerset  APP_GRP  NAMESPACE  [SECRET_NAME]
    ### create_listenerset  monitoring monitoring

    local app_group namespace secretName routing sampleFile resourceDefFile targetFqdn

    app_group="${1}" # logging|monitoring
    namespace="${2}"
    secretName="${3:-v4m-ingress-tls-secret}"

    routing="${ROUTING:-host}"

    sampleFile="samples/gateway-api/${routing}-based/$app_group/listenerset.yaml"
    resourceDefFile="$TMP_DIR/${app_group}_listenerset_def_file.yaml"
    touch "$resourceDefFile"

    # shellcheck disable=SC2016
    yq -i eval-all '. as $item ireduce ({}; . * $item )' "$resourceDefFile" "$sampleFile"

    snippet="$GATEWAY_NAME" yq -i '.spec.parentRef.name=env(snippet)' "$resourceDefFile"
    snippet="$GATEWAY_NAMESPACE" yq -i '.spec.parentRef.namespace=env(snippet)' "$resourceDefFile"
    snippet="$secretName" yq -i '.spec.listeners.[0].tls.certificateRefs.[0].name=env(snippet)' "$resourceDefFile"

    BASE_DOMAIN="${BASE_DOMAIN:-notset}"

    if [ "$routing" == "path" ]; then
        # One shared hostname per namespace (e.g. monitoring.$BASE_DOMAIN).
        targetFqdn="$app_group.$BASE_DOMAIN"
    else
        # Host-based: each app's HTTPRoute carries its own concrete hostname
        # ("$app.$app_group.$BASE_DOMAIN", see get_app_ingress_fqdn), so the
        # listener just needs a wildcard that covers all of them for this
        # namespace. It can't be a flat "*.$BASE_DOMAIN": monitoring and
        # logging share BASE_DOMAIN, and SNI can't disambiguate two
        # completely overlapping wildcard listeners on the same port between
        # namespaces (reason: HostnameConflict) -- the per-namespace segment
        # ("*.$app_group.$BASE_DOMAIN") keeps the two apart.
        targetFqdn="*.$app_group.$BASE_DOMAIN"
    fi
    # strenv (not env): a host-based hostname starts with "*", which env()
    # would parse as a YAML anchor alias rather than a literal string.
    snippet="$targetFqdn" yq -i '.spec.listeners.[0].hostname=strenv(snippet)' "$resourceDefFile"
    snippet="$targetFqdn" yq -i '.spec.listeners.[1].hostname=strenv(snippet)' "$resourceDefFile"

    kubectl apply -f "$resourceDefFile" -n "$namespace"
    kubectl -n "$namespace" label listenerset v4m-listenerset managed-by="v4m-es-script"
}
export -f create_listenerset

function create_httproute {

    # ####################################################### #
    # developed/tested with gateway-api sample version: 0.1.0 #
    # ####################################################### #

    local app_group app_prefix fqdn path secretName targetFqdn resourceDefFile routing namespace oldPathToken

    app_group="${1}"
    app_prefix="${2}"
    path="${3}"
    fqdn="${4}"
    # secretName is accepted for signature parity with create_httpproxy, but is
    # unused: Gateway API terminates TLS on the ListenerSet, not the HTTPRoute.
    secretName="${5:-v4m-ingress-tls-secret}"

    routing="${ROUTING:-host}"

    sampleFile="samples/gateway-api/${routing}-based/$app_group/${app_prefix}_httproute.yaml"

    # Construct host for application URL
    targetFqdn="$(get_app_ingress_fqdn "$fqdn" "$path" "$app_group")"

    resourceDefFile="$TMP_DIR/${app_prefix}_httproute_def_file.yaml"
    touch "$resourceDefFile"

    #intialized the yaml file w/appropriate gateway-api sample
    # shellcheck disable=SC2016
    yq -i eval-all '. as $item ireduce ({}; . * $item )' "$resourceDefFile" "$sampleFile"

    if [ "$app_group" == "logging" ]; then
        namespace="${LOG_NS:-logging}"
    else
        namespace="${MON_NS:-monitoring}"
    fi

    if [ "$routing" == "host" ]; then
        # The ListenerSet's wildcard listener only covers
        # "*.$app_group.$BASE_DOMAIN" (see create_listenerset) -- an
        # explicit FQDN override (e.g. GRAFANA_FQDN) that doesn't fall
        # within that pattern would otherwise get applied anyway and sit
        # permanently broken (Accepted: False, reason: NoMatchingListenerHostname)
        # with no indication until something downstream (e.g.
        # show_app_url.sh) happens to check status.
        if [[ $targetFqdn != *".$app_group.$BASE_DOMAIN" ]]; then
            log_error "FQDN [$targetFqdn] for [$app_group/$app_prefix] does not fall under *.${app_group}.${BASE_DOMAIN}, the hostname pattern the [$app_group] ListenerSet's listener actually covers."
            log_error "The resulting HTTPRoute would never match that listener (reason: NoMatchingListenerHostname). Set a value ending in .$app_group.$BASE_DOMAIN, or change BASE_DOMAIN."
            return 1
        fi
        snippet="$targetFqdn" yq -i '.spec.hostnames.[0]=env(snippet)' "$resourceDefFile"
    else
        oldPathToken="$(yq '.spec.rules.[0].matches.[0].path.value' "$resourceDefFile")"
        if [ "$oldPathToken" != "/$path" ]; then
            sed -i.bak "s#${oldPathToken}#/${path}#g" "$resourceDefFile"
            rm -f "${resourceDefFile}.bak"
        fi
    fi

    kubectl apply -f "$resourceDefFile" -n "$namespace"
}
export -f create_httproute

function create_http_redirect_httproute {

    # ####################################################### #
    # developed/tested with gateway-api sample version: 0.1.0 #
    # ####################################################### #

    ### create_http_redirect_httproute  APP_GRP  NAMESPACE
    ### create_http_redirect_httproute  monitoring monitoring

    local app_group namespace routing sampleFile resourceDefFile

    app_group="${1}" # logging|monitoring
    namespace="${2}"

    routing="${ROUTING:-host}"

    sampleFile="samples/gateway-api/${routing}-based/$app_group/http-redirect_httproute.yaml"
    resourceDefFile="$TMP_DIR/${app_group}_http_redirect_httproute_def_file.yaml"
    touch "$resourceDefFile"

    # shellcheck disable=SC2016
    yq -i eval-all '. as $item ireduce ({}; . * $item )' "$resourceDefFile" "$sampleFile"

    kubectl apply -f "$resourceDefFile" -n "$namespace"
    kubectl -n "$namespace" label httproute v4m-http-redirect managed-by="v4m-es-script"
}
export -f create_http_redirect_httproute

function get_backend_tls_hostname {

    ### get_backend_tls_hostname  NAMESPACE  SECRET_NAME

    # Prints the first non-"localhost" DNS SAN on the cert in SECRET_NAME, for
    # use as BackendTLSPolicy's validation.hostname. Works for both the
    # cert-manager and openssl TLS flows without needing to know which is
    # active. Prints nothing if the secret is missing or the cert has no SAN.

    local namespace secretName certPem

    namespace="${1}"
    secretName="${2}"

    if ! kubectl -n "$namespace" get secret "$secretName" -o name > /dev/null 2>&1; then
        return 1
    fi

    certPem="$(kubectl -n "$namespace" get secret "$secretName" -o jsonpath='{.data.tls\.crt}' 2> /dev/null | base64 -d 2> /dev/null)"

    if [ -z "$certPem" ]; then
        return 1
    fi

    echo "$certPem" | openssl x509 -noout -ext subjectAltName 2> /dev/null \
        | grep -oE 'DNS:[^,]+' | sed 's/^DNS://' | grep -v '^localhost$' | head -1
}
export -f get_backend_tls_hostname

function apply_backend_tls_policy {

    ### apply_backend_tls_policy  NAMESPACE  POLICY_NAME  SERVICE_NAME  TLS_SECRET_NAME  [CA_CONFIGMAP_NAME]

    # The CA ConfigMap is derived from TLS_SECRET_NAME's own ca.crt, not
    # guessed from some other secret in the namespace. Both TLS flows
    # (openssl and cert-manager) put the CA that actually signed a given
    # backend's cert into that same backend's own Secret -- apps in the same
    # namespace commonly share one CA by default, but USER_DIR overrides
    # (deploy_issuers/deploy_app_cert honor USER_DIR for exactly this) can
    # give one app a different CA than another. Picking a CA from an
    # unrelated secret in the namespace would silently validate the wrong
    # one once that happens.

    local namespace policyName serviceName tlsSecretName caConfigMapName hostname caCertB64 caFile

    namespace="${1}"
    policyName="${2}"
    serviceName="${3}"
    tlsSecretName="${4}"
    caConfigMapName="${5:-${policyName}-ca-certs}"

    # Callers can invoke this before TLS_SECRET_NAME actually exists (e.g.
    # deploy_opensearch.sh applies ingress/BackendTLSPolicy resources before
    # create_tls_certs runs later in the same script) or before cert-manager
    # has finished issuing it. Poll for up to 2 minutes before giving up,
    # rather than failing (or silently skipping) on what's often just a
    # not-ready-yet race.
    local tlsWaitAttempt
    hostname=""
    for tlsWaitAttempt in $(seq 1 24); do
        hostname="$(get_backend_tls_hostname "$namespace" "$tlsSecretName")"
        caCertB64="$(kubectl -n "$namespace" get secret "$tlsSecretName" -o jsonpath='{.data.ca\.crt}' 2> /dev/null)"
        [ -n "$hostname" ] && [ -n "$caCertB64" ] && break
        sleep 5
    done

    if [ -z "$hostname" ]; then
        log_error "Could not determine a SAN to validate for BackendTLSPolicy [$policyName] after waiting ${tlsWaitAttempt}x5s; secret [$namespace/$tlsSecretName] is missing or its cert has no usable SAN."
        # bin/renew-tls-certs.sh's actual renewal case (not its -r restart-only
        # mode) only accepts the ALL-MON/ALL-LOG group targets -- individual
        # app names are only valid with -r. Point at the correct group,
        # chosen by namespace, rather than suggesting a target that would
        # just fail.
        if [ "$namespace" == "$LOG_NS" ]; then
            log_error "If the cert generator failed to issue this cert, try: ./bin/renew-tls-certs.sh -t ALL-LOG"
        else
            log_error "If the cert generator failed to issue this cert, try: ./bin/renew-tls-certs.sh -t ALL-MON"
        fi
        exit 1
    fi

    if [ -z "$caCertB64" ]; then
        log_error "Secret [$namespace/$tlsSecretName] has no ca.crt after waiting ${tlsWaitAttempt}x5s; cannot create BackendTLSPolicy [$policyName]'s CA ConfigMap."
        exit 1
    fi

    caFile="$TMP_DIR/${policyName}-ca.crt"
    echo "$caCertB64" | base64 -d > "$caFile"

    kubectl -n "$namespace" delete configmap "$caConfigMapName" --ignore-not-found
    kubectl -n "$namespace" create configmap "$caConfigMapName" --from-file=ca.crt="$caFile"
    kubectl -n "$namespace" label configmap "$caConfigMapName" managed-by="v4m-es-script"

    log_debug "Using hostname [$hostname] and CA from secret [$namespace/$tlsSecretName] for BackendTLSPolicy [$policyName]"

    kubectl -n "$namespace" apply -f - << EOF
apiVersion: gateway.networking.k8s.io/v1
kind: BackendTLSPolicy
metadata:
  name: $policyName
spec:
  targetRefs:
    - group: ""
      kind: Service
      name: $serviceName
  validation:
    caCertificateRefs:
      - group: ""
        kind: ConfigMap
        name: $caConfigMapName
    hostname: $hostname
EOF
    kubectl -n "$namespace" label backendtlspolicy "$policyName" managed-by="v4m-es-script" --overwrite

    # kubectl apply succeeding only means the API server accepted the
    # resource, not that the GatewayClass's controller actually implements
    # BackendTLSPolicy -- there's no reliable way to check that up front
    # (GatewayClass.status.supportedFeatures exists but is optional to
    # report; Envoy Gateway, which this sample is developed against, doesn't
    # populate it despite genuinely supporting BackendTLSPolicy). So check
    # the applied policy's own status instead: if the controller rejected or
    # never acknowledged it, say so now rather than silently assuming
    # backend TLS is active.
    local attempt accepted reason
    accepted=""
    for attempt in 1 2 3 4 5; do
        accepted="$(kubectl -n "$namespace" get backendtlspolicy "$policyName" \
            -o jsonpath='{.status.ancestors[0].conditions[?(@.type=="Accepted")].status}' 2> /dev/null)"
        [ "$accepted" == "True" ] && break
        sleep 1
    done

    if [ "$accepted" != "True" ]; then
        reason="$(kubectl -n "$namespace" get backendtlspolicy "$policyName" \
            -o jsonpath='{.status.ancestors[0].conditions[?(@.type=="Accepted")].reason}' 2> /dev/null)"
        log_warn "BackendTLSPolicy [$namespace/$policyName] was applied but has not been Accepted after $attempt attempts (status: ${accepted:-no status reported}${reason:+, reason: $reason})."
        log_warn "Backend TLS for [$serviceName] may not actually be active; check 'kubectl -n $namespace describe backendtlspolicy $policyName' and confirm your GatewayClass's controller supports BackendTLSPolicy."
    fi
}
export -f apply_backend_tls_policy

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

        if [ "$INGRESS_TYPE" != "ingress-nginx" ] && [ "$INGRESS_TYPE" != "contour" ] && [ "$INGRESS_TYPE" != "gateway-api" ]; then
            log_error "Invalid INGRESS_TYPE value, valid values are 'ingress-nginx', 'contour' or 'gateway-api'"
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
        elif [ "$INGRESS_TYPE" == "gateway-api" ]; then

            if [ -z "$GATEWAY_CLASS_NAME" ]; then
                log_error "Required parameter [GATEWAY_CLASS_NAME] not provided"
                exit 1
            fi

            if [ -z "$GATEWAY_NAMESPACE" ]; then
                log_error "Required parameter [GATEWAY_NAMESPACE] not provided"
                exit 1
            fi

            if [ -z "$GATEWAY_NAME" ]; then
                log_error "Required parameter [GATEWAY_NAME] not provided"
                exit 1
            fi

            # verify required Gateway API CRDs available
            for crd in gatewayclasses.gateway.networking.k8s.io \
                gateways.gateway.networking.k8s.io \
                listenersets.gateway.networking.k8s.io \
                httproutes.gateway.networking.k8s.io; do
                if ! kubectl get crd "$crd" 1> /dev/null 2>&1; then
                    log_error "Ingress type [gateway-api] specified but required CRD [$crd] is not installed"
                    exit 1
                fi
            done
            log_debug "Required Gateway API CRDs installed"

            # verify the GatewayClass exists and is Accepted
            gatewayClassAccepted="$(kubectl get gatewayclass "$GATEWAY_CLASS_NAME" \
                -o jsonpath='{.status.conditions[?(@.type=="Accepted")].status}' 2> /dev/null)"

            if [ -z "$gatewayClassAccepted" ]; then
                log_error "GatewayClass [$GATEWAY_CLASS_NAME] specified in GATEWAY_CLASS_NAME does NOT exist"
                exit 1
            elif [ "$gatewayClassAccepted" != "True" ]; then
                log_error "GatewayClass [$GATEWAY_CLASS_NAME] is not in an 'Accepted: True' state"
                exit 1
            fi
            log_debug "GatewayClass [$GATEWAY_CLASS_NAME] exists and is Accepted"

            # Verify a Gateway named $GATEWAY_NAME using this GatewayClass
            # exists in $GATEWAY_NAMESPACE. This is expected to be a single
            # shared, platform-managed Gateway. We never create or modify it;
            # instead monitoring/logging each attach their own ListenerSet to
            # it (see create_listenerset), which is how they bring their own
            # host name and TLS cert without the Gateway owner provisioning
            # anything on their behalf.
            gatewayClassInUse="$(kubectl -n "$GATEWAY_NAMESPACE" get gateway "$GATEWAY_NAME" \
                -o jsonpath='{.spec.gatewayClassName}' 2> /dev/null)"

            if [ -z "$gatewayClassInUse" ]; then
                log_error "No Gateway named [$GATEWAY_NAME] was found in namespace [$GATEWAY_NAMESPACE]"
                log_error "The Gateway resource must be created by the platform/cluster administrator before enabling AUTOGENERATE_INGRESS with INGRESS_TYPE=gateway-api."
                log_error "It must be named [$GATEWAY_NAME] (see GATEWAY_NAME) in namespace [$GATEWAY_NAMESPACE] (see GATEWAY_NAMESPACE) -- the generated ListenerSets' parentRef is set to that name/namespace."
                exit 1
            elif [ "$gatewayClassInUse" != "$GATEWAY_CLASS_NAME" ]; then
                log_error "Gateway [$GATEWAY_NAME] in namespace [$GATEWAY_NAMESPACE] uses GatewayClass [$gatewayClassInUse], not [$GATEWAY_CLASS_NAME] as specified in GATEWAY_CLASS_NAME"
                exit 1
            fi
            log_debug "Found Gateway [$GATEWAY_NAME] using GatewayClass [$GATEWAY_CLASS_NAME] in namespace [$GATEWAY_NAMESPACE]"

            # Verify the Gateway actually allows ListenerSets to attach from
            # outside its own namespace. This is a separate field from
            # listeners[].allowedRoutes (which gates HTTPRoute attachment to a
            # Gateway's own listeners directly, not used here); without this,
            # our ListenerSet attaches silently nowhere even though the
            # Gateway itself looks otherwise correct.
            allowedListenersPolicy="$(kubectl -n "$GATEWAY_NAMESPACE" get gateway "$GATEWAY_NAME" \
                -o jsonpath='{.spec.allowedListeners.namespaces.from}' 2> /dev/null)"

            if [ "$allowedListenersPolicy" != "All" ] && [ "$allowedListenersPolicy" != "Selector" ]; then
                log_error "Gateway [$GATEWAY_NAME] in namespace [$GATEWAY_NAMESPACE] has spec.allowedListeners.namespaces.from set to [${allowedListenersPolicy:-None (unset)}]"
                log_error "That rejects our ListenerSet from attaching to it. It must be [All] or a namespace Selector that matches our namespace."
                exit 1
            fi

            # "Selector" alone doesn't guarantee OUR namespace matches it --
            # build the equivalent kubectl label-selector string from
            # spec.allowedListeners.namespaces.selector and confirm it
            # actually selects LOG_NS/MON_NS (whichever this driver script
            # set), rather than only checking the policy *type*.
            if [ "$allowedListenersPolicy" == "Selector" ]; then
                gatewayYamlFile="$TMP_DIR/gateway_def_file.yaml"
                kubectl -n "$GATEWAY_NAMESPACE" get gateway "$GATEWAY_NAME" -o yaml > "$gatewayYamlFile" 2> /dev/null

                selectorParts=()
                while IFS= read -r labelPair; do
                    [ -n "$labelPair" ] && selectorParts+=("$labelPair")
                done < <(yq -r '.spec.allowedListeners.namespaces.selector.matchLabels // {} | to_entries | .[] | .key + "=" + .value' "$gatewayYamlFile")

                while IFS='|' read -r exprKey exprOp exprValues; do
                    [ -z "$exprKey" ] && continue
                    case "$exprOp" in
                    In) selectorParts+=("$exprKey in ($exprValues)") ;;
                    NotIn) selectorParts+=("$exprKey notin ($exprValues)") ;;
                    Exists) selectorParts+=("$exprKey") ;;
                    DoesNotExist) selectorParts+=("!$exprKey") ;;
                    esac
                done < <(yq -r '.spec.allowedListeners.namespaces.selector.matchExpressions // [] | .[] | .key + "|" + .operator + "|" + (.values // [] | join(","))' "$gatewayYamlFile")

                namespaceSelectorString="$(
                    IFS=,
                    echo "${selectorParts[*]}"
                )"

                for ourNamespace in "$LOG_NS" "$MON_NS"; do
                    if [ -z "$ourNamespace" ]; then
                        continue
                    fi
                    if ! kubectl get namespace -l "$namespaceSelectorString" -o name 2> /dev/null | grep -qx "namespace/$ourNamespace"; then
                        log_error "Gateway [$GATEWAY_NAME] in namespace [$GATEWAY_NAMESPACE] restricts attachment to namespaces matching selector [$namespaceSelectorString], which namespace [$ourNamespace] does NOT match"
                        # The deploy scripts create $ourNamespace themselves if
                        # it doesn't already exist, but never apply labels to
                        # it -- there's no safe, generic way to derive label
                        # values that satisfy an arbitrary selector. If
                        # [$ourNamespace] doesn't exist yet, create it and
                        # apply matching labels yourself before running the
                        # deploy scripts; the scripts will reuse it as-is.
                        log_error "Label namespace [$ourNamespace] to match that selector before running the deploy scripts, or have the Gateway's spec.allowedListeners.namespaces.from set to [All]"
                        exit 1
                    fi
                    log_debug "Namespace [$ourNamespace] matches Gateway [$GATEWAY_NAME]'s allowedListeners namespace selector"
                done
            fi

            # Gateway API has no root-resource concept
            INGRESS_CREATE_ROOT_PROXY="false"

            # Unlike Contour (one HTTPProxy/cert per app), the ListenerSet
            # terminates TLS once per app-group namespace (see
            # create_listenerset) and create_httproute never takes a
            # secretName override -- there's no per-app cert to apply here.
            # Reject the setting rather than silently ignoring it.
            if [ "$INGRESS_USE_SEPARATE_CERTS" == "true" ]; then
                log_error "INGRESS_USE_SEPARATE_CERTS=true is not supported with INGRESS_TYPE=gateway-api"
                log_error "Gateway API terminates TLS once per app-group's ListenerSet, not per app; there is no per-app certificate to apply"
                exit 1
            fi
            INGRESS_USE_SEPARATE_CERTS="false"
            # Defaults to whatever TLS_ENABLE already is (itself defaulted by
            # monitoring/bin/common.sh or logging/bin/common.sh before this
            # runs), falling back to true only if that's unset too: app
            # backends only serve HTTPS -- and thus only need a
            # BackendTLSPolicy -- when TLS_ENABLE says they do. Defaulting
            # this independently of TLS_ENABLE would try to apply backend TLS
            # for a plaintext backend whenever TLS_ENABLE=false, which can't
            # succeed (no TLS Secret/SAN ever exists) and now hard-fails the
            # deploy (see apply_backend_tls_policy). An explicit
            # INGRESS_BACKEND_TLS_ENABLE still wins either way.
            INGRESS_BACKEND_TLS_ENABLE="${INGRESS_BACKEND_TLS_ENABLE:-${TLS_ENABLE:-true}}"

            if [ "$INGRESS_BACKEND_TLS_ENABLE" == "true" ]; then
                if ! kubectl get crd backendtlspolicies.gateway.networking.k8s.io 1> /dev/null 2>&1; then
                    log_error "INGRESS_BACKEND_TLS_ENABLE is [true] but CRD [backendtlspolicies.gateway.networking.k8s.io] is not installed"
                    log_error "Without BackendTLSPolicy the gateway sends plaintext to a TLS-only backend and every request fails; set INGRESS_BACKEND_TLS_ENABLE=false if that's intentional"
                    exit 1
                fi

                backendTLSPolicyServedVersions="$(kubectl get crd backendtlspolicies.gateway.networking.k8s.io \
                    -o jsonpath='{range .spec.versions[?(@.served==true)]}{.name}{" "}{end}' 2> /dev/null)"

                if ! echo "$backendTLSPolicyServedVersions" | grep -qw "v1"; then
                    log_error "INGRESS_BACKEND_TLS_ENABLE is [true] but CRD [backendtlspolicies.gateway.networking.k8s.io] does not serve [v1] (serves: ${backendTLSPolicyServedVersions:-none})"
                    log_error "The generated BackendTLSPolicy uses apiVersion gateway.networking.k8s.io/v1; set INGRESS_BACKEND_TLS_ENABLE=false if your cluster only serves an older version"
                    exit 1
                fi
                log_debug "CRD [backendtlspolicies.gateway.networking.k8s.io] installed and serves [v1]"
            fi

            export INGRESS_BACKEND_TLS_ENABLE GATEWAY_CLASS_NAME GATEWAY_NAME GATEWAY_NAMESPACE
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
