#!/bin/bash

source $V4M_REPO/bin/colors-include.sh
source $V4M_REPO/bin/log-include.sh
source $V4M_REPO/bin/helm-include.sh

LOG_COLOR_ENABLE="false"

#REQUIRED for log_* to function
exec 3>&1

echo "HELM_VER_FULL=$HELM_VER_FULL"
echo "HELM_VER_MAJOR=$HELM_VER_MAJOR"
echo "HELM_VER_MINOR=$HELM_VER_MINOR"
echo "HELM_VER_PATCH=$HELM_VER_PATCH"

#get_helmchart_reference function test
##success: non-airgap
get_helmchart_reference myrepo mychart 1.2.3

##success: airgap - tar file
AIRGAP_HELM_REPO="airgapRepo"
AIRGAP_HELM_FORMAT="tgz"
get_helmchart_reference myrepo mychart 1.2.3

##success: airgap - OCI 
AIRGAP_HELM_FORMAT="oci"
get_helmchart_reference myrepo mychart 1.2.3

##failure: missing version
get_helmchart_reference myrepo mychart

##failure: missing chart name
get_helmchart_reference myrepo

##failure: missing repository
get_helmchart_reference 

##failure: missing version
get_helmchart_reference myrepo "" "1.2.3"

# helm3ReleaseExists
##test set-up
###kubectl create ns helmtest

helm $helmDebug upgrade --install \
     --create-namespace \
     -n "helmtest" \
     --set testvalue=1 \
     helmtest1   $V4M_REPO/v4m-chart > /dev/null 2>&1
if [  "$?" != "0" ]; then
   log_error "Helm chart installation failed!"
   exit
fi

##success: Helm release exists
if helm3ReleaseExists helmtest1 helmtest ; then
   echo "Helm release [helmtest1] in namespace [helmtest] found"
else
   echo "Helm release [helmtest1] in namespace [helmtest] NOT found"
fi

##failure: Helm release does NOT exist
if helm3ReleaseExists helmtest2 helmtest ; then
   echo "Helm release [helmtest2] in namespace [helmtest] found"
else
   echo "Helm release [helmtest2] in namespace [helmtest] NOT found"
fi

##test clean-up
helm uninstall -n helmtest "helmtest1"
kubectl delete namespace helmtest

#helmRepoAdd function test
##Add a repo (using Fluent helm repo)
helmRepoAdd foo https://fluent.github.io/helm-charts

##test clean-up
helm repo remove foo

##Add a repo w/AIRGAP_DEPLOYMENT = true (should be no op)
AIRGAP_DEPLOYMENT=true
helmRepoAdd foo https://fluent.github.io/helm-charts

##the following should generate a "0" since 
##the 'foo' repo should NOT have been added
helm repo list |grep foo|wc -l

