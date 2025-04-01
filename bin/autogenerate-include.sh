# Copyright © 2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo


function checkYqVersion {
   # confirm yq installed and correct version
   local goodver yq_version
   goodver="yq \(.+mikefarah.+\) version (v)?(4\.(3[2-9]|[4-9][0-9])\..+)"
   yq_version=$(yq --version)
   if [ "$?" == "1" ]; then
      log_error "Required component [yq] not available."
      return 1
   elif [[ ! $yq_version =~ $goodver ]]; then
      log_error "Incorrect version [$yq_version] found; version 4.32.2+ required."
      return 1
   else
      log_debug "A valid version [$yq_version] of yq detected"
      return 0
   fi
}

export -f checkYqVersion

function create_ingress_certs {
   local certFile keyFile namespace secretName

   namespace="$1"
   secretName="$2"
   certFile="${3:-$INGRESS_CERT}"
   keyFile="${4:-$INGRESS_KEY}"

   if [ -f "$certFile" ] && [ -f "$keyFile" ]; then
      kubectl delete secret "$secretName" --namespace "$namespace" --ignore-not-found 
      kubectl create secret tls "$secretName" --namespace "$namespace" --key="$keyFile" --cert="$certFile" 
      kubectl -n $namespace label secret $secretName  managed-by="v4m-es-script"
   elif [ ! -z "$certFile$keyFile" ]; then
      log_warn "Missing Ingress certificate file; specified Ingress cert [$certFile] and/or key [$keyFile] file is missing."
      log_warn "Create the missing Kubernetes secrets after deployment; use command: kubectl -create secret tls $secretName --namespace $namespace --key=cert_key_file --cert=cert_file"
   fi   
}

export -f create_ingress_certs

AUTOGENERATE_INGRESS="${AUTOGENERATE_INGRESS:-false}"
AUTOGENERATE_STORAGECLASS="${AUTOGENERATE_STORAGECLASS:-false}"

if [ "$AUTOGENERATE_INGRESS" != "true" ] && [ "$AUTOGENERATE_STORAGECLASS" != "true" ]; then
   log_debug "No autogeneration of YAML enabled"
   export AUTOGENERATE_SOURCED="NotNeeded"
fi

if [ -z "$AUTOGENERATE_SOURCED" ]; then

   if ! checkYqVersion; then
     exit 1
   fi

   if [ "$AUTOGENERATE_INGRESS" == "true" ]; then

      # Confirm NOT on OpenShift
      if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
         log_error "Setting AUTOGENERATE_INGRESS to 'true' is not valid on OpenShift clusters."
         log_error "Web applications will be made accessible via OpenShift routes instead (if enabled)."

         export AUTOGENERATE_INGRESS="false"
         exit 1
      fi


      #validate required inputs
      BASE_DOMAIN="${BASE_DOMAIN}"
      if [ -z "$BASE_DOMAIN" ]; then
         log_error "Required parameter [BASE_DOMAIN] not provided"
         exit 1
      fi

      ROUTING="${ROUTING:-host}"
      
      if [ "$ROUTING" == "path" ]; then
         export MON_TLS_PATH_INGRESS="true"
         log_debug "Path ingress requested, setting MON_TLS_PATH_INGRESS to 'true'"
      elif [ "$ROUTING" != "host" ] && [ "$ROUTING" != "path" ]; then
         log_error "Invalid ROUTING value, valid values are 'host' or 'path'"
         exit 1
      fi

      INGRESS_CERT="${INGRESS_CERT}"
      INGRESS_KEY="${INGRESS_KEY}"
      if [ "$INGRESS_CERT/$INGRESS_KEY" != "/" ]; then
         if [ ! -f "$INGRESS_CERT" ] || [ ! -f "$INGRESS_KEY" ]; then
            # Only WARN b/c missing cert doesn't prevent deployment and it can be created afterwards
            log_warn "Missing Ingress certificate file; specified Ingress cert [$INGRESS_CERT] and/or key [$INGRESS_KEY] file is missing."
            log_warn "You can create the missing Kubernetes secrets after deployment. See Enable TLS for Ingress topic in Help Center documentation."
            #unset variable values to prevent further attempted use
            unset INGRESS_CERT
            unset INGRESS_KEY
         else
            log_debug "Ingress cert [$INGRESS_CERT] and key [$INGRESS_KEY] files exist."
         fi
      fi

      log_info "Autogeneration of Ingress definitions has been enabled"

   fi

   if [ "$AUTOGENERATE_STORAGECLASS" == "true" ]; then

      log_info "Autogeneration of StorageClass specfication has been enabled"

   fi

   export AUTOGENERATE_SOURCED="true"

elif [ "$AUTOGENERATE_SOURCED" == "NotNeeded" ]; then
   log_debug "autogenerate-include.sh not needed" 
else
   log_debug "autogenerate-include.sh was already sourced [$AUTOGENERATE_SOURCED]"
fi


function checkStorageClass {
    # input parms: $1  *Name of env var* identifying storageClass
    # input parms: $2  storageClass
    # NOTE: Using 2 vars b/c Mac doesn't support indirection (e.g. x="${!1}")

    local storageClass storageClassEnvVar
    storageClassEnvVar="$1"
    storageClass="${2:-$STORAGECLASS}"

    if [ -z "$storageClass" ]; then
         log_error "Required parameter not provided.  Either [$storageClassEnvVar] or [STORAGECLASS] MUST be provided."
         exit 1
    else
       if $(kubectl get storageClass "$storageClass" -o name &>/dev/null); then
          log_debug "The specified StorageClass [$storageClass] exists"
       else
          log_error "The specified StorageClass [$storageClass] does NOT exist"
          exit 1
       fi
    fi

}



export -f checkStorageClass
