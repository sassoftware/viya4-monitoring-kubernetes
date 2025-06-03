#!/bin/bash

# Test version info variables

TEST_NS="ver-test-namespace"
export V4M_NS=$TEST_NS

cd $V4M_REPO

LOG_COLOR_ENABLE="false"
source $V4M_REPO/bin/common.sh
source $V4M_REPO/bin/version-include.sh

kubectl delete namespace $TEST_NS --ignore-not-found
kubectl create namespace $TEST_NS

#
# Deploy
#
# Install a known older version so we can
# validate values of V4M_CURRENT* variables

git checkout 1.2.25
deployV4MInfo $TEST_NS
log_info "Listing helm releases in ver-test-namespace"
helm ls -n $TEST_NS

#
# Deploy again
#
# Upgrade to latest version to have V4M_CURRENT* variables
# displayed and allow us to test releaseVersion* variables

git checkout main
# V4M_CURRENT* variables are only set on
# initial load of version-include.sh.
unset V4M_VERSION_INCLUDE
source $V4M_REPO/bin/version-include.sh

deployV4MInfo $TEST_NS

# Check existing version vars that should be set
log_info "Version Information for existing Helm release"
log_info "V4M_CURRENT_VERSION_FULL=$V4M_CURRENT_VERSION_FULL"
log_info "V4M_CURRENT_VERSION_MAJOR=$V4M_CURRENT_VERSION_MAJOR"
log_info "V4M_CURRENT_VERSION_MINOR=$V4M_CURRENT_VERSION_MINOR"
log_info "V4M_CURRENT_VERSION_PATCH=$V4M_CURRENT_VERSION_PATCH"
log_info "V4M_CURRENT_STATUS=$V4M_CURRENT_STATUS"

# Check getHelmReleaseVersion function
log_info "Information on newly installed Helm release"
getHelmReleaseVersion "$TEST_NS"

log_info "releaseVersionFull: [$releaseVersionFull]"
log_info "releaseVersionMajor: [$releaseVersionMajor]"
log_info "releaseVersionMinor: [$releaseVersionMinor]"
log_info "releaseVersionPatch: [$releaseVersionPatch]"
log_info "releaseStatus: [$releaseStatus]"

# Clean up
removeV4MInfo $TEST_NS
kubectl delete namespace $TEST_NS
