# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

function configureElasticsearchDatasource() {
  # Check to see if logging components have already been deployed.
  if [[ $(kubectl get pods -A -l app.kubernetes.io/instance=v4m-fb -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) == 0 ]]; then
    log_verbose "No logging components found.  Skipping Elasticsearch data source set up.";
  elif [[ $(kubectl get pods -A -l app.kubernetes.io/instance=v4m-fb -o custom-columns=:metadata.namespace --no-headers | uniq | wc -l) > 1 ]]; then
    log_verbose "Too many logging components found.  Skipping Elasticsearch data source set up.";
  else
    # Replace logging namespace name and password in grafana-datasource-es.yaml file
    logNS=$(kubectl get pods -A -l app.kubernetes.io/instance=v4m-fb -o custom-columns=:metadata.namespace --no-headers | uniq)
    monDir=$TMP_DIR/$MON_NS
    mkdir -p $monDir
    cp -R monitoring/grafana-datasource-es.yaml $monDir/grafana-datasource-es.yaml
  
    # Pull Elasticsearch password in temp directory file
    adminPass="$(kubectl -n $logNS get secret internal-user-admin -o=jsonpath="{.data.password}" | base64 --decode)"
    
    # Replace placeholders
    log_debug "Replacing logging namespace for files in [$monDir]"
    if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
      sed -i '' "s/__logNS__/$logNS/g" $monDir/grafana-datasource-es.yaml
      sed -i '' "s/__adminPass__/$adminPass/g" $monDir/grafana-datasource-es.yaml
    else
      sed -i "s/__logNS__/$logNS/g" $monDir/grafana-datasource-es.yaml
      sed -i "s/__adminPass__/$adminPass/g" $monDir/grafana-datasource-es.yaml
    fi
  
    log_info "Provisioning Elasticsearch datasource for Grafana"
    kubectl delete secret -n $MON_NS --ignore-not-found grafana-datasource-es
    kubectl create secret generic -n $MON_NS grafana-datasource-es --from-file $monDir/grafana-datasource-es.yaml
    kubectl label secret -n $MON_NS grafana-datasource-es grafana_datasource=1 sas.com/monitoring-base=kube-viya-monitoring
  fi
}

if [ "$SAS_MONITORING_COMMON_SOURCED" = "" ]; then
  source bin/common.sh

  if [ -f "$USER_DIR/monitoring/user.env" ]; then
      userEnv=$(grep -v '^[[:blank:]]*$' $USER_DIR/monitoring/user.env | grep -v '^#' | xargs)
      log_verbose "Loading user environment file: $USER_DIR/monitoring/user.env"
      if [ "$userEnv" ]; then
        export $userEnv
      fi
  fi

  export MON_NS="${MON_NS:-monitoring}"
  export TLS_ENABLE="${MON_TLS_ENABLE:-${TLS_ENABLE:-false}}"
  export V4M_NS=$MON_NS

  source bin/version-include.sh
  export SAS_MONITORING_COMMON_SOURCED=true
  export -f configureElasticsearchDatasource
fi
echo ""
