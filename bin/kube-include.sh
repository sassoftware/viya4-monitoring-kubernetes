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

# Client version allowed to be one minor version earlier than minimum server version
if [[ $KUBE_CLIENT_VER =~ v1.2[0-9] ]]; then
  :
else 
  log_warn "Unsupported kubectl version: [$KUBE_CLIENT_VER]."
  log_warn "This script might not work as expected. Support might not be available until kubectl is upgraded to a supported version."
fi

# SAS Viya 4 versions
# supported by SAS Tech Support
# Updated: 22NOV23
# 2022.09 LTS 1.21 1.24
# 2023.03 LTS 1.23 1.25
# 2023.10 LTS 1.25 1.27
# 2023.08     1.24 1.26
# 2023.09     1.25 1.27
# 2023.10     1.25 1.27
# 2023.11     1.25 1.27
if [[ $KUBE_SERVER_VER =~ v1.2[1-9] ]]; then
  :
else 
  log_warn "The detected version of Kubernetes [$KUBE_SERVER_VER] is not supported by any of the currently supported releases of SAS Viya."
  log_warn "This script might not work as expected. Support might not be available until Kubernetes is upgraded to a supported version."
fi

export KUBE_CLIENT_VER="$KUBE_CLIENT_VER"
export KUBE_SERVER_VER="$KUBE_SERVER_VER"
