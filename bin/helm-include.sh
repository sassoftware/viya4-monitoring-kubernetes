#!/bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is not intended to be run directly
# Assumes bin/common.sh has been sourced

if [ ! $(which helm) ]; then
  echo "helm not found on the current PATH"
  exit 1
fi

helmVer=$(helm version 2>/dev/null)
if [[ "$helmVer" =~ 'Version:"v3.' ]]; then
  HELM_VER_MAJOR=3
  HELM_VER_FULL=$(helm version --short)
elif [[ "$helmVer" =~ 'SemVer:"v2.' ]]; then
  HELM_VER_MAJOR=2
  HELM_VER_FULL=$(helm version --short --client --template '{{ .Client.SemVer }}')
  HELM_SERVER_VER_FULL=$(helm version --short --template '{{ .Server.SemVer }}')
else
  echo "Error: Unable to determine helm version from [$(which helm) -version]: [$helmVer]"
  exit 1
fi

function helm2ReleaseExists {
  release=$1
  log_debug "Checking for Helm 2.x release of [$release]"
  releases=$(kubectl get configmap --all-namespaces -l "OWNER=TILLER" -o name)
  if [[ $releases =~ configmap/$release\.v[0-9]+ ]]; then
    log_debug "A Helm 2.x release of [$release] exists"
    return 0
  else
    return 1
  fi
}

function helm3ReleaseExists {
  release=$1
  namespace=$2
  log_debug "Checking for Helm 3.x release of [$release]"
  releases=$(kubectl get secret -n $namespace -l name=$release,owner=helm -o name)
  if [[ $releases =~ secret/sh\.helm\.release\.v1\.$release\.v[0-9]+ ]]; then
    log_debug "A Helm 3.x release of [$release] exists"
    return 0
  else
    return 1
  fi
}

function helm2ReleaseCheck {
  if [ "$HELM_RELEASE_CHECK" != "false" ]; then
    if [ "$HELM_VER_MAJOR" == "3" ]; then
      release=$1
      if helm2ReleaseExists $release; then
        log_error "A Helm 2.x release of [$release] already exists"
        log_error "Helm [$HELM_VER_FULL] cannot manage the Helm 2.x release of [$release]"
        exit 1
      fi  
    fi
  fi
}

function helm3ReleaseCheck {
  if [ "$HELM_RELEASE_CHECK" != "false" ]; then
    if [ "$HELM_VER_MAJOR" == "2" ]; then
      release=$1
      namespace=$2
      if helm3ReleaseExists $release $namespace; then
        log_error "A Helm 3.x release of [$release] already exists in the [$namespace] namespace"
        log_error "Helm [$HELM_VER_FULL] cannot manage the Helm 3.x release of [$release] in [$namespace]"
        exit 1
      fi
    fi
  fi
}

function helmRepoAdd {
  repo=$1
  repoURL=$2
  if [[ ! $(helm repo list 2>/dev/null) =~ $repo[[:space:]] ]]; then
    log_info "Adding [$repo] helm repository"
    helm repo add $repo $repoURL
  else
    log_debug "The helm repo [$repo] already exists"
  fi
}

export HELM_VER_MAJOR HELM_VER_FULL HELM_SERVER_VER_FULL
export -f helm2ReleaseExists
export -f helm3ReleaseExists
export -f helm2ReleaseCheck
export -f helm3ReleaseCheck
export -f helmRepoAdd
