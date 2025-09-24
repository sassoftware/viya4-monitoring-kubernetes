# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
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

    # determine nodePort or clusterPort (ingress)
    service_type=$(get_k8s_info "$namespace" "service/$service" "$json_service_type")

    if [ "$service_type" == "ClusterIP" ]; then
        get_ingress_ports

        url=$(get_ingress_url "$namespace" "$ingress")

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
