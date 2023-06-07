#! /bin/bash

# Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source monitoring/bin/common.sh

this_script=`basename "$0"`

function show_usage {
  log_message  "Usage: $this_script [--password PASSWORD --namespace NAMESPACE --tenant TENANT]"
  log_message  ""
  log_message  "Changes the password of the Grafana admin user."
  log_message  ""
  log_message  "To change the Grafana admin user at the cluster level, you need to provide"
  log_message  "the following argument:"
  log_message  "     -p,  --password PASSWORD     - The new password you want to use."
  log_message  ""
  log_message  "To change the Grafana admin user at the tenant level, you need"
  log_message  "to provide the following arguments:"
  log_message  "     -ns, --namespace NAMESPACE   - The namespace where the SAS Viya tenant resides."
  log_message  "     -t,  --tenant TENANT         - The tenant whose Grafana admin password you want to change."
  log_message  "     -p,  --password PASSWORD     - The new password you want to use."
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
    -p|--password)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        password=$2
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

# Convert namespace and tenant to all lower-case
tenantNS=$(echo "$tenantNS"| tr '[:upper:]' '[:lower:]')
tenant=$(echo "$tenant"| tr '[:upper:]' '[:lower:]')

# Check for parameters - set with cluster or tenant
if [ -z "$tenantNS" ] && [ -z "$tenant" ]; then
  cluster="true"
  namespace=$MON_NS
  grafanaInstance="v4m-grafana"
elif [ -n "$tenantNS" ] && [ -n "$tenant" ]; then
  cluster="false"
  namespace=$tenantNS
  grafanaInstance="v4m-grafana-${tenant}"
else
  log_error "Both a [NAMESPACE] and a [TENANT] are required in order to change the Grafana admin password.";
  exit 1
fi

# Check and make sure that a password was provided.
if [ -z $password ]; then
  log_error "A value for parameter [PASSWORD] has not been provided"
  exit 1
fi 

if [ "$cluster" == "true" ]; then
  grafanaPod="$(kubectl get pods -n $namespace -l app.kubernetes.io/name=grafana --template='{{range .items}}{{.metadata.name}}{{end}}')"
else
  grafanaPod="$(kubectl get pods -n $namespace -l app.kubernetes.io/name=grafana -l app.kubernetes.io/instance=$grafanaInstance --template='{{range .items}}{{.metadata.name}}{{end}}')"
fi

# Error out if a Grafana pod has not been found
if [ -z $grafanaPod ]; then
  log_error "Unable to update Grafana password."
  log_error "No Grafana pods were available to update"
  exit 1
fi

# Changes the admin password using the Grafana CLI
log_info "Updating the admin password using Grafana CLI"
kubectl exec -n $namespace $grafanaPod -c grafana -- bin/grafana-cli admin reset-admin-password $password

# Exit out of the script if the Grafana CLI call fails
if (( $? != 0 )); then
  log_error "An error occurred when updating the password"
  exit 1
fi

# Patch new password in Kubernetes
encryptedPassword="$(echo -n "$password" | base64)"
log_info "Updating Grafana secret with the new password"
kubectl -n $namespace patch secret $grafanaInstance --type='json' -p="[{'op' : 'replace' ,'path' : '/data/admin-password' ,'value' : '$encryptedPassword'}]"

# Restart Grafana pods and wait for them to restart
log_info "Grafana admin password has been updated.  Restarting Grafana pods to apply the change"
if [ "$cluster" == "true" ]; then
    kubectl delete pods -n $namespace -l "app.kubernetes.io/instance=v4m-prometheus-operator" -l "app.kubernetes.io/name=grafana"
    kubectl -n $namespace wait pods --selector "app.kubernetes.io/instance=v4m-prometheus-operator","app.kubernetes.io/name=grafana" --for condition=Ready --timeout=2m
    log_info "Grafana password has been successfully changed."
else
    kubectl delete pods -n $namespace -l "app.kubernetes.io/instance=$grafanaInstance"
    kubectl -n $namespace wait pods --selector app.kubernetes.io/instance=$grafanaInstance --for condition=Ready --timeout=2m
    log_info "Grafana admin password has been successfully changed for [$tenantNS/$tenant]."
fi
