#! /bin/bash

# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source logging/bin/secrets-include.sh
source bin/tls-include.sh
source logging/bin/apiaccess-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

ELASTICSEARCH_ENABLE=${ELASTICSEARCH_ENABLE:-true}

if [ "$ELASTICSEARCH_ENABLE" != "true" ]; then
  log_verbose "Environment variable [ELASTICSEARCH_ENABLE] is not set to 'true'; exiting WITHOUT deploying OpenSearch"
  exit 0
fi

set -e

#
# check for pre-reqs
#

#Fail if not using OpenSearch back-end
require_opensearch

checkDefaultStorageClass

# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "Namespace [$LOG_NS] does NOT exist."
  exit 1
fi

## Check for air gap deployment
if [ "$AIRGAP_DEPLOYMENT" == "true" ]; then
  source bin/airgap-include.sh

  # Check for the image pull secret for the air gap environment and replace placeholders
  checkForAirgapSecretInNamespace "$AIRGAP_IMAGE_PULL_SECRET_NAME" "$LOG_NS"
###  replaceAirgapValuesInFiles "logging/airgap/airgap-opensearch.yaml"

###  airgapValuesFile=$updatedAirgapValuesFile
###else
###  airgapValuesFile=$TMP_DIR/empty.yaml
fi

######
echo " DDDDDDDD"      #DEBUGGING-REMOVE
generateImageKeysFile "$OS_FULL_IMAGE"          "logging/opensearch/os_container_image.template"
generateImageKeysFile "$OS_SYSCTL_FULL_IMAGE"   "$imageKeysFile"  "OS_SYSCTL_"
cat "$imageKeysFile"  #DEBUGGING-REMOVE
echo " DDDDDDDD"      #DEBUGGING-REMOVE

# get credentials
export ES_ADMIN_PASSWD=${ES_ADMIN_PASSWD}
export ES_KIBANASERVER_PASSWD=${ES_KIBANASERVER_PASSWD}
export ES_LOGCOLLECTOR_PASSWD=${ES_LOGCOLLECTOR_PASSWD}
export ES_METRICGETTER_PASSWD=${ES_METRICGETTER_PASSWD}

# Create secrets containing internal user credentials
create_user_secret internal-user-admin        admin        "$ES_ADMIN_PASSWD"         managed-by=v4m-es-script
create_user_secret internal-user-kibanaserver kibanaserver "$ES_KIBANASERVER_PASSWD"  managed-by=v4m-es-script
create_user_secret internal-user-logcollector logcollector "$ES_LOGCOLLECTOR_PASSWD"  managed-by=v4m-es-script
create_user_secret internal-user-metricgetter metricgetter "$ES_METRICGETTER_PASSWD"  managed-by=v4m-es-script

#cert_generator="${CERT_GENERATOR:-openssl}"

# Verify cert generator is available (if necessary)
if verify_cert_generator $LOG_NS es-transport es-rest es-admin; then
   log_debug "cert generator check OK [$cert_generator_ok]"
else
   log_error "One or more required TLS certs do not exist and the expected certificate generator mechanism [$CERT_GENERATOR] is not available to create the missing certs"
   exit 1
fi

# Create/Get necessary TLS certs
create_tls_certs $LOG_NS logging es-transport es-rest es-admin

# need to wait for cert-manager to create all certs and secrets
sleep 10

# Get subject from admin and transport cert for opensearch.yaml
if [ ! -f  $TMP_DIR/es-transport.pem ]; then
   log_debug "Extracting es-transport cert from secret"
   kubectl -n $LOG_NS get secret es-transport-tls-secret -o=jsonpath="{.data.tls\.crt}" |base64 --decode > $TMP_DIR/es-transport.pem
fi
node_dn=$(openssl x509 -subject -nameopt RFC2253 -noout -in $TMP_DIR/es-transport.pem | sed -e "s/subject=\s*\(\S*\)/\1/" -e "s/^[ \t]*//")

if [ ! -f  $TMP_DIR/es-admin.pem ]; then
   log_debug "Extracting es-admin cert from secret"
   kubectl -n $LOG_NS get secret es-admin-tls-secret -o=jsonpath="{.data.tls\.crt}" |base64 --decode > $TMP_DIR/es-admin.pem
fi
admin_dn=$(openssl x509 -subject -nameopt RFC2253 -noout -in $TMP_DIR/es-admin.pem | sed -e "s/subject=\s*\(\S*\)/\1/" -e "s/^[ \t]*//")

log_debug "Subjects node_dn:[$node_dn] admin_dn:[$admin_dn]"

#write cert subjects to secret to be mounted as env var
kubectl -n $LOG_NS delete secret opensearch-cert-subjects --ignore-not-found
kubectl -n $LOG_NS create secret generic opensearch-cert-subjects  --from-literal=node_dn="$node_dn" --from-literal=admin_dn="$admin_dn"
kubectl -n $LOG_NS label  secret opensearch-cert-subjects  managed-by=v4m-es-script

# Create ConfigMap for securityadmin script
kubectl -n $LOG_NS delete configmap run-securityadmin.sh --ignore-not-found
kubectl -n $LOG_NS create configmap run-securityadmin.sh --from-file logging/opensearch/bin/run_securityadmin.sh
kubectl -n $LOG_NS label  configmap run-securityadmin.sh managed-by=v4m-es-script search-backend=opensearch

# Need to retrieve these from secrets in case secrets pre-existed
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)
export ES_METRICGETTER_USER=$(kubectl -n $LOG_NS get secret internal-user-metricgetter -o=jsonpath="{.data.username}" |base64 --decode)
export ES_METRICGETTER_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-metricgetter -o=jsonpath="{.data.password}" |base64 --decode)

# Generate message about autogenerated admin password
adminpwd_autogenerated=$(kubectl -n $LOG_NS get secret internal-user-admin   -o jsonpath='{.metadata.labels.autogenerated_password}')
if [ ! -z "$adminpwd_autogenerated"  ]; then
   # Print info about how to obtain admin password
   add_notice "                                                                    "
   add_notice "**The OpenSearch 'admin' Account**"
   add_notice "Generated 'admin' password:  $ES_ADMIN_PASSWD                       "
   add_notice "To change the password for the 'admin' account at any time, run the "
   add_notice "following command:                                                  "
   add_notice "                                                                    "
   add_notice "    logging/bin/change_internal_password.sh admin newPassword       "
   add_notice "                                                                    "
   add_notice "NOTE: *NEVER* change the password for the 'admin' account from within the"
   add_notice "OpenSearch Dashboards web-interface.  The 'admin' password should *ONLY* be changed via "
   add_notice "the change_internal_password.sh script in the logging/bin sub-directory."
   add_notice "                                                                    "

   LOGGING_DRIVER=${LOGGING_DRIVER:-false}
   if [ "$LOGGING_DRIVER" != "true" ]; then
      echo ""
      display_notices
      echo ""
   fi
fi


# enable debug on Helm via env var
export HELM_DEBUG="${HELM_DEBUG:-false}"

if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

helmRepoAdd opensearch  https://opensearch-project.github.io/helm-charts

## Commenting out as it might be redundant code
# log_verbose "Updating Helm repositories"
# helm repo update

# Check for existing OpenSearch helm release
if [ "$(helm -n $LOG_NS list --filter 'opensearch' -q)" == "opensearch" ]; then
   log_debug "The Helm release [opensearch] already exists; upgrading the release."
   existingSearch="true"
else
   log_debug "The Helm release [opensearch] does NOT exist; deploying a new release."
   existingSearch="false"
fi

helm2ReleaseCheck odfe-$LOG_NS

# Check for existing Open Distro helm release
if [ "$(helm -n $LOG_NS list --filter 'odfe' -q)" == "odfe" ]; then

   log_info "An existing ODFE-based deployment was detected; migrating to an OpenSearch-based deployment."
   existingODFE="true"

   #
   #Migrate Kibana content if upgrading from ODFE 1.7.0
   #
   if [ "$(helm -n $LOG_NS list -o yaml --filter odfe |grep app_version)" == "- app_version: 1.8.0" ]; then

      # Prior to our 1.1.0 release we used ODFE 1.7.0
      log_info "Migrating content from Open Distro for Elasticsearch 1.7.0"

      #export exisiting content from global tenant
      #KB_GLOBAL_EXPORT_FILE="$TMP_DIR/kibana_global_content.ndjson"

      log_debug "Exporting exisiting content from global tenant to temporary file [$KB_GLOBAL_EXPORT_FILE]."

      set +e

      #Need to connect to existing ODFE instance:
      #   *unset vars returned by call to get_kb_api_url to force regeneration
      #   *pass ODFE-specific values to get_kb_api_url
      unset kb_api_url
      unset kbpfpid
      get_kb_api_url "ODFE" "v4m-es-kibana-svc"  "kibana-svc" "v4m-es-kibana-ing" "false"

      #Need to confirm KB URL works...might not if TLS enabled.
      #If that's the case, reset things and do it again with TLS=true.

      response=$(curl -s -o /dev/null -w  "%{http_code}" -XGET "${kb_api_url}/status" -u $ES_ADMIN_USER:$ES_ADMIN_PASSWD -k)

      if [[ $response != 2* ]]; then
         log_debug "Unable to connect to Kibana using HTTP; will try using HTTPS"
         stop_kb_portforwarding
         unset kb_api_url
         unset kbpfpid
         get_kb_api_url "ODFE" "v4m-es-kibana-svc"  "kibana-svc" "v4m-es-kibana-ing" "true"
      else
         log_debug "Confirmed connection to Kibana"
      fi

      content2export='{"type": ["config", "url","visualization", "dashboard", "search", "index-pattern"],"excludeExportDetails": false}'

      #The 'kb-xsrf' reference below is correct since we are interacting with ODFE KB
      response=$(curl -s -o $KB_GLOBAL_EXPORT_FILE  -w  "%{http_code}" -XPOST "${kb_api_url}/api/saved_objects/_export" -d "$content2export"  -H "kbn-xsrf: true" -H 'Content-Type: application/json' -u $ES_ADMIN_USER:$ES_ADMIN_PASSWD -k)

      if [[ $response != 2* ]]; then
         log_warn "There was an issue exporting the existing content from Kibana [$response]"
         log_debug "Failed response details: $(tail -n1 $KB_GLOBAL_EXPORT_FILE)"
         #TODO: Exit here?  Display messages as shown?  Add BIG MESSAGE about potential loss of content?
      else
         log_info "Content from existing Kibana instance cached for migration. [$response]"
         log_debug "Export details: $(tail -n1 $KB_GLOBAL_EXPORT_FILE)"
      fi

      #Remove traces of ODFE interaction
      stop_kb_portforwarding
      unset kb_api_url
      unset kbpfpid
   fi

   #
   # Upgrade from ODFE to OpenSearch
   #

   # Remove Fluent Bit Helm release to
   # avoid losing log messages during transition
   if helm3ReleaseExists v4m-fb $LOG_NS; then
      log_debug "Removing the Fluent Bit Helm release"
      helm -n $LOG_NS delete v4m-fb
   fi

   # Remove the existing ODFE Helm release
   log_debug "Removing an existing ODFE Helm release"
   helm -n $LOG_NS delete odfe
   sleep 20

   #bypass security setup since 
   #it was already configured
   existingSearch=true

   #Migrate PVCs
   source logging/bin/migrate_odfe_pvcs-include.sh
else
   log_debug "No obsolete Helm release of [odfe] was found."
   existingODFE="false"
fi


# OpenSearch user customizations
ES_OPEN_USER_YAML="${ES_OPEN_USER_YAML:-$USER_DIR/logging/user-values-opensearch.yaml}"
if [ ! -f "$ES_OPEN_USER_YAML" ]; then
  log_debug "[$ES_OPEN_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  ES_OPEN_USER_YAML=$TMP_DIR/empty.yaml
fi

if [ -z "$(kubectl -n $LOG_NS get secret opensearch-securityconfig -o name 2>/dev/null)" ]; then

   kubectl -n $LOG_NS delete secret opensearch-securityconfig --ignore-not-found

   #Copy OpenSearch Security Configuration files
   mkdir -p $TMP_DIR/opensearch/securityconfig
   cp logging/opensearch/securityconfig/*.yml $TMP_DIR/opensearch/securityconfig
   #Overlay OpenSearch security configuration files from USER_DIR (if exists)
   if [ -d "$USER_DIR/logging/opensearch/securityconfig" ]; then
      log_debug "OpenSearch Security Configuration directory found w/in USER_DIR [$USER_DIR]"

      if [ "$(ls $USER_DIR/logging/opensearch/securityconfig/*.yml 2>/dev/null)" ]; then
        log_info "Copying OpenSearch Security Configuration files from [$USER_DIR/logging/opensearch/securityconfig]"
        cp $USER_DIR/logging/opensearch/securityconfig/*.yml $TMP_DIR/opensearch/securityconfig
      else
         log_debug "No YAML (*.yml) files found in USER_DIR/opensearch/securityconfig directory"
      fi
   fi

   #create secret containing OpenSearch security configuration yaml files
   #NOTE: whitelist.yml file is only created due to apparent bug in OpenSearch
   #      which causes an ERROR when securityAdmin.sh is run without it 
   kubectl -n $LOG_NS create secret generic opensearch-securityconfig    \
       --from-file $TMP_DIR/opensearch/securityconfig/action_groups.yml  \
       --from-file $TMP_DIR/opensearch/securityconfig/allowlist.yml      \
       --from-file whitelist.yml=$TMP_DIR/opensearch/securityconfig/allowlist.yml      \
       --from-file $TMP_DIR/opensearch/securityconfig/config.yml         \
       --from-file $TMP_DIR/opensearch/securityconfig/internal_users.yml \
       --from-file $TMP_DIR/opensearch/securityconfig/nodes_dn.yml       \
       --from-file $TMP_DIR/opensearch/securityconfig/roles.yml          \
       --from-file $TMP_DIR/opensearch/securityconfig/roles_mapping.yml  \
       --from-file $TMP_DIR/opensearch/securityconfig/tenants.yml

   kubectl -n $LOG_NS label secret opensearch-securityconfig  managed-by=v4m-es-script

else
   log_verbose "Using existing secret [opensearch-securityconfig] for OpenSearch Security Configuration"
fi

# OpenSearch
log_info "Deploying OpenSearch"

# Enable workload node placement?
LOG_NODE_PLACEMENT_ENABLE=${LOG_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}

# Optional workload node placement support
if [ "$LOG_NODE_PLACEMENT_ENABLE" == "true" ]; then
  log_verbose "Enabling OpenSearch for workload node placement"
  wnpValuesFile="logging/node-placement/values-opensearch-wnp.yaml"
else
  log_debug "Workload node placement support is disabled for OpenSearch"
  wnpValuesFile="$TMP_DIR/empty.yaml"
fi

OPENSHIFT_SPECIFIC_YAML=$TMP_DIR/empty.yaml
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
    OPENSHIFT_SPECIFIC_YAML=logging/openshift/values-opensearch-openshift.yaml
fi


# Get Helm Chart Name
log_debug "OpenSearch Helm Chart: repo [$OPENSEARCH_HELM_CHART_REPO] name [$OPENSEARCH_HELM_CHART_NAME] version [$OPENSEARCH_HELM_CHART_VERSION]"
chart2install="$(get_helmchart_reference $OPENSEARCH_HELM_CHART_REPO $OPENSEARCH_HELM_CHART_NAME $OPENSEARCH_HELM_CHART_VERSION)"
log_debug "Installing Helm chart from artifact [$chart2install]"


# Deploy OpenSearch via Helm chart
# NOTE: nodeGroup needed to get resource names we want
helm $helmDebug upgrade --install opensearch \
    --version $OPENSEARCH_HELM_CHART_VERSION \
    --namespace $LOG_NS \
    --values "$imageKeysFile" \
    --values logging/opensearch/opensearch_helm_values.yaml \
    --values "$wnpValuesFile" \
    --values "$ES_OPEN_USER_YAML" \
    --values "$OPENSHIFT_SPECIFIC_YAML" \
    --set nodeGroup=primary  \
    --set masterService=v4m-search \
    --set fullnameOverride=v4m-search \
    $chart2install

# ODFE => OpenSearch Migration
if [ "$deploy_temp_masters" == "true" ]; then

   #NOTE: rbac.create set to 'false' since ServiceAccount
   #      was created during prior Helm chart deployment
   log_debug "Upgrade from ODFE to OpenSearch detected; creating temporary master-only nodes."
   helm $helmDebug upgrade --install opensearch-master \
       --version $OPENSEARCH_HELM_CHART_VERSION \
       --namespace $LOG_NS \
       --values logging/opensearch/opensearch_helm_values.yaml \
       --values "$imageKeysFile" \
       --values "$wnpValuesFile" \
       --values "$ES_OPEN_USER_YAML" \
       --values "$OPENSHIFT_SPECIFIC_YAML" \
       --set nodeGroup=temp_masters  \
       --set ingress.enabled=false \
       --set replicas=2 \
       --set roles={master} \
       --set rbac.create=false \
       --set masterService=v4m-search \
       --set fullnameOverride=v4m-master \
       $chart2install
fi


# waiting for PVCs to be bound
declare -i pvcCounter=0
pvc_status=$(kubectl -n $LOG_NS get pvc  v4m-search-v4m-search-0  -o=jsonpath="{.status.phase}")
until [ "$pvc_status" == "Bound" ] || (( $pvcCounter>90 ));
do
   sleep 5
   pvcCounter=$((pvcCounter+5))
   pvc_status=$(kubectl -n $LOG_NS get pvc v4m-search-v4m-search-0 -o=jsonpath="{.status.phase}")
done

# Confirm PVC is "bound" (matched) to PV
pvc_status=$(kubectl -n $LOG_NS get pvc  v4m-search-v4m-search-0  -o=jsonpath="{.status.phase}")
if [ "$pvc_status" != "Bound" ];  then
      log_error "It appears that the PVC [v4m-search-v4m-search-0] associated with the [v4m-search-0] node has not been bound to a PV."
      log_error "The status of the PVC is [$pvc_status]"
      log_error "After ensuring all claims shown as Pending can be satisfied; run the remove_opensearch.sh script and try again."
      exit 1
fi
log_verbose "The PVC [v4m-search-v4m-search-0] have been bound to PVs"

# Need to wait 2-3 minutes for the OpenSearch to come up and running
log_info "Waiting on OpenSearch pods to be Ready"
kubectl -n $LOG_NS wait pods v4m-search-0 --for=condition=Ready --timeout=10m


# TO DO: Convert to curl command to detect ES is up?
# hitting https:/host:port -u adminuser:adminpwd --insecure 
# returns "OpenDistro Security not initialized." and 503 when up
log_verbose "Waiting [2] minutes to allow OpenSearch to initialize [$(date)]"
sleep 120

# ODFE => OpenSearch Migration
if [ "$deploy_temp_masters" == "true" ]; then

   log_verbose "Upgrade to OpenSearch from Open Distro for Elasticsearch processing continues..."
   log_info "Waiting up to [3] minutes for 'master-only' ES pods to be Ready [$(date)]"
   kubectl -n $LOG_NS wait pods  -l app.kubernetes.io/instance=opensearch-master --for=condition=Ready --timeout=3m

   #TODO: Remove 'master-only' nodes from list of 'master-eligible' ES nodes via API call?
   # get_es_api_url
   # curl call to remove 'master-only' nodes from list of 'master-eligible' nodes
   # curl -X POST $es_api_url/_cluster/voting_config_exclusions?node_names=v4m-master-0,v4m-master-1,v4m-master-2
   # sleep 60
   # Probably (?) can skip the scale down and just uninstall Helm release


   # Scale down master statefulset by 1 (to 1)
   log_debug "Removing 'master-only' ES nodes needed only during upgrade to OpenSearch"

   kubectl -n $LOG_NS scale statefulset v4m-master --replicas 1
   ## wait for 1 minute (probably excessive, but...)
   sleep 30

   #Scale down master statefulset by 1 (to 0)
   kubectl -n $LOG_NS scale statefulset v4m-master --replicas 0
   ##wait for 1 minute (probably excessive, but...)
   sleep 30

   #uninstall the Helm release
   helm -n $LOG_NS delete opensearch-master
   ##wait for 30 secs? 1 min?
   sleep 30

   #Delete "master" PVCs
   ## Add labels?  Appears labels were overwritten by Helm chart
   kubectl -n $LOG_NS delete pvc v4m-master-v4m-master-0 v4m-master-v4m-master-1 v4m-master-v4m-master-2 --ignore-not-found
fi

# Reconcile count of 'data' nodes
if [ "$existingODFE" == "true" ]; then

   min_data_nodes=$((odfe_data_pvc_count - 1))
   search_node_count=$(kubectl -n $LOG_NS get statefulset v4m-search -o jsonpath='{.spec.replicas}' 2>/dev/null)

   if [ "$search_node_count" -gt "0" ] && [ "$min_data_nodes" -gt "0" ] && [ "$search_node_count" -lt "$min_data_nodes" ]; then
      log_warn "There were insufficient OpenSearch nodes [$search_node_count] configured to handle all of the data from the original ODFE 'data' nodes"
      log_warn "This OpenSearch cluster has been scaled up to [$min_data_nodes] nodes to ensure no loss of data."
      kubectl -n $LOG_NS scale statefulset v4m-search --replicas=$min_data_nodes
   fi
fi

set +e

# Run the security admin script on the pod
# Add some logic to find ES release
if [ "$existingSearch" == "false" ] && [ "$existingODFE" != "true" ]; then
  kubectl -n $LOG_NS exec v4m-search-0 -c opensearch -- config/run_securityadmin.sh
  # Retrieve log file from security admin script
  kubectl -n $LOG_NS cp v4m-search-0:config/run_securityadmin.log $TMP_DIR/run_securityadmin.log -c opensearch
  if [ "$(tail -n1  $TMP_DIR/run_securityadmin.log)" == "Done with success" ]; then
    log_verbose "The run_securityadmin.log script appears to have run successfully; you can review its output below:"
  else
    log_warn "There may have been a problem with the run_securityadmin.log script; review the output below:"
  fi
  # show output from run_securityadmin.sh script
  sed 's/^/   | /' $TMP_DIR/run_securityadmin.log
else
  log_verbose "Existing OpenSearch release found. Skipping OpenSearch security initialization."
fi

set -e

#Container Security: Disable serviceAccount Token Automounting
if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
   disable_sa_token_automount $LOG_NS v4m-os
   #NOTE: On other providers, OpenSearch pods linked to the 'default' serviceAccount
fi

log_info "OpenSearch has been deployed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
