#!/bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is not intended to be run directly
# Assumes bin/common.sh has been sourced

if [ ! $(which helm) ]; then
  echo "helm not found on the current PATH"
  exit 1
fi

helmVer=$(helm version --short 2>/dev/null)
hver=( $(echo ${helmVer//[^0-9]/ }) )
HELM_VER_MAJOR=${hver[0]}
HELM_VER_MINOR=${hver[1]}
HELM_VER_PATCH=${hver[2]}
HELM_VER_FULL=$HELM_VER_MAJOR.$HELM_VER_MINOR.$HELM_VER_PATCH
if [ "$HELM_VER_MAJOR" == "2" ]; then
    log_error "Helm 2.x has reached end of life as of 11/13/2020 and is no longer supported"
    log_error "See: https://github.com/helm/helm/releases/tag/v2.17.0 for details"
    log_error "Please upgrade to Helm 3.x at https://github.com/helm/helm/releases"
    exit 1
fi

if [ "$V4M_HELM_USE_LATEST"  == "true" ]; then
  log_info "Environment variable V4M_HELM_USE_LATEST set; deploying *latest* version of all Helm charts"
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
    release=$1
    if helm2ReleaseExists $release; then
      log_error "A Helm 2.x release of [$release] already exists"
      log_error "Helm [$HELM_VER_FULL] cannot manage the Helm 2.x release of [$release]"
      exit 1
    fi  
  fi
}

function helmRepoAdd {
  repo=$1
  repoURL=$2

  ## If this is an air gap deployment, do nothing
  if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
    return 0
  fi 

  HELM_FORCE_REPO_UPDATE=${HELM_FORCE_REPO_UPDATE:-true}
  if [[ ! $(helm repo list 2>/dev/null) =~ $repo[[:space:]] ]]; then
    log_info "Adding [$repo] helm repository"
    helm repo add $repo $repoURL
  else
    log_debug "The helm repo [$repo] already exists"
    if [ "$HELM_FORCE_REPO_UPDATE" == "true" ]; then
      log_debug "Forcing update of [$repo] helm repo to [$repoURL]"

      # Helm 3.3.2 changed 'repo add' behavior and added the --force-update flag
      # https://github.com/helm/helm/releases/tag/v3.3.2
      if [[  $HELM_VER_MINOR -lt 3 || ( $HELM_VER_MINOR -eq 3 &&  $HELM_VER_PATCH -lt 2) ]]; then
         helm repo add $repo $repoURL
      else
         helm repo add --force-update $repo $repoURL
      fi

    fi
  fi
}

function get_helmchart_reference {
  local chart_repository chart_name chart_version

  chart_repository=$1
  chart_name=$2
  chart_version=$3

  if [ -z "$chart_repository" ]; then
     echo "'ERROR: Helm chart repository not specified'"
     return 1
  elif [ -z "$chart_name" ]; then
     echo "'ERROR: Helm chart name not specified'"
     return 1
  elif [ -z "$chart_version" ]; then
     echo "'ERROR: Helm chart version not specified'"
     return 1
  else
     #all parms have values
     :
  fi

  if [ "$AIRGAP_HELM_FORMAT"  == "tgz" ]; then
      echo "${AIRGAP_HELM_REPO}/${chart_name}-${chart_version}.tgz"
  elif [ "$AIRGAP_HELM_FORMAT"  == "oci" ]; then
      echo "oci://${AIRGAP_HELM_REPO}/${chart_repository}/${chart_name}"
  else
      echo "${chart_repository}/${chart_name}"
  fi
}
function get_helm_versionstring {
    if [ "$V4M_HELM_USE_LATEST"  == "true" ]; then
       :  # return null string
    else
       echo "--version $1"
    fi

    return
}
export HELM_VER_FULL HELM_VER_MAJOR HELM_VER_MINOR HELM_VER_PATCH
export -f helm2ReleaseExists
export -f helm3ReleaseExists
export -f helm2ReleaseCheck
export -f helmRepoAdd
export -f get_helmchart_reference
export -f get_helm_versionstring
