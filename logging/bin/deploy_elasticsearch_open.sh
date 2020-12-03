#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source logging/bin/secrets-include.sh
source bin/tls-include.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

ELASTICSEARCH_ENABLE=${ELASTICSEARCH_ENABLE:-true}

if [ "$ELASTICSEARCH_ENABLE" != "true" ]; then
  log_info "Environment variable [ELASTICSEARCH_ENABLE] is not set to 'true'; exiting WITHOUT deploying Open Distro for Elasticsearch"
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

# get credentials
export ES_ADMIN_PASSWD=${ES_ADMIN_PASSWD:-admin}
export ES_KIBANASERVER_PASSWD=${ES_KIBANASERVER_PASSWD:-$(uuidgen)}
export ES_LOGCOLLECTOR_PASSWD=${ES_LOGCOLLECTOR_PASSWD:-$(uuidgen)}
export ES_METRICGETTER_PASSWD=${ES_METRICGETTER_PASSWD:-$(uuidgen)}

# Create secrets containing internal user credentials
create_user_secret internal-user-admin        admin        $ES_ADMIN_PASSWD         managed-by=v4m-es-script
create_user_secret internal-user-kibanaserver kibanaserver $ES_KIBANASERVER_PASSWD  managed-by=v4m-es-script
create_user_secret internal-user-logcollector logcollector $ES_LOGCOLLECTOR_PASSWD  managed-by=v4m-es-script
create_user_secret internal-user-metricgetter metricgetter $ES_METRICGETTER_PASSWD  managed-by=v4m-es-script

# Print info about how to obtain admin password
# TO DO: customize message based on how admin password was set?
# a) passed value; b) existing secret; or, c) randomly-generated?
add_notice "================================================================================"
add_notice "== To obtain the 'admin' password, used to access Kibana, submit the          =="
add_notice "== following command:                                                         =="
add_notice "==                                                                            =="
add_notice "==  kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath='{.data.username}' |base64 --decode    =="
add_notice "==                                                                            =="
add_notice "== NOTE: If you need to change the password for the 'admin' account, use the  =="
add_notice "== change_internal_password.sh script found in the logging/bin directory.     =="
add_notice "================================================================================"
add_notice_separator

LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
   display_notices
fi


# Create/Get necessary TLS certs
apps=( es-transport es-rest es-admin kibana )
create_tls_certs $LOG_NS logging ${apps[@]}

# Create ConfigMap for securityadmin script
if [ -z "$(kubectl -n $LOG_NS get configmap run-securityadmin.sh -o name 2>/dev/null)" ]; then
  kubectl -n $LOG_NS create configmap run-securityadmin.sh --from-file logging/es/odfe/bin/run_securityadmin.sh
  kubectl -n $LOG_NS label  configmap run-securityadmin.sh managed-by=v4m-es-script
else
  log_info "Using existing ConfigMap [run-securityadmin.sh]"
fi

# Need to retrieve these from secrets in case secrets pre-existed
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)
export ES_METRICGETTER_USER=$(kubectl -n $LOG_NS get secret internal-user-metricgetter -o=jsonpath="{.data.username}" |base64 --decode)
export ES_METRICGETTER_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-metricgetter -o=jsonpath="{.data.password}" |base64 --decode)


# enable debug on Helm via env var
export HELM_DEBUG="${HELM_DEBUG:-false}"

if [ "$HELM_DEBUG" == "true" ]; then
  helmDebug="--debug"
fi

helm2ReleaseCheck odfe-$LOG_NS

# Check for existing Open Distro helm release
existingODFE="false"
if [ helm status -n $LOG_NS odfe 1>/dev/null 2>&1 ]; then
   existingODFE="true"
fi


# Elasticsearch user customizations
ES_OPEN_USER_YAML="${ES_OPEN_USER_YAML:-$USER_DIR/logging/user-values-elasticsearch-open.yaml}"
if [ ! -f "$ES_OPEN_USER_YAML" ]; then
  log_debug "[$ES_OPEN_USER_YAML] not found. Using $TMP_DIR/empty.yaml"
  ES_OPEN_USER_YAML=$TMP_DIR/empty.yaml
fi

# Kibana user customizations
# NOTE: There is not KIBANA_OPEN_USER_YAML equivalent because
# Kibana is deployed as part of the Elasticsearch Helm chart
# User values for Kibana should be included in the ES_OPEN_USER_YAML


# Require TLS into Kibana?
LOG_KB_TLS_ENABLE=${LOG_KB_TLS_ENABLE:-false}

# Enable TLS for East/West Kibana traffic (inc. requiring HTTPS from browser if using NodePorts)
if [ "$LOG_KB_TLS_ENABLE" == "true" ]; then
   # Kibana TLS-specific Helm chart values currently maintained in separate YAML file
   KB_OPEN_TLS_YAML=logging/es/odfe/es_helm_values_kb_tls_open.yaml
   # w/TLS: use HTTPS in curl commands
   KB_CURL_PROTOCOL=https
   log_debug "TLS enabled for Kibana"
else
   # point to an empty yaml file
   KB_OPEN_TLS_YAML=$TMP_DIR/empty.yaml
   # w/o TLS: use HTTP in curl commands
   KB_CURL_PROTOCOL=http
   log_debug "TLS not enabled for Kibana"
fi


# Create secrets containing SecurityConfig files
create_secret_from_file securityconfig/action_groups.yml   security-action-groups   managed-by=v4m-es-script
create_secret_from_file securityconfig/config.yml          security-config          managed-by=v4m-es-script
create_secret_from_file securityconfig/internal_users.yml  security-internal-users  managed-by=v4m-es-script
create_secret_from_file securityconfig/roles.yml           security-roles           managed-by=v4m-es-script
create_secret_from_file securityconfig/roles_mapping.yml   security-roles-mapping   managed-by=v4m-es-script


# Open Distro for Elasticsearch
log_info "Deploying Open Distro for Elasticsearch"

odfe_tgz_file=opendistro-es-1.8.0.tgz

baseDir=$(pwd)
if [ ! -f "$TMP_DIR/$odfe_tgz_file" ]; then
   cd $TMP_DIR

   rm -rf $TMP_DIR/opendistro-build
   log_info "Cloning Open Distro for Elasticsearch repo"
   git clone https://github.com/opendistro-for-elasticsearch/opendistro-build

   # checkout specific commit
   cd opendistro-build
   git checkout 2c139044ee31a490b58ac6a306a5a5ef5ef21383

   # build package
   log_info "Packaging Helm Chart for Elasticsearch"

   # cd opendistro-build/helm/opendistro-es/
   cd helm/opendistro-es/
   helm package .

   # move .tgz file to $TMP_DIR
   mv $odfe_tgz_file $TMP_DIR/$odfe_tgz_file

   # return to working dir
   cd $baseDir

   # remove repo directories
   rm -rf $TMP_DIR/opendistro-build
fi

# Enable workload node placement?
LOG_NODE_PLACEMENT_ENABLE=${LOG_NODE_PLACEMENT_ENABLE:-${NODE_PLACEMENT_ENABLE:-false}}

# Optional workload node placement support
if [ "$LOG_NODE_PLACEMENT_ENABLE" == "true" ]; then
  log_info "Enabling elasticsearch for workload node placement"
  wnpValuesFile="logging/node-placement/values-elasticsearch-open-wnp.yaml"
else
  log_debug "Workload node placement support is disabled for elasticsearch"
  wnpValuesFile="$TMP_DIR/empty.yaml"
fi


# Deploy Elasticsearch via Helm chart
helm $helmDebug upgrade --install odfe --namespace $LOG_NS  --values logging/es/odfe/es_helm_values_open.yaml  --values "$KB_OPEN_TLS_YAML" --values "$wnpValuesFile" --values "$ES_OPEN_USER_YAML" --set fullnameOverride=v4m-es $TMP_DIR/$odfe_tgz_file


# Use multi-purpose Elasticsearch nodes?
ES_MULTIROLE_NODES=${ES_MULTIROLE_NODES:-false}

# switch to multi-role ES nodes (if enabled)
if [ "$ES_MULTIROLE_NODES" == "true" ]; then

   sleep 10s
   log_debug "Configuring Elasticsearch to use multi-role nodes"

   # Reconfigure 'master' nodes to be 'multi-role' nodes (i.e. support master, data and client roles)
   log_debug "Patching statefulset [v4m-es-master]"
   kubectl -n $LOG_NS patch statefulset v4m-es-master --patch "$(cat logging/es/odfe/es_multirole_nodes_patch.yml)"

   # Delete existing (unpatched) master pod
   kubectl -n $LOG_NS delete pod v4m-es-master-0 --ignore-not-found

   # By default, there will be no single-role 'client' or 'data' nodes; but patching corresponding
   # K8s objects to ensure proper labels are used in case user chooses to configure additional single-role nodes
   log_debug "Patching deployment [v4m-es-client]"
   kubectl -n $LOG_NS patch deployment v4m-es-client --type=json --patch '[{"op": "add","path": "/spec/template/metadata/labels/esclient","value": "true" }]'

   log_debug "Patching statefulset [v4m-es-data]"
   kubectl -n $LOG_NS patch statefulset v4m-es-data  --type=json --patch '[{"op": "add","path": "/spec/template/metadata/labels/esdata","value": "true" }]'

   # patching 'client' and 'data' _services_ to use new multi-role labels for node selection
   log_debug "Patching  service [v4m-es-client-service]"
   kubectl -n $LOG_NS patch service v4m-es-client-service --type=json --patch '[{"op": "remove","path": "/spec/selector/role"},{"op": "add","path": "/spec/selector/esclient","value": "true" }]'

   log_debug "Patching  service [v4m-es-data-service]"
   kubectl -n $LOG_NS patch service v4m-es-data-svc --type=json --patch '[{"op": "remove","path": "/spec/selector/role"},{"op": "add","path": "/spec/selector/esdata","value": "true" }]'
else
   log_debug "**********************************>Multirole Flag: $ES_MULTIROLE_NODES"
fi

# wait for pod to come up
log_info "Waiting [90] seconds to allow PVCs for pod [v4m-es-master-0] to be matched with available PVs [$(date)]"
sleep 90s

# Confirm PVC is "bound" (matched) to PV
pvc_status=$(kubectl -n $LOG_NS get pvc  data-v4m-es-master-0  -o=jsonpath="{.status.phase}")
if [ "$pvc_status" != "Bound" ];  then
      log_error "It appears that the PVC [data-v4m-es-master-0] associated with the [v4m-es-master-0] node has not been bound to a PV."
      log_error "The status of the PVC is [$pvc_status]"
      log_error "After ensuring all claims shown as Pending can be satisfied; run the remove_elasticsearch_open.sh script and try again."
      exit 1
fi
log_info "The PVC [data-v4m-es-master-0] have been bound to PVs"

# Need to wait 2-3 minutes for the elasticsearch to come up and running
log_info "Checking on status of Elasticsearch pod before configuring [$(date)]"
podready="FALSE"

for pause in 40 30 20 15 10 10 10 15 15 15 30 30 30 30
do
   if [[ "$( kubectl -n $LOG_NS get pod v4m-es-master-0 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}')" == *"True"* ]]; then
      log_info "Pod [v4m-es-master-0] is ready...continuing."
      podready="TRUE"
      break
   else
      log_info "Pod  [v4m-es-master-0] is not ready yet...sleeping for [$pause] more seconds before checking again."
      sleep ${pause}s
   fi
done

if [ "$podready" != "TRUE" ]; then
   log_error "The Elasticsearch pod [v4m-es-master-0] has NOT reached [Ready] status in the expected time; exiting."
   log_error "Review pod's events and log to identify the issue and resolve it; run the remove_logging.sh script and try again."
   exit 1
fi

# TO DO: Convert to curl command to detect ES is up?
# hitting https:/host:port -u adminuser:adminpwd --insecure 
# returns "Open Distro Security not initialized." and 503 when up
log_info "Waiting [2] minute to allow Elasticsearch to initialize [$(date)]"
sleep 120s

set +e

# Run the security admin script on the pod
# Add some logic to find ES release
if [ "$existingODFE" == "false" ]; then
  kubectl -n $LOG_NS exec v4m-es-master-0 -it -- config/run_securityadmin.sh
  # Retrieve log file from security admin script
  kubectl -n $LOG_NS cp v4m-es-master-0:config/run_securityadmin.log $TMP_DIR/run_securityadmin.log
  if [ "$(tail -n1  $TMP_DIR/run_securityadmin.log)" == "Done with success" ]; then
    log_info "The run_securityadmin.log script appears to have run successfully; you can review its output below:"
  else
    log_warn "There may have been a problem with the run_securityadmin.log script; review the output below:"
  fi
  # show output from run_securityadmin.sh script
  sed 's/^/   | /' $TMP_DIR/run_securityadmin.log
else
  log_info "Existing Open Distro release found. Skipping Elasticsearh security initialization."
fi

set -e

log_debug "Script [$this_script] has completed [$(date)]"
echo ""
