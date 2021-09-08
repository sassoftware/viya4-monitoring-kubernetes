#! /bin/bash

# Copyright © 2021, 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#
# Deletes the following RBAC structures (NST=NAMESPACE|NAMESPACE_TENANT):
#
#                                    /-- [ROLE: kibana_user]           |only link to backend role is deleted; kibana_user role NOT deleted
# [BACKEND_ROLE: {NST}_kibana_user]<-                                  |{NST}_kibana_user backend-role IS deleted
#                                    \-- [ROLE: search_index_{NST}]    |search_index_{NST} role IS deleted
#
#
# READONLY ROLE
#
#                                         /- [ROLE: cluster_ro_perms]  |only link to backend role is deleted; cluster_ro_perms role NOT deleted
#                                        /-- [ROLE: kibana_read_only]  |only link to backend role is deleted; kibana_read_only role NOT deleted
#                                       /--- [ROLE: kibana_user]       |only link to backend role is deleted; kibana_user role NOT deleted
# [BACKEND_ROLE: {NST}_kibana_ro_user]<-                               |{NST}_kibana_ro_user backend-role IS deleted
#                                       \--- [ROLE: search_index_{NST}]|search_index_{NST} role IS deleted
#

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh
this_script=`basename "$0"`

source logging/bin/rbac-include.sh
source logging/bin/apiaccess-include.sh

NAMESPACE=${1}
TENANT=${2}

if [ -z "$NAMESPACE" ]; then
  log_error "Required argument NAMESPACE not specified"
  log_info  ""
  log_info  "Usage: $this_script NAMESPACE"
  log_info  ""
  log_info  "Deletes access control artifacts (e.g. roles, role-mappings, etc.) previously created to limit access to the specified namespace."
  log_info  ""
  log_info  "        NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace for which access controls should be deleted"
  log_info  "        TENANT    - (Optional) The tenant with the Viya deployment/Kubernetes Namespace for which access controls should be created"
  log_info  ""

  exit 4
else
  log_notice "Deleting access controls for namespace [$NAMESPACE] [$(date)]"
fi

if [ -n "$TENANT" ]; then
   NST="${NAMESPACE}_${TENANT}"
else
   NST="$NAMESPACE"
fi



ROLENAME=search_index_$NST
BACKENDROLE=${NST}_kibana_users
BACKENDROROLE=${NST}_kibana_ro_users

log_debug "NAMESPACE: $NAMESPACE TENANT: $TENANT ROLENAME: $ROLENAME BACKENDROLE: $BACKENDROLE"


# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)

#temp file to hold responses
tmpfile=$TMP_DIR/output.txt

# Get Security API URL
get_sec_api_url

if [ -z "$sec_api_url" ]; then
   log_error "Unable to determine URL to access security API endpoint"
   exit 1
fi

# handle $ROLENAME
delete_rolemappings $ROLENAME
delete_role $ROLENAME

# handle KIBANA_USER
remove_rolemapping kibana_user

# handle KIBANA_READ_ONLY
remove_rolemapping kibana_read_only

# handle CLUSTER_RO_PERMS
remove_rolemapping cluster_ro_perms


#remove tmpfile
rm -f $tmpfile


log_notice "Access controls deleted [$(date)]"
echo ""
if [ -n "$TENANT" ]; then
   log_notice "You should delete any users whose only purpose was to access log messages from the [$TENANT] tenant within the [$NAMESPACE] namespace  "
else
   log_notice "You should delete any users whose only purpose was to access log messages from the [$NAMESPACE] namespace  "
fi

