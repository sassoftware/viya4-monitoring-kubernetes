#! /bin/bash

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
source monitoring/bin/common.sh

source logging/bin/apiaccess-include.sh
source logging/bin/secrets-include.sh
source logging/bin/rbac-include.sh

this_script=`basename "$0"`

function show_usage {
  log_message  "Usage: $this_script --namespace NAMESPACE --tenant TENANT --user USER --password PASSWORD"
  log_message  ""
  log_message  "'Creates the Elasticsearch datasource for a Viya tenant given using user-provided "
  log_message  "namespace, tenant, and user credentials."
  log_message  ""
  log_message  "    Arguments:"
  log_message  "     -ns, --namespace NAMESPACE   - The namespace where the Viya tenant is resides."
  log_message  "     -t,  --tenant TENANT         - The tenant whose Elasticsearch data source you want to set up."
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
elif [ -n "$tenant" ]; then
    nst="${tenantNS}_${tenant}"
else
   nst="$tenantNS"
fi

# Check to see if monitoring/Viya namespace provided exists and components have already been deployed
if [ "$cluster" == "true" ]; then
    log_info "Checking for Grafana pods in the $MON_NS namespace ..."
    if [[ $(kubectl get pods -n $MON_NS -l app.kubernetes.io/instance=v4m-prometheus-operator -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
        log_error "No monitoring components found in the [$MON_NS] namespace."
        log_error "Monitoring needs to be deployed in this namespace in order to configure Elasticsearch with this script.";
        exit 1
    else
        log_debug "Monitoring found in $MON_NS namespace.  Continuing."
    fi
else
    log_info "Checking the [$tenantNS] namespace for monitoring deployment for the [$tenant] tenant ..."
    if [[ $(kubectl get pods -n $tenantNS -l app.kubernetes.io/instance=v4m-grafana-$tenant -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
        log_error "No monitoring components were found for $tenant in the $tenantNS namespace."
        log_error "Monitoring needs to be deployed in this namespace in order to configure Elasticsearch with this script.";
        exit 1
    else
        log_debug "Monitoring deployment was found for the $tenant tenant in the $tenantNS namespace.  Continuing."
    fi
fi

# Check to see if logging namespace provided exists and components have already been deployed
log_info "Checking for Elasticsearch pods in the $LOG_NS namespace ..."
if [[ $(kubectl get pods -n $LOG_NS -l app=v4m-es -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
  log_error "No logging components found in the $LOG_NS namespace."
  log_error "Logging needs to be deployed in this namespace in order to configure Elasticsearch with this script.";
  exit 1
else
  log_debug "Logging deployment found in $LOG_NS namespace.  Continuing."
fi

# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)

get_sec_api_url
get_credentials_from_secret admin

# FOR TENANT - Check to see if tenant has been deployed in logging.
if [ "$cluster" != "true" ]; then
    log_info "Checking that [$tenant] has been onboarded to Elasticsearch in the $LOG_NS namespace ..."

    if ! kibana_tenant_exists "${tenantNS}_${tenant}"; then
        log_error "Unable to configure Elasticsearch data source."
        log_error "The [$tenant] tenant in the $tenantNS namespace has not been onboarded.";
        exit 1
    else
        log_debug "The [$tenant] tenant has been been onboarded in the Elasticsearch.  Continuing."
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
    sed -i '' "s/__userID__/$grfds_user/g" $monDir/grafana-datasource-es.yaml
    sed -i '' "s/__passwd__/$grfds_passwd/g" $monDir/grafana-datasource-es.yaml
else
    sed -i "s/__namespace__/$LOG_NS/g" $monDir/grafana-datasource-es.yaml
    sed -i "s/__userID__/$grfds_user/g" $monDir/grafana-datasource-es.yaml
    sed -i "s/__passwd__/$grfds_passwd/g" $monDir/grafana-datasource-es.yaml
fi

# Removes old Elasticsearch data source if one exists
if [ "$cluster" == "true" ]; then
    if [[ -n "$(kubectl get secret -n $MON_NS grafana-datasource-es -o custom-columns=:metadata.name --no-headers --ignore-not-found)" ]]; then
        log_info "Removing existing Elasticsearch data source ..."
        kubectl delete secret -n $MON_NS --ignore-not-found grafana-datasource-es
    fi
else
    if [ -n "$(kubectl get secret -n $tenantNS v4m-grafana-datasource-es-$tenant -o custom-columns=:metadata.name --no-headers --ignore-not-found)" ]; then
        log_info "Removing existing Elasticsearch data source for [$tenantNS/$tenant] ..."
        kubectl delete secret -n $tenantNS --ignore-not-found v4m-grafana-datasource-es-$tenant
    fi
fi

# Adds the Elasticsearch data source to Grafana
log_info "Provisioning Elasticsearch datasource for Grafana"
if [ "$cluster" == "true" ]; then
    kubectl create secret generic -n $MON_NS grafana-datasource-es --from-file $monDir/grafana-datasource-es.yaml
    kubectl label secret -n $MON_NS grafana-datasource-es grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring
else
    kubectl create secret generic -n $tenantNS v4m-grafana-datasource-es-$tenant --from-file $monDir/grafana-datasource-es.yaml
    kubectl label secret -n $tenantNS v4m-grafana-datasource-es-$tenant grafana_datasource-$tenant=true sas.com/monitoring-base=kube-viya-monitoring
fi

# Delete pods so that they can be restarted with the change.
log_info "Elasticsearch data source provisioned.  Restarting pods to apply the change"
if [ "$cluster" == "true" ]; then
    kubectl delete pods -n $MON_NS -l "app.kubernetes.io/instance=v4m-prometheus-operator" -l "app.kubernetes.io/name=grafana"
    kubectl -n $MON_NS wait pods --selector "app.kubernetes.io/instance=v4m-prometheus-operator","app.kubernetes.io/name=grafana" --for condition=Ready --timeout=2m
    log_info "Elasticsearch data source has been configured."
else
    kubectl delete pods -n $tenantNS -l "app.kubernetes.io/instance=v4m-grafana-$tenant"
    kubectl -n $tenantNS wait pods --selector app.kubernetes.io/instance=v4m-grafana-$tenant --for condition=Ready --timeout=2m
    log_info "Elasticsearch data source has been configured for [$tenantNS/$tenant]."
fi