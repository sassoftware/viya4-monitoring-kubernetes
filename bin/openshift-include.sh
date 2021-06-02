# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is not intended to be run directly
# Assumes bin/common.sh has been sourced

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
  log_warn "========================================================================="
  log_warn "OpenShift support is under active development and is EXPERIMENTAL        "
  log_warn "Variable names, defaults and usage may change until officially supported "
  log_warn "========================================================================="
  log_message ""
  
  if [ "${OPENSHIFT_OC_CHECK:-true}" == "true" ]; then
    if [ ! $(which oc) ]; then
      echo "'oc' is required for OpenShift and not found on the current PATH"
      exit 1
    fi
  fi

  ocver=$(oc version --client 2>/dev/null)
  log_debug "oc: $ocver"
  if [[ $verstr =~ v(([0-9]+)\.([0-9]+)\.([0-9]+)) ]]; then
    OC_FULL_VERSION=${BASH_REMATCH[1]}
    OC_MAJOR_VERSION=${BASH_REMATCH[2]}
    OC_MINOR_VERSION=${BASH_REMATCH[3]}
    OC_PATCH_VERSION=${BASH_REMATCH[4]}
  fi

  export OPENSHIFT_CLUSTER OC_FULL_VERSION OC_MAJOR_VERSION OC_MINOR_VERSION OC_PATCH_VERSION
else
  log_debug "OpenShift not detected. Skipping 'oc' checks."
fi
