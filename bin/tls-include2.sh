# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Helper functions for TLS support

function  do_all_secrets_already_exist {
    namespace="$1"
    shift
    apps=("$@")

    all_secrets_exist="true"

    for app in "${apps[@]}"; do
      secretName=$app-tls-secret
      if [ -z "$(kubectl get secret -n $namespace $secretName -o name 2>/dev/null)" ]; then
          log_debug "Secret [$namespace/$secretName] not found. Certificate generation is required."
          all_secrets_exist="false"
          break
      else
        log_debug "Found existing secret $namespace/$secretName"
      fi
    done

   if [ "$all_secrets_exist" == "false" ]; then
      return 1
   else
      return 0
   fi
}


function verify_cert_generator {

  if [ "$TLS_ENABLE" != "true" ]; then
     log_debug "TLS is disabled. Skipping verification of certificate generator."
     return 0
  fi

  if [ "$cert_generator_ok" == "true" ]; then
    return 0
  elif [ "$cert_generator_ok" == "false" ]; then
    return 1
  fi

  if do_all_secrets_already_exist $@; then
     log_debug "All required secrets exist. Skipping check for certificate generator check."
     cert_generator_ok="true"
     return 0
  else
     cert_generator_ok="false"
  fi

  if [ "$cert_generator" == "cert-manager" ]; then
     verify_cert_manager_new
     rc=$?
  elif [ "$cert_generator" == "openssl" ]; then
    verify_openssl
    rc=$?
  else
     log_error "No TLS certificate generation mechanism defined"
     return 1
  fi

  if [ "$rc" == "0" ]; then
     cert_generator_ok="true"
  else
     cert_generator_ok="false"
  fi
  return $rc
}

function verify_cert_manager_new {
  if [ "$cert_manager_ok" == "true" ]; then
    return 0
  elif [ "$cert_manager_ok" == "false" ]; then
    return 1
  fi

  if [ "$(kubectl get crd certificates.cert-manager.io -o name 2>/dev/null)" ]; then
    cert_manager_ok="true"
    return 0
  else
    cert_manager_ok="false"
    return 1
  fi
}


function verify_openssl {
  if [ "$openssl_ok" == "true" ]; then
    return 0
  elif [ "$openssl_ok" == "false" ]; then
    return 1
  else
     openssl_version="$(which openssl)" 2>/dev/null
     openssl_available="$?"

     if [ "$openssl_available" == "0" ]; then
        log_debug "OpenSSL is available to generate missing required certs"
        openssl_ok="true"
        return 0
     else
        log_error "OpenSSL is NOT available to generate missing required certs"
        openssl_ok="false"
        return 1
     fi

  fi
}

function create_tls_certs_new {
  local namespace context apps
  namespace=$1
  context=$2
  shift 2
  apps=("$@")

  if [ "$cert_generator" == "cert-manager" ]; then
     ## call existing create_tls_certs (renamed to create_tls_certs_cert-manager?)
     create_tls_certs          $namespace $context ${apps[@]}
  elif [ "$cert_generator" == "openssl" ]; then
     create_tls_certs_openssl  $namespace          ${apps[@]}
  else
     log_error "Unknown TLS Certificate Generator [$cert-generator] requested."
     return 1
  fi
}


function create_cert_secret {
    local namespace app
    namespace="$1"
    app="$2"

    secretName="${app}-tls-secret"
    log_debug "Storing TLS Cert for [$app] in secret [$secretName] in namespace [$namespace]"

    expiration_date=$(openssl x509 -enddate -noout -in  $TMP_DIR/${app}.pem | awk -F "=" '{print $2}')
    # Secret Type: TLS (two sub-parts: cert + key
    #kubectl -n $namespace create secret tls $secretName --cert $TMP_DIR/${app}.pem --key $TMP_DIR/${app}-key.pem
    # Secret Type: GENERIC (3 sub-parts: cert + key + CACert
    set -x
    kubectl -n $namespace create secret generic $secretName --from-file=tls.crt=$TMP_DIR/${app}.pem --from-file=tls.key=$TMP_DIR/${app}-key.pem --from-file=ca.crt=$TMP_DIR/root-ca.pem
    set +x
    kubectl -n $namespace annotate secret $secretName  expiration="$expiration_date"

}

function create_tls_certs_openssl {
    local namespace apps
    namespace="$1"
    shift
    apps=("$@")

    cert_life=180

    for app in "${apps[@]}"; do
      secretName="${app}-tls-secret"

      if [ -n "$(kubectl get secret -n $namespace $secretName -o name 2>/dev/null)" ]; then
         log_debug "TLS Secret for [$app] already exists; skipping TLS certificate generation."
         continue
      fi

      if [ ! -f  $TMP_DIR/root-ca-key.pem ]; then

         #Hmmm, if we're doing a big install, the TMP_DIR would/might? exist and the first root-ca-key.pem file would be
         # used for all subsequent certs...is that a problem?

         if [ -n "$(kubectl get secret -n $namespace root-ca-tls-secret -o name 2>/dev/null)" ]; then
            #IF secret $namespace/root-ca-tls-secret exists THEN extract the rootca key & key from it
            log_debug "Extracting Root CA from secret [root-ca-tls-secret]"
            kubectl -n $namespace get secret root-ca-tls-secret -o=jsonpath="{.data.tls\.crt}" |base64 --decode > $TMP_DIR/root-ca.pem
            kubectl -n $namespace get secret root-ca-tls-secret -o=jsonpath="{.data.tls\.key}" |base64 --decode > $TMP_DIR/root-ca-key.pem
         else
            #ELSE create things from scratch
            log_debug "Creating Root CA using OpenSSL"
            cert_subject="/O=cert-manager/CN=rootca"
            openssl genrsa -out $TMP_DIR/root-ca-key.pem 2048
            openssl req -new -x509 -sha256 -key $TMP_DIR/root-ca-key.pem -subj "$cert_subject" -out $TMP_DIR/root-ca.pem -days $cert_life

            #Store Root CA in a secret
           create_cert_secret $namespace root-ca
         fi

      else
         log_debug "Using existing Root CA cert"
      fi

      log_debug "Creating TLS Cert for [$app] using OpenSSL"
      cert_subject="/O=cert-manager/CN=$app"
      openssl genrsa -out $TMP_DIR/${app}-key-temp.pem 2048
      openssl pkcs8 -inform PEM -outform PEM -in $TMP_DIR/${app}-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out $TMP_DIR/${app}-key.pem
      openssl req -new -key $TMP_DIR/${app}-key.pem -subj "$cert_subject" -out $TMP_DIR/${app}.csr
      openssl x509 -req -in $TMP_DIR/${app}.csr -CA $TMP_DIR/root-ca.pem  -CAkey $TMP_DIR/root-ca-key.pem -CAcreateserial -sha256 -out $TMP_DIR/${app}.pem -days $cert_life

      create_cert_secret $namespace $app

      # TO DO: For TRANSPORT and ADMIN certs, create env vars w/subject...to be used in opensearch.yaml
      log_debug "Subject for [$app]"
      openssl x509 -subject -nameopt RFC2253 -noout -in $TMP_DIR/${app}.pem 
    done


}
