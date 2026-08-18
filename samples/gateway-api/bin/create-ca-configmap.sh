#!/bin/bash
# Copyright © 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# POC helper -- samples/gateway-api Version: 0.1.0
#
# BackendTLSPolicy requires the CA certificate that signed the application
# serving certificates to be supplied in a ConfigMap.  The deployment scripts
# only create Secrets, so this script extracts the CA public certificate from an
# existing Secret and (re)creates it as a ConfigMap.
#
# This is deliberately a standalone script rather than a change to
# bin/autogenerate-include.sh:create_ingress_certs -- where this logic should
# ultimately live is still an open design question (extend create_ingress_certs,
# have certframe emit the ConfigMap, or append to a shared
# customer-provided-ca-certificates ConfigMap).
#
# Usage:  create-ca-configmap.sh NAMESPACE [CONFIGMAP_NAME]
#
#   NAMESPACE       namespace holding the certs (e.g. monitoring, logging)
#   CONFIGMAP_NAME  name of the ConfigMap to create (default: v4m-ca-certs)
#
# Both TLS flows used by the deployment scripts are handled:
#   * cert-manager  -- CA is in secret ca-certificate-secret, key ca.crt
#   * openssl       -- CA is in each app secret under key ca.crt

set -euo pipefail

namespace="${1:-}"
configMapName="${2:-v4m-ca-certs}"

if [ -z "$namespace" ]; then
    echo "ERROR: NAMESPACE is required.  Usage: $0 NAMESPACE [CONFIGMAP_NAME]" >&2
    exit 1
fi

tmpDir="$(mktemp -d)"
# shellcheck disable=SC2064
trap "rm -rf '$tmpDir'" EXIT
caFile="$tmpDir/ca.crt"

# Candidate secrets, in preference order: the cert-manager CA secret first, then
# any app secret (all of which carry the CA under ca.crt in the openssl flow).
candidates=(
    ca-certificate-secret
    grafana-tls-secret
    kibana-tls-secret
    es-rest-tls-secret
    prometheus-tls-secret
    alertmanager-tls-secret
)

found=""
for secret in "${candidates[@]}"; do
    if kubectl -n "$namespace" get secret "$secret" -o name > /dev/null 2>&1; then
        if kubectl -n "$namespace" get secret "$secret" -o jsonpath='{.data.ca\.crt}' 2> /dev/null \
            | base64 -d > "$caFile" 2> /dev/null && [ -s "$caFile" ]; then
            found="$secret"
            break
        fi
    fi
done

if [ -z "$found" ]; then
    echo "ERROR: could not locate a CA certificate (key 'ca.crt') in any of these secrets in namespace [$namespace]:" >&2
    printf '  %s\n' "${candidates[@]}" >&2
    echo "Confirm TLS is enabled for the deployment, or supply the CA certificate manually with:" >&2
    echo "  kubectl -n $namespace create configmap $configMapName --from-file=ca.crt=/path/to/ca.crt" >&2
    exit 1
fi

echo "Using CA certificate from secret [$namespace/$found]"

if ! openssl x509 -in "$caFile" -noout -subject > /dev/null 2>&1; then
    echo "ERROR: extracted ca.crt is not a valid PEM certificate" >&2
    exit 1
fi
echo "  $(openssl x509 -in "$caFile" -noout -subject)"

kubectl -n "$namespace" delete configmap "$configMapName" --ignore-not-found
kubectl -n "$namespace" create configmap "$configMapName" --from-file=ca.crt="$caFile"
kubectl -n "$namespace" label configmap "$configMapName" managed-by="v4m-es-script"

echo "Created ConfigMap [$namespace/$configMapName]"
echo "Reference it from BackendTLSPolicy as:"
echo "  validation.caCertificateRefs[0] = {group: \"\", kind: ConfigMap, name: $configMapName}"
