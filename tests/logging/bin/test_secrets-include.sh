#! /bin/bash

# Copyright © 2021-2024, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

V4M_REPO=${V4M_REPO:-"../viya4-monitoring-kubernetes"}
LOG_COLOR_ENABLE=false

cd $V4M_REPO

source $V4M_REPO/logging/bin/common.sh
source $V4M_REPO/logging/bin/secrets-include.sh

LOG_NS=${TEST_NAMESPACE:-unit-test-ns}

secret_name="internal-user-testuser"
user_name="testuser"
password="Password123"
label="somelabel=somevalue"

## PREP
log_info "Prep Start"
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" != "namespace/$LOG_NS" ]; then

   log_debug "Creating namespace [$LOG_NS]"

   kubectl create namespace $LOG_NS 2> /dev/null
   if [ "$?" == "0" ]; then
      created_namespace="true"
   else
      exit 1
   fi

else
   log_info "Using existing namespace [$LOG_NS]."
fi
log_info "Prep End"

## TEST #1: create_user_secret
log_info "Test #1 Start"
create_user_secret $secret_name $user_name "$password" $label
log_info "Test #1 End"

## TEST #2: get_credentials_from_secret
log_info "Test #2 Start"
get_credentials_from_secret "$user_name"
if [ "$ES_TESTUSER_USER" != "$user_name" ]; then
   log_info "ERROR: Unexpected username retrieved from secret"
   log_info "ES_TESTUSER_USER:   [$ES_TESTUSER_USER]   USER_NAME: [$user_name]"
else
  log_info "Expected username retrieved from secret"
fi

if [ "$ES_TESTUSER_PASSWD" != "$password" ]; then
   log_info "ERROR: Unexpected password retrieved from secret"
   log_info "ES_TESTUSER_PASSWD: [$ES_TESTUSER_PASSWD] PASSWORD:  [$password]"
else
  log_info "Expected password retrieved from secret"
fi
log_info "Test #2 End"

## TEST #3: create_secret_from_file
log_info "Test #3 Start"
mkdir  $TMP_DIR/logging
secretfile="$TMP_DIR/logging/secret.yaml"

touch "$secretfile"
echo "Here is some super secret stuff we do not want people to know." >> "$secretfile"
echo "Please do not tell anyone." >> "$secretfile"

export USER_DIR=$TMP_DIR
create_secret_from_file "secret.yaml" "some-random-secret" "label1=value1"

kubectl -n $LOG_NS get secret "some-random-secret"
log_info "Test #3 End"


log_info "Cleanup Start"
kubectl -n $LOG_NS delete secret some-random-secret     --ignore-not-found
kubectl -n $LOG_NS delete secret internal-user-testuser --ignore-not-found

if [  "$created_namespace" == "true" ]; then
   log_debug "Deleting namespace [$LOG_NS]"
   kubectl delete ns $LOG_NS --ignore-not-found
else
   log_info "Leaving pre-existing namespace [$LOG_NS] in-place."
fi
log_info "Cleanup End"


## test case: greenfield; everything works
# INFO User directory: /home/sasgzs/repos/viya4-monitoring-kubernetes
# INFO Helm client version: 3.12.3
# INFO Kubernetes client version: v1.27.4
# INFO Kubernetes server version: v1.27.2
# INFO Loading user environment file: /home/sasgzs/repos/viya4-monitoring-kubernetes/logging/user.env
#
# INFO Prep Start
# namespace/foo created
# INFO Prep End
# INFO Test #1 Start
# INFO Created secret for OpenSearch user credentials [testuser]
# secret/internal-user-testuser labeled
# INFO Test #1 End
# INFO Test #2 Start
# INFO Expected username retrieved from secret
# INFO Expected password retrieved from secret
# INFO Test #2 End
# INFO Test #3 Start
# INFO Created secret for OpenSearch config file [secret.yaml]
# secret/some-random-secret labeled
# NAME                 TYPE     DATA   AGE
# some-random-secret   Opaque   1      2s
# INFO Test #3 End
# INFO Cleanup Start
# secret "some-random-secret" deleted
# secret "internal-user-testuser" deleted
# namespace "foo" deleted
# INFO Cleanup End

## If specified namespace exists, the namespace created/deleted
## messages are replaced with the following (respectively)
# INFO Using existing namespace [foobar].
# INFO Leaving pre-existing namespace [foobar] in-place.


