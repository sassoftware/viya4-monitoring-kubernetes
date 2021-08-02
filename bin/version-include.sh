# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

function deployV4MInfo() {
  NS=$1
  if [ -z "$NS" ]; then
    log_error "No namespace specified for deploying version info"
    return 1
  fi
  v4mValuesYAML=$TMP_DIR/v4mValues.yaml
  rm -f "$v4mValuesYAML"
  touch "$v4mValuesYAML"

  if [ -d "$USER_DIR" ]; then
    echo '"user_dir":' >> "$v4mValuesYAML"
    echo '  files: |' >> "$v4mValuesYAML"
    ls -R "$USER_DIR" | sed 's/^/      /' >> "$v4mValuesYAML"
  fi  
  if [ -f "$USER_DIR/user.env" ]; then
    echo '  "user.env": |' >> "$v4mValuesYAML"
    cat "$USER_DIR/user.env" | sed 's/^/      /' >> "$v4mValuesYAML"
  fi
  if [ -f "$USER_DIR/monitoring/user.env" ]; then
    echo '  "monitoring_user.env": |' >> "$v4mValuesYAML"
    cat "$USER_DIR/monitoring/user.env" | sed 's/^/      /' >> "$v4mValuesYAML"
  fi
  if [ -f "$USER_DIR/logging/user.env" ]; then
    echo '  "logging_user.env": |' >> "$v4mValuesYAML"
    cat "$USER_DIR/logging/user.env" | sed 's/^/      /' >> "$v4mValuesYAML"
  fi
  
  log_info "Updating version info..."
  helm upgrade --install \
    -n "$NS" \
    --values $v4mValuesYAML \
    v4m ./v4m-chart
}

function removeV4MInfo() {
  NS=$1
  if [ -z "$NS" ]; then
    log_error "No namespace specified for removing version info"
    return 1
  fi
  log_info "Removing version info..."
  helm uninstall -n "$NS" v4m
}

if [ -z "$V4M_VERSION_INCLUDE" ]; then
  origIFS=$IFS
  IFS=$'\n' v4mHelmVersionLines=($(helm list -n "$V4M_NS" --filter '^v4m$' -o yaml))
  IFS=$origIFS
  if [ -z "$v4mHelmVersionLines" ]; then
  log_debug "No v4m release found in [$V4M_NS]"
  else
    for (( i=0; i<${#v4mHelmVersionLines[@]}; i++ )); do 
      line=${v4mHelmVersionLines[$i]}
      vre='app_version: (([0-9]+).([[0-9]+)(.[0-9]+)?(-.+)?)'
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
