#!/bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

source bin/common.sh

declare -A json_paths
# k8s object: ingress
json_paths["host"]='{.spec.rules[0].host}'
json_paths["path"]='{.spec.rules[0].http.paths[0].path}'
json_paths["tls"]='{.spec.tls[0]}'
# k8s object: service
json_paths["service_type"]='{.spec.type}'
json_paths["service_nodeport"]='{.spec.ports[0].nodePort}'
json_paths["service_http_port"]='{.spec.ports[?(@.name=="http")].port}'
json_paths["service_https_port"]='{.spec.ports[?(@.name=="https")].port}'
# k8s object: route (OpenShift)
json_paths["host"]='{.spec.host}'
json_paths["tls"]='{.spec.tls.termination}'

function get_k8s_info {
  local namespace object info_item info rc

  namespace=$1
  object=$2
  info_item=$3

  info=$(kubectl -n $namespace get $object  -o=jsonpath=${json_paths[$info_item]} 2>/dev/null)
  rc=$?

  if [ ! -z  "$info" ]; then
     echo "$info"
  else
     echo ""
     return 1
  fi
}

function get_ingress_ports {

  if [ -z "$ingress_http_port" ]; then

     ingress_namespace="${NGINX_NS:-ingress-nginx}"

     ingress_service="service/${NGINX_SVCNAME:-ingress-nginx-controller}"

     ingress_http_port=$(get_k8s_info "$ingress_namespace" "$ingress_service" "service_http_port")
     if [ -z "$ingress_http_port" ]; then
        ingress_http_port=80
     fi

     ingress_https_port=$(get_k8s_info "$ingress_namespace" "$ingress_service" "service_https_port")
     if [ -z "$ingress_https_port" ]; then
        ingress_https_port=443
     fi
  fi
}

function get_ingress_url {

  local namespace name host path tls_info rc port porttxt protocol

  namespace=$1
  name=$2

  if [ ! "$(kubectl -n $namespace  get ingress/$name 2>/dev/null)" ]; then
    # ingress object does not exist
    return 1
  fi

  host=$(get_k8s_info "$namespace" "ingress/$name" "host")
  if [ -z "$host" ]; then
     return 1
  fi

  path=$(get_k8s_info "$namespace" "ingress/$name" "path")
  if [ -z "$path" ]; then
     return 1
  fi

  tls_info=$(get_k8s_info "$namespace" "ingress/$name" "tls")
  rc=$?
  if [ "$rc" == "0" ]; then
     port=$ingress_https_port
     protocol=https
  else
     port=$ingress_http_port
     protocol=http
  fi

  if [ ! -z "$port" ]; then
     porttxt=":$port"
  fi

  url="$protocol://${host}${porttxt}${path}"
  echo "$url"
}

function get_route_url {

  local host tls_enabled protocol url

  namespace=$1
  service=$2

  # host=$(oc -n $LOG_NS get route v4m-es-kibana-svc -o=jsonpath='{.spec.host}')
  host=$(get_k8s_info "$namespace" "route/$service" "host")
  if [ -z "$host" ]; then
     echo ""
     return 1
  fi
  # tls_mode=$(oc -n $LOG_NS get route v4m-es-kibana-svc -o=jsonpath='{.spec.tls.termination}')
  tls_mode=$(get_k8s_info "$namespace" "route/$service" "tls")
  if [ -z "$tls_mode" ]; then
     protocol="http"
  else
     protocol="https"
  fi

  url="$protocol://$host"
  echo "$url"
}

function get_nodeport_url {
  local host path tls_enabled port porttxt  protocol

  namespace=$1
  service=$2
  path=$3
  tls_enabled=$4

  if [ ! "$(kubectl -n $namespace get service/$service 2>/dev/null)" ]; then
    # ingress object does not exist
    return 1
  fi


  # DEPRECATION: use of the NODE_NAME env var to override the node name used in the Kibana URL has been 
  #              deprecated with release 1.0.5 (09MAR21) and will support removed completely in an upcoming release
  host=${NODE_NAME:-$(kubectl get node --selector='node-role.kubernetes.io/master' | awk 'NR==2 { print $1 }')}
  if [ -z "$host" ]; then
     host=$(kubectl get nodes | awk 'NR==2 { print $1 }')  # use first node
  fi

  port=$(get_k8s_info "$namespace" "service/$service" "service_nodeport")

  if [ "$tls_enabled" == "true" ]; then
     protocol=https
  else
     protocol=http
  fi

  if [ ! -z "$port" ]; then
     porttxt=":$port"
  fi

  url="$protocol://${host}${porttxt}${path}"
  echo "$url"
}


function get_service_url {

 local namespace service path use_tls ingress service_type url

 namespace=$1
 service=$2                 # name of service
 path=$3                    # only used for NodePort?  Appended to path returned by ingress objects
 use_tls=$4                 # use http or https (ingress properties over-ride)
 ingress=${5:-${service}}   # (optional) name of ingress object (default: $service)

 # is a route defined for this service?
 if [ "$(kubectl -n $namespace get route/$service 2>/dev/null)" ]; then
     url=$(get_route_url $namespace $service)

     if [ -z "$url" ]; then
        return 1
     else
        echo "$url"
       return
     fi

 fi

 # determine nodePort or clusterPort (ingress)
 service_type=$(get_k8s_info "$namespace" "service/$service" "service_type")

 if [ "$service_type" == "ClusterIP" ]; then

     get_ingress_ports

     url=$(get_ingress_url $namespace $ingress)

     if [ -z "$url" ]; then
        return 1
     else
        echo "$url"
     fi

 elif [ "$service_type" == "NodePort" ]; then

     url=$(get_nodeport_url $namespace $service $path $use_tls)

     if [ -z "$url" ]; then
        return 1
     else
        echo "$url"
     fi
 else
    # uh-oh, how what?
    return 1
 fi
}

# USAGE NOTES
#
# #Exit on error
#
# These functions return with a non-zero return code when unable to generate the requested URL;
# therefore, you may need to set +e before calling these functions if you want to handle that exception
# rather than having the calling script fail.
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
# Exit code: 0 = success 1 = failure to generate URL
#

