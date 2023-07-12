# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

if [ "$SAS_LOGGING_COMMON_SOURCED" = "" ]; then
    source bin/common.sh

    if [ -f "$USER_DIR/logging/user.env" ]; then
        userEnv=$(grep -v '^[[:blank:]]*$' $USER_DIR/logging/user.env | grep -v '^#' | xargs)
        log_verbose "Loading user environment file: $USER_DIR/logging/user.env"
        if [ "$userEnv" ]; then
          export $userEnv
        fi
    fi


    function require_opensearch {
       if [ "$LOG_SEARCH_BACKEND" != "OPENSEARCH" ]; then
          log_error "This script is only appropriate for use with OpenSearch as the search back-end."
          log_error "The LOG_SEARCH_BACKEND environment variable is currently set to [$LOG_SEARCH_BACKEND]"
          exit 1
       fi
    }
    export -f require_opensearch

    export LOG_NS="${LOG_NS:-logging}"

    #if TLS (w/in cluster; for all monitoring components) is requested, require TLS into OSD pod, too
    export TLS_ENABLE="${TLS_ENABLE:-true}"
    log_debug "logging/common.sh (incoming): TLS_ENABLE=$TLS_ENABLE"

    export OSD_TLS_ENABLE=${TLS_ENABLE:-true}
    # TLS is required for logging components so hard-code to 'true'
    export TLS_ENABLE="true"

    # OpenSearch or OpenDistro for Elasticsearch
    export LOG_SEARCH_BACKEND="${LOG_SEARCH_BACKEND:-OPENSEARCH}"
    log_debug "Search Backend set to [$LOG_SEARCH_BACKEND]"

    if [ "$LOG_SEARCH_BACKEND" == "OPENSEARCH" ]; then
       export ES_SERVICENAME="v4m-search"
       export ES_INGRESSNAME="v4m-search"

       export KB_SERVICENAME="v4m-osd"
       export KB_INGRESSNAME="v4m-osd"
       export KB_SERVICEPORT="http"

       export ES_PLUGINS_DIR="_plugins"
       export LOG_XSRF_HEADER="osd-xsrf:true"
    else
       export ES_SERVICENAME="v4m-es-client-service"
       export ES_INGRESSNAME="v4m-es-client-service"

       export KB_SERVICENAME="v4m-es-kibana-svc"
       export KB_INGRESSNAME="v4m-es-kibana-ing"
       export KB_SERVICEPORT="kibana-svc"


       export ES_PLUGINS_DIR="_opendistro"
       export LOG_XSRF_HEADER="kbn-xsrf: true"
    fi

    export V4M_NS=$LOG_NS
    source bin/version-include.sh

    export SAS_LOGGING_COMMON_SOURCED=true

    #Environment vars related to upgrading ODFE 1.7.0 to ODFE 1.13.x
    export KB_GLOBAL_EXPORT_FILE=${KB_GLOBAL_EXPORT_FILE:-"$TMP_DIR/kibana_global_content.ndjson"}
fi
echo ""

