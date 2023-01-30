# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

function trap_add() {
 # based on https://stackoverflow.com/questions/3338030/multiple-bash-traps-for-the-same-signal
 # but: prepends new cmd rather than append it, changed var names and eliminated messages

   local cmd_to_add signal

   cmd_to_add=$1; shift
   for signal in "$@"; do
      trap -- "$(
         # print the new trap command
         printf '%s\n' "${cmd_to_add}"
         # helper fn to get existing trap command from output
         # of trap -p
         extract_trap_cmd() { printf '%s\n' "$3"; }
         # print existing trap command with newline
         eval "extract_trap_cmd $(trap -p "${signal}")"
      )" "${signal}"
   done
}

function errexit_msg {
   if [ -o errexit ]; then
      log_error "Exiting script [`basename $0`] due to an error executing the command [$BASH_COMMAND]."
   else
      log_debug "Trap [ERR] triggered in [`basename $0`] while executing the command [$BASH_COMMAND]."
   fi
}

if [ "$SAS_COMMON_SOURCED" = "" ]; then
    # Save standard out to a new descriptor
    exec 3>&1

    # Includes
    source bin/colors-include.sh
    source bin/log-include.sh
    source bin/openshift-include.sh

    if [ ! $(which sha256sum) ]; then
      log_error "Missing required utility: sha256sum"
      exit 1
    fi

    export USER_DIR=${USER_DIR:-$(pwd)}
    if [ -d "$USER_DIR" ]; then
      # Resolve full path
      export USER_DIR=$(cd "$(dirname "$USER_DIR")"; pwd)/$(basename "$USER_DIR")
    fi
    if [ -f "$USER_DIR/user.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' $USER_DIR/user.env | grep -v '^#' | xargs)
        if [ "$userEnv" != "" ]; then
          log_debug "Loading global user environment file: $USER_DIR/user.env"
          if [ "$userEnv" != "" ]; then
            export $userEnv
          fi
        fi
    fi

    log_debug "Working directory: $(pwd)"
    log_info "User directory: $USER_DIR"

    CHECK_HELM=${CHECK_HELM:-true}
    if [ "$CHECK_HELM" == "true" ]; then
       source bin/helm-include.sh
       log_verbose "Helm client version: $HELM_VER_FULL"
    fi

    CHECK_KUBERNETES=${CHECK_KUBERNETES:-true}
    if [ "$CHECK_KUBERNETES" == "true" ]; then
       source bin/kube-include.sh

       log_verbose Kubernetes client version: "$KUBE_CLIENT_VER"
       log_verbose Kubernetes server version: "$KUBE_SERVER_VER"

       # Check that the current KUBECONFIG has admin access
       CHECK_ADMIN=${CHECK_ADMIN:-true}
       if [ "$CHECK_ADMIN" == "true" ]; then
          if [ "$(kubectl auth can-i create namespace --all-namespaces)" == "no" ]; then
             ctx=$(kubectl config current-context)
             log_error "The current kubectl context [$ctx] does not have cluster admin access"
             exit 1
          else
             log_debug "Cluster admin check OK"
          fi
       else
          log_debug "Cluster admin check disabled"
       fi
    fi

    # set TLS Cert Generator (cert-manager|openssl)
    export CERT_GENERATOR="${CERT_GENERATOR:-openssl}"


    # Set default timeout for kubectl namespace delete command
    export KUBE_NAMESPACE_DELETE_TIMEOUT=${KUBE_NAMESPACE_DELETE_TIMEOUT:-5m}

    export TMP_DIR=$(mktemp -d -t sas.mon.XXXXXXXX)
    if [ ! -d "$TMP_DIR" ]; then
      log_error "Could not create temporary directory [$TMP_DIR]"
      exit 1
    fi
    log_debug "Temporary directory: [$TMP_DIR]"
    echo "# This file intentionally empty" > $TMP_DIR/empty.yaml

    # Delete the temp directory on exit
    function cleanup {
      KEEP_TMP_DIR=${KEEP_TMP_DIR:-false}
      if [ "$KEEP_TMP_DIR" != "true" ]; then
        rm -rf "$TMP_DIR"
        log_debug "Deleted temporary directory: [$TMP_DIR]"
      else
        log_info "TMP_DIR [$TMP_DIR] was not removed"
      fi
    }
    trap_add cleanup EXIT

    trap_add errexit_msg ERR

    export SAS_COMMON_SOURCED=true
fi

function checkDefaultStorageClass {
    if [ -z "$defaultStorageClass" ]; then
      # Check for kubernetes environment conflicts/requirements
      defaultStorageClass=$(kubectl get storageclass -o jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.metadata.annotations..storageclass\.kubernetes\.io/is-default-class}{'\n'}{end}" | grep true | awk '{print $1}')
      if [ "$defaultStorageClass" ]; then
        log_debug "Found default storageClass: [$defaultStorageClass]"
      else
        # Try again with beta storageclass annotation key
        defaultStorageClass=$(kubectl get storageclass -o jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.metadata.annotations..storageclass\.beta\.kubernetes\.io/is-default-class}{'\n'}{end}" | grep true | awk '{print $1}')
        if [ "$defaultStorageClass" ]; then
          log_debug "Found default storageClass: [$defaultStorageClass]"
        else
          log_warn "This cluster does not have a default storageclass defined"
          log_warn "This may cause errors unless storageclass values are explicitly defined"
          defaultStorageClass=_NONE_
        fi
      fi
    fi
}

function validateTenantID {
  tenantID=$1
  reservedNames=(default provider shared sharedservices spre uaa viya)

  CHECK_TENANT_NAME=${CHECK_TENANT_NAME:-true}
  if [ "$CHECK_TENANT_NAME" == "true" ]; then
    if [[ $tenantID =~ ^[a-z]([a-z0-9]){0,15}$ ]]; then
      if [[ $tenantID =~ ^sas ]]; then
        log_error "Tenant names cannot start with 'sas'"
        exit 1
      fi
      for n in ${reservedNames[@]}; do
        if [ "$tenantID" == "$n" ]; then
          log_error "The tenant name [$tenantID] is a reserved name"
          exit 1
        fi
      done
    else
      log_error "[$tenantID] is not a valid tenant name"
      exit 1
    fi
  else
    log_debug "Tenant name validation is disabled"
  fi
}


function validateNamespace {
  local namespace
  namespace="$1"
  if [[ "$namespace" =~ ^[a-z0-9]([\-a-z0-9]*[a-z0-9])?$ ]]; then
    log_debug "Namespace [$namespace] passes validation"
  else
    log_error "[$namespace] is not a valid namespace name"
    exit 1
  fi
}


function randomPassword {
  date +%s | sha256sum | base64 | head -c 32 ; echo
}

function disable_sa_token_automount {
  local ns sa_name should_disable
  ns=$1
  sa_name=$2
  should_disable=${SEC_DISABLE_SA_TOKEN_AUTOMOUNT:-true}

  if [ "$should_disable" == "true" ]; then
     log_debug "Disabling automount of API tokens for serviceAccount [$ns/$sa_name]"
     kubectl -n $ns patch serviceAccount $sa_name -p '{"automountServiceAccountToken":false}'
  else
     log_debug "NOT disabling token automount serviceAccount [$ns/$sa_name]; SEC_DISABLE_SA_TOKEN_AUTOMOUNT set to [$SEC_DISABLE_SA_TOKEN_AUTOMOUNT]"
  fi
}

function enable_pod_token_automount {
  local ns resource_type resource_name should_disable
  ns=$1
  resource_type=$2
  resource_name=$3
  should_disable=${SEC_DISABLE_SA_TOKEN_AUTOMOUNT:-true}

  if [ "$should_disable" == "true" ]; then
     log_debug "Enabling automount of API tokens for pods deployed via [$resource_type/$resource_name]"

     if [ "$resource_type" == "daemonset" ] || [ "$resource_type" == "deployment" ]; then
        kubectl -n $ns patch $resource_type  $resource_name -p '{"spec": {"template": {"spec": {"automountServiceAccountToken":true}}}}'
     else
        log_error "Invalid request to function [${FUNCNAME[0]}]; unsupported resource_type [$resource_type]"
        return 1
     fi
  else
     log_debug "NOT enabling token automount on pods for [$ns/$resource_type/$resource_name]; SEC_DISABLE_SA_TOKEN_AUTOMOUNT set to [$SEC_DISABLE_SA_TOKEN_AUTOMOUNT]"
  fi
}

export -f checkDefaultStorageClass
export -f validateTenantID
export -f validateNamespace
export -f randomPassword
export -f trap_add
export -f errexit_msg
export -f disable_sa_token_automount
export -f enable_pod_token_automount
