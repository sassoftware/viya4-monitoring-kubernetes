#!/bin/bash

# Copyright © 2024,2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is not intended to be run directly
# Assumes bin/common.sh has been sourced

if [ ! "$(which kubectl)" ]; then
  log_error "kubectl not found on the current PATH"
  exit 1
fi

KUBE_CLIENT_VER=$(kubectl version --output=json | tr -d '\n' | tr -s " " | sed -E 's/^\{.*"clientVersion": \{([^\}]+)}.*/\1\n/' | sed -E 's/.*"gitVersion": "([^\"]*)".*$/\1/')
KUBE_SERVER_VER=$(kubectl version --output=json | tr -d '\n' | tr -s " " | sed -E 's/^\{.*"serverVersion": \{([^\}]+)}.*/\1\n/' | sed -E 's/.*"gitVersion": "([^\"]*)".*$/\1/')

if [[ "$KUBE_CLIENT_VER" =~ v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
   KUBE_CLIENT_MAJOR=${BASH_REMATCH[1]}
   KUBE_CLIENT_MINOR=${BASH_REMATCH[2]}
   KUBE_CLIENT_PATCH=${BASH_REMATCH[3]}
   log_debug "Kubernetes CLIENT - Major: [$KUBE_CLIENT_MAJOR] Minor: [$KUBE_CLIENT_MINOR] Patch: [$KUBE_CLIENT_PATCH]"
else
   log_error "Kubernetes Client Version does not match expected pattern.";
fi;

if [[ "$KUBE_SERVER_VER" =~ v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
   KUBE_SERVER_MAJOR=${BASH_REMATCH[1]}
   KUBE_SERVER_MINOR=${BASH_REMATCH[2]}
   KUBE_SERVER_PATCH=${BASH_REMATCH[3]}
   log_debug "Kubernetes SERVER - Major: [$KUBE_SERVER_MAJOR] Minor: [$KUBE_SERVER_MINOR] Patch: [$KUBE_SERVER_PATCH]"
else
   log_error "Kubernetes SERVER Version does not match expected pattern.";
fi;

# SAS Viya 4 versions
# supported by SAS Tech Support
# Updated: 26AUG24
# 2022.09 LTS 1.21 1.24  (EOL: 1.21, 1.22)
# 2023.03 LTS 1.23 1.25
# 2023.10 LTS 1.25 1.27
# 2024.03 LTS 1.26 1.28
# 2024.05     1.27 1.29
# 2024.06     1.27 1.29
# 2024.07     1.27 1.29
# 2024.08     1.27 1.29


# Client version allowed to be one minor version earlier than minimum server version
if [ "$KUBE_CLIENT_MAJOR" -eq "1" ] && [ "$KUBE_CLIENT_MINOR" -gt "21" ]; then
  :
else
  log_warn "Unsupported kubectl version: [$KUBE_CLIENT_VER]."
  log_warn "This script might not work as expected. Support might not be available until kubectl is upgraded to a supported version."
fi

if [ "$KUBE_SERVER_MAJOR" -eq "1" ] && [ "$KUBE_SERVER_MINOR" -gt "22"  ]; then
  :
else
  log_warn "The detected version of Kubernetes [$KUBE_SERVER_VER] is not supported by any of the currently supported releases of SAS Viya."
  log_warn "This script might not work as expected. Support might not be available until Kubernetes is upgraded to a supported version."
fi

export KUBE_CLIENT_VER="$KUBE_CLIENT_VER"
export KUBE_SERVER_VER="$KUBE_SERVER_VER"
