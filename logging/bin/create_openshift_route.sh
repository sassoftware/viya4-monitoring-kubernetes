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
   "")
      log_error "You must identify the application for which you want to create a route."
      exit 1
      ;;
   "KIBANA"|"kibana"|"kb"|"KB")
      namespace="$LOG_NS"
      service_name="v4m-es-kibana-svc"
      port="kibana-svc"
      tls_enable="$LOG_KB_TLS_ENABLE"
      tls_secret="kibana-tls-secret"
      route_name="$service_name"
      ;;
   "ELASTICSEARCH"|"elasticsearch"|"ES"|"es")
      namespace="$LOG_NS"
      service_name="v4m-es-client-service"
      port="http"
      tls_enable="true"
      tls_secret="es-rest-tls-secret"
      route_name="$service_name"
      ;;
   *)
      namespace="$app"
      service_name="$2"
      port="${3:-http}"
      tls_enable="${4:-$TLS_ENABLE}"
      tls_secret="$5"
      route_name="${6:-$service_name}"

      if [ -z "$service_name" ]; then
         log_error "You must provide the name of the service for which you want route created."
         exit 1
      fi

      if [ -z "$namespace" ]; then
         log_error "You must provide the namespace in which you want the route created."
         exit 1
      fi

      if [ "$tls_enable" == "true" ]; then

         if [ -z "$tls_secret" ]; then
            log_error "You must provide the name of the secret containing the CA information for the TLS certs used by the service for which you want route created."
            exit 1
         fi
      fi
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
   cert_options=""
else
   oc -n $namespace get secret $tls_secret  -o template='{{index .data "ca.crt"}}' | base64 -d > $TMP_DIR/tls_ca.crt

   if [ ! -f "$TMP_DIR/tls_ca.crt" ]; then
      log_error "Required TLS information for [$route_name] not found in expected location [secret/$tls_secret]; unable to create route."
      exit 1
   fi
   tls_mode="reencrypt"
   cert_options="--dest-ca-cert=$TMP_DIR/tls_ca.crt"
fi

oc -n $LOG_NS create route $tls_mode $route_name  --service $service_name  --port=$port  $cert_options
rc=$?

if [ "$rc" != "0" ]; then
   log_error "There was a problem creating the route for [$route_name]. [$rc]"
   exit 1
fi

log_info "OpenShift Route [$route_name] has been created."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
