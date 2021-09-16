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

   local file filename
   file=$1

   if [ -f "$file" ]; then
      # ODFE 1.7.0: successful request returns: {"success":true,"successCount":20}
      # ODFE 1.13.2: successful request returns: {"successCount":1,"success":true,"successResults":[...content details...]}
      response=$(curl -s -o /dev/null -w "%{http_code}" -XPOST "${kb_api_url}api/saved_objects/_import?overwrite=true" -H "security_tenant: $tenant"  -H "kbn-xsrf: true"   --form file=@$file --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )

      if [[ $response == 2* ]]; then
         log_info "Deployed content from file [$f] - Success!"
         return 0
      else
         log_warn "Error encountered while deploying content from file [$f]. [$response]"
         return 1
      fi
   fi
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
      import_file $f
      if [ "$?" != "0" ]; then
         rc=1
      fi
   done
   return $rc
}




if [ "$#" != "2" ]; then
   log_error "Invalid set of arguments"
   log_message  ""
   log_message  "Usage: $this_script [CONTENT_LOCATION] [TENANT]"
   log_message  ""
   log_message  "Loads content from the specified location into the specified Kibana tenant space."
   log_message  ""
   log_message  "     CONTENT_LOCATION  - (Required) The location, either a single file or a directory, containing content to be imported into Kibana. Note: content must be in form of .ndjson files."
   log_message  "     TENANT            - (Required) The Kibana tenant space to which the content should be imported.  Note: the tenant space must already exist."
   log_message  ""
   exit 1
fi


get_kb_api_url
if [ -z "$kb_api_url" ]; then
   log_error "Unable to determine Kibana URL"
   exit 1
fi


get_sec_api_url
if [ -z "$sec_api_url" ]; then
   log_error "Unable to determine URL to security API endpoint"
   exit 1
fi

if [ -z "$2" ]; then
   log_error "The required parameter [TENANT] was NOT specified; please specify a tenant"
   exit 1
else
   tenant=$2
fi

# get credentials
get_credentials_from_secret admin
rc=$?
if [ "$rc" != "0" ] ;then log_info "RC=$rc"; exit $rc;fi

if kibana_tenant_exits $tenant; then
   log_debug "Specified tenant exists"
else
   log_error "Specified tenant does not exist"
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
    import_content $1
    import_problems=$?
else
   log_error "The specified input directory [$1] does not exist or cannot be accessed."
   exit 1
fi


if [ "$import_problems" == "0" ]; then
 log_info "Imported content into tenant space [$tenant]."
else
 log_warn "There were one or more issues deploying the requested content to Kibana.  Review the messages above."
fi

