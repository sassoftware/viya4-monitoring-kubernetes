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
   #arg3 prefix to insert in placeholders
   #prefix="_"
   parseFullImage "$1"
   prefix=${3:-""}

   tempfile="/tmp/container_image.yaml"
   template_file=$2

   if [ "$template_file" != "TEMPFILE" ]; then
      rm -f  $tempfile
      cp $template_file  $tempfile
   else
      echo "DEBUG: modifying existing file"
   fi

   if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
      REGISTRY="$AIRGAP_REGISTRY"
   fi
   v4m_replace "__${prefix}IMAGE_REGISTRY__"     "$REGISTRY"                 "$tempfile"
   v4m_replace "__${prefix}GLOBAL_REGISTRY__"    "$REGISTRY"                 "$tempfile"
   v4m_replace "__${prefix}IMAGE_REPO__"         "$REGISTRY\/$REPOS\/$IMAGE" "$tempfile"
   v4m_replace "__${prefix}IMAGE__"              "$IMAGE"                    "$tempfile"
   v4m_replace "__${prefix}IMAGE_TAG__"          "$VERSION"                  "$tempfile"
   v4m_replace "__${prefix}IMAGE_PULL_POLICY__"  "Always"                    "$tempfile"
   v4m_replace "__${prefix}IMAGE_PULL_SECRET__"  "null"                      "$tempfile"       #Handle Single Image Pull Secret
   v4m_replace "__${prefix}IMAGE_PULL_SECRETS__" "[]"                        "$tempfile"       #Handle Multiple Image Pull Secrets

   cat $tempfile

}

echo "*****************"

doitall "$FB_FULL_IMAGE"          "logging/fb/container_image.template"

doitall "$OS_FULL_IMAGE"          "logging/opensearch/os_container_image.template"
doitall "$OS_SYSCTL_FULL_IMAGE"   "TEMPFILE"  "OS_SYSCTL_"

doitall "$OSD_FULL_IMAGE"         "logging/opensearch/osd_container_image.template"

doitall "$ES_EXPORTER_FULL_IMAGE" "logging/esexporter/es-exporter_container_image.template"

GRAFANA_FULL_IMAGE="docker.io/grafana/grafana:10.2.1"
GRAFANA_SIDECAR_FULL_IMAGE="quay.io/kiwigrid/k8s-sidecar:1.25.2"
doitall "$GRAFANA_FULL_IMAGE"     "monitoring/grafana_container_image.template"
doitall "$GRAFANA_SIDECAR_FULL_IMAGE"   "TEMPFILE"  "SIDECAR_"

ALERTMANAGER_FULL_IMAGE="quay.io/prometheus/alertmanager:v0.26.0"
GRAFANA_FULL_IMAGE="docker.io/grafana/grafana:10.2.1"
GRAFANA_SIDECAR_FULL_IMAGE="quay.io/kiwigrid/k8s-sidecar:1.25.2"
ADMWEBHOOK_FULL_IMAGE="registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20221220-controller-v1.5.1-58-g787ea74b6"
KSM_FULL_IMAGE="registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.0"
NODEXPORT_FULL_IMAGE="quay.io/prometheus/node-exporter:v1.7.0"
PROMETHEUS_FULL_IMAGE="quay.io/prometheus/prometheus:v2.47.1"
PROMOP_FULL_IMAGE="quay.io/prometheus-operator/prometheus-operator:v0.69.1"
CONFIGRELOAD_FULL_IMAGE="quay.io/prometheus-operator/prometheus-config-reloader:v0.69.1"

doitall "$PROMOP_FULL_IMAGE"          "TEMPFILE"  "monitoring/prom-operator_container_image.template"
doitall "$ALERTMANAGER_FULL_IMAGE"    "TEMPFILE"  "ALERTMANAGER_"
doitall "$ADMWEBHOOK_FULL_IMAGE"      "TEMPFILE"  "ADMWEBHOOK_"
doitall "$KSM_FULL_IMAGE"             "TEMPFILE"  "KSM_"
doitall "$NODEXPORT_FULL_IMAGE"       "TEMPFILE"  "NODEXPORT_"
doitall "$PROMETHEUS_FULL_IMAGE"      "TEMPFILE"  "PROMETHEUS_"
doitall "$CONFIGRELOAD_FULL_IMAGE"    "TEMPFILE"  "CONFIGRELOAD_"
doitall "$GRAFANA_FULL_IMAGE"         "TEMPFILE"  "GRAFANA_"
doitall "$GRAFANA_SIDECAR_FULL_IMAGE" "TEMPFILE"  "SIDECAR_"



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
 
