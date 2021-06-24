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
      tls_enable="true"
      tls_secret="kibana-tls-secret"
      ingress_tls_secret="kibana-ingress-tls-secret"
      route_name="$service_name"
      ;;
   "ELASTICSEARCH"|"elasticsearch"|"ES"|"es")
      namespace="$LOG_NS"
      service_name="v4m-es-client-service"
      port="http"
      tls_enable="true"
      tls_secret="es-rest-tls-secret"
      ingress_tls_secret="elasticsearch-ingress-tls-secret"
      route_name="$service_name"
      ;;
   *)
      # NOTE: ** Experimental feature **
      # NOTE: Use of this script to create routes other than the ones above is not supported.
      log_warn "** Experimental feature **"
      log_warn "Use of this script to create adhoc routes is NOT supported."
      log_warn "The resulting route may not be usable or properly secured."
      namespace="$app"
      service_name="$2"
      port="${3:-http}"
      tls_enable="${4:-$TLS_ENABLE}"
      tls_secret="$5"
      ingress_tls_secret="$6"
      route_name="${7:-$service_name}"

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
else

   if oc -n $namespace get secret $tls_secret 2>/dev/null 1>&2; then
      tls_mode="reencrypt"
      annotations="cert-utils-operator.redhat-cop.io/destinationCA-from-secret=$tls_secret $annotations"
   else
      log_error "The specified secret [$tls_secret] does NOT exists in the namespace [$namespace]."
      exit 1
   fi

fi

oc -n $LOG_NS create route $tls_mode $route_name  --service $service_name  --port=$port  --insecure-policy=Redirect
rc=$?

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
