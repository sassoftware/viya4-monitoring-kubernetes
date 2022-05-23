#!/bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

source logging/bin/secrets-include.sh
source logging/bin/apiaccess-include.sh
source logging/bin/rbac-include.sh


function import_file {
   # Loads a .ndjson file into Kibana
   #
   # Returns: 0 - Content loaded successfully
   #          1 - Content was not loaded successfully

   local file filename response
   file=$1

   if [ -f "$file" ]; then
      # ODFE 1.7.0: successful request returns: {"success":true,"successCount":20}
      # ODFE 1.13.x: successful request returns: {"successCount":1,"success":true,"successResults":[...content details...]}
      response=$(curl -s -o $TMP_DIR/curl.response -w "%{http_code}" -XPOST "${kb_api_url}/api/saved_objects/_import?overwrite=true" -H "securitytenant: $tenant"  -H "$LOG_XSRF_HEADER"   --form file=@$file --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )

      if [[ $response == 2* ]]; then
         if grep -q '"success":true' $TMP_DIR/curl.response ; then
            log_verbose "Deployed content from file [$file] - Success! [$response]"
         else
            log_warn "Unable to deploy content from file [$file]. [$response]"
            log_verbose "  Response received was: $(cat $TMP_DIR/curl.response)"
            #log_message "" # null line since response file may not contain LF
         fi
         return 0
      else
         log_warn "Error encountered while deploying content from file [$file]. [$response]"
         return 1
      fi
   fi
}

function import_content_batch {
   # Loads content from a directory in a single API call
   #
   # Returns: 0 - No load issues
   #          1 - At least one load issue encountered

   local dir rc f tmpfile item_count
   dir=$1

   tmpfile=$TMP_DIR/batched.ndjson
   touch $tmpfile

   rc=0
   item_count=0
   for f in $dir/*.ndjson; do
      if [ -f "$f" ]; then
         log_debug "Adding $f to $tmpfile"
         cat $f >>$tmpfile
         echo " " >> $tmpfile
         ((item_count++))
      fi
   done

   if [[ "$item_count" -gt 0 ]]; then
      log_debug "$item_count items packed into $tmpfile for loading"
      import_file $tmpfile
   else
      log_debug "No content found in [$dir] to be loaded"
   fi
   return $?
}
function import_content {
   # Loads content from a directory
   #
   # Returns: 0 - No load issues
   #          1 - At least one load issue encountered

   local dir rc f
   dir=$1

   rc=0
   for f in $dir/*.ndjson; do
      if [ -f "$f" ]; then
         import_file $f
         if [ "$?" != "0" ]; then
            rc=1
         fi
      fi
   done
   return $rc
}


#
# Process input parms and args
#

if [ "$#" != "2" ]; then
   log_error "Invalid set of arguments"
   log_message  ""
   log_message  "Usage: $this_script [CONTENT_LOCATION] [TENANT_SPACE]"
   log_message  ""
   log_message  "Loads content from the specified location into the specified Kibana tenant space."
   log_message  ""
   log_message  "     CONTENT_LOCATION  - (Required) The location, either a single file or a directory, containing content to be imported into Kibana. Note: content must be in form of .ndjson files."
   log_message  "     TENANT_SPACE      - (Required) The Kibana tenant space to which the content should be imported.  Note: the tenant space must already exist."
   log_message  ""
   exit 1
fi

#Flag to suppress file/directory not found error
ignore_not_found="${IGNORE_NOT_FOUND:-false}"

#Flag to force loading of directory files individually
batch_kibana_content="${BATCH_KIBANA_CONTENT:-true}"

get_kb_api_url
if [ -z "$kb_api_url" ]; then
   log_error "Unable to determine Kibana URL"
   exit 1
else
   log_debug "Kibana URL: $kb_api_url"
fi


get_sec_api_url
if [ -z "$sec_api_url" ]; then
   log_error "Unable to determine URL to security API endpoint"
   exit 1
fi

if [ -z "$2" ]; then
   log_error "The required parameter [TENANT_SPACE] was NOT specified; please specify a Kibana tenant space."
   exit 1
else
   tenant=$2
fi

# Convert tenant to all lower-case
tenant=$(echo "$tenant"| tr '[:upper:]' '[:lower:]')

# get credentials
get_credentials_from_secret admin
rc=$?
if [ "$rc" != "0" ] ;then log_info "RC=$rc"; exit $rc;fi

if kibana_tenant_exists $tenant; then
   log_debug "Confirmed Kibana tenant space [$tenant] exists"
elif [ "$tenant" == "global" ];then
   log_debug "Kibana tenant space [global] specified."
else
   log_error "Specified Kibana tenant space [$tenant] does not exist. Target Kibana tenant space must exist."
   exit 1
fi


# Deploy either the specified .ndjson file or all .ndjson files in the specified directory
if [ -f "$1" ]; then
   if [[ $1 =~ .+\.ndjson ]]; then
      # Deploy single content file
      f=$1
      log_info "Importing Kibana content from file [$f] to Kibana tenant space [$tenant]..."

      import_file $f
      import_problems=$?
   else
      log_error "The specified content file [$1] is not a .ndjson file."
      exit 1
   fi
elif [ -d "$1" ]; then

    # Deploy specified directory of Kibana content
    log_info "Importing Kibana content in [$1] to Kibana tenant space [$tenant]..."
    if [ "$batch_kibana_content" != "true" ]; then
       log_debug "'BATCH_KIBANA_CONTENT' flag set to 'false'; loading files individually from directory"
       import_content $1
    else
       import_content_batch $1
    fi

    import_problems=$?

elif [ "$ignore_not_found" == "true" ]; then
   log_debug "The specified file/directory to import [$1] does not exist or cannot be accessed but --ignore-not-found flag has been set."
   exit 0
else
   log_error "The specified file/directory to import [$1] does not exist or cannot be accessed."
   exit 1
fi


if [ "$import_problems" == "0" ]; then
 log_info "Imported content into Kibana tenant space [$tenant]."
else
 log_warn "There were one or more issues deploying the requested content to Kibana.  Review the messages above."
fi

