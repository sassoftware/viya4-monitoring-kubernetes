#!/bin/bash
# Copyright © 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# POC helper -- samples/gateway-api Version: 0.1.0
#
# Reports what the Gateway API implementation in the current cluster actually
# supports, focused on the features this sample depends on.  Intended to answer
# the open validation questions before the sample is finalized -- in particular
# whether Contour supports sessionPersistence and BackendTLSPolicy.
#
# Read-only: this script creates nothing and changes nothing.
#
# Usage:  check-gateway-api-support.sh

echo "=============================================================="
echo " Gateway API support check"
echo "=============================================================="

pass() { echo "  [ OK ]   $1"; }
warn() { echo "  [ WARN ] $1"; }
fail() { echo "  [ FAIL ] $1"; }

echo
echo "-- Standard-channel CRDs (required) --"
for crd in gatewayclasses.gateway.networking.k8s.io \
           gateways.gateway.networking.k8s.io \
           httproutes.gateway.networking.k8s.io \
           referencegrants.gateway.networking.k8s.io; do
    if kubectl get crd "$crd" > /dev/null 2>&1; then
        version="$(kubectl get crd "$crd" -o jsonpath='{.spec.versions[*].name}')"
        pass "$crd (served versions: $version)"
    else
        fail "$crd is NOT installed"
    fi
done

echo
echo "-- BackendTLSPolicy (required for backend re-encryption) --"
if kubectl get crd backendtlspolicies.gateway.networking.k8s.io > /dev/null 2>&1; then
    # Only versions with served=true can actually be applied.  As of Gateway API
    # v1.4.0 the Standard channel serves v1 and defines-but-does-not-serve
    # v1alpha3; older installs serve only v1alpha3.
    served="$(kubectl get crd backendtlspolicies.gateway.networking.k8s.io \
        -o jsonpath='{range .spec.versions[?(@.served==true)]}{.name}{" "}{end}')"
    pass "backendtlspolicies CRD installed (served versions: ${served:-none})"
    if echo "$served" | grep -qw v1; then
        pass "v1 is served -- matches the apiVersion used by this sample"
    elif echo "$served" | grep -qw v1alpha3; then
        warn "only v1alpha3 is served -- change apiVersion in backendtlspolicies.yaml to gateway.networking.k8s.io/v1alpha3"
    else
        warn "neither v1 nor v1alpha3 is served; check your Gateway API version"
    fi
else
    fail "backendtlspolicies CRD NOT installed -- full-stack TLS (Contour 'protocol: tls' equivalent) is unavailable"
fi

echo
echo "-- sessionPersistence (EXPERIMENTAL channel; OSD sticky-session parity) --"
if kubectl get crd httproutes.gateway.networking.k8s.io > /dev/null 2>&1; then
    if kubectl get crd httproutes.gateway.networking.k8s.io -o yaml \
        | grep -q sessionPersistence; then
        pass "HTTPRoute CRD includes sessionPersistence (experimental CRD set is installed)"
        warn "CRD presence does NOT prove the controller implements it -- confirm by applying a route and checking its status conditions"
    else
        warn "HTTPRoute CRD does NOT include sessionPersistence (Standard channel installed)"
        warn "Sticky sessions are unavailable; only relevant if OpenSearch Dashboards is scaled past one replica"
    fi
fi

echo
echo "-- GatewayClasses available --"
if ! kubectl get gatewayclass > /dev/null 2>&1; then
    fail "unable to list GatewayClasses"
else
    kubectl get gatewayclass \
        -o custom-columns='NAME:.metadata.name,CONTROLLER:.spec.controllerName,ACCEPTED:.status.conditions[?(@.type=="Accepted")].status' \
        --no-headers 2> /dev/null | while read -r line; do
        echo "  $line"
    done
    if [ -z "$(kubectl get gatewayclass --no-headers 2> /dev/null)" ]; then
        fail "no GatewayClass found -- no Gateway API implementation is installed"
    fi
fi

echo
echo "-- Contour-specific --"
if kubectl get crd contourconfigurations.projectcontour.io > /dev/null 2>&1; then
    pass "Contour CRDs present"
    echo "  Contour only reconciles Gateway API resources when configured to do so."
    echo "  Check gateway.controllerName / gateway.gatewayRef in its ContourConfiguration:"
    kubectl get contourconfigurations.projectcontour.io -A \
        -o custom-columns='NS:.metadata.namespace,NAME:.metadata.name,GATEWAY:.spec.gateway' \
        --no-headers 2> /dev/null | sed 's/^/    /'
else
    echo "  Contour CRDs not present (not an error -- this sample is implementation-agnostic)"
fi

echo
echo "-- Proxy tuning (buffer/header sizes, timeouts) --"
echo "  No portable Gateway API mechanism exists.  These must be configured on the"
echo "  Gateway/implementation by the platform administrator; see the README."

echo
echo "Done."
