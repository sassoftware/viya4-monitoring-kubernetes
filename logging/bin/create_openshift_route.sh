#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh

this_script=$(basename "$0")

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
app=$(echo "$app" | tr '[:lower:]' '[:upper:]')

case "$app" in
"OPENSEARCH" | "OS")
    namespace="$LOG_NS"
    service_name="v4m-search"
    port="http"
    tls_enable="true"
    tls_secret="es-rest-tls-secret"
    ingress_tls_secret="elasticsearch-ingress-tls-secret"
    route_name="$service_name"
    if [ "$OPENSHIFT_PATH_ROUTES" == "true" ]; then
        route_host=${OPENSHIFT_ROUTE_HOST_ELASTICSEARCH:-v4m-$namespace.$OPENSHIFT_ROUTE_DOMAIN}
        route_path="/opensearch"
    else
        route_host=${OPENSHIFT_ROUTE_HOST_ELASTICSEARCH:-$service_name-$namespace.$OPENSHIFT_ROUTE_DOMAIN}
        route_path="/"
    fi
    ;;
"OSD" | "OPENSEARCHDASHBOARD" | "OPENSEARCHDASHBOARDS")
    namespace="$LOG_NS"
    service_name="v4m-osd"
    port="http"
    tls_enable="true"
    tls_secret="kibana-tls-secret"
    ingress_tls_secret="kibana-ingress-tls-secret"
    route_name="$service_name"
    if [ "$OPENSHIFT_PATH_ROUTES" == "true" ]; then
        route_host=${OPENSHIFT_ROUTE_HOST_KIBANA:-v4m-$namespace.$OPENSHIFT_ROUTE_DOMAIN}
        route_path="/dashboards"
    else
        route_host=${OPENSHIFT_ROUTE_HOST_KIBANA:-$service_name-$namespace.$OPENSHIFT_ROUTE_DOMAIN}
        route_path="/"
    fi
    ;;
"" | *)
    log_error "Application name is invalid or missing."
    log_error "The APPLICATION NAME is required; valid values are: OpenSearch or OpenSearchDashboards"
    exit 1
    ;;
esac

if oc -n "$namespace" get route $route_name > /dev/null 2>&1; then
    log_info "Skipping route creation; the requested route [$route_name] already exists in the namespace [$namespace]."
    exit 0
fi

if [ "$tls_enable" != "true" ]; then
    tls_mode="edge"
else
    if oc -n "$namespace" get secret $tls_secret > /dev/null 2>&1; then
        tls_mode="reencrypt"
    else
        log_error "The specified secret [$tls_secret] does NOT exists in the namespace [$namespace]."
        exit 1
    fi
fi

oc -n "$namespace" create route $tls_mode $route_name \
    --service $service_name \
    --port=$port \
    --insecure-policy=Redirect \
    --hostname "$route_host" \
    --path $route_path
rc=$?

if [ "$OPENSHIFT_PATH_ROUTES" == "true" ]; then
    oc -n "$namespace" annotate route $route_name "haproxy.router.openshift.io/rewrite-target=/"
fi

if [ "$rc" != "0" ]; then
    log_error "There was a problem creating the route for [$route_name]. [$rc]"
    exit 1
fi

if [ "$tls_enable" == "true" ]; then
    # identify secret containing destination CA
    oc -n "$namespace" annotate route $route_name cert-utils-operator.redhat-cop.io/destinationCA-from-secret=$tls_secret
fi

if oc -n "$namespace" get secret $ingress_tls_secret 2> /dev/null 1>&2; then
    # Add annotation to identify secret containing TLS certs
    oc -n "$namespace" annotate route $route_name cert-utils-operator.redhat-cop.io/certs-from-secret=$ingress_tls_secret
else
    log_debug "The ingress secret [$ingress_tls_secret] does NOT exists, omitting annotation [certs-from-secret]."
fi

log_info "OpenShift Route [$route_name] has been created."

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
