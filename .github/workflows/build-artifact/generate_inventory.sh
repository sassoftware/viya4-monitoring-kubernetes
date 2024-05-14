#! /bin/bash
# Copyright © 2024, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# NOTE: This script is NOT intended to be run by end-users.  It
#       is used by the project development team to generate an
#       important file documenting the container images and Helm
#       charts used by the project.

V4M_BUILD_REPO=${V4M_BUILD_REPO:-"../v4m-build"}
# V4M_REPO=${V4M_REPO:-"/home/runner/work/viya4-monitoring-kubernetes/viya4-monitoring-kubernetes"}
# cd $V4M_REPO

CHECK_HELM=false
CHECK_KUBERNETES=false

source bin/common.sh

file="ARTIFACT_INVENTORY.md"
template=".github/workflows/artifact/ARTIFACT_INVENTORY.template"

cp "$template" "$file"

function buildHelmArchiveFilename {

   local prefix repo name version format chart_archive_filename

   prefix=$1
   repo="${prefix}_CHART_REPO"
   name="${prefix}_CHART_NAME"
   version="${prefix}_CHART_VERSION"
   format="tgz"
   chart_archive_filename="${!repo}\/${!name}-${!version}.$format"
   v4m_replace "__${prefix}_CHART_REPO__" "${!repo}" "$file"
   v4m_replace "__${prefix}_CHART_NAME__" "${!name}" "$file"
   v4m_replace "__${prefix}_CHART_VERSION__" "${!version}" "$file"
   v4m_replace "__${prefix}_CHART_ARCHIVE__" "$chart_archive_filename" "$file"

}

buildHelmArchiveFilename "ESEXPORTER_HELM"
buildHelmArchiveFilename "FLUENTBIT_HELM"
buildHelmArchiveFilename "OPENSEARCH_HELM"
buildHelmArchiveFilename "OSD_HELM"
buildHelmArchiveFilename "OPENSHIFT_GRAFANA"
buildHelmArchiveFilename "KUBE_PROM_STACK"
buildHelmArchiveFilename "PUSHGATEWAY"
buildHelmArchiveFilename "TEMPO"

parseFullImage "$ALERTMANAGER_FULL_IMAGE"
v4m_replace "__ALERTMANAGER_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$GRAFANA_FULL_IMAGE"
v4m_replace "__GRAFANA_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$GRAFANA_SIDECAR_FULL_IMAGE"
v4m_replace "__GRAFANA_SIDECAR_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$ADMWEBHOOK_FULL_IMAGE"
v4m_replace "__ADMWEBHOOK_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$KSM_FULL_IMAGE"
v4m_replace "__KSM_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$NODEXPORT_FULL_IMAGE"
v4m_replace "__NODEXPORT_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$PROMETHEUS_FULL_IMAGE"
v4m_replace "__PROMETHEUS_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$PROMOP_FULL_IMAGE"
v4m_replace "__PROMOP_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$CONFIGRELOAD_FULL_IMAGE"
v4m_replace "__CONFIGRELOAD_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$FB_FULL_IMAGE"
v4m_replace "__FB_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$OS_FULL_IMAGE"
v4m_replace "__OS_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$OS_SYSCTL_FULL_IMAGE"
v4m_replace "__OS_SYSCTL_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$OSD_FULL_IMAGE"
v4m_replace "__OSD_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$ES_EXPORTER_FULL_IMAGE"
v4m_replace "__ES_EXPORTER_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$OPENSHIFT_OAUTHPROXY_FULL_IMAGE"
v4m_replace "__OPENSHIFT_OAUTHPROXY_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$TEMPO_FULL_IMAGE"
v4m_replace "__TEMPO_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

parseFullImage "$PUSHGATEWAY_FULL_IMAGE"
v4m_replace "__PUSHGATEWAY_FULL_IMAGE__" "$FULL_IMAGE_ESCAPED" "$file"

log_notice "Be sure to review the generated file [$file] prior to adding/committing it to the repo"
