# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is not intended to be run directly
# Assumes bin/common.sh has been sourced

function ocVersionCheck {
  origIFS=$IFS
  IFS=$'\n'

  allArr=($(oc version 2>/dev/null))
  IFS=$origIFS

  for (( i=0; i<${#allArr[@]}; i++ )); do
    # Split the line into an array
    verArr=(${allArr[$i]})
    if [ ${#verArr[@]} -eq 3 ]; then
      verType="${verArr[0]}"
      ver="${verArr[2]}"
      if [ "$verType" == "Client" ]; then
          ver="${verArr[2]}"
          if [[ $ver =~ v?(([0-9]+)\.([0-9]+)\.([0-9]+)) ]]; then
            OC_FULL_VERSION=${BASH_REMATCH[1]}
            OC_MAJOR_VERSION=${BASH_REMATCH[2]}
            OC_MINOR_VERSION=${BASH_REMATCH[3]}
            OC_PATCH_VERSION=${BASH_REMATCH[4]}
          else
            echo "Unable to parse client version: [$ver]"
          fi
      elif [ "$verType" == "Server" ]; then
          ver="${verArr[2]}"
          if [[ $ver =~ (([0-9]+)\.([0-9]+)\.([0-9]+)) ]]; then
            OSHIFT_FULL_VERSION=${BASH_REMATCH[1]}
            OSHIFT_MAJOR_VERSION=${BASH_REMATCH[2]}
            OSHIFT_MINOR_VERSION=${BASH_REMATCH[3]}
            OSHIFT_PATCH_VERSION=${BASH_REMATCH[4]}
          else
            echo "Unable to parse server version: [$ver]"
          fi
      fi
    fi
  done
  log_info "OpenShift client version: $OC_FULL_VERSION"
  log_info "OpenShift server version: $OSHIFT_FULL_VERSION"
  
  # Version enforcement
  if [ "$OPENSHIFT_VERSION_CHECK" == "true" ]; then
    ## Server Version
    ### Openshift versions that do not start with a 4 should produce an error.
    if (( "$OSHIFT_MAJOR_VERSION" != 4 )); then
      log_error "Unsupported OpenShift server version: $OSHIFT_FULL_VERSION"
      log_error "Version 4.10+ is required"
      exit 1
    ### 17MAY23: Openshift 4 versions earlier than 4.10 should produce an error.
    elif (( "$OSHIFT_MINOR_VERSION" < 11 )); then
      log_error "Unsupported OpenShift server version: $OSHIFT_FULL_VERSION"
      log_error "Version 4.10+ is required"
      exit 1
    else
      log_debug "OpenShift server version check OK"
    fi

    ## Client Version
    ### Openshift versions that do not start with a 4 should produce an error.
    if (( "$OC_MAJOR_VERSION" != 4 )); then
      log_error "Unsupported OpenShift client version: $OC_FULL_VERSION"
      log_error "Version 4.9+ is required"
      exit 1
    ### Openshift 4 client version must be w/in 1 minor releases of server minimum.
    elif (( "$OC_MINOR_VERSION" < 9 )); then
      log_error "Unsupported OpenShift client version: $OC_FULL_VERSION"
      log_error "Version 4.9+ is required"
      exit 1
    else
      log_debug "OpenShift client version check OK"
    fi
  fi
}

OPENSHIFT_VERSION_CHECK=${OPENSHIFT_VERSION_CHECK:-true}
if [ "$SAS_OPENSHIFT_SOURCED" != "true" ]; then
  if [ "$OPENSHIFT_CLUSTER" == "" ]; then
    # Detect OpenShift cluster
    if kubectl get ns openshift 2>/dev/null 1>&2; then
      log_debug "OpenShift detected"
      OPENSHIFT_CLUSTER="true"
    else
      log_debug "OpenShift not detected"
      OPENSHIFT_CLUSTER="false"
    fi
  else
    log_debug "Skipping OpenShift detection. OPENSHIFT_CLUSTER=[$OPENSHIFT_CLUSTER]"
  fi

  if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    if [ "${OPENSHIFT_OC_CHECK:-true}" == "true" ]; then
      if [ ! $(which oc) ]; then
        echo "'oc' is required for OpenShift and not found on the current PATH"
        exit 1
      fi
      ocVersionCheck

      # Get base OpenShift route hostname
      OPENSHIFT_ROUTE_DOMAIN=${OPENSHIFT_ROUTE_DOMAIN:-$(oc get route -n openshift-console console -o 'jsonpath={.spec.host}' | cut -c 27-)}
      if [ "$OPENSHIFT_ROUTE_DOMAIN" != "" ]; then
        log_debug "OpenShift route host is [$OPENSHIFT_ROUTE_DOMAIN]"
      else
        log_error "Unable to determine OpenShift route host. Set OPENSHIFT_ROUTE_DOMAIN if necessary."
        exit 1
      fi

      export OPENSHIFT_ROUTE_DOMAIN
      export OC_MAJOR_VERSION OC_MINOR_VERSION OC_PATCH_VERSION
      export OSHIFT_MAJOR_VERSION OSHIFT_MINOR_VERSION OSHIFT_PATCH_VERSION
    fi
  else
    log_debug "OpenShift not detected. Skipping 'oc' checks."
  fi
  export OPENSHIFT_CLUSTER
  export SAS_OPENSHIFT_SOURCED="true"
fi
