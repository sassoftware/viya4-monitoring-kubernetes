#!/bin/bash

# This file should be placed in the top-level 'bin' directory of the
# the viya4-monitoring-kubernetes repository. If not, the 

export V4M_REPO=${V4M_REPO:-$(dirname $BASH_SOURCE)/..}
export V4M_IMAGE=${V4M_IMAGE:-registry.unx.sas.com/brelli/v4m}
export V4M_TAG=${V4M_TAG:-latest}

if [ ! -d "$V4M_REPO" ]; then
    echo "Unable to locate the viya4-monitoring-kubernetes repository at [$V4M_REPO]"
    exit 1
fi

cd "$V4M_REPO"

# Disable checks of the local environment
export OPENSHIFT_OC_CHECK=false
export CHECK_HELM=false
export CHECK_KUBERNETES=false

source bin/common.sh

set -e

if [ ! -f "$KUBECONFIG" ]; then
  log_error "The KUBECONFIG file [$KUBECONFIG] does not exist"
  exit 1
fi

if [ "$USER_DIR" != "" ]; then
  log_debug "Running with USER_DIR=[$USER_DIR]"
	docker run \
      -v "$KUBECONFIG":/opt/v4m/.kube/config \
      -v "$USER_DIR":/opt/v4m/user_dir \
      -e LOG_DEBUG_ENABLE="$LOG_DEBUG_ENABLE" \
      -e VIYA_NS="$VIYA_NS" \
      "$V4M_IMAGE:$V4M_TAG" \
      $*
else
  log_debug "Running with no USER_DIR"
	docker run \
      -v "$KUBECONFIG":/opt/v4m/.kube/config \
      -e LOG_DEBUG_ENABLE="$LOG_DEBUG_ENABLE" \
      -e VIYA_NS="$VIYA_NS" \
      "$V4M_IMAGE:$V4M_TAG" \
      $*
fi

# Clean up if necessary
V4M_REMOVE_CONTAINER_ON_SUCCESS=${V4M_REMOVE_CONTAINER_ON_SUCCESS:-true}
V4M_REMOVE_CONTAINER_ON_ERROR=${V4M_REMOVE_CONTAINER_ON_ERROR:-false}

contID=$(docker ps -lq)
contRC=$(docker inspect $contID --format='{{.State.ExitCode}}')
if [ "$contRC" == "0" ]; then
  log_debug "Container [$contID] completed successfully"
  if [ "$V4M_REMOVE_CONTAINER_ON_SUCCESS" == "true" ]; then
    log_debug "Removing container [$contID]"
    docker rm "$contID" >/dev/null
  fi
else
  log_error "Container [$contID] failed with RC [$contRC]"
  if [ "$V4M_REMOVE_CONTAINER_ON_ERROR" == "true" ]; then
    log_debug "Removing container [$contID]"
    docker rm "$contID" >/dev/null
  fi
fi
