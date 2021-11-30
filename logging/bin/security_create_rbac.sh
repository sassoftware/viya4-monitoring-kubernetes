#! /bin/bash

# Copyright © 2021, 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#
# Creates the following RBAC structures (NST=NAMESPACE|NAMESPACE_TENANT):
#
#
#                                    /--- [ROLE: v4m_kibana_user]    (allows access to Kibana)
# [BACKEND_ROLE: {NST}_kibana_user]<-
#                                    \--- [ROLE: search_index_{NST}] (allows access to log messages from {NST})
#                                     \-- [ROLE: tenant_{NST}]       (allows access to Kibana tenant space for {NST})
#
#
#

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

source logging/bin/rbac-include.sh
source logging/bin/apiaccess-include.sh


function show_usage {
  log_message  "Usage: $this_script NAMESPACE [TENANT]"
  log_message  ""
  log_message  "Creates access controls (e.g. roles, role-mappings, etc.) to limit access to the specified namespace and, optionally, the specified tenant within that namespace."
  log_message  ""
  log_message  "        NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace for which access controls should be created"
  log_message  ""
  log_message  "        TENANT    - (Optional) The tenant with the Viya deployment/Kubernetes Namespace for which access controls should be created"
  log_message  ""
}

#TO DO: Move to named args

namespace=${1}
tenant=${2}

# Convert namespace and tenant to all lower-case
namespace=$(echo "$namespace"| tr '[:upper:]' '[:lower:]')
tenant=$(echo "$tenant"| tr '[:upper:]' '[:lower:]')


create_ktenant_roles=${CREATE_KTENANT_ROLE:-true}


if [ -z "$namespace" ]; then
  log_error "Required argument NAMESPACE no specified"
  echo  ""
  show_usage
  exit 1
elif [[ "$namespace" =~ -H|--HELP|-h|--help ]]; then
 show_usage
 exit
fi

validateNamespace "$namespace"

if [[ "$tenant" =~ -H|--HELP|-h|--help ]]; then
   show_usage
   exit
elif [ -n "$tenant" ]; then

   validateTenantID $tenant

   NST="${namespace}_${tenant}"
   INDEX_NST="${namespace}-__${tenant}__"
else
   NST="$namespace"
   INDEX_NST="${namespace}"
fi

if [ -n "$tenant" ]; then
  log_notice "Creating access controls for tenant [$tenant] within namespace [$namespace] [$(date)]"
else
  log_notice "Creating access controls for namespace [$namespace] [$(date)]"
fi


INDEX_PREFIX=viya_logs
ROLENAME=search_index_$NST
BE_ROLENAME=${NST}_kibana_users

log_debug "NST: $NST TENANT: $tenant NAMESPACE: $namespace ROLENAME: $ROLENAME"


# Copy RBAC templates
cp logging/es/odfe/rbac $TMP_DIR -r

# Replace PLACEHOLDERS
sed -i'.bak' "s/xxIDXPREFIXxx/$INDEX_PREFIX/g"  $TMP_DIR/rbac/*.json     # IDXPREFIX
sed -i'.bak' "s/xxNAMESPACExx/$namespace/g"     $TMP_DIR/rbac/*.json     # NAMESPACE
sed -i'.bak' "s/xxTENANTxx/$tenant/g"           $TMP_DIR/rbac/*.json     # TENANT
sed -i'.bak' "s/xxIDXNSTxx/$INDEX_NST/g"        $TMP_DIR/rbac/*.json     # NAMESPACE|NAMESPACE-__TENANT__    (used in index names)
sed -i'.bak' "s/xxNSTxx/$NST/g"                 $TMP_DIR/rbac/*.json     # NAMESPACE|NAMESPACE_TENANT        (used in RBAC names)



# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)


# Get Security API URL
get_sec_api_url

if [ -z "$sec_api_url" ]; then
   log_error "Unable to determine URL to access security API endpoint"
   exit 1
fi


#index user (controls access to indexes)
ensure_role_exists $ROLENAME $TMP_DIR/rbac/index_role.json
add_rolemapping $ROLENAME $BE_ROLENAME

#tenant role (controls access to Kibanas tenant spaces)
if [ "$create_ktenant_roles" == "true" ]; then

   ensure_role_exists tenant_${NST} $TMP_DIR/rbac/kibana_tenant_limited_role.json
   add_rolemapping  tenant_${NST} $BE_ROLENAME

fi

#kibana_user
ensure_role_exists v4m_kibana_user $TMP_DIR/rbac/v4m_kibana_user_role.json
add_rolemapping v4m_kibana_user $BE_ROLENAME null

log_notice "Access controls created [$(date)]"
echo ""

add_notice    "   Assign users the back-end role of  [${BE_ROLENAME}] to                        "
add_notice    "   grant them access to Kibana and limit their access to log messages            "
if [ -n "$tenant" ]; then
   add_notice "   from the [$tenant] tenant within the [$namespace] namespace          "
else
   add_notice "   from the [$namespace] namespace.                               "
fi

LOGGING_DRIVER=${LOGGING_DRIVER:-false}
if [ "$LOGGING_DRIVER" != "true" ]; then
   echo ""
   log_notice    "================================================================================="
   display_notices
   log_notice    "================================================================================="
   echo ""
fi


