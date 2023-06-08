# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

function populateValuesYAML() {
  v4mValuesYAML=$1
  rm -f "$v4mValuesYAML"
  touch "$v4mValuesYAML"

  # Attempt to obtain current git commit hash
  gitCommit=$(git rev-parse --short HEAD 2>/dev/null)
  if [ -n "$gitCommit" ]; then
    echo "gitCommit: $gitCommit" >> "$v4mValuesYAML"
    gitStatus=$(git status -s | sed 's/^ M/M/' | sed 's/^/  /')
    if [ -n "$gitStatus" ]; then
      echo "gitStatus: |" >> "$v4mValuesYAML"
      echo "$gitStatus" >> "$v4mValuesYAML"
    fi
  fi

  # List contents of USER_DIR
  if ! [[ "$USER_DIR" -ef "$(pwd)" ]]; then
    if [ -d "$USER_DIR" ]; then
      echo '"user_dir":' >> "$v4mValuesYAML"
      echo "  path: $USER_DIR" >> "$v4mValuesYAML"
      echo '  files: |' >> "$v4mValuesYAML"
      l=($(find "$USER_DIR" -type f))
      for (( i=0; i<${#l[@]}; i++ )); do
        fullPath=${l[i]}
        path=${fullPath#"$USER_DIR/"}
        echo "      $path" >> "$v4mValuesYAML"
      done
    fi
    
    # Top-level user.env contents
    if [ -f "$USER_DIR/user.env" ]; then
      echo '  "user.env": |' >> "$v4mValuesYAML"
      cat "$USER_DIR/user.env" | sed 's/^/      /' >> "$v4mValuesYAML"
    fi
    # Monitoring user.env contents
    if [ -f "$USER_DIR/monitoring/user.env" ]; then
      echo '  "monitoring_user.env": |' >> "$v4mValuesYAML"
      cat "$USER_DIR/monitoring/user.env" | sed 's/^/      /' >> "$v4mValuesYAML"
    fi
    # Logging user.env contents
    if [ -f "$USER_DIR/logging/user.env" ]; then
      echo '  "logging_user.env": |' >> "$v4mValuesYAML"
      cat "$USER_DIR/logging/user.env" | sed 's/^/      /' >> "$v4mValuesYAML"
    fi
  fi

  # Encrypt passwords stored in V4M Helm Chart
  if echo "$OSTYPE" | grep 'darwin' > /dev/null 2>&1; then
    sed -i '' "s/GRAFANA_ADMIN_PASSWORD=.*/GRAFANA_ADMIN_PASSWORD=***/g" "$v4mValuesYAML"
    sed -i '' "s/ES_ADMIN_PASSWD=.*/ES_ADMIN_PASSWD=***/g" "$v4mValuesYAML"
    sed -i '' "s/LOG_LOGADM_PASSWD=.*/LOG_LOGADM_PASSWD=***/g" "$v4mValuesYAML"
  else
    sed -i "s/GRAFANA_ADMIN_PASSWORD=.*/GRAFANA_ADMIN_PASSWORD=***/g" "$v4mValuesYAML"
    sed -i "s/ES_ADMIN_PASSWD=.*/ES_ADMIN_PASSWD=***/g" "$v4mValuesYAML"
    sed -i "s/LOG_LOGADM_PASSWD=.*/LOG_LOGADM_PASSWD=***/g" "$v4mValuesYAML"
  fi
}

function deployV4MInfo() {
  NS=$1
  releaseName=${2:-'v4m'}
  if [ -z "$NS" ]; then
    log_error "No namespace specified for deploying SAS Viya Monitoring for Kubernetes version information"
    return 1
  fi

  valuesYAML=$TMP_DIR/v4mValues.yaml
  populateValuesYAML "$valuesYAML"

  log_info "Updating SAS Viya Monitoring for Kubernetes version information"
  helm upgrade --install \
    -n "$NS" \
    --values $valuesYAML \
    $releaseName ./v4m-chart

  getHelmReleaseVersion "$NS" "$releaseName"
}

function removeV4MInfo() {
  NS=$1
  releaseName=${2:-'v4m'}
  if [ -z "$NS" ]; then
    log_error "No namespace specified for removing SAS Viya Monitoring for Kubernetes version information"
    return 1
  fi
 
  if [ ! -z $(helm list -n "$NS" --filter "^$releaseName\$" -q) ]; then
    log_info "Removing SAS Viya Monitoring for Kubernetes version information"
    helm uninstall -n "$NS" "$releaseName"
  fi
}

function getHelmReleaseVersion() {
  NS=$1
  releaseName=${2:-'v4m'}

  releaseVersionFull=""
  releaseVersionMajor=""
  releaseVersionMinor=""
  releaseVersionPatch=""
  releaseStatus=""

  origIFS=$IFS
  IFS=$'\n' v4mHelmVersionLines=($(helm list -n "$NS" --filter "^$releaseName\$" -o yaml))
  IFS=$origIFS
  if [ -z "$v4mHelmVersionLines" ]; then
    log_debug "No [$releaseName] release found in [$NS]"
  else
    for (( i=0; i<${#v4mHelmVersionLines[@]}; i++ )); do 
      line=${v4mHelmVersionLines[$i]}
      vre='app_version: (([0-9]+).([[0-9]+).([0-9]+)\.?(-.+)?)'
      sre='status: (.+)'
      if [[ $line =~ $vre ]]; then
        # Set
        releaseVersionFull=${BASH_REMATCH[1]}
        releaseVersionMajor=${BASH_REMATCH[2]}
        releaseVersionMinor=${BASH_REMATCH[3]}        
        releaseVersionPatch=${BASH_REMATCH[4]}
      elif [[ "$line" =~ $sre ]]; then
        releaseStatus=${BASH_REMATCH[1]}
      fi
    done

  fi
  
  export releaseVersionFull releaseVersionMajor releaseVersionMinor releaseVersionPatch releaseStatus
}

if [ -z "$V4M_VERSION_INCLUDE" ]; then
  getHelmReleaseVersion "$V4M_NS"
  
  V4M_CURRENT_VERSION_FULL=$releaseVersionFull
  V4M_CURRENT_VERSION_MAJOR=$releaseVersionMajor
  V4M_CURRENT_VERSION_MINOR=$releaseVersionMinor
  V4M_CURRENT_VERSION_PATCH=$releaseVersionPatch
  V4M_CURRENT_STATUS=$releaseStatus
  
  log_debug "V4M_CURRENT_VERSION_FULL=$V4M_CURRENT_VERSION_FULL"
  log_debug "V4M_CURRENT_VERSION_MAJOR=$V4M_CURRENT_VERSION_MAJOR"
  log_debug "V4M_CURRENT_VERSION_MINOR=$V4M_CURRENT_VERSION_MINOR"
  log_debug "V4M_CURRENT_VERSION_PATCH=$V4M_CURRENT_VERSION_PATCH"
  log_debug "V4M_CURRENT_STATUS=$V4M_CURRENT_STATUS"

  export V4M_CURRENT_VERSION_FULL V4M_CURRENT_VERSION_MAJOR V4M_CURRENT_VERSION_MINOR V4M_CURRENT_VERSION_PATCH 
  export V4M_CURRENT_STATUS

  export -f deployV4MInfo removeV4MInfo getHelmReleaseVersion
  export V4M_VERSION_INCLUDE=true
fi

