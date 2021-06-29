#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

##################################
# Confirm on OpenShift           #
##################################

if [ "$OPENSHIFT_CLUSTER" != "true" ]; then
  if [ "${CHECK_OPENSHIFT_CLUSTER:-true}" == "true" ]; then
    log_error "This script should only be run on OpenShift clusters"
    exit 1
  fi
fi

app=${1}
case "$app" in
   "KIBANA"|"kibana"|"kb"|"KB")
      namespace="$LOG_NS"
      service_name="v4m-es-kibana-svc"
      port="kibana-svc"
      tls_enable="true"
      tls_secret="kibana-tls-secret"
      ingress_tls_secret="kibana-ingress-tls-secret"
      route_name="$service_name"
      if [ "$OPENSHIFT_PATH_ROUTES" == "true" ]; then
        route_path="/kibana"
      else
        route_path="/"
      fi
      ;;
   "ELASTICSEARCH"|"elasticsearch"|"ES"|"es")
      namespace="$LOG_NS"
      service_name="v4m-es-client-service"
      port="http"
      tls_enable="true"
      tls_secret="es-rest-tls-secret"
      ingress_tls_secret="elasticsearch-ingress-tls-secret"
      route_name="$service_name"
      if [ "$OPENSHIFT_PATH_ROUTES" == "true" ]; then
        route_path="/elasticsearch"
      else
        route_path="/"
      fi
      ;;
  ""|*)
      log_error "Application name is invalid or missing."
      log_error "The APPLICATION NAME is required; valid values are: ELASTICSEARCH or KIBANA"
      exit 1
      ;;
esac

if oc -n $namespace get route $route_name 2>/dev/null 1>&2; then
   log_error "The requested route [$route_name] already exists in the namespace [$namespace]."
   log_error "The details of existing route are shown below:"
   oc -n $namespace get route $route_name
   exit 1
fi

if [ "$tls_enable" != "true" ]; then
   tls_mode="edge"
else
   if oc -n $namespace get secret $tls_secret 2>/dev/null 1>&2; then
      tls_mode="reencrypt"
   else
      log_error "The specified secret [$tls_secret] does NOT exists in the namespace [$namespace]."
      exit 1
   fi
fi

oc -n $LOG_NS create route $tls_mode $route_name --service $service_name --port=$port --insecure-policy=Redirect --path $route_path
rc=$?

oc -n $LOG_NS annotate route $route_name "haproxy.router.openshift.io/rewrite-target=$route_path"

if [ "$rc" != "0" ]; then
   log_error "There was a problem creating the route for [$route_name]. [$rc]"
   exit 1
fi

if [ "$tls_enable" == "true" ]; then
   # identify secret containing destination CA
   oc -n $LOG_NS annotate  route $route_name cert-utils-operator.redhat-cop.io/destinationCA-from-secret=$tls_secret
fi

# identify secret containing TLS certs
oc -n $LOG_NS annotate  route $route_name cert-utils-operator.redhat-cop.io/certs-from-secret=$ingress_tls_secret

log_info "OpenShift Route [$route_name] has been created."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
