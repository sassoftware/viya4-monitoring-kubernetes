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
}

function deployV4MInfo() {
  NS=$1
  if [ -z "$NS" ]; then
    log_error "No namespace specified for deploying Viya Monitoring for Kubernetes version information"
    return 1
  fi

  valuesYAML=$TMP_DIR/v4mValues.yaml
  populateValuesYAML "$valuesYAML"

  log_info "Updating Viya Monitoring for Kubernetes version information..."
  helm upgrade --install \
    -n "$NS" \
    --values $valuesYAML \
    v4m ./v4m-chart
}

function removeV4MInfo() {
  NS=$1
  if [ -z "$NS" ]; then
    log_error "No namespace specified for removing Viya Monitoring for Kubernetes version information"
    return 1
  fi
  log_info "Removing Viya Monitoring for Kubernetes version information..."
  helm uninstall -n "$NS" v4m
}

if [ -z "$V4M_VERSION_INCLUDE" ]; then
  origIFS=$IFS
  IFS=$'\n' v4mHelmVersionLines=($(helm list -n "$V4M_NS" --filter '^v4m$' -o yaml))
  IFS=$origIFS
  if [ -z "$v4mHelmVersionLines" ]; then
    log_debug "No Viya Monitoring for Kubernetes release found in [$V4M_NS]"
  else
    for (( i=0; i<${#v4mHelmVersionLines[@]}; i++ )); do 
      line=${v4mHelmVersionLines[$i]}
      vre='app_version: (([0-9]+).([[0-9]+).([0-9]+)\.?(-.+)?)'
      sre='status: (.+)'
      if [[ $line =~ $vre ]]; then
        V4M_CURRENT_VERSION_FULL=${BASH_REMATCH[1]}
        V4M_CURRENT_VERSION_MAJOR=${BASH_REMATCH[2]}
        V4M_CURRENT_VERSION_MINOR=${BASH_REMATCH[3]}        
        V4M_CURRENT_VERSION_PATCH=${BASH_REMATCH[4]}
      elif [[ "$line" =~ $sre ]]; then
        V4M_CURRENT_STATUS=${BASH_REMATCH[1]}
      fi
    done

    log_debug "V4M_CURRENT_VERSION_FULL=$V4M_CURRENT_VERSION_FULL"
    log_debug "V4M_CURRENT_VERSION_MAJOR=$V4M_CURRENT_VERSION_MAJOR"
    log_debug "V4M_CURRENT_VERSION_MINOR=$V4M_CURRENT_VERSION_MINOR"
    log_debug "V4M_CURRENT_VERSION_PATCH=$V4M_CURRENT_VERSION_PATCH"
    log_debug "V4M_CURRENT_STATUS=$V4M_CURRENT_STATUS"

    export V4M_CURRENT_VERSION_FULL V4M_CURRENT_VERSION_MAJOR V4M_CURRENT_VERSION_MINOR V4M_CURRENT_VERSION_PATCH 
    export V4M_CURRENT_STATUS
  fi

  export -f deployV4MInfo removeV4MInfo
  export V4M_VERSION_INCLUDE=true
fi
