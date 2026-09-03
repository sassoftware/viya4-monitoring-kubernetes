#! /bin/bash


# Copyright © 2026 SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/.." || exit
source bin/common.sh

log_debug "Script [$this_script] has started [$(date)]"

fqdn=contour.gemini-m1.opsmonitor.sashq-d.openstack.sas.com
namespace=logging

#create temp space
mkdir $TMP_DIR/$namespace/tls -p


# Extract Root CA info from v4m-root-ca-tls-secret
kubectl -n "$namespace" get secret v4m-root-ca-tls-secret   -o jsonpath='{.data.tls\.crt}' | base64 --decode > $TMP_DIR/$namespace/tls/root-ca.pem
kubectl -n "$namespace" get secret v4m-root-ca-tls-secret   -o jsonpath='{.data.tls\.key}' | base64 --decode > $TMP_DIR/$namespace/tls/root-ca-key.pem

# Generate TLS cert
cat > $TMP_DIR/$namespace/tls/contour-extensions.cnf <<EOF
[v3_req]
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectAltName=DNS:$fqdn
EOF

openssl genrsa -out $TMP_DIR/$namespace/tls/contour.key 4096

openssl req -new \
  -key $TMP_DIR/$namespace/tls/contour.key \
  -subj "/O=v4m/CN=$fqdn" \
  -out $TMP_DIR/$namespace/tls/contour.csr

openssl x509 -req \
  -in $TMP_DIR/$namespace/tls/contour.csr \
  -CA $TMP_DIR/$namespace/tls/root-ca.pem \
  -CAkey $TMP_DIR/$namespace/tls/root-ca-key.pem \
  -CAcreateserial \
  -CAserial contour-ca.srl \
  -sha256 \
  -days 550 \
  -out $TMP_DIR/$namespace/tls/contour.crt \
  -extfile $TMP_DIR/$namespace/tls/contour-extensions.cnf \
  -extensions v3_req


# create secret v4m-ingress-tls-secret
kubectl -n $namespace create secret tls v4m-ingress-tls-secret \
  --cert=$TMP_DIR/$namespace/tls/contour.crt \
  --key=$TMP_DIR/$namespace/tls/contour.key
