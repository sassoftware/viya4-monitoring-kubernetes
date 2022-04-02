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

checkDefaultStorageClass

# Confirm namespace exists
if [ "$(kubectl get ns $LOG_NS -o name 2>/dev/null)" == "" ]; then
  log_error "Namespace [$LOG_NS] does NOT exist."
  exit 1
fi

# OPENSEARCH UPGRADE
# TODO: Do we need all of these credentials/secrets if we are only handling OpenSearch in this script?
# TODO: Q: Rename env vars from ES_ to OS_?  Support both?

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

# Verify cert-manager is available (if necessary)
if verify_cert_manager $LOG_NS es-transport es-rest es-admin kibana; then
  log_debug "cert-manager check OK"
else
  log_error "One or more required TLS certs do not exist and cert-manager is not available to create the missing certs"
  exit 1
fi

# Create/Get necessary TLS certs
apps=( es-transport es-rest es-admin kibana)
create_tls_certs $LOG_NS logging ${apps[@]}

# Create ConfigMap for securityadmin script
kubectl -n $LOG_NS delete configmap run-securityadmin.sh --ignore-not-found
kubectl -n $LOG_NS create configmap run-securityadmin.sh --from-file logging/es/opensearch/bin/run_securityadmin.sh
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

# OPENSEARCH UPGRADE
# Notice is incorrect to describe this as the Kibana 'admin' account;
# it's actually an ES/OS account.

   add_notice "                                                                    "
   add_notice "**The Kibana 'admin' Account**"
   add_notice "Generated 'admin' password:  $ES_ADMIN_PASSWD                       "
   add_notice "To change the password for the 'admin' account at any time, run the "
   add_notice "following command:                                                  "
   add_notice "                                                                    "
   add_notice "    logging/bin/change_internal_password.sh admin newPassword       "
   add_notice "                                                                    "
   add_notice "NOTE: *NEVER* change the password for the 'admin' account from within the"
   add_notice "Kibana web-interface.  The 'admin' password should *ONLY* be changed via "
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
   if [ "$(helm -n logging list -o yaml --filter odfe |grep app_version)" == "- app_version: 1.8.0" ]; then

      # Prior to our 1.1.0 release we used ODFE 1.7.0
      log_info "Migrating content from Open Distro for Elasticsearch 1.7.0"

      #export exisiting content from global tenant
      #KB_GLOBAL_EXPORT_FILE="$TMP_DIR/kibana_global_content.ndjson"

      log_debug "Exporting exisiting content from global tenant to temporary file [$KB_GLOBAL_EXPORT_FILE]."

      set +e

      #Need to connect to existing ODFE instance:
      #   set LOG_SEARCH_BACKEND (temporarily) to get ODFE-specific values
      #   unset vars returned by call to get_kb_api_url
      export LOG_SEARCH_BACKEND="ODFE"
      unset kb_api_url
      unset kbpfpid
      get_kb_api_url

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
      #and re-set LOG_SEARCH_BACKEND
      stop_kb_port_forwarding
      unset kb_api_url
      unset kbpfpid
      export LOG_SEARCH_BACKEND="OPENSEARCH"
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

   ## bypass security setup since 
   ## it was already configured
   existingSearch=true

   ## Migrate PVCs
   source logging/bin/migrate_odfe_pvcs.sh
else
   log_debug "No obsolete Helm release of [odfe] was found."
   existingODFE="false"
fi


# Elasticsearch user customizations
ES_OPEN_USER_YAML="${ES_OPEN_USER_YAML:-$USER_DIR/logging/user-values-elasticsearch-opensearch.yaml}"
if [ ! -f "$ES_OPEN_USER_YAML" ]; then
  log_debug "[$ES_OPEN_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  ES_OPEN_USER_YAML=$TMP_DIR/empty.yaml
fi


# Create secrets containing SecurityConfig files
## 28MAR22: TO DO: secrets-include.sh has hard-coded path to logging/es/odfe
##          needs to become logging/es/opensearch when ODFE support dropped
create_secret_from_file securityconfig/action_groups.yml   security-action-groups   managed-by=v4m-es-script
create_secret_from_file securityconfig/config.yml          security-config          managed-by=v4m-es-script
create_secret_from_file securityconfig/internal_users.yml  security-internal-users  managed-by=v4m-es-script
create_secret_from_file securityconfig/roles.yml           security-roles           managed-by=v4m-es-script
create_secret_from_file securityconfig/roles_mapping.yml   security-roles-mapping   managed-by=v4m-es-script
create_secret_from_file securityconfig/tenants.yml         security-tenants         managed-by=v4m-es-script


# OpenSearch
log_info "Deploying OpenSearch"

# Enable workload node placement?
LOG_NODE_PLACEMENT_ENABLE=${LOG_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}

# Optional workload node placement support
if [ "$LOG_NODE_PLACEMENT_ENABLE" == "true" ]; then
  log_verbose "Enabling elasticsearch for workload node placement"
  wnpValuesFile="logging/node-placement/values-elasticsearch-open-wnp.yaml"
else
  log_debug "Workload node placement support is disabled for elasticsearch"
  wnpValuesFile="$TMP_DIR/empty.yaml"
fi

ES_PATH_INGRESS_YAML=$TMP_DIR/empty.yaml
if [ "$OPENSHIFT_CLUSTER:$OPENSHIFT_PATH_ROUTES" == "true:true" ]; then
    ES_PATH_INGRESS_YAML=logging/openshift/values-elasticsearch-path-route-openshift.yaml
fi

# Deploy OpenSearch via Helm chart
# NOTE: nodeGroup needed to get resource names we want
helm $helmDebug upgrade --install opensearch \
    --namespace $LOG_NS \
    --values logging/es/opensearch/es_helm_values_opensearch.yaml \
    --values "$wnpValuesFile" \
    --values "$ES_OPEN_USER_YAML" \
    --values "$ES_PATH_INGRESS_YAML" \
    --set nodeGroup=primary  \
    --set masterService=v4m-es \
    --set fullnameOverride=v4m-es opensearch/opensearch

# ODFE => OpenSearch Migration
if [ "$deploy_temp_masters" == "true" ]; then

   log_debug "Upgrade from ODFE to OpenSearch detected; creating temporary master-only nodes."
   helm $helmDebug upgrade --install opensearch-master \
       --namespace $LOG_NS \
       --values logging/es/opensearch/es_helm_values_opensearch.yaml \
       --values "$wnpValuesFile" \
       --values "$ES_OPEN_USER_YAML" \
       --values "$ES_PATH_INGRESS_YAML" \
       --set nodeGroup=temp_masters  \
       --set ingress.enabled=false \
       --set replicas=2 \
       --set roles={master} \
       --set masterService=v4m-es \
       --set fullnameOverride=v4m-master opensearch/opensearch
fi


# waiting for PVCs to be bound
declare -i pvcCounter=0
pvc_status=$(kubectl -n $LOG_NS get pvc  v4m-es-v4m-es-0  -o=jsonpath="{.status.phase}")
until [ "$pvc_status" == "Bound" ] || (( $pvcCounter>90 ));
do
   sleep 5
   pvcCounter=$((pvcCounter+5))
   pvc_status=$(kubectl -n $LOG_NS get pvc v4m-es-v4m-es-0 -o=jsonpath="{.status.phase}")
done

# Confirm PVC is "bound" (matched) to PV
pvc_status=$(kubectl -n $LOG_NS get pvc  v4m-es-v4m-es-0  -o=jsonpath="{.status.phase}")
if [ "$pvc_status" != "Bound" ];  then
      log_error "It appears that the PVC [v4m-es-v4m-es-0] associated with the [v4m-es-0] node has not been bound to a PV."
      log_error "The status of the PVC is [$pvc_status]"
      log_error "After ensuring all claims shown as Pending can be satisfied; run the remove_elasticsearch_open.sh script and try again."
      exit 1
fi
log_verbose "The PVC [v4m-es-v4m-es-0] have been bound to PVs"

# Need to wait 2-3 minutes for the elasticsearch to come up and running
log_info "Waiting on Elasticsearch pods to be Ready"
kubectl -n $LOG_NS wait pods v4m-es-0 --for=condition=Ready --timeout=10m


# TO DO: Convert to curl command to detect ES is up?
# hitting https:/host:port -u adminuser:adminpwd --insecure 
# returns "OpenDisro Security not initialized." and 503 when up
log_verbose "Waiting [2] minutes to allow OpenSearch to initialize [$(date)]"
sleep 120

# ODFE => OpenSearch Migration
if [ "$deploy_temp_masters" == "true" ]; then
   ## Confirm ES is up and working?
   ## Or does the sleep above do that?  To be replaced with better logic

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
   search_node_count=$(kubectl -n $LOG_NS get statefulset v4m-es -o jsonpath='{.spec.replicas}' 2>/dev/null)

   if [ "$search_node_count" -gt "0" ] && [ "$min_data_nodes" -gt "0" ] && [ "$search_node_count" -lt "$min_data_nodes" ]; then
      log_warn "There were insufficient OpenSearch nodes [$search_node_count] configured to handle all of the data from the original ODFE 'data' nodes"
      log_warn "This OpenSearch cluster has been scaled up to [$min_data_nodes] nodes to ensure no loss of data."
      kubectl -n $LOG_NS scale statefulset v4m-es --replicas=$min_data_nodes
   fi
fi

set +e

# Run the security admin script on the pod
# Add some logic to find ES release
if [ "$existingSearch" == "false" ] && [ "$existingODFE" != "true" ]; then
  kubectl -n $LOG_NS exec v4m-es-0 -c opensearch -- config/run_securityadmin.sh
  # Retrieve log file from security admin script
  kubectl -n $LOG_NS cp v4m-es-0:config/run_securityadmin.log $TMP_DIR/run_securityadmin.log
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

log_info "OpenSearch has been deployed"

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
