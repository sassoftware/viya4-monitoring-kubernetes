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

      routing="${ROUTING:-host}"

      if [ "$routing" != "host" ]; then
         MON_TLS_PATH_INGRESS="true"
         log_debug "Path ingress requested, setting MON_TLS_PATH_INGRESS to 'true'"
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
