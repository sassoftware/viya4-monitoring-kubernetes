#! /bin/bash

function parseFullImage {
   fullImage="$1"
   unset REGISTRY REPOS IMAGE VERSION

   if [[ "$1" =~ (.*)\/(.*)\/(.*)\:(.*) ]]; then
      ###echo "DEBUG:  ${BASH_REMATCH[0]}"

      REGISTRY="${BASH_REMATCH[1]}"
      REPOS="${BASH_REMATCH[2]}"
      IMAGE="${BASH_REMATCH[3]}"
      VERSION="${BASH_REMATCH[4]}"
      return 0
   else
      ###echo "no match"
      return 1
   fi
}


function v4m_replace {

    if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
      sed -i '' s/"$1"/"$2"/g  "$3"
    else
      sed -i  s/"$1"/"$2"/g  "$3"
    fi
}



#Function, function what's your (er) function?
function doitall {

   #arg1 Full container image
   #arg2 name of template file
   #arg3 prefix to insert in placeholders

   if ! parseFullImage "$1";  then
      echo "ERROR: unable to parse full image [$1]"
      return 1
   fi

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

   return 0
}


    if [ -f "component_versions.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' component_versions.env | grep -v '^#' | xargs)
        if [ "$userEnv" != "" ]; then
           echo "DEBUG: Loading global user environment file: component_versions.env"
          if [ "$userEnv" != "" ]; then
            export $userEnv
          fi
        fi
    else
        echo "DEBUG No component_versions.env file found"
    fi


echo "*****************"
TEMPFILE="/tmp/container_image.yaml"

###FB_FULL_IMAGE="cr.fluentbit.io/fluent/fluent-bit:2.1.10"
if doitall "$FB_FULL_IMAGE"          "logging/fb/container_image.template"; then
   cat $TEMPFILE
else
   echo "ERROR"
fi

###OS_FULL_IMAGE="docker.io/opensearchproject/opensearch:2.10.0"
###OS_SYSCTL_FULL_IMAGE="docker.io/library/busybox:latest"
if doitall "$OS_FULL_IMAGE"          "logging/opensearch/os_container_image.template"; then
   if doitall "$OS_SYSCTL_FULL_IMAGE"   "TEMPFILE"  "OS_SYSCTL_"; then
      cat $TEMPFILE
   else echo "ERROR: Failed on [OS_SYSCT]"
   fi
else
   echo "ERROR: Failed on [OS]"
fi
exit

###OSD_FULL_IMAGE="docker.io/opensearchproject/opensearch-dashboards:2.10.0"
doitall "$OSD_FULL_IMAGE"         "logging/opensearch/osd_container_image.template"
cat $TEMPFILE

###ES_EXPORTER_FULL_IMAGE="quay.io/prometheuscommunity/elasticsearch-exporter:v1.6.0"
doitall "$ES_EXPORTER_FULL_IMAGE" "logging/esexporter/es-exporter_container_image.template"
cat $TEMPFILE

###GRAFANA_FULL_IMAGE="docker.io/grafana/grafana:10.2.1"
###GRAFANA_SIDECAR_FULL_IMAGE="quay.io/kiwigrid/k8s-sidecar:1.25.2"
doitall "$GRAFANA_FULL_IMAGE"     "monitoring/grafana_container_image.template"
doitall "$GRAFANA_SIDECAR_FULL_IMAGE"   "TEMPFILE"  "SIDECAR_"
cat $TEMPFILE

###ALERTMANAGER_FULL_IMAGE="quay.io/prometheus/alertmanager:v0.26.0"
###GRAFANA_FULL_IMAGE="docker.io/grafana/grafana:10.2.1"
###GRAFANA_SIDECAR_FULL_IMAGE="quay.io/kiwigrid/k8s-sidecar:1.25.2"
###ADMWEBHOOK_FULL_IMAGE="registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20221220-controller-v1.5.1-58-g787ea74b6"
###KSM_FULL_IMAGE="registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.0"
###NODEXPORT_FULL_IMAGE="quay.io/prometheus/node-exporter:v1.7.0"
###PROMETHEUS_FULL_IMAGE="quay.io/prometheus/prometheus:v2.47.1"
###PROMOP_FULL_IMAGE="quay.io/prometheus-operator/prometheus-operator:v0.69.1"
###CONFIGRELOAD_FULL_IMAGE="quay.io/prometheus-operator/prometheus-config-reloader:v0.69.1"

doitall "$PROMOP_FULL_IMAGE"          "monitoring/prom-operator_container_image.template"
doitall "$ALERTMANAGER_FULL_IMAGE"    "TEMPFILE"  "ALERTMANAGER_"
doitall "$ADMWEBHOOK_FULL_IMAGE"      "TEMPFILE"  "ADMWEBHOOK_"
doitall "$KSM_FULL_IMAGE"             "TEMPFILE"  "KSM_"
doitall "$NODEXPORT_FULL_IMAGE"       "TEMPFILE"  "NODEXPORT_"
doitall "$PROMETHEUS_FULL_IMAGE"      "TEMPFILE"  "PROMETHEUS_"
doitall "$CONFIGRELOAD_FULL_IMAGE"    "TEMPFILE"  "CONFIGRELOAD_"
doitall "$GRAFANA_FULL_IMAGE"         "TEMPFILE"  "GRAFANA_"
doitall "$GRAFANA_SIDECAR_FULL_IMAGE" "TEMPFILE"  "SIDECAR_"
cat $TEMPFILE

#TEMPO_FULL_IMAGE="docker.io/grafana/tempo:2.2.0"
doitall "$TEMPO_FULL_IMAGE" "monitoring/tempo_container_image.template"
cat $TEMPFILE

#PUSHGATEWAY_FULL_IMAGE="quay.io/prom/pushgateway:v1.6.2"
doitall "$PUSHGATEWAY_FULL_IMAGE" "monitoring/pushgateway_container_image.template"
cat $TEMPFILE

 
