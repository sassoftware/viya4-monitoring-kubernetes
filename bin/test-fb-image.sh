#! /bin/bash

function parseFullImage {
   fullImage="$1"
   unset REGISTRY REPOS IMAGE VERSION

   if [[ "$1" =~ (.*)\/(.*)\/(.*)\:(.*) ]]; then
      echo "ALL:      ${BASH_REMATCH[0]}"
      REGISTRY="${BASH_REMATCH[1]}"
      REPOS="${BASH_REMATCH[2]}"
      IMAGE="${BASH_REMATCH[3]}"
      VERSION="${BASH_REMATCH[4]}"
   else
      echo "no match"
   fi
}


function v4m_replace {

    if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
      sed -i '' s/"$1"/"$2"/g  "$3"
    else
      sed -i  s/"$1"/"$2"/g  "$3"
    fi
}

FB_FULL_IMAGE="cr.fluentbit.io/fluent/fluent-bit:2.1.10"
parseFullImage "$FB_FULL_IMAGE"

rm -f  /tmp/container_image.yaml
cp logging/fb/container_image.template /tmp/container_image.yaml

if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
   REGISTRY="$AIRGAP_REGISTRY"
fi

v4m_replace "__IMAGE_REPO__" "$REGISTRY\/$REPOS\/$IMAGE" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_TAG__" "$VERSION" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_PULL_POLICY__" "Always" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_PULL_SECRETS__" "[]" "/tmp/container_image.yaml"

cat /tmp/container_image.yaml

#2nd verse, much like the 1st
OS_FULL_IMAGE="docker.io/opensearchproject/opensearch:2.10.0"
parseFullImage "$OS_FULL_IMAGE"

rm -f  /tmp/container_image.yaml
cp logging/opensearch/os_container_image.template /tmp/container_image.yaml

if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
   REGISTRY="$AIRGAP_REGISTRY"
fi

v4m_replace "__GLOBAL_REGISTRY__" "$REGISTRY" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_REPO__" "$REGISTRY\/$REPOS\/$IMAGE" "/tmp/container_image.yaml"    #No Registry since we set Global?
v4m_replace "__IMAGE_TAG__" "$VERSION" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_PULL_POLICY__" "Always" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_PULL_SECRETS__" "[]" "/tmp/container_image.yaml"

OS_SYSCTL_FULL_IMAGE="docker.io/library/busybox:latest"
parseFullImage "$OS_SYSCTL_FULL_IMAGE"

v4m_replace "__OS_SYSCTL_IMAGE__" "$REGISTRY\/$REPOS\/$IMAGE" "/tmp/container_image.yaml" 
v4m_replace "__OS_SYSCTL_TAG__" "$VERSION" "/tmp/container_image.yaml"

cat /tmp/container_image.yaml

#3rd times the charm 
OSD_FULL_IMAGE="docker.io/opensearchproject/opensearch-dashboards:2.10.0"
parseFullImage "$OSD_FULL_IMAGE"

rm -f  /tmp/container_image.yaml
cp logging/opensearch/osd_container_image.template /tmp/container_image.yaml

if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
   REGISTRY="$AIRGAP_REGISTRY"
fi

#v4m_replace "__GLOBAL_REGISTRY__" "$REGISTRY" "/tmp/container_image.yaml"  #NOT NEEDED
v4m_replace "__IMAGE_REPO__" "$REGISTRY\/$REPOS\/$IMAGE" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_TAG__" "$VERSION" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_PULL_POLICY__" "Always" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_PULL_SECRETS__" "[]" "/tmp/container_image.yaml"

cat /tmp/container_image.yaml

#4 on the floor
ES_EXPORTER_FULL_IMAGE="quay.io/prometheuscommunity/elasticsearch-exporter:v1.6.0"
parseFullImage "$ES_EXPORTER_FULL_IMAGE"

rm -f  /tmp/container_image.yaml
cp logging/esexporter/es-exporter_container_image.template /tmp/container_image.yaml

if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
   REGISTRY="$AIRGAP_REGISTRY"
fi

#v4m_replace "__GLOBAL_REGISTRY__" "$REGISTRY" "/tmp/container_image.yaml"  #NOT NEEDED
v4m_replace "__IMAGE_REPO__" "$REGISTRY\/$REPOS\/$IMAGE" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_TAG__" "$VERSION" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_PULL_POLICY__" "Always" "/tmp/container_image.yaml"
v4m_replace "__IMAGE_PULL_SECRET__" "null" "/tmp/container_image.yaml"      #Single Image Pull Secret 

cat /tmp/container_image.yaml

#Function, function what's your (er) function?
function doitall {

   #arg1 Full container image
   #arg2 name of template file
   parseFullImage "$1"

   tempfile="/tmp/container_image.yaml"

   rm -f  $tempfile
   cp $2  $tempfile

   if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
      REGISTRY="$AIRGAP_REGISTRY"
   fi

   v4m_replace "__GLOBAL_REGISTRY__"    "$REGISTRY"                 "$tempfile"
   v4m_replace "__IMAGE_REPO__"         "$REGISTRY\/$REPOS\/$IMAGE" "$tempfile"
   v4m_replace "__IMAGE_TAG__"          "$VERSION"                  "$tempfile"
   v4m_replace "__IMAGE_PULL_POLICY__"  "Always"                    "$tempfile"
   v4m_replace "__IMAGE_PULL_SECRET__"  "null"                      "$tempfile"       #Handle Single Image Pull Secret
   v4m_replace "__IMAGE_PULL_SECRETS__" "[]"                        "$tempfile"       #Handle Multiple Image Pull Secrets

   cat $tempfile

}

echo "*****************"
doitall "$FB_FULL_IMAGE"          "logging/fb/container_image.template"
doitall "$OS_FULL_IMAGE"          "logging/opensearch/os_container_image.template"
doitall "$OSD_FULL_IMAGE"         "logging/opensearch/osd_container_image.template"
doitall "$ES_EXPORTER_FULL_IMAGE" "logging/esexporter/es-exporter_container_image.template"


#### REMOVE FOLLOWING
exit
LOG_NS=foo
FLUENTBIT_HELM_CHART_VERSION=0.40.0
touch /tmp/empty.yaml
FB_OPENSEARCH_USER_YAML=/tmp/empty.yaml
set -x
helm $helmDebug upgrade --install --namespace $LOG_NS fb-testing  \
  --version $FLUENTBIT_HELM_CHART_VERSION \
  --values /tmp/container_image.yaml \
  --values logging/fb/fluent-bit_helm_values_opensearch.yaml  \
  --values $FB_OPENSEARCH_USER_YAML   \
  --set fullnameOverride=v4m-fb \
  fluent/fluent-bit
 
