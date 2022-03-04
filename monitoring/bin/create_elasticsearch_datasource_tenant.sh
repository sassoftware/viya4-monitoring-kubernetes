#! /bin/bash

# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Prerequisites:
# If cluster, cluster level needs to be deployed.  Uses $LOG_NS and $MON_NS.  If tenant, provide namespace, tenant name, user, password.
# If tenant, tenant needs to be onboarded.  Need to provide namespace (default to usual monitoring/logging), tenant, user, password.


cd "$(dirname $BASH_SOURCE)/../.."
CHECK_HELM=false
source monitoring/bin/common.sh
source logging/bin/apiaccess-include.sh
source logging/bin/rbac-include.sh
source logging/bin/secrets-include.sh
export LOG_NS="${LOG_NS:-logging}"

function show_usage {
  log_message  "Usage: $this_script --namespace NAMESPACE --tenant TENANT --user USER --password PASSWORD"
  log_message  ""
  log_message  "'Creates the Elasticsearch datasource for a Viya tenant given using user-provided "
  log_message  "namespace, tenant, and user credentials."
  log_message  ""
  log_message  "    Arguments:"
  log_message  "     -ns, --namespace NAMESPACE   - The namespace where the Viya tenant is resides."
  log_message  "     -t,  --tenant TENANT         - The tenant whose Elasticsearch data source you want to set up."
  log_message  "     -u,  --user USER             - The user with access to this Kibana tenant space."
  log_message  "     -p,  --password PASSWORD     - Password for the initial user."
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
    -u|--user)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        userID=$2
        shift 2
      else
        log_error "A value for parameter [USER] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -p|--password)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        passwd=$2
        shift 2
      else
        log_error "A value for parameter [PASSWORD] has not been provided." >&2
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

# Check to make sure all parameters have been provided
if [ -z "$tenantNS" ]; then
  log_error "A value for parameter [NAMESPACE] was not been provided."
  exit 2
fi

if [ -z "$tenant" ]; then
  log_error "A value for parameter [TENANT] was not been provided."
  exit 2
fi

if [ -z "$userID" ]; then
  log_error "A value for parameter [USER] was not been provided."
  exit 2
fi

if [ -z "$passwd" ]; then
  log_error "A value for parameter [PASSWORD] was not been provided."
  exit 2
fi

# Convert namespace and tenant to all lower-case
tenantNS=$(echo "$tenantNS"| tr '[:upper:]' '[:lower:]')
tenant=$(echo "$tenant"| tr '[:upper:]' '[:lower:]')

# Check to see if monitoring deployment could be found for tenant in provided namespace
log_info "Checking the $tenantNS namespace for monitoring deployment for the $tenant tenant ..."
if [[ $(kubectl get pods -n $tenantNS -l app.kubernetes.io/instance=v4m-grafana-$tenant -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
  log_error "No monitoring components were found for $tenant in the $tenantNS namespace."
  log_error "Monitoring needs to be deployed in this namespace in order to configure Elasticsearch with this script.";
  exit 1
else
  log_debug "Monitoring deployment was found for the $tenant tenant in the $tenantNS namespace.  Continuing."
fi

# Check to see if tenant has been deployed in logging.
log_info "Checking that $tenant has been onboarded to Elasticsearch in the $LOG_NS namespace ..."

get_sec_api_url
get_credentials_from_secret admin

if ! kibana_tenant_exists "${tenantNS}_${tenant}"; then
  log_error "Unable to configure Elasticsearch data source.  The $tenant tenant has not been onboarded.";
  exit 1
else
  log_debug "The $tenant tenant has been been onboarded in the Elasticsearch.  Continuing."
fi 

# Create temporary directory for string replacement in the grafana-datasource-es.yaml file
tenantDir=$TMP_DIR/$tenant
mkdir -p $tenantDir
cp monitoring/grafana-datasource-es.yaml $tenantDir/grafana-datasource-es.yaml

# Replace placeholders
log_debug "Replacing variables in $tenantDir/grafana-datasource-es.yaml file"
if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
  sed -i '' "s/__namespace__/$LOG_NS/g" $tenantDir/grafana-datasource-es.yaml
  sed -i '' "s/__userID__/$userID/g" $tenantDir/grafana-datasource-es.yaml
  sed -i '' "s/__passwd__/$passwd/g" $tenantDir/grafana-datasource-es.yaml
else
  sed -i "s/__namespace__/$LOG_NS/g" $tenantDir/grafana-datasource-es.yaml
  sed -i "s/__userID__/$userID/g" $tenantDir/grafana-datasource-es.yaml
  sed -i "s/__passwd__/$passwd/g" $tenantDir/grafana-datasource-es.yaml
fi

if [ -n "$(kubectl get secret -n $tenantNS v4m-grafana-datasource-es-$tenant -o custom-columns=:metadata.name --no-headers --ignore-not-found)" ]; then
  log_info "Removing existing Elasticsearch data source for [$tenantNS/$tenant] ..."
  kubectl delete secret -n $tenantNS --ignore-not-found v4m-grafana-datasource-es-$tenant
fi

log_info "Provisioning Elasticsearch data source for [$tenantNS/$tenant] instance of Grafana"
kubectl create secret generic -n $tenantNS v4m-grafana-datasource-es-$tenant --from-file $tenantDir/grafana-datasource-es.yaml
kubectl label secret -n $tenantNS v4m-grafana-datasource-es-$tenant grafana_datasource-$tenant=true sas.com/monitoring-base=kube-viya-monitoring

# Delete pods so that they can be restarted with the change.
log_info "Elasticsearch data source provisioned.  Restarting pods to apply the change"
kubectl delete pods -n $tenantNS -l "app.kubernetes.io/instance=v4m-grafana-$tenant"
kubectl -n $tenantNS wait pods --selector app.kubernetes.io/instance=v4m-grafana-$tenant --for condition=Ready --timeout=2m
log_info "Elasticsearch data source has been configured for [$tenantNS/$tenant]."
