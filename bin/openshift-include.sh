# shellcheck disable=SC2148
# Copyright © 2026,2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is not intended to be run directly
# Assumes bin/common.sh has been sourced

if [ "$SAS_OPENSHIFT_SOURCED" != "true" ]; then
    if [ "$OPENSHIFT_CLUSTER" == "" ]; then
        # Detect OpenShift cluster
        if kubectl get ns openshift 2> /dev/null 1>&2; then
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

        #Confirm oc CLI is available
        if ! which oc 1> /dev/null; then
            echo "'oc' is required for OpenShift and not found on the current PATH"
            exit 1
        fi

        OSHIFT_VER=$(oc version | sed -n 's/^Server Version:[[:space:]]*//p')

        if [ "$OSHIFT_VER" == "$(semver_parse "$OSHIFT_VER")" ]; then
            OSHIFT_FULL_VERSION="$(semver_parse "$OSHIFT_VER" FULL)"
            OSHIFT_MAJOR_VERSION="$(semver_parse "$OSHIFT_VER" MAJOR)"
            OSHIFT_MINOR_VERSION="$(semver_parse "$OSHIFT_VER" MINOR)"
            OSHIFT_PATCH_VERSION="$(semver_parse "$OSHIFT_VER" PATCH)"
        else
            log_error "OpenShift Version [$OSHIFT_VER] does not match expected pattern."
        fi
        log_info "OpenShift server version: $OSHIFT_FULL_VERSION"

        OC_VER=$(oc version | sed -n 's/^Client Version:[[:space:]]*//p')

        if [ "$OC_VER" == "$(semver_parse "$OC_VER")" ]; then
            OC_FULL_VERSION="$(semver_parse "$OC_VER" FULL)"
            OC_MAJOR_VERSION="$(semver_parse "$OC_VER" MAJOR)"
            OC_MINOR_VERSION="$(semver_parse "$OC_VER" MINOR)"
            OC_PATCH_VERSION="$(semver_parse "$OC_VER" PATCH)"
        else
            log_error "OpenShift CLI Version [$OC_VER] does not match expected pattern."
        fi
        log_info "OpenShift client version: $OC_FULL_VERSION"

        OPENSHIFT_VERSION_CHECK=${OPENSHIFT_VERSION_CHECK:-true}
        # OpenShift  Version enforcement
        if [ "$OPENSHIFT_VERSION_CHECK" == "true" ]; then

            OPENSHIFT_MIN_VER=${OPENSHIFT_MIN_VER:-"4.14.0"} #TO DO: Keep this changeable via env var?

            ## Server Version
            if semver_check "$OSHIFT_FULL_VERSION" MIN "$OPENSHIFT_MIN_VER"; then
                log_debug "OpenShift server version check OK"
            else
                log_error "Unsupported OpenShift server version: $OSHIFT_FULL_VERSION"
                log_error "Version [$OPENSHIFT_MIN_VER] or higher is required"
                exit 1
            fi

            ## Client Version
            OC_MIN_VER="$OSHIFT_MAJOR_VERSION.$((OSHIFT_MINOR_VERSION - 1)).$OSHIFT_PATCH_VERSION"
            if semver_check "$OSHIFT_FULL_VERSION" MIN "$OC_MIN_VER"; then
                log_debug "OpenShift client version check OK"
            else
                log_error "Unsupported OpenShift client version: $OC_FULL_VERSION"
                log_error "Client version [$OC_MIN_VER] or higher is required"
                exit 1
            fi
        fi

        # Get base OpenShift route hostname
        # shellcheck disable=SC2269
        OPENSHIFT_ROUTE_DOMAIN=${OPENSHIFT_ROUTE_DOMAIN} #clarifies that this can be set externally
        if [ -z "$OPENSHIFT_ROUTE_DOMAIN" ]; then
            OPENSHIFT_ROUTE_DOMAIN=$(oc get route -n openshift-console console -o 'jsonpath={.spec.host}' | cut -c 27-)
        fi

        #confirms OPENSHIFT_ROUTE_DOMAIN is set one way or another
        if [ "$OPENSHIFT_ROUTE_DOMAIN" != "" ]; then
            log_debug "OpenShift route host is [$OPENSHIFT_ROUTE_DOMAIN]"
        else
            log_error "Unable to determine OpenShift route host. Set OPENSHIFT_ROUTE_DOMAIN if necessary."
            exit 1
        fi

        export OPENSHIFT_ROUTE_DOMAIN
        export OC_MAJOR_VERSION OC_MINOR_VERSION OC_PATCH_VERSION             #TODO: Remove? Not used anywhere
        export OSHIFT_MAJOR_VERSION OSHIFT_MINOR_VERSION OSHIFT_PATCH_VERSION #TODO: Remove? Not used anywhere
        export OSHIFT_FULL_VERSION

    else
        log_debug "OpenShift not detected. Skipping 'oc' checks."
    fi
    export OPENSHIFT_CLUSTER
    export SAS_OPENSHIFT_SOURCED="true"
fi
