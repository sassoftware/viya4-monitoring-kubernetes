#! /bin/bash

# Copyright © 2022,2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source logging/bin/common.sh
source monitoring/bin/common.sh

source logging/bin/apiaccess-include.sh
source logging/bin/secrets-include.sh
source logging/bin/rbac-include.sh

# Check to see if monitoring/Viya namespace provided exists and components have already been deployed
if kubectl -n "$MON_NS" get deployment v4m-grafana &>/dev/null; then
   log_debug "Grafana deployment found in [$MON_NS] namespace.  Continuing."
else
   log_error "No monitoring components found in the [$MON_NS] namespace."
   log_error "Monitoring needs to be deployed in this namespace in order to configure the logging data source in Grafana."
   exit 1
fi

# Check to see if logging namespace provided exists and components have already been deployed
if kubectl -n "$LOG_NS" get statefulSet v4m-search &>/dev/null; then
  log_debug "Logging deployment found in [$LOG_NS] namespace.  Continuing."
else
  log_error "Search backend was not found in the [$LOG_NS] namespace."
  log_error "All of the required log monitoring components need to be deployed in this namespace before this script can configure the logging data source."
  exit 1
fi

# get admin credentials
# shellcheck disable=SC2155
export ES_ADMIN_USER=$(kubectl -n "$LOG_NS" get secret internal-user-admin -o=jsonpath="{.data.username}" | base64 --decode)
# shellcheck disable=SC2155
export ES_ADMIN_PASSWD=$(kubectl -n "$LOG_NS" get secret internal-user-admin -o=jsonpath="{.data.password}" | base64 --decode)

get_sec_api_url
get_credentials_from_secret admin


# Set user ID and password
grfds_user="V4M_ALL_grafana_ds"

if user_exists "$grfds_user"; then
   log_verbose "Removing the existing [$grfds_user] utility account."
   delete_user "$grfds_user"
fi

grfds_passwd="$(randomPassword)"

./logging/bin/user.sh CREATE -ns _all_ -t _all_ -u "$grfds_user" -p "$grfds_passwd" -g

# Create temporary directory for string replacement in the grafana-datasource-opensearch.yaml file
monDir=$TMP_DIR/$MON_NS
mkdir -p "$monDir"
cp monitoring/grafana-datasource-opensearch.yaml "$monDir/grafana-datasource-opensearch.yaml"

#Determine OpenSearch version programatically
parseFullImage "$OS_FULL_IMAGE"
opensearch_version="${VERSION:-2.12.0}"
log_debug "OpenSearch version [$opensearch_version] will be specified in datasource definition."

# Replace placeholders
log_debug "Replacing variables in $monDir/grafana-datasource-opensearch.yaml file"
v4m_replace "__namespace__"          "$LOG_NS"               "$monDir/grafana-datasource-opensearch.yaml"
v4m_replace "__ES_SERVICENAME__"     "$ES_SERVICENAME"       "$monDir/grafana-datasource-opensearch.yaml"
v4m_replace "__userID__"             "$grfds_user"           "$monDir/grafana-datasource-opensearch.yaml"
v4m_replace "__passwd__"             "$grfds_passwd"         "$monDir/grafana-datasource-opensearch.yaml"
v4m_replace "__opensearch_version__" "$opensearch_version"   "$monDir/grafana-datasource-opensearch.yaml"


# Removes old OpenSearch data source if one exists
log_info "Removing any existing logging data source secret ..."
kubectl delete secret -n "$MON_NS" --ignore-not-found grafana-datasource-es

# Install OpenSearch datasource plug-in to Grafana
grafanaPod=$(kubectl -n "$MON_NS" get pods -l app.kubernetes.io/name=grafana -o jsonpath='{.items[0].metadata.name}')
log_debug "Grafana Pod [$grafanaPod]"

pluginInstalled=$(kubectl exec -n "$MON_NS" "$grafanaPod" -- bash -c "grafana cli plugins ls |grep -c opensearch-datasource|| true")
log_debug "Grafana OpenSearch Datasource Plugin installed? [$pluginInstalled]"

if [ "$pluginInstalled" = "0" ]; then

   log_info "Installing OpenSearch Datasource plugin"
   pluginVersion="${GRAFANA_DATASOURCE_PLUGIN_VERSION:-2.17.4}"
   pluginFile="grafana-opensearch-datasource-$pluginVersion.linux_amd64.zip"

   if [ -n "$AIRGAP_HELM_REPO" ]; then
      log_debug "Air-gapped deployment detected; loading OpenSearch Datasource plugin from USER_DIR/monitoring directory"

      userPluginFile="$USER_DIR/monitoring/$pluginFile"
      if [ -f "$userPluginFile" ]; then
         kubectl cp "$userPluginFile" "$MON_NS/$grafanaPod:/var/lib/grafana/plugins"
         kubectl exec -n "$MON_NS" "$grafanaPod" -- unzip -o /var/lib/grafana/plugins/"$pluginFile" -d /var/lib/grafana/plugins/
      else
         log_error "The OpenSearch datasource plugin to Grafana zip file was NOT found in the expected location [$userPluginFile]"
         exit 1
      fi
   else
      log_debug "Using Grafana CLI to install plugin (version [$pluginVersion])"
      kubectl exec -n "$MON_NS" "$grafanaPod" -- grafana cli plugins install grafana-opensearch-datasource "$pluginVersion"
      log_info "You may ignore any previous messages regarding restarting the Grafana pod; it will be restarted automatically."
   fi
else
   log_debug "The OpenSearch datasource plugin is already installed; skipping installation."
fi

# Adds the logging data source to Grafana
log_info "Provisioning logging data source in Grafana"
kubectl delete secret generic -n "$MON_NS" grafana-datasource-opensearch --ignore-not-found
kubectl create secret generic -n "$MON_NS" grafana-datasource-opensearch --from-file "$monDir/grafana-datasource-opensearch.yaml"
kubectl label secret -n "$MON_NS" grafana-datasource-opensearch grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring

# Deploy the log-enabled Viya dashboards
WELCOME_DASH="false" KUBE_DASH="false" VIYA_DASH="false" VIYA_LOGS_DASH="true" PGMONITOR_DASH="false" RABBITMQ_DASH="false" NGINX_DASH="false" LOGGING_DASH="false" USER_DASH="false" monitoring/bin/deploy_dashboards.sh

# Delete pods so that they can be restarted with the change.
log_info "Logging data source provisioned in Grafana.  Restarting pods to apply the change"
kubectl delete pods -n "$MON_NS" -l "app.kubernetes.io/instance=v4m-prometheus-operator" -l "app.kubernetes.io/name=grafana"
kubectl -n "$MON_NS" wait pods --selector "app.kubernetes.io/name=grafana" --for condition=Ready --timeout=2m
log_info "Logging data source in Grafana has been configured."
