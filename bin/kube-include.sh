#!/bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is not intended to be run directly
# Assumes bin/common.sh has been sourced

if [ ! $(which kubectl) ]; then
  log_error "kubectl not found on the current PATH"
  exit 1
fi

KUBE_CLIENT_VER=$(kubectl version --short | grep 'Client Version' | awk '{print $3}' 2>/dev/null)
KUBE_SERVER_VER=$(kubectl version --short | grep 'Server Version' | awk '{print $3}' 2>/dev/null)

# Minimuim version: 1.21  effective: 14JUN22
if [[ $KUBE_CLIENT_VER =~ v1.2[1-9] ]]; then
  :
else 
  log_error "Unsupported kubectl version: [$KUBE_CLIENT_VER]"
  exit 1
fi

# Minimuim version: 1.21  effective: 14JUN22
if [[ $KUBE_SERVER_VER =~ v1.2[1-9] ]]; then
  :
else 
  log_error "Unsupported Kubernetes server version: [$KUBE_SERVER_VER]"
  exit 1
fi

export KUBE_CLIENT_VER="$KUBE_CLIENT_VER"
export KUBE_SERVER_VER="$KUBE_SERVER_VER"
export KUBE_NAMESPACE_DELETE_TIMEOUT=${KUBE_NAMESPACE_DELETE_TIMEOUT:-5m}
