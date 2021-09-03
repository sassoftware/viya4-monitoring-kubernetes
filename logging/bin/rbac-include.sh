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
      log_info "Security role [$role] created [$response]"
      return  0
   else
      log_error "There was an issue creating the security role [$role] [$response]"
      log_debug "template contents: /n $(cat $role_template)"
      return 1
   fi
}


function delete_role {
   # Delete Viya deployment-restricted role
   #
   # Returns: 0 - Role deleted
   #          1 - Role was/could not be deleted

   local role
   role=$1

   if role_exists $role; then
      response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "$sec_api_url/roles/$role"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
      if [[ $response != 2* ]]; then
         log_error "There was an issue deleting the security role [$ROLENAME] [$response]"
         return 1
      else
         log_info "Security role [$ROLENAME] deleted. [$response]"
      fi
   else
      #role does not exist, nothing to do
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

   local role

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

 local targetrole berole
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

   local role
   role=$1

   if role_exists $role; then
      response=$(curl -s -o /dev/null -w "%{http_code}" -XDELETE "$sec_api_url/rolesmapping/$role"   --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
      if [[ $response != 2* ]]; then
         log_error "There was an issue deleting the rolemappings for [$role] [$response]"
         return 1
      else
         log_info "Security rolemappings for [$role] deleted. [$response]"
         return 0
      fi
   else
      #role does not exist, nothing to do
      return 1
   fi
}


function remove_rolemapping {
   # removes $BACKENDROLE and $BACKENDROROLE from the
   # rolemappings for $targetrole (if $targetrole exists)

   #
   # Returns: 0 - The rolemappings removed
   #          1 - The rolemappings were/could not be removed

 local targetrole
 targetrole=$1


 if role_exists $targetrole; then

    # get existing rolemappings for $targetrole
    response=$(curl -s -o $TMP_DIR/rolemapping.json -w "%{http_code}" -XGET "$sec_api_url/rolesmapping/$targetrole"  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)

    if [[ $response == 404 ]]; then
       log_debug "Rolemappings for [$targetrole] do not exist; nothing to do. [$response]"
    elif [[ $response != 2* ]]; then
       log_error "There was an issue getting the existing rolemappings for [$targetrole]. [$response]"
       return 1
    else
       log_debug "Existing rolemappings for [$targetrole] obtained. [$response]"
       log_debug "$(cat $TMP_DIR/rolemapping.json)"

       if [ "$(grep '"backend_roles":\[\]' $TMP_DIR/rolemapping.json)" ]; then
          log_debug "No backend roles to patch for [$targetrole]; moving on"
       else
          # Extract and reconstruct backend_roles array from rolemapping json
          newroles=$(grep -oE '"backend_roles":\[(.*)\],"h' $TMP_DIR/rolemapping.json | grep -oE '\[.*\]' | sed "s/\"$BACKENDROLE\"//g;s/\"$BACKENDROROLE\"//g;s/,,,/,/g;s/,,/,/g; s/,]/]/" )
          log_debug "Updated Back-end Roles ($targetrole): $newroles"

          # Copy RBAC template
          cp logging/es/odfe/rbac/backend_rolemapping_delete.json $TMP_DIR/${targetrole}_backend_rolemapping_delete.json

          #update json template file w/revised list of backend roles
          sed -i'.bak' "s/xxBACKENDROLESxx/$newroles/g"     $TMP_DIR/${targetrole}_backend_rolemapping_delete.json # BACKENDROLES

          # Replace the rolemappings for the $targetrole with the revised list of backend roles
          response=$(curl -s -o /dev/null -w "%{http_code}" -XPATCH "$sec_api_url/rolesmapping/$targetrole"  -H 'Content-Type: application/json' -d @$TMP_DIR/${targetrole}_backend_rolemapping_delete.json  --user $ES_ADMIN_USER:$ES_ADMIN_PASSWD --insecure)
          if [[ $response != 2* ]]; then
             log_error "There was an issue updating the rolesmapping for [$targetrole] to remove link with backend-roles [$BACKENDROLE, $BACKENDROROLE]. [$response]"
             return 1
          else
             log_info "Security rolemapping deleted between [$targetrole] and backend-roles [$BACKENDROLE, $BACKENDROROLE]. [$response]"
          fi
       fi
    fi
 else
   log_debug "The role [$targetrole] does not exist; doing nothing. [$response]"
 fi # role exists
}
