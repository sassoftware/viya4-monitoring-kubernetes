#! /bin/bash

# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo


#
# ROLE Functions
#

function create_role {
   # Creates role using provided role template
   #
   # Returns: 0 - Role created
   #          1 - Role NOT created

   local role role_template

   role=$1
   role_template=$2

   response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$sec_api_url/roles/$role"  -H 'Content-Type: application/json' -d @${role_template}  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

   if [[ $response == 2* ]]; then
      log_info "Security role [$role] created. [$response]"
      return  0
   else
      log_error "There was an issue creating the security role [$role]. [$response]"
      log_debug "template contents: /n $(cat $role_template)"
      return 1
   fi
}


function delete_role {
   # Delete SAS Viya deployment-restricted role
   #
   # Returns: 0 - Role deleted
   #          1 - Role was/could not be deleted

   local role response
   role=$1

   if role_exists $role; then
      response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "$sec_api_url/roles/$role"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
      if [[ $response != 2* ]]; then
         log_error "There was an issue deleting the security role [$role]. [$response]"
         return 1
      else
         log_info "Security role [$role] deleted. [$response]"
      fi
   else
      #role does not exist, nothing to do
      log_debug "Role [$role] does not exist; not able to delete it."
      return 1
   fi
}

function ensure_role_exists {
   # Ensures specified role exists; creating it if necessary
   #
   # Returns: 0 - Role exists or was created
   #          1 - Role does NOT exist and/or was NOT created

   local role role_template

   role=$1
   role_template=${2:-null}

   if  role_exists $role; then
      return 0
   else
      if [ -n "$role_template" ]; then
         rc=$()
         if create_role $role $role_template; then
            return 0
         else
            return 1
         fi
      else
         # couldn't create it b/c we didn't have a template
         log_debug "No role template provided; did not attempt to create role [$role]"
         return 1
      fi
  fi

}

function role_exists {
   #Check if $role role exists
   #
   # Returns: 0 - Role exists
   #          1 - Role does not exist

   local role response

   role=$1

   response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "$sec_api_url/roles/$role"   --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
   if [[ $response == 2* ]]; then
      log_debug "Confirmed [$role] exists."
      return 0
   else
      log_debug "Role [$role] does not exist."
      return 1
   fi
}


#
# ROLEMAPPING Functions
#

function add_rolemapping {
 # adds $berole to the  rolemappings for $targetrole

 local targetrole berole json verb response
 targetrole=$1
 berole=$2

 log_debug "Parms passed to add_rolemapping function  targetrole=$targetrole  berole=$berole"


 # get existing rolemappings for $targetrole
 response=$(curl -s -o $TMP_DIR/rolemapping.json -w "%{http_code}" -XGET "$sec_api_url/rolesmapping/$targetrole"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

 if [[ $response == 404 ]]; then
    log_debug "Rolemappings for [$targetrole] do not exist; creating rolemappings. [$response]"

    json='{"backend_roles" : ["'"$berole"'"]}'
    verb=PUT

 elif [[ $response == 2* ]]; then
    log_debug "Existing rolemappings for [$targetrole] obtained. [$response]"
    log_debug "$(cat $TMP_DIR/rolemapping.json)"


    if [ "$(grep $berole  $TMP_DIR/rolemapping.json)" ]; then
       log_debug "A rolemapping between [$targetrole] and  back-end role [$berole] already appears to exist; leaving as-is."
       return 0
    elif [ "$(grep '\"backend_roles\":\[\],' $TMP_DIR/rolemapping.json)" ]; then
       log_debug "The role [$targetrole] has no existing rolemappings"
       json='[{"op": "add","path": "/backend_roles","value":["'"$berole"'"]}]'
       verb=PATCH
    else
       json='[{"op": "add","path": "/backend_roles/-","value":"'"$berole"'"}]'
       verb=PATCH
    fi

 else
     log_error "There was an issue getting the existing rolemappings for [$targetrole]. [$response]"
     return 1
 fi

 log_debug "JSON data passed to curl [$verb]: $json"

 response=$(curl -s -o /dev/null -w "%{http_code}" -X${verb} "$sec_api_url/rolesmapping/$targetrole"  -H 'Content-Type: application/json' -d "$json" --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
 if [[ $response != 2* ]]; then
    log_error "There was an issue creating the rolemapping between [$targetrole] and backend-role(s) ["$berole"]. [$response]"
    return 1
 else
    log_info "Security rolemapping created between [$targetrole] and backend-role(s) ["$berole"]. [$response]"
    return 0
 fi

}


function delete_rolemappings {
   # Delete ALL role-mappings for specified role
   #
   # Returns: 0 - Rolemappings deleted
   #          1 - Rolemappings were/could not be deleted

   local role response
   role=$1

   if role_exists $role; then
      response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "$sec_api_url/rolesmapping/$role"   --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
      if [[ $response == 404 ]]; then
         log_info "Rolemappings for [$role] do not exist; nothing to delete. [$response]"
         return 0
      elif [[ $response != 2* ]]; then
         log_error "There was an issue deleting the rolemappings for [$role]. [$response]"
         return 1
      else
         log_info "Security rolemappings for [$role] deleted. [$response]"
         return 0
      fi
   else
      #role does not exist, nothing to do
      log_debug "Role [$role] does not exist; no rolemappings to delete."
      return 1
   fi
}


function remove_rolemapping {
   # removes $berole2remove from the rolemappings
   # for $targetrole (if $targetrole exists)

   #
   # Returns: 0 - The rolemappings removed
   #          1 - The rolemappings were/could not be removed

 local targetrole regex json beroles newroles response berole2remove
 targetrole=$1
 berole2remove=$2
 log_debug "remove_rolemapping targetrole:$targetrole berole2remove:$berole2remove"

 if role_exists $targetrole; then

    # get existing rolemappings for $targetrole
    response=$(curl -s -o $TMP_DIR/rolemapping.json -w "%{http_code}" -XGET "$sec_api_url/rolesmapping/$targetrole"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

    if [[ $response == 404 ]]; then
       log_debug "Rolemappings for [$targetrole] do not exist; nothing to do. [$response]"
       return 0
    elif [[ $response != 2* ]]; then
       log_error "There was an issue getting the existing rolemappings for [$targetrole]. [$response]"
       return 1
    else
       log_debug "Existing rolemappings for [$targetrole] obtained. [$response]"
       log_debug "$(cat $TMP_DIR/rolemapping.json)"

       regex='"backend_roles":\[((("[_0-9a-zA-Z\-]+",?)?)+)\]'
       json=$(cat  $TMP_DIR/rolemapping.json)

       if [[ $json =~ $regex ]]; then

          be_roles="[${BASH_REMATCH[1]}]"

          if [ -z "$be_roles" ]; then
             log_debug "No backend roles to patch for [$targetrole]; moving on"
             return 0
          else

             # ODFE 1.7  {"kibana_user":{"reserved":false,"hidden":false,"backend_roles":["kibanauser","d27885_kibana_users","acme_d27885_kibana_user"],"hosts":[],"users":[],"and_backend_roles":[],"description":"Maps kibanauser to kibana_user"}}
             # ODFE 1.13 {"kibana_user":{"hosts":[],"users":[],"reserved":false,"hidden":false,"backend_roles":["kibanauser","d27886_kibana_users","d35396_kibana_users","d35396_acme_kibana_users","d35396A_kibana_users","d35396A_acme_kibana_users"],"and_backend_roles":[]}}

             # Extract and reconstruct backend_roles array from rolemapping json
             newroles=$(echo $be_roles | sed "s/\"$berole2remove\"//g;s/,,,/,/g;s/,,/,/g; s/,]/]/g;s/\[,/\[/g")
             if [ "$be_roles" == "$newroles" ]; then
                log_debug "The backend role [$berole2remove] is not mapped to [$targetrole]; moving on."
                return 0
             else

                log_debug "Updated Back-end Role ($targetrole): $newroles"

                # Copy RBAC template
                cp logging/opensearch/rbac/backend_rolemapping_delete.json $TMP_DIR/${targetrole}_backend_rolemapping_delete.json

                #update json template file w/revised list of backend roles
                sed -i'.bak' "s/xxBACKENDROLESxx/$newroles/g"     $TMP_DIR/${targetrole}_backend_rolemapping_delete.json # BACKENDROLES

                # Replace the rolemappings for the $targetrole with the revised list of backend roles
                response=$(curl -s -o /dev/null -w "%{http_code}" -XPATCH "$sec_api_url/rolesmapping/$targetrole"  -H 'Content-Type: application/json' -d @$TMP_DIR/${targetrole}_backend_rolemapping_delete.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
                if [[ $response != 2* ]]; then
                   log_error "There was an issue updating the rolesmapping for [$targetrole] to remove link with backend-role [$berole2remove]. [$response]"
                   return 1
                else
                   log_info "Security rolemapping deleted between [$targetrole] and backend-role [$berole2remove]. [$response]"
                   return 0
                fi
             fi
          fi
       fi
    fi
 else
    log_debug "The role [$targetrole] does not exist; doing nothing. [$response]"
 fi
}


#
# TENANT Functions
#

function create_kibana_tenant {
   # Creates a Kibana tenant
   #
   # Returns: 0 - Kibana tenant created
   #          1 - Kibana tenant NOT created

   local tenant description response

   tenant=$1
   description=$2

   response=$(curl -s -o /dev/null -w "%{http_code}" -XPUT "$sec_api_url/tenants/$tenant"  -H 'Content-Type: application/json' -d '{"description":"'"$description"'"}'  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

   if [[ $response == 2* ]]; then
      log_info "OpenSearch Dashboards tenant space [$tenant] created. [$response]"
      return  0
   else
      log_error "There was an issue creating the OpenSearch Dashboards tenant space [$tenant]. [$response]"
      return 1
   fi
}

function delete_kibana_tenant {
   # Deletes a Kibana tenant
   #
   # Returns: 0 - Kibana tenant deleted
   #          1 - Kibana tenant NOT deleted

   local tenant response

   tenant=$1

   response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "$sec_api_url/tenants/$tenant"   --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

   if [[ $response == 2* ]]; then
      log_info "OpenSearch Dashboards tenant space [$tenant] deleted. [$response]"
      return  0
   else
      log_error "There was an issue deleting the OpenSearch Dashboards tenant space [$tenant]. [$response]"
      return 1
   fi
}

function kibana_tenant_exists {
   # Check if $tenant exists
   #
   # Returns: 0 - Tenant exists
   #          1 - Tenant does not exist

   local tenant response
   tenant=$1

   response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "${sec_api_url}/tenants/$tenant" --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )

   if [[ $response == 2* ]]; then
      log_debug "Confirmed OpenSearch Dashboards tenant [$tenant] exists. [$response]"
      return 0
   else
      log_debug "OpenSearch Dashboards tenant [$tenant] does not exist. [$response]"
      return 1
   fi
}

#
# USER Functions
#

function user_exists {
   # Check if $user exists
   #
   # Returns: 0 - User exists
   #          1 - User does not exist

   local username response
   username=$1

   response=$(curl -s -o /dev/null -w "%{http_code}" -XGET "${sec_api_url}/internalusers/$username" --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )

   if [[ $response == 2* ]]; then
      log_debug "Confirmed OpenSearch user [$username] exists. [$response]"
      return 0
   else
      log_debug "OpenSearch user [$username] does not exist. [$response]"
      return 1
   fi
}

function delete_user {
   # Deletes $user from internal user 
   #
   # Returns: 0 - User deleted
   #          1 - User NOT deleted

   local username response
   username=$1

   if user_exists $username; then
      response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "${sec_api_url}/internalusers/$username" --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure )

      if [[ $response == 2* ]]; then
         log_debug "User [$username] deleted. [$response]"
         return 0
      else
         log_error "There was an issue deleting the user role [$username]. [$response]"
         return 1
      fi
   else
      #username does not exist, nothing to do
      log_debug "User [$userename] does not exist; not able to delete it."
      return 1
   fi
}
