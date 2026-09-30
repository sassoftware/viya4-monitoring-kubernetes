# Copyright © 2021-2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# shellcheck disable=SC2148
# This script is not intended to be run directly

source bin/common.sh

# k8s object: ingress
json_ingress_host='{.spec.rules[0].host}'
json_ingress_path='{.spec.rules[0].http.paths[0].path}'
json_ingress_tls='{.spec.tls[0]}'

# k8s object: service
json_service_type='{.spec.type}'
json_service_nodeport='{.spec.ports[0].nodePort}'
json_service_http_port='{.spec.ports[?(@.name=="http")].port}'
json_service_https_port='{.spec.ports[?(@.name=="https")].port}'

# k8s object: route (OpenShift)
json_route_host='{.spec.host}'
json_route_path='{.spec.path}'
json_route_tls='{.spec.tls.termination}'

# k8s object: contour HTTPProxy
json_contour_host='{.spec.virtualhost.fqdn}'
json_contour_path='{.spec.routes[0].conditions[0].prefix}'
json_contour_tls='{.spec.virtualhost.tls}'
json_contour_currentStatus='{.status.currentStatus}'
json_contour_errorMessage='{.status.conditions[0].errors[0].message}'

# k8s object: Gateway API HTTPRoute
# host-based routes set spec.hostnames[0]; path-based routes don't set
# hostnames at all (they match by path only, on whatever hostname the parent
# Gateway serves), so json_httproute_host is empty for those.
json_httproute_host='{.spec.hostnames[0]}'
json_httproute_path='{.spec.rules[*].matches[?(@.path.type=="PathPrefix")].path.value}'
json_httproute_parentName='{.spec.parentRefs[0].name}'
json_httproute_parentNamespace='{.spec.parentRefs[0].namespace}'
json_httproute_accepted='{.status.parents[0].conditions[?(@.type=="Accepted")].status}'
json_httproute_acceptedReason='{.status.parents[0].conditions[?(@.type=="Accepted")].reason}'
json_httproute_resolvedRefs='{.status.parents[0].conditions[?(@.type=="ResolvedRefs")].status}'
json_httproute_resolvedRefsReason='{.status.parents[0].conditions[?(@.type=="ResolvedRefs")].reason}'

# misc k8s information
metadata_name='{.metadata.name}'

function get_k8s_info {
    local namespace object jsonpath info

    namespace=$1
    object=$2
    jsonpath=$3

    info=$(kubectl -n "$namespace" get "$object" -o=jsonpath="$jsonpath" 2> /dev/null)

    if [ -n "$info" ]; then
        echo "$info"
    else
        v4m_rc=1
        echo ""
    fi
}
function check_httpproxy_status {
    local namespace name status

    namespace=$1
    name=$2

    status=$(get_k8s_info "$namespace" "httpproxy/$name" "$json_contour_currentStatus")

    echo "$status"
}

function get_httpproxy_error {
    local namespace name msg

    namespace=$1
    name=$2

    msg=$(get_k8s_info "$namespace" "httpproxy/$name" "$json_contour_errorMessage")

    echo "$msg"
}

function get_root_httpproxy {
    local namespace name root_httpproxy
    namespace=$1
    name=$2

    # shellcheck disable=SC2016
    root_httpproxy="$(kubectl get httpproxy -A -o=yaml | yq '.items[] | select(.spec.includes[] | select(.namespace=="'"$namespace"'" and .name=="'"$name"'")) | "\(.metadata.namespace)/\(.metadata.name)"')"

    if [ -z "$root_httpproxy" ] || [ "$root_httpproxy" == "/" ]; then
        echo " "
        return
    else
        echo "$root_httpproxy"
    fi

}

function get_contour_url {
    local namespace name host path tls scheme root_httpproxy root_namespace root_name url

    namespace=$1
    name=$2

    path=$(get_k8s_info "$namespace" "httpproxy/$name" "$json_contour_path")

    host=$(get_k8s_info "$namespace" "httpproxy/$name" "$json_contour_host")

    if [ -z "$host" ]; then

        # potentially path-based; need to try and find the root HTTProxy
        root_httpproxy="$(get_root_httpproxy "$namespace" "$name")"

        if [ -n "$root_httpproxy" ]; then

            # a  root HTTPProxy was found!

            IFS="/" read -r root_namespace root_name <<< "$root_httpproxy"

            host=$(get_k8s_info "$root_namespace" "httpproxy/$root_name" "$json_contour_host")
            tls=$(get_k8s_info "$root_namespace" "httpproxy/$root_name" "$json_contour_tls")
        else
            # a root HTTPProxy not found; error out for now.
            v4m_rc=1
            echo ""
            return
        fi
    else
        tls=$(get_k8s_info "$namespace" "httpproxy/$name" "$json_contour_tls")
    fi

    if [ -n "$tls" ]; then
        scheme="https"
    else
        scheme="http"
    fi

    if [ -n "$host" ]; then
        url="$scheme://$host$path"
        echo "$url"
        return
    else
        # a root HTTPProxy not found; error out for now.
        v4m_rc=1
        echo ""
        return
    fi
}

function get_gateway_listener_hostname {
    # Returns the first non-wildcard HTTPS listener hostname on a Gateway, or
    # empty if there isn't one (e.g. the Gateway has no hostname restriction,
    # or only a wildcard) -- either way, not something we can build a concrete
    # browsable URL from.
    local namespace name hostname

    namespace=$1
    name=$2

    hostname="$(kubectl -n "$namespace" get gateway "$name" \
        -o jsonpath='{.spec.listeners[?(@.protocol=="HTTPS")].hostname}' 2> /dev/null \
        | tr ' ' '\n' | grep -v '^\*' | head -1)"

    echo "$hostname"
}

function get_httproute_url {
    local namespace name host path scheme parentName parentNamespace url

    namespace=$1
    name=$2

    path=$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_path")
    [ -z "$path" ] && path="/"

    host=$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_host")

    if [ -z "$host" ]; then
        # path-based route: no hostname on the route itself, so it's whatever
        # hostname the parent Gateway serves. Only usable if that's a
        # concrete (non-wildcard) hostname.
        parentName=$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_parentName")
        parentNamespace=$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_parentNamespace")
        [ -z "$parentNamespace" ] && parentNamespace="$namespace"

        if [ -n "$parentName" ]; then
            host="$(get_gateway_listener_hostname "$parentNamespace" "$parentName")"
        fi

        if [ -z "$host" ]; then
            v4m_rc=1
            echo ""
            return
        fi
    fi

    # All app HTTPRoutes shipped in this sample attach to the Gateway's HTTPS
    # listener; there's no per-route TLS toggle in Gateway API (see
    # samples/gateway-api/README.md).
    scheme="https"

    url="$scheme://$host$path"
    url="${url%/}" # strip any trailing "/", matching get_ingress_url/get_route_url
    echo "$url"
}

function check_httproute_status {
    local namespace name accepted resolvedRefs

    namespace=$1
    name=$2

    accepted="$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_accepted")"
    resolvedRefs="$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_resolvedRefs")"

    if [ "$accepted" == "True" ] && [ "$resolvedRefs" == "True" ]; then
        echo "valid"
    else
        echo "invalid"
    fi
}

function get_httproute_error {
    local namespace name accepted acceptedReason resolvedRefs resolvedRefsReason msg

    namespace=$1
    name=$2

    accepted="$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_accepted")"
    resolvedRefs="$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_resolvedRefs")"

    msg=""
    if [ "$accepted" != "True" ]; then
        acceptedReason="$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_acceptedReason")"
        msg="Accepted=${accepted:-Unknown} (${acceptedReason:-no status reported})"
    fi
    if [ "$resolvedRefs" != "True" ]; then
        resolvedRefsReason="$(get_k8s_info "$namespace" "httproute/$name" "$json_httproute_resolvedRefsReason")"
        [ -n "$msg" ] && msg="$msg; "
        msg="${msg}ResolvedRefs=${resolvedRefs:-Unknown} (${resolvedRefsReason:-no status reported})"
    fi

    echo "$msg"
}

function get_ingress_ports {
    if [ -z "$ingress_http_port" ]; then

        ingress_namespace="${NGINX_NS:-ingress-nginx}"

        ingress_service="service/${NGINX_SVCNAME:-ingress-nginx-controller}"

        ingress_http_port=$(get_k8s_info "$ingress_namespace" "$ingress_service" "$json_service_http_port")
        if [ "$ingress_http_port" == "80" ]; then
            ingress_http_port=""
        fi

        ingress_https_port=$(get_k8s_info "$ingress_namespace" "$ingress_service" "$json_service_https_port")
        if [ "$ingress_https_port" == "443" ]; then
            ingress_https_port=""
        fi
    fi
}

function get_ingress_url {
    local namespace name host path tls_info port porttxt protocol

    namespace=$1
    name=$2

    if [ ! "$(kubectl -n "$namespace" get ingress/"$name" 2> /dev/null)" ]; then
        # ingress object does not exist
        v4m_rc=1
        echo ""
        return
    fi

    host=$(get_k8s_info "$namespace" "ingress/$name" "$json_ingress_host")
    if [ -z "$host" ]; then
        v4m_rc=1
        echo ""
        return
    fi

    path=$(get_k8s_info "$namespace" "ingress/$name" "$json_ingress_path")
    if [ -z "$path" ]; then
        v4m_rc=1
        echo ""
        return
    fi

    tls_info=$(get_k8s_info "$namespace" "ingress/$name" "$json_ingress_tls")
    if [ -n "$tls_info" ]; then
        port=$ingress_https_port
        protocol=https
    else
        port=$ingress_http_port
        protocol=http
    fi

    if [ -n "$port" ]; then
        porttxt=":$port"
    fi

    url="$protocol://${host}${porttxt}${path}"

    url="${url%/}" # strip any trailing "/"
    echo "$url"
}

function get_route_url {
    local host tls_enabled protocol url

    namespace=$1
    service=$2

    host=$(get_k8s_info "$namespace" "route/$service" "$json_route_host")
    if [ -z "$host" ]; then
        v4m_rc=1
        echo ""
        return
    fi

    # OK if path is empty
    path=$(get_k8s_info "$namespace" "route/$service" "$json_route_path")

    tls_mode=$(get_k8s_info "$namespace" "route/$service" "$json_route_tls")
    if [ -z "$tls_mode" ]; then
        protocol="http"
    else
        protocol="https"
    fi

    url="$protocol://$host$path"
    url="${url%/}" # strip any trailing "/"

    echo "$url"
}

function get_nodeport_url {
    local host tls_enabled port porttxt protocol

    namespace=$1
    service=$2
    tls_enabled=$3

    if [ ! "$(kubectl -n "$namespace" get service/"$service" 2> /dev/null)" ]; then
        # ingress object does not exist
        v4m_rc=1
        echo ""
        return
    fi

    host="$(kubectl get node --selector='node-role.kubernetes.io/master' | awk 'NR==2 { print $1 }')"
    if [ -z "$host" ]; then
        host=$(kubectl get nodes | awk 'NR==2 { print $1 }') # use first node
    fi

    port=$(get_k8s_info "$namespace" "service/$service" "$json_service_nodeport")

    if [ "$tls_enabled" == "true" ]; then
        protocol=https
    else
        protocol=http
    fi

    if [ -n "$port" ]; then
        porttxt=":$port"
    fi

    url="$protocol://${host}${porttxt}"
    echo "$url"
}

function get_service_url {
    local namespace service use_tls ingress service_type url

    namespace=$1
    service=$2               # name of service
    use_tls=$3               # (optional - NodePort only) use http or https (ingress properties over-ride)
    ingress=${4:-${service}} # (optional) name of ingress/route object (default: $service)

    # is a route defined for this service?
    if [ "$OPENSHIFT_CLUSTER" == "true" ] && [ "$(kubectl -n "$namespace" get route/"$service" 2> /dev/null)" ]; then
        url=$(get_route_url "$namespace" "$service")

        if [ -z "$url" ]; then
            v4m_rc=1
            echo ""
            return
        else
            echo "$url"
            return
        fi
    fi

    # determine nodePort or clusterPort (ingress|contour)
    service_type=$(get_k8s_info "$namespace" "service/$service" "$json_service_type")

    if [ "$service_type" == "ClusterIP" ]; then

        if [ -n "$(get_k8s_info "$namespace" "httpproxy/$service" "$metadata_name")" ]; then
            #If an HTTPProxy resource exists - assume it is being used
            url=$(get_contour_url "$namespace" "$ingress")
        elif [ -n "$(get_k8s_info "$namespace" "httproute/$service" "$metadata_name")" ]; then
            #If an HTTPRoute resource exists - assume Gateway API is being used
            url=$(get_httproute_url "$namespace" "$ingress")
        else
            get_ingress_ports

            url=$(get_ingress_url "$namespace" "$ingress")
        fi

        if [ -z "$url" ]; then
            v4m_rc=1
            echo ""
            return
        else
            echo "$url"
        fi
    elif [ "$service_type" == "NodePort" ]; then
        url=$(get_nodeport_url "$namespace" "$service" "$use_tls")

        if [ -z "$url" ]; then
            v4m_rc=1
            echo ""
            return
        else
            echo "$url"
        fi
    else
        # uh-oh, how what?
        # shellcheck disable=SC2034
        v4m_rc=1
        echo ""
        return
    fi
}

# USAGE NOTES
#
# #Return code
# These functions always exit with a return code of 0.  If problems were encountered, they will return a
# null value and set the v4m_rc variable to 1.
#
# #Setting ingress_http_port and ingress_https_port variables
#
#    * The get_service_url function assumes variables ingress_http_port and ingress_https_port have been set
#    * call  get_ingress_ports function to set these variables or set them by hand
#
# # Sample usage:
#   grafana_url=$(get_service_url monitoring v4m-grafana  "/" "false")
#
# Returns generated URL or "" (null) string (if unable to generate URL)
#
