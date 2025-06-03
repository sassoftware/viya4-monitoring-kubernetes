#!/bin/bash

# Basic test for v4m version information

TEST_NS="ver-test-namespace"
export V4M_NS=$TEST_NS

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

# Clean up
removeV4MInfo $TEST_NS


kubectl delete namespace $TEST_NS
