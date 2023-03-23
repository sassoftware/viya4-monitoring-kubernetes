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

# Minimuim Client version: 1.21  effective: 18OCT22
# Client version allowed to be one minor version earlier than minimum server version
if [[ $KUBE_CLIENT_VER =~ v1.2[1-9] ]]; then
  :
else 
  log_error "Unsupported kubectl version: [$KUBE_CLIENT_VER]"
  exit 1
fi

# 23MAR23
# Supported versions of SAS Viya 4
# 2022.1  LTS 1.20 1.22
# 2022.09 LTS 1.21 1.24
# 2022.12     1.22 1.24
# 2023.01     1.22 1.24
# 2023.02     1.22 1.24
# 2023.03     1.23 1.25

if [[ $KUBE_SERVER_VER =~ v1.2[0-9] ]]; then
  :
else 
  log_warn "WARNING: The detected version of Kubernetes [$KUBE_SERVER_VER] is not supported by any of the currently supported releases of SAS Viya 4."
  log_warn "WARNING: This script might not work as expected. Support might not be available until the Kubernetes version is upgraded to a supported version."
fi

export KUBE_CLIENT_VER="$KUBE_CLIENT_VER"
export KUBE_SERVER_VER="$KUBE_SERVER_VER"
