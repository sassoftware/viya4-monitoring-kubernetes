#!/bin/bash

# Test version info with a USER_DIR set

TEST_NS="ver-test-namespace"
export V4M_NS=$TEST_NS

export USER_DIR=$TEST_REPO/tests/common/version-test-user-dir

cd $V4M_REPO

LOG_COLOR_ENABLE="false"
source $V4M_REPO/bin/common.sh
source $V4M_REPO/bin/version-include.sh

kubectl delete namespace $TEST_NS --ignore-not-found
kubectl create namespace $TEST_NS

# Deploy
deployV4MInfo $TEST_NS
log_info "Listing helm releases in ver-test-namespace"
helm ls -n $TEST_NS
log_info "Getting helm values for 'v4m' in ver-test-namespace"
helm get values -n $TEST_NS v4m

# Clean up
removeV4MInfo $TEST_NS
kubectl delete namespace $TEST_NS
