# Copyright © 2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo


function checkYqVersion {
   # confirm yq installed and correct version
   local goodver yq_version
   goodver="yq \(.+mikefarah.+\) version (v)?(4\.(4[4-9]|[5-9][0-9])\..+)"
   yq_version=$(yq --version)
   if [ "$?" == "1" ]; then
      log_error "Required component [yq] not available."
      return 1
   elif [[ ! $yq_version =~ $goodver ]]; then
      log_error "Incorrect version [$yq_version] found; version 4.45.1+ required."
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
   export AUTOINGRESS_SOURCED="NotNeeded"
fi

if [ -z "$AUTOINGRESS_SOURCED" ]; then

   checkYqVersion

   # Confirm NOT on OpenShift
   if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
      log_warn "Setting AUTOGENERATE_INGRESS to 'true' is not valid on OpenShift clusters; ignoring option."
      log_warn "Web applications will be made accessible via OpenShift routes instead (if enabled)."

      export AUTOGENERATE_INGRESS="false"
   fi

   if [ "$AUTOGENERATE_INGRESS" == "true" ]; then

      #validate required inputs
      BASE_DOMAIN="${BASE_DOMAIN}"
      if [ -z "$BASE_DOMAIN" ]; then
         log_error "Required parameter [BASE_DOMAIN] not provided"
         exit
      fi

      log_debug "Autogeneration of Ingress definitions has been enabled"

   fi

   if [ "$AUTOGENERATE_STORAGECLASS" == "true" ]; then

      log_debug "Autogeneration of StorageClass specfication has been enabled"

   fi

   export AUTOINGRESS_SOURCED="true"

elif [ "$AUTOINGRESS_SOURCE" == "NotNeeded" ]; then
   log_debug "autoingress-include.sh not needed" 
else
   log_debug "autoingress-include.sh was already sourced [$AUTOINGRESS_SOURCED]"
fi


function checkStorageClass {
    # input parms: $1  storageclass
    local storageClass storageClassEnvVar
    storageClassEnvVar="$1"
    storageClass="${!1:-$STORAGECLASS}"

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
