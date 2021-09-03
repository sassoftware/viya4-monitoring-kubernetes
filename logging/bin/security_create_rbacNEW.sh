#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#
# Creates the following RBAC structures (NST=NAMESPACE|NAMESPACE_TENANT):
#
#
#                                    /-- [ROLE: kibana_user]       (allows access to Kibana)
# [BACKEND_ROLE: {NST}_kibana_user]<-
#                                    \-- [ROLE: search_index_{NST}] (allows access to log messages from {NST})
#
#
#
# READONLY ROLE
#
#                                         /- [ROLE: cluster_ro_perms]  (limits access to cluster to read-only)
#                                        /-- [ROLE: kibana_read_only]  (limits Kibana access to read-only)
#                                       /--- [ROLE: kibana_user]       (allows access to Kibana)
# [BACKEND_ROLE: {NST}_kibana_ro_user]<-
#                                       \--- [ROLE: search_index_{NST}] (allows access to log messages from {NST})
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

NAMESPACE=${1}
TENANT=${2}
READONLY=${3:-false}

if [ "$TENANT" == "--add_read_only" ]; then
   READONLY="--add_read_only"
   TENANT=""
fi

if [ "$READONLY" == "--add_read_only" ]; then
 READONLY="true"
 READONLY_FLAG="_ro"
elif [[ "$READONLY" =~ -H|--HELP|-h|--help ]]; then
 show_usage
 exit
elif [ "$READONLY" != "false" ]; then
 log_error "Unrecognized additional option(s) [$READONLY] provided."
 show_usage
 exit 2
fi

if [ -z "$NAMESPACE" ]; then
  log_error "Required argument NAMESPACE no specified"
  echo  ""
  show_usage
  exit 4
elif [[ "$NAMESPACE" =~ -H|--HELP|-h|--help ]]; then
 show_usage
 exit
fi

if [[ "$TENANT" =~ -H|--HELP|-h|--help ]]; then
   show_usage
   exit
elif [ -n "$TENANT" ]; then
   NST="${NAMESPACE}_${TENANT}"
else
   NST="$NAMESPACE"
fi

if [ -n "$TENANT" ]; then
  log_notice "Creating access controls for tenant [$TENANT] within namespace [$NAMESPACE] [$(date)]"
else
  log_notice "Creating access controls for namespace [$NAMESPACE] [$(date)]"
fi


INDEX_PREFIX=viya_logs
ROLENAME=search_index_$NST
BE_ROLENAME=${NST}_kibana_users
if [ "$READONLY" == "true" ]; then
   RO_BE_ROLENAME=${NST}_kibana_ro_users
else
   RO_BE_ROLENAME="null"
fi

log_debug "NST: $NST TENANT: $TENANT NAMESPACE: $NAMESPACE ROLENAME: $ROLENAME RO_BE_ROLENAME: $RO_BE_ROLENAME "


# Copy RBAC templates
cp logging/es/odfe/rbac $TMP_DIR -r

# Replace PLACEHOLDERS
sed -i'.bak' "s/xxIDXPREFIXxx/$INDEX_PREFIX/g"  $TMP_DIR/rbac/*.json                  # IDXPREFIX
sed -i'.bak' "s/xxNAMESPACExx/$NST/g"     $TMP_DIR/rbac/*.json                  # NAMESPACE


# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)


#temp file to hold responses
tmpfile=$TMP_DIR/output.txt


sec_api_url=""
get_sec_api_url

if [ -z "$sec_api_url" ]; then
   log_error "Unable to determine URL to access security API endpoint"
   exit 1
fi


#index user
ensure_role_exists $ROLENAME $TMP_DIR/rbac/index_role.json
add_rolemapping $ROLENAME $BE_ROLENAME

#kibana_user
add_rolemapping kibana_user $BE_ROLENAME null

# Create restricted READ_ONLY Kibana role as well
if [ "$READONLY" == "true" ]; then

   #index user
   add_rolemapping $ROLENAME $RO_BE_ROLENAME

   #kibana_user
   add_rolemapping kibana_user $RO_BE_ROLENAME

   #cluster_ro_perms
   ensure_role_exists cluster_ro_perms $TMP_DIR/rbac/cluster_ro_perms_role.json
   add_rolemapping cluster_ro_perms $RO_BE_ROLENAME

   #kibana_read_only
   add_rolemapping kibana_read_only $RO_BE_ROLENAME
fi

# terminate port-forwarding and remove tmpfile
if [ -n "$pfPID" ]; then
   log_info "You may see a message below about a process being killed; it is expected and can be ignored."
   kill  -9 $pfPID
fi
rm -f $tmpfile

#pause to allow port-forward kill message to appear
sleep 7s

log_notice "Access controls created [$(date)]"
echo ""

log_notice    "================================================================================="
log_notice    "   Assign users the back-end role of  [${BE_ROLENAME}] to                        "
log_notice    "   grant them access to Kibana and limit their access to log messages            "
if [ -n "$TENANT" ]; then
   log_notice "   from the [$TENANT] tenant within the [$NAMESPACE] namespace          "
else
   log_notice "   from the [$NAMESPACE] namespace.                               "
fi
if [ "$READONLY" == "true" ]; then
   log_notice "                                                                                 "
   log_notice "   Assign users the back-end role of  [${RO_BE_ROLENAME}] to                     "
   log_notice "   grant them READ-ONLY access to Kibana and limit their access to log messages  "
   if [ -n "$TENANT" ]; then
      log_notice "   from the [$TENANT] tenant within the [$NAMESPACE] namespace       "
   else
      log_notice "   from the [$NAMESPACE] namespace.                            "
   fi
fi
log_notice    "================================================================================="
