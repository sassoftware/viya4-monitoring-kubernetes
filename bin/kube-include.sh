# Copyright © 2020-2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# shellcheck disable=SC2148

# This script is not intended to be run directly
# Assumes bin/common.sh has been sourced

if [ ! "$(which kubectl)" ]; then
    log_error "kubectl not found on the current PATH"
    exit 1
fi

KUBE_CLIENT_VER=$(kubectl version | sed -n 's/^Client Version:[[:space:]]*//p')
KUBE_SERVER_VER=$(kubectl version | sed -n 's/^Server Version:[[:space:]]*//p')

if [ "$KUBE_CLIENT_VER" != "$(semver_parse "$KUBE_CLIENT_VER")" ]; then
    log_error "Kubernetes Client Version does not match expected pattern."
fi

if [ "$KUBE_SERVER_VER" != "$(semver_parse "$KUBE_SERVER_VER")" ]; then
    log_error "Kubernetes SERVER Version does not match expected pattern."
fi

# SAS Viya 4 versions
# supported by SAS Tech Support
# Updated: 20MAY26
# 2024.03 LTS 1.26 1.28   (EOL: 1.26)
# 2024.09 LTS 1.28 1.30   (EOL: 1.28)
# 2025.03 LTS 1.29 1.31
# 2025.09 LTS 1.31 1.33
# 2026.01     1.31 1.33
# 2026.02     1.32 1.34
# 2026.03     1.32 1.34
# 2026.04     1.32 1.34

KUBE_MIN_VER=${KUBE_MIN_VER:-"1.28.0"} #TO DO: Keep this changeable via env var?

if semver_check "$KUBE_SERVER_VER" MIN "$KUBE_MIN_VER"; then
    :
else
    log_warn "The detected version of Kubernetes [$KUBE_SERVER_VER] is not supported by any of the currently supported releases of SAS Viya."
    log_warn "This script might not work as expected. Support might not be available until Kubernetes is upgraded to a supported version."
fi

# Client version allowed to be one MINOR version earlier than
# minimum server version (PATCH value does not matter, set to 0)

##KUBE_MIN_MAJOR_VERSION=$(semver_parse "$KUBE_MIN_VER" MAJOR)
##KUBE_MIN_MINOR_VERSION=$(semver_parse "$KUBE_MIN_VER" MINOR)
##KUBE_CLIENT_MIN_VER="$KUBE_MIN_MAJOR_VERSION.$((KUBE_MIN_MINOR_VERSION-1)).0"

KUBE_CLIENT_MIN_VER=$(semver_parse "$KUBE_MIN_VER" MAJOR).$(($(semver_parse "$KUBE_MIN_VER" MINOR) - 1)).0
if semver_check "$KUBE_CLIENT_VER" MIN "$KUBE_CLIENT_MIN_VER"; then
    :
else
    log_warn "Unsupported kubectl version: [$KUBE_CLIENT_VER]."
    log_warn "This script might not work as expected. Support might not be available until kubectl is upgraded to a supported version."
fi

export KUBE_CLIENT_VER="$KUBE_CLIENT_VER"
export KUBE_SERVER_VER="$KUBE_SERVER_VER"
