# Helper functions for TLS support

func create_issuers {
  # Create issuers if needed
  # Issuers honor USER_DIR for overrides/customizations
  if [ -z "$(kubectl get issuer -n $namespace selfsigning-issuer -o name 2>/dev/null)" ]; then
    log_info "Creating selfsigning-issuer for the [$namespace] namespace..."
    selfsignIssuer=monitoring/tls/selfsigning-issuer.yaml
    if [ -f "$USER_DIR/monitoring/tls/selfsigning-issuer.yaml" ]; then
      selfsignIssuer="$USER_DIR/monitoring/tls/selfsigning-issuer.yaml"
    fi
    log_debug "Self-sign issuer yaml is [$selfsignIssuer]"
    kubectl apply -n $namespace -f "$selfsignIssuer"
    sleep 5
  fi
  if [ -z "$(kubectl get secret -n $namespace ca-certificate -o name 2>/dev/null)" ]; then
    log_info "Creating self-signed CA certificate for the [$namespace] namespace..."
    caCert=monitoring/tls/ca-certificate.yaml
    if [ -f "$USER_DIR/monitoring/tls/ca-certificate.yaml" ]; then
      caCert="$USER_DIR/monitoring/tls/ca-certificate.yaml"
    fi
    log_debug "CA cert yaml file is [$caCert]"
    kubectl apply -n $namespace -f "$caCert"
    sleep 5
  fi
  if [ -z "$(kubectl get issuer -n $namespace namespace-issuer -o name 2>/dev/null)" ]; then
    log_info "Creating namespace-issuer for the [$namespace] namespace..."
    namespaceIssuer=monitoring/tls/namespace-issuer.yaml
    if [ -f "$USER_DIR/monitoring/tls/namespace-issuer.yaml" ]; then
      namespaceIssuer="$USER_DIR/monitoring/tls/namespace-issuer.yaml"
    fi
    log_debug "Namespace issuer yaml is [$namespaceIssuer]"
    kubectl apply -n $namespace -f "$namespaceIssuer"
    sleep 5
  fi
}

func create_app_certs {
  namespace = $1
  apps=( $2 )

  if [ "$TLS_CERT_MANAGER_ENABLE" == "true" ]; then
    # Create the certificate using cert-manager
    certyaml=monitoring/tls/$app-tls-cert.yaml
    if [ -f "$USER_DIR/monitoring/tls/$app-tls-cert.yaml" ]; then
      certyaml="$USER_DIR/monitoring/tls/$app-tls-cert.yaml"
    fi
    log_debug "Creating cert-manager certificate custom resource for [$app] using [$certyaml]"
    kubectl apply -n $namespace -f "$certyaml"
  fi
}

func create_tls_certs {
  namespace=$1
  apps=( $2 )

  # Optional TLS Support
  if [ "$TLS_CERT_MANAGER_ENABLE" == "true" ]; then
    create_issuers $namespace
  fi
  
  # Certs honor USER_DIR for overrides/customizations
  for app in "${apps[@]}"; do
    # Only create the secrets if they do not exist
    TLS_SECRET_NAME=$app-tls-secret
    if [ -z "$(kubectl get secret -n $namespace $TLS_SECRET_NAME -o name 2>/dev/null)" ]; then
      if [ "$TLS_CERT_MANAGER_ENABLE" == "true" ]; then
        create_app_certs "$namespace" "$apps[@]"
      fi
    else
      log_debug "Using existing $TLS_SECRET_NAME for [$app]"
    fi
  done
}

func cert_manager_available {
  if [ "$_cert_manager_available" == "true" ]; then
    return 0
  elif [ "$_cert_manager_available" == "false" ]; then
    return 1
  fi

  if [ "$(kubectl get crd certificates.cert-manager.io -o name 2>/dev/null)" ]; then
    export _cert_manager_available=true
    return 0
  else
    export _cert_manager_available=false
    return 1
  fi
}