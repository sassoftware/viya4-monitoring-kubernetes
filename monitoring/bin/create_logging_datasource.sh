#! /bin/bash

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source monitoring/bin/common.sh

source logging/bin/apiaccess-include.sh
source logging/bin/secrets-include.sh
source logging/bin/rbac-include.sh

this_script=`basename "$0"`

function show_usage {
  log_message  "Usage: $this_script [--namespace NAMESPACE --tenant TENANT]"
  log_message  ""
  log_message  "Creates the logging data source to allow log messages to be viewed in Grafana."
  log_message  ""
  log_message  "To create the logging data source at the cluster level, do not pass any "
  log_message  "arguments.  To create the logging data source at the tenant level, you need"
  log_message  "to provide the following arguments:"
  log_message  "     -ns, --namespace NAMESPACE   - The namespace where the SAS Viya tenant resides."
  log_message  "     -t,  --tenant TENANT         - The tenant whose logging data source you want to set up."
  log_message  ""
}

# Assigning passed in parameters as variables for the script:
POS_PARMS=""

# Setting passed in variables:
while (( "$#" )); do
  case "$1" in
    -ns|--namespace)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        tenantNS=$2
        shift 2
      else
        log_error "A value for parameter [NAMESPACE] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -t|--tenant)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        tenant=$2
        shift 2
      else
        log_error "A value for parameter [TENANT] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -h|--help)
      show_usage
      exit
      ;;
    -*|--*=) # unsupported flags
      log_error "Unsupported flag $1" >&2
      show_usage
      exit 1
      ;;
    *) # preserve positional arguments
      POS_PARMS="$POS_PARMS $1"
      shift
      ;;
  esac
done

# Convert namespace and tenant to all lower-case
tenantNS=$(echo "$tenantNS"| tr '[:upper:]' '[:lower:]')
tenant=$(echo "$tenant"| tr '[:upper:]' '[:lower:]')

# Check for parameters - set with cluster or tenant
if [ -z "$tenantNS" ] && [ -z "$tenant" ]; then
   cluster="true"
elif [ -n "$tenantNS" ] && [ -n "$tenant" ]; then
    nst="${tenantNS}_${tenant}"
else
   log_error "Both a [NAMESPACE] and a [TENANT] are required in order to set up the data source.";
   exit 1
fi

# Check to see if monitoring/Viya namespace provided exists and components have already been deployed
if [ "$cluster" == "true" ]; then
    log_info "Checking for Grafana pods in the $MON_NS namespace ..."
    if [[ $(kubectl get pods -n $MON_NS -l app.kubernetes.io/instance=v4m-prometheus-operator -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
        log_error "No monitoring components found in the [$MON_NS] namespace."
        log_error "Monitoring needs to be deployed in this namespace in order to configure the logging data source in Grafana.";
        exit 1
    else
        log_debug "Monitoring found in $MON_NS namespace.  Continuing."
    fi
else
    log_info "Checking the [$tenantNS] namespace for monitoring deployment for the [$tenant] tenant ..."
    if [[ $(kubectl get pods -n $tenantNS -l app.kubernetes.io/instance=v4m-grafana-$tenant -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
        log_error "No monitoring components were found for [$tenantNS/$tenant] tenant."
        log_error "Monitoring needs to be deployed using the deploy_monitoring_tenant script in order to configure the logging data source in Grafana.";
        exit 1
    else
        log_debug "Monitoring deployment was found for the [$tenantNS/$tenant] tenant.  Continuing."
    fi
fi

# Check to see if logging namespace provided exists and components have already been deployed
if [[ $(kubectl get pods -n $LOG_NS -l app.kubernetes.io/component=$ES_SERVICENAME -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]] && [[ $(kubectl get pods -n $LOG_NS -l app=v4m-es -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
  log_error "Search backend was not found in the [$LOG_NS] namespace."
  log_error "All of the required log monitoring components need to be deployed in this namespace before this script can configure the logging data source."
  exit 1
else
  log_debug "Logging deployment found in [$LOG_NS] namespace.  Continuing."
fi

# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)

get_sec_api_url
get_credentials_from_secret admin

# FOR TENANT - Check to see if tenant has been deployed in logging.
if [ "$cluster" != "true" ]; then
    log_info "Verify that the log monitoring onboarding process has been performed for [${tenantNS}/${tenant}] tenant ..."

    if ! kibana_tenant_exists "${tenantNS}_${tenant}"; then
        log_error "Unable to configure logging datasource for this tenant because the log monitoring onboarding process has not been completed for the [$tenant] in the [$tenantNS] namespace."
        log_error "This can be done by running the logging/bin/onboard.sh script"
        exit 1
    else
        log_debug "The [${tenantNS}/${tenant}] tenant has been been onboarded.  Continuing."
    fi 
fi

# Set user ID and password
if [ "$cluster" == "true" ]; then
   grfds_user="V4M_ALL_grafana_ds"
else
   grfds_user="${nst}_grafana_ds"
fi

if user_exists "$grfds_user"; then
   log_verbose "Removing the existing [$grfds_user] utility account."
   delete_user $grfds_user
fi

grfds_passwd="$(randomPassword)"

if [ "$cluster" == "true" ]; then
   ./logging/bin/user.sh CREATE -ns _all_ -t _all_ -u $grfds_user -p "$grfds_passwd" -g
elif [ -z "$tenant" ]; then
   ./logging/bin/user.sh CREATE -ns $tenantNS -u $grfds_user -p "$grfds_passwd" -g
else
   ./logging/bin/user.sh CREATE -ns $tenantNS -t $tenant -u $grfds_user -p "$grfds_passwd" -g
fi

# Create temporary directory for string replacement in the grafana-datasource-opensearch.yaml file
monDir=$TMP_DIR/$MON_NS
mkdir -p $monDir
cp monitoring/grafana-datasource-opensearch.yaml $monDir/grafana-datasource-opensearch.yaml

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


# Removes old Elasticsearch data source if one exists
if [ "$cluster" == "true" ]; then
    if [[ -n "$(kubectl get secret -n $MON_NS grafana-datasource-es -o custom-columns=:metadata.name --no-headers --ignore-not-found)" ]]; then
        log_info "Removing existing logging data source secret ..."
        kubectl delete secret -n $MON_NS --ignore-not-found grafana-datasource-es
    fi
else
    if [ -n "$(kubectl get secret -n $tenantNS v4m-grafana-datasource-es-$tenant -o custom-columns=:metadata.name --no-headers --ignore-not-found)" ]; then
        log_info "Removing existing logging data source secret for [$tenantNS/$tenant] ..."
        kubectl delete secret -n $tenantNS --ignore-not-found v4m-grafana-datasource-es-$tenant
    fi
fi

# Install OpenSearch datasource plug-in to Grafana
grafanaPod=$(kubectl -n $MON_NS get pods -l app.kubernetes.io/name=grafana -o jsonpath='{.items[0].metadata.name}')
log_debug "Grafana Pod [$grafanaPod]"

pluginInstalled=$(kubectl exec -n $MON_NS $grafanaPod  -- bash -c "grafana cli plugins ls |grep -c opensearch-datasource|| true")
log_debug "Grafana OpenSearch Datasource Plugin installed? [$pluginInstalled]"

if [ "$pluginInstalled" == "0" ]; then

   log_info "Installing OpenSearch Datasource plugin"
   pluginVersion="${GRAFANA_DATASOURCE_PLUGIN_VERSION:-2.17.4}"
   pluginFile="grafana-opensearch-datasource-$pluginVersion.linux_amd64.zip"

   if [ -n "$AIRGAP_HELM_REPO" ]; then
      log_debug "Air-gapped deployment detected; loading OpenSearch Datasource plugin from USER_DIR/monitoring directory"

      userPluginFile="$USER_DIR/monitoring/$pluginFile"
      if [ -f "$userPluginFile" ]; then
         kubectl cp $userPluginFile $MON_NS/$grafanaPod:/var/lib/grafana/plugins
         kubectl exec -n $MON_NS $grafanaPod  -- unzip -o /var/lib/grafana/plugins/$pluginFile -d /var/lib/grafana/plugins/
      else
         log_error "The OpenSearch datasource plugin to Grafana zip file was NOT found in the expected location [$userPluginFile]"
         exit 1
      fi
   else
      log_debug "Using Grafana CLI to install plugin (version [$pluginVersion])"
      kubectl exec -n $MON_NS $grafanaPod  -- grafana cli plugins install grafana-opensearch-datasource $pluginVersion
      log_info "You may ignore any previous messages regarding restarting the Grafana pod; it will be restarted automatically."
   fi
else
   log_debug "The OpenSearch datasource plugin is already installed; skipping installation."
fi

# Adds the logging data source to Grafana
log_info "Provisioning logging data source in Grafana"
if [ "$cluster" == "true" ]; then
    kubectl delete secret generic -n $MON_NS grafana-datasource-opensearch --ignore-not-found
    kubectl create secret generic -n $MON_NS grafana-datasource-opensearch --from-file $monDir/grafana-datasource-opensearch.yaml
    kubectl label secret -n $MON_NS grafana-datasource-opensearch grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring
fi

# Deploy the log-enabled Viya dashboards
WELCOME_DASH="false" KUBE_DASH="false" VIYA_DASH="false" VIYA_LOGS_DASH="true" PGMONITOR_DASH="false" RABBITMQ_DASH="false" NGINX_DASH="false" LOGGING_DASH="false" USER_DASH="false" monitoring/bin/deploy_dashboards.sh

# Delete pods so that they can be restarted with the change.
log_info "Logging data source provisioned in Grafana.  Restarting pods to apply the change"
if [ "$cluster" == "true" ]; then
    kubectl delete pods -n $MON_NS -l "app.kubernetes.io/instance=v4m-prometheus-operator" -l "app.kubernetes.io/name=grafana"
    kubectl -n $MON_NS wait pods --selector "app.kubernetes.io/instance=v4m-prometheus-operator","app.kubernetes.io/name=grafana" --for condition=Ready --timeout=2m
    log_info "Logging data source in Grafana has been configured."
else
    kubectl delete pods -n $tenantNS -l "app.kubernetes.io/instance=v4m-grafana-$tenant"
    kubectl -n $tenantNS wait pods --selector app.kubernetes.io/instance=v4m-grafana-$tenant --for condition=Ready --timeout=2m
    log_info "Logging data source in Grafana has been configured for [$tenantNS/$tenant]."
fi
