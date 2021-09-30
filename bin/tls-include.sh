# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
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

  cert_manager_ok="true"
  if [ "$TLS_ENABLE" == "true" ]; then
    # Check if all secrets already exist
    all_secrets_exist="true"
    namespace="$1"
    shift
    apps=("$@")
    for app in "${apps[@]}"; do
      secretName=$app-tls-secret
      if [ -z "$(kubectl get secret -n $namespace $secretName -o name 2>/dev/null)" ]; then
          log_debug "Secret [$namespace/$secretName] not found. cert-manager is required."
          all_secrets_exist="false"
          break
      else
        log_debug "Found existing secret $namespace/$secretName"
      fi
    done

    if [ "$all_secrets_exist" == "true" ]; then
      log_debug "All required secrets exist. Skipping cert-manager check."
    else
      if [ "$certManagerAvailable" == "true" ]; then
        log_debug "cert-manager is available"        
      else
        log_error "Missing secret [$secretName] requires cert-manager, which is not available"
        cert_manager_ok="false"
      fi
    fi
  else
    log_debug "TLS is disabled. Skipping verification of cert-manager."
  fi
  
  export cert_manager_ok
  if [ "$cert_manager_ok" == "true" ]; then
    return 0
  else
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

function create_tls_certs {
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

export -f verify_cert_manager deploy_issuers deploy_app_cert create_tls_certs
