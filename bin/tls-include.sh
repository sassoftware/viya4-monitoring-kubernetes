# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Helper functions for TLS support

# Determine if cert-manager is available

if [ "$(kubectl get crd certificates.cert-manager.io -o name 2>/dev/null)" ]; then
  certManagerAvailable="true"
else
  certManagerAvailable="false"
fi

function verify_cert_manager {
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


function deploy_issuers {
  namespace=$1
  context=$2

  contextDir=${TLS_CONTEXT_DIR:-$context/tls}

  if [ "TLS_DEPLOY_SELFSIGNED_ISSUERS" == "false" ]; then
    return 0
  fi

  # Create issuers if needed
  # Issuers honor USER_DIR for overrides/customizations
  if [ -z "$(kubectl get issuer -n $namespace selfsigning-issuer -o name 2>/dev/null)" ]; then
    log_info "Creating selfsigning-issuer for the [$namespace] namespace..."
    selfsignIssuer=$context/tls/selfsigning-issuer.yaml
    if [ -f "$USER_DIR/$context/tls/selfsigning-issuer.yaml" ]; then
      selfsignIssuer="$USER_DIR/$context/tls/selfsigning-issuer.yaml"
    fi
    log_debug "Self-sign issuer yaml is [$selfsignIssuer]"
    kubectl apply -n $namespace -f "$selfsignIssuer"
    sleep 5
  else
    log_debug "Using existing $namespace/selfsigning-issuer"
  fi
  if [ -z "$(kubectl get secret -n $namespace ca-certificate-secret -o name 2>/dev/null)" ]; then
    log_info "Creating self-signed CA certificate for the [$namespace] namespace..."
    caCert=$context/tls/ca-certificate.yaml
    if [ -f "$USER_DIR/$context/tls/ca-certificate.yaml" ]; then
      caCert="$USER_DIR/$context/tls/ca-certificate.yaml"
    fi
    log_debug "CA cert yaml file is [$caCert]"
    kubectl apply -n $namespace -f "$caCert"
    sleep 5
  else
    log_debug "Using existing $namespace/ca-certificate-secret"
  fi
  if [ -z "$(kubectl get issuer -n $namespace namespace-issuer -o name 2>/dev/null)" ]; then
    log_info "Creating namespace-issuer for the [$namespace] namespace..."
    namespaceIssuer=$context/tls/namespace-issuer.yaml
    if [ -f "$USER_DIR/$context/tls/namespace-issuer.yaml" ]; then
      namespaceIssuer="$USER_DIR/$context/tls/namespace-issuer.yaml"
    fi
    log_debug "Namespace issuer yaml is [$namespaceIssuer]"
    kubectl apply -n $namespace -f "$namespaceIssuer"
    sleep 5
  else
    log_debug "Using existing $namespace/namespace-issuer"
  fi
}

function deploy_app_cert {
  namespace=$1
  context=$2
  app=$3

  contextDir=${TLS_CONTEXT_DIR:-$context/tls}

  # Create the certificate using cert-manager
  certyaml=$contextDir/$app-tls-cert.yaml
  if [ -f "$USER_DIR/$context/tls/$app-tls-cert.yaml" ]; then
    certyaml="$USER_DIR/$context/tls/$app-tls-cert.yaml"
  fi
  log_debug "Creating cert-manager certificate custom resource for [$app] using [$certyaml]"
  kubectl apply -n $namespace -f "$certyaml"
}

function create_tls_certs_cm {
  namespace=$1
  context=$2
  shift 2
  apps=("$@")

  deployedIssuers="false"
    # Certs honor USER_DIR for overrides/customizations
  for app in "${apps[@]}"; do
    # Only create the secrets if they do not exist
    TLS_SECRET_NAME=$app-tls-secret
    if [ -z "$(kubectl get secret -n $namespace $TLS_SECRET_NAME -o name 2>/dev/null)" ]; then
        if [ "$deployedIssuers" == "false" ]; then
          deploy_issuers $namespace $context
          deployedIssuers="true"
        fi
        deploy_app_cert "$namespace" "$context" "$app"
    else
      log_debug "Using existing $TLS_SECRET_NAME for [$app]"
    fi
  done
}

function create_tls_certs {
  local namespace context apps
  namespace=$1
  context=$2
  shift 2
  apps=("$@")

  if [ "$CERT_GENERATOR" == "cert-manager" ]; then
     create_tls_certs_cm       $namespace $context ${apps[@]}
  elif [ "$CERT_GENERATOR" == "openssl" ]; then
     create_tls_certs_openssl  $namespace          ${apps[@]}
  else
     log_error "Unknown TLS Certificate Generator [$cert-generator] requested."
     return 1
  fi
}


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

  if [ "$CERT_GENERATOR" == "cert-manager" ]; then
     verify_cert_manager
     rc=$?
  elif [ "$CERT_GENERATOR" == "openssl" ]; then
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

function create_cert_secret {
    local namespace app
    namespace="$1"
    app="$2"
    secretName="$3"

    if [ -z "$secretName" ]; then
       secretName="${app}-tls-secret"
    fi
    log_debug "Storing TLS Cert for [$app] in secret [$secretName] in namespace [$namespace]"

    expiration_date=$(openssl x509 -enddate -noout -in  $TMP_DIR/${app}.pem | awk -F "=" '{print $2}')
    # Secret Type: TLS (two sub-parts: cert + key)
    #kubectl -n $namespace create secret tls $secretName --cert $TMP_DIR/${app}.pem --key $TMP_DIR/${app}-key.pem

    # Secret Type: GENERIC (3 sub-parts: cert + key + CACert)
    kubectl -n $namespace create secret generic $secretName --from-file=tls.crt=$TMP_DIR/${app}.pem --from-file=tls.key=$TMP_DIR/${app}-key.pem --from-file=ca.crt=$TMP_DIR/root-ca.pem
    kubectl -n $namespace annotate secret $secretName  expiration="$expiration_date"
    kubectl -n $namespace label secret $secretName  managed-by="v4m" cert-generator="openssl"

}

# Checks if tls cert is or will expire within TLS_CERT_RENEW_WINDOW timeframe
# Return 1: cert is still valid and will not expire with the given timeframe
# Return 0: cert is expired or will expire within the given timeframe
function tls_cert_expired () {
  namespace="$1"
  app="$2"
  secretName="$3"
  
  cert_window=$((${TLS_CERT_RENEW_WINDOW:-7} * 86400))

  if kubectl get secret -n $namespace $secretName -o "jsonpath={.data['tls\.crt']}" | base64 -d | openssl x509 -checkend $cert_window -noout 2>/dev/null
  then
    return 1
  else
    return 0
  fi
}

# Checks if tls cert is generated and managed by V4M
# Return 0: TLS cert is managed by V4M
# Return 1: TLS cert is not managed by V4M 
function tls_cert_managed_by_v4m () {
  namespace="$1"
  secretName="$3"

  if [[ "$(kubectl get secret -n $namespace $secretName --show-labels)" == *"managed-by=v4m"* ]]; then
    log_debug "TLS Certs are managed by SAS Viya Monitoring"
    return 0
  else
    log_debug "TLS Certs are not managed by SAS Viya Monitoring"
    return 1
  fi
}

function create_tls_certs_openssl {
    local namespace apps
    namespace="$1"
    shift
    apps=("$@")

    cert_life=${OPENSSL_CERT_LIFE:-550}

    for app in "${apps[@]}"; do
      secretName="${app}-tls-secret"

      if [ -n "$(kubectl get secret -n "$namespace" "$secretName" -o name 2>/dev/null)" ]; then
        if (tls_cert_managed_by_v4m "$namespace" "$secretName") then
          if ! (tls_cert_expired "$namespace" "$app" "$secretName") then
            log_debug "TLS Secret for [$app] already exists and cert is not expired; skipping TLS certificate generation."
            continue
          else
            log_info "TLS Secret for [$app] exists but cert has expired or will do so within ${TLS_CERT_RENEW_WINDOW:-7} days"
            log_info "Renew cert using: renew-tls-certs.sh"
            # TODO: When certs are expired:
            # Delete secret and allow cert generation
            # Get the resource restarted by calling func in renew-tls-certs.sh
            # kubectl delete secret -n $namespace $secretName
            continue
          fi
        else
          # Cert not managed by SAS Viya Monitoring
          continue
        fi
      fi

      if [ ! -f  $TMP_DIR/root-ca-key.pem ]; then

         if [ -n "$(kubectl get secret -n $namespace v4m-root-ca-tls-secret -o name 2>/dev/null)" ]; then
            log_debug "Extracting Root CA cert from secret [v4m-root-ca-tls-secret]"
            kubectl -n $namespace get secret v4m-root-ca-tls-secret -o=jsonpath="{.data.tls\.crt}" |base64 --decode > $TMP_DIR/root-ca.pem
            kubectl -n $namespace get secret v4m-root-ca-tls-secret -o=jsonpath="{.data.tls\.key}" |base64 --decode > $TMP_DIR/root-ca-key.pem
         else
            log_debug "Creating Root CA cert using OpenSSL"
            cert_subject="/O=v4m/CN=rootca"
            openssl genrsa -out $TMP_DIR/root-ca-key.pem 4096 2>/dev/null
            openssl req -new -x509 -sha256 -key $TMP_DIR/root-ca-key.pem -subj "$cert_subject" -out $TMP_DIR/root-ca.pem -days $cert_life

            create_cert_secret $namespace root-ca v4m-root-ca-tls-secret
         fi

      else
         log_debug "Using existing Root CA cert"
      fi

      log_debug "Creating TLS Cert for [$app] using OpenSSL"
      cert_subject="/O=v4m/CN=$app"
      openssl genrsa -out $TMP_DIR/${app}-key-temp.pem 4096 2>/dev/null
      openssl pkcs8 -inform PEM -outform PEM -in $TMP_DIR/${app}-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out $TMP_DIR/${app}-key.pem
      openssl req -new -key $TMP_DIR/${app}-key.pem -subj "$cert_subject" -out $TMP_DIR/${app}.csr
      openssl x509 -req -in $TMP_DIR/${app}.csr -CA $TMP_DIR/root-ca.pem  -CAkey $TMP_DIR/root-ca-key.pem -CAcreateserial -CAserial $TMP_DIR/ca.srl -sha256 -out $TMP_DIR/${app}.pem -days $cert_life 2>/dev/null

      create_cert_secret $namespace $app

    done


}


export -f verify_cert_manager deploy_issuers deploy_app_cert create_tls_certs_cm
export -f do_all_secrets_already_exist verify_cert_generator verify_openssl create_cert_secret create_tls_certs_openssl create_tls_certs
