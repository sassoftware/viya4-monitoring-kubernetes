#! /bin/bash

# Copyright © 2021, 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#
# Deletes the following RBAC structures (NST=NAMESPACE|NAMESPACE_TENANT):
#
#                                    /--- [ROLE: v4m_kibana_user]      |only link to backend role is deleted; v4m_kibana_user role NOT deleted
# [BACKEND_ROLE: {NST}_kibana_users]<                                  |{NST}_kibana_user backend-role IS deleted
#                                    \--- [ROLE: search_index_{NST}]   |search_index_{NST} role IS deleted
#                                     \-- [ROLE: tenant_{NST}]         |tenant_{NST} role IS deleted
#
#
#
#                                       /--- [ROLE: v4m_grafana_dsuser] |only link to backend role is deleted; v4m_grafana_dsuser role NOT deleted
# [BACKEND_ROLE: {NST}_grfana_dsusers]<-
#                                       \--- [ROLE: search_index_{NST}] |search_index_{NST} role IS deleted
#
#
# NOTE: When NAMESPACE='_all_' and TENANT='_all_' are specified, the artifacts involved are:
#       backend role: 'V4MCLUSTER_ADMIN_kibana_users'  roles: 'tenant_cluster_admins' and 'search_index_-ALL-'
#

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

source logging/bin/rbac-include.sh
source logging/bin/apiaccess-include.sh

namespace=${1}
tenant=${2}

if [ -z "$namespace" ]; then
  log_error "Required argument NAMESPACE not specified"
  log_message  ""
  log_message  "Usage: $this_script NAMESPACE"
  log_message  ""
  log_message  "Deletes access control artifacts (e.g. roles, role-mappings, etc.) previously created to limit access to the specified namespace."
  log_message  ""
  log_message  "        NAMESPACE - (Required) The SAS Viya deployment/Kubernetes Namespace for which access controls should be deleted"
  log_message  "        TENANT    - (Optional) The tenant with the SAS Viya deployment/Kubernetes Namespace for which access controls should be created"
  log_message  ""

  exit 1
fi

# Convert namespace and tenant to all lower-case
namespace=$(echo "$namespace"| tr '[:upper:]' '[:lower:]')
tenant=$(echo "$tenant"| tr '[:upper:]' '[:lower:]')

if [ "$namespace" == "_all_" ] && [ "$tenant" == "_all_" ]; then
   log_debug "Deleting of All cluster access RBACs requested"
   cluster="true"
else
   cluster="false"
fi

if [ "$cluster" == "true" ]; then

   # deleting cluster-wide RBACs
   ROLENAME="search_index_-ALL-"
   BACKENDROLE="V4MCLUSTER_ADMIN_kibana_users"
   GFDS_BACKENDROLE="V4MCLUSTER_ADMIN_grafana_dsusers"
   NST="cluster_admins"

else
   # deleting namespace or tenant limited RBACs
   validateNamespace "$namespace"

   if [ -n "$tenant" ]; then
      validateTenantID $tenant

      NST="${namespace}_${tenant}"

      log_notice "Deleting access controls for the [$tenant] tenant within the namespace [$namespace] [$(date)]"

   else
      NST="$namespace"
      log_notice "Deleting access controls for namespace [$namespace] [$(date)]"
   fi

   ROLENAME="search_index_$NST"
   BACKENDROLE="${NST}_kibana_users"
   GFDS_BACKENDROLE="${NST}_grafana_dsusers"

   log_debug "NAMESPACE: $namespace TENANT: $tenant ROLENAME: $ROLENAME BACKENDROLE: $BACKENDROLE GFDS_BACKENDROLE: $GFDS_BACKENDROLE"
fi

# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)

# Get Security API URL
get_sec_api_url

if [ -z "$sec_api_url" ]; then
   log_error "Unable to determine URL to access security API endpoint"
   exit 1
fi

# handle $ROLENAME
if role_exists $ROLENAME; then
   delete_rolemappings $ROLENAME
   delete_role $ROLENAME

   # handle tenant_$NST
   delete_rolemappings tenant_${NST}
   delete_role tenant_${NST}
else
  log_verbose "The role [$ROLENAME] does not exist; nothing to delete"
fi

# handle KIBANA_USER
remove_rolemapping kibana_user     $BACKENDROLE    # Needed for RBACs created prior to MT support (should be no-op for post MT RBACs)
remove_rolemapping v4m_kibana_user $BACKENDROLE

# handle Grafana Data Source user
remove_rolemapping v4m_grafana_dsuser $GFDS_BACKENDROLE

log_notice "Access controls deleted [$(date)]"
echo ""
if [ "$cluster" == "true" ]; then
   log_verbose "You may want to consider deleting users whose *only* role(s) were 'V4MCLUSTER_ADMIN_kibana_users' and/or 'search_index_-ALL-'"
elif [ -n "$tenant" ]; then
   log_notice "You should delete any users whose only purpose was to access log messages from the [$tenant] tenant within the [$namespace] namespace  "
else
   log_notice "You should delete any users whose only purpose was to access log messages from the [$namespace] namespace  "
fi

