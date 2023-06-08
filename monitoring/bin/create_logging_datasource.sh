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

# Create temporary directory for string replacement in the grafana-datasource-es.yaml file
monDir=$TMP_DIR/$MON_NS
mkdir -p $monDir
cp monitoring/grafana-datasource-es.yaml $monDir/grafana-datasource-es.yaml

# Replace placeholders
log_debug "Replacing variables in $monDir/grafana-datasource-es.yaml file"
if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
    sed -i '' "s/__namespace__/$LOG_NS/g" $monDir/grafana-datasource-es.yaml
    sed -i '' "s/__ES_SERVICENAME__/$ES_SERVICENAME/g" $monDir/grafana-datasource-es.yaml    
    sed -i '' "s/__userID__/$grfds_user/g" $monDir/grafana-datasource-es.yaml
    sed -i '' "s/__passwd__/$grfds_passwd/g" $monDir/grafana-datasource-es.yaml
else
    sed -i "s/__namespace__/$LOG_NS/g" $monDir/grafana-datasource-es.yaml
    sed -i "s/__ES_SERVICENAME__/$ES_SERVICENAME/g" $monDir/grafana-datasource-es.yaml
    sed -i "s/__userID__/$grfds_user/g" $monDir/grafana-datasource-es.yaml
    sed -i "s/__passwd__/$grfds_passwd/g" $monDir/grafana-datasource-es.yaml
fi

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

# Adds the logging data source to Grafana
log_info "Provisioning logging data source in Grafana"
if [ "$cluster" == "true" ]; then
    kubectl create secret generic -n $MON_NS grafana-datasource-es --from-file $monDir/grafana-datasource-es.yaml
    kubectl label secret -n $MON_NS grafana-datasource-es grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring
else
    kubectl create secret generic -n $tenantNS v4m-grafana-datasource-es-$tenant --from-file $monDir/grafana-datasource-es.yaml
    kubectl label secret -n $tenantNS v4m-grafana-datasource-es-$tenant grafana_datasource-$tenant=true sas.com/monitoring-base=kube-viya-monitoring
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
