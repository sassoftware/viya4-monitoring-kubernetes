#!/bin/bash

export USER_DIR=$TEST_REPO/tests/common/test-user-dir

cwd=$(pwd)
cd $V4M_REPO    #change dir so paths w/in common.sh resolve 
source bin/common.sh
cd $cwd

##disable colorized log messages to ensure
##assert statements in robot scripts match
LOG_COLOR_ENABLE=false

checkDefaultStorageClass
echo "defaultStorageClass=$defaultStorageClass"

echo "randomPassword_1=$(randomPassword)"
sleep 2
echo "randomPassword_2=$(randomPassword)"
sleep 2
echo "randomPassword_3=$(randomPassword)"

echo "USER_DIR_ENV_VAR_TEST1=$USER_DIR_ENV_VAR_TEST1"

#validate parseFullImage function
full_image="docker.io/opensearchproject/opensearch:2.17.1"

parseFullImage "$full_image"
rc="$?"
echo "parseFullImage function called return code [$rc]"
echo "REGISTRY [$REGISTRY]"
echo "REPOS [$REPOS]"
echo "IMAGE [$IMAGE]"
echo "VERSION [$VERSION]"
echo "FULL IMAGE ESCAPED [$FULL_IMAGE_ESCAPED]"
echo "full_image [$full_image]"

#ServiceAccount function tests
##validate disable_sa_token_automount function

###By default, automounting is enabled
kubectl create ns commontest
response=$(kubectl get sa -n commontest default -o custom-columns=FOO:automountServiceAccountToken --no-headers)
#### Expected response: <none>
echo "automountServiceAccountToken: $response"

###Disable automounting
disable_sa_token_automount commontest default
#### the function call will output a message
response=$(kubectl get sa -n commontest default -o custom-columns=FOO:automountServiceAccountToken --no-headers)
#### Expected response: false
echo "automountServiceAccountToken: $response"

##enable_pod_token_automount

###Create deployment (function only works with deployment|daemonset)
kubectl -n commontest apply -f data/simple-deployment.yaml

###call function
enable_pod_token_automount commontest deployment simple-deployment

###Try it with a pod, should fail
enable_pod_token_automount commontest pod simple-deployment

##Cleanup after ourselves
kubectl -n commontest delete -f data/simple-deployment.yaml
kubectl delete ns commontest

## validateNamespace function
###NOTE: validateNamespace exits w/none-zero exit code when invalid
###      Therefore, we call it via $() to prevent test script exiting

badns="ABC"     #invalid char: upper-case letters
x=$(validateNamespace "$badns")

badns="a_b_c"   #invalid char: underscore
x=$(validateNamespace "$badns")

###validateNamespace *only* emits 
###DEBUG-level message when passed
###a valid value
LOG_DEBUG_ENABLE=true
goodns="abc123"
x=$(validateNamespace "$goodns")
