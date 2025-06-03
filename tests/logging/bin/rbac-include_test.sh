#! /bin/bash

this_script=`basename "$0"`

TEST_REPO=${TEST_REPO:-$V4M_REPO}
source $TEST_REPO/tests/logging/bin/testing-include.sh

##NOTE: Although we no longer deploy Elasticsearch and Kibana, having
##      replaced them with OpenSearch and Opensearch Dashboards, both
##      names continue to be used in function names.  And, therefore,
##      continue to be used in the messages output by this script

#NOTE: The following two fields should be checked/changed with every edit
#      version_number must be incremented after adding/removing tests
version_number="1.0"
tests_expected=28 #excluding the invalid tenant namespace test since it is commented out

cd $V4M_REPO
LOG_COLOR_ENABLE=${LOG_COLOR_ENABLE:-false}

source $V4M_REPO/bin/common.sh

# pre-reqs
source $V4M_REPO/logging/bin/common.sh
source $V4M_REPO/logging/bin/secrets-include.sh
source $V4M_REPO/logging/bin/apiaccess-include.sh

# file containing functions to test
source $V4M_REPO/logging/bin/rbac-include.sh

# set-up
LOG_NS=${LOG_NS:-logging}

#create 'good' role template
cp $V4M_REPO/logging/opensearch/rbac/index_role.json $TMP_DIR/good_role_template.json
#sed -i'.bak' "s/xxIDXPREFIXxx/$INDEX_PREFIX/g"  $TMP_DIR/rbac/*.json     # IDXPREFIX
sed -i'.bak' "s/xxIDXPREFIXxx/viya_log_shouldnot_exist/g"  $TMP_DIR/good_role_template.json
good_role_template="$TMP_DIR/good_role_template.json"
bad_role_template="$TEST_REPO/tests/logging/testing/bad_role_template.json"


get_credentials_from_secret admin
get_sec_api_url
rc=$?

if [ $rc != 0 ]; then
   log_error "TST: Unable to obtain ES security API endpoint URL"
   exit 1
fi



# TESTS
newTest "Work with new role"

newSubTest "Create Role, good role template provided"
create_role xxtestrolexx "$good_role_template"
rc="$?"
if [ $rc == 0 ]; then
   testResult SUCCESS "create_role exited w/o error when good 'role-template' provided"
   newSubTest "role_exists, existing role"

   role_exists xxtestrolexx
   rc="$?"
   if [ $rc == 0 ]; then
      testResult SUCCESS "role_exists confirms role exists  [$rc]"

      newSubTest "Delete Role, existing role"
      delete_role xxtestrolexx
      rc="$?"
      if [ $rc == 0 ]; then
         testResult SUCCESS "delete_role exited w/o error  [$rc]"
      else
         testResult FAIL "delete_role exited w/ error [$rc]"
      fi
   else
      testResult FAILED "role_exists did not confirm role [xxtestrolexx] exists  [$rc]"
      testResult SKIPPED "delete_role test"
   fi
else
   testResult FAILED "create_role exited w/ error when good 'role-template' provided  [$rc]"
   testResult SKIPPED "role_exist test skipped"
fi

newSubTest "Create Role, bad role template provided"
create_role xxbadtestrolexx $bad_role_template
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED "create_role exited w/o error when bad 'role-template' provided  [$rc]"
else
   testResult SUCCESS "create_role exited w/ error when bad 'role-template' provided  [$rc]"
fi

newTest "Scenarios with non-existent role"
newSubTest "Role exists? (non-existent role)"

role_exists xxbadtestrolexx
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED "role_exists incorrectly reports non-existent role exists  [$rc]"
else
   testResult SUCCESS "role_exists correctly reports non-existent use does not exists  [$rc]"
fi

newSubTest "Delete Role, non-existent role"
delete_role xxbadtestrolexx
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED "delete_role exited w/o error when deleting non-existent role  [$rc]"
else
   testResult SUCCESS "delete_role exited w/ error when deleting non-existent role [$rc]"
fi

# ensure_role_exists
newTest "Testing ensure_role_exists"
newSubTest "Call ensure_role_exists with new role"
ensure_role_exists xxxtestrolexxx $good_role_template
rc="$?"
if [ $rc == 0 ]; then
   testResult SUCCESS "ensure_role_exists exited w/o error"

   newSubTest "confirm role was actually created"
   role_exists xxxtestrolexxx
   rc="$?"
   if [ $rc == 0 ]; then
      testResult SUCCESS "creation of role confirmed  [$rc]"

      newSubTest "call ensure_role_exists for an an existing role"
      ensure_role_exists xxxtestrolexxx
      rc="$?"
      if [ $rc == 0 ]; then
         testResult SUCCESS "ensure_role_exists exited w/o error when called for an existing role  [$rc]"

         delete_role xxxtestrolexxx #clean-up after ourselves

      else
         testResult FAILED "ensure_role_exists exited w/ error when called for an existing role [$rc]"
      fi
   else
      testResult FAILED "role was NOT created  [$rc]"
      testResult SKIPPED "calling ensure_role_exists for an existing role"
   fi
else
   testResult FAILED "ensure_role_exists exited w/ error  [$rc]"
   testResult SKIPPED "role creation confirmation"
   testResult SKIPPED "calling ensure_role_exists for an existing role"
fi


#ROLE-MAPPING Functions
#create role to work with
create_role xxtestrolexx "$good_role_template"
rc="$?"
if [ $rc == 0 ]; then
   role_exists xxtestrolexx
   rc="$?"
   if [ $rc == 0 ]; then
      newTest "Working with Role-mapping functions"
      #add a role mapping (berole to new role)
      newSubTest "Add a role-mapping"
      add_rolemapping xxtestrolexx xxxtest_back_end_rolexxx
      rc="$?"
      if [ $rc == 0 ]; then
         testResult SUCCESS "Backend role mapped to role"

         #remove a role mapping
         newSubTest "Remove a role-mapping"
         remove_rolemapping xxtestrolexx xxxtest_back_end_rolexxx
         rc="$?"
         if [ $rc == 0 ]; then
            testResult SUCCESS "Rolemapping delete w/o error [$rc]"
         else
            testResult FAILED  "Rolemapping delete w/ errors [$rc]"
         fi

         #add 2 role mappings
         newSubTest "Add multiple role-mappings to a role"
         add_rolemapping xxtestrolexx xxxtest_back_end_role1xxx
         rc1="$?"
         add_rolemapping xxtestrolexx xxxtest_back_end_role2xxx
         rc2="$?"
         if [ $rc1 == 0 ] &&  [ $rc2 == 0 ]; then
            testResult SUCCESS "Successfully added multiple role-mappings to a role [$rc]"

            #remove ALL role mapping
            newSubTest "Delete all rolemappings"
            delete_rolemappings xxtestrolexx
            rc="$?"
            if [ $rc == 0 ]; then
               testResult SUCCESS "delete_rolemappings exited w/o errors  [$rc]"
            else
               testResult FAILED  "delete_rolemappings exited w/ errors  [$rc]"
            fi

         else
            testResult FAILED  "Unable to add multiple role-mappings to a role [$rc]"
            testResult SKIPPED "delete all rolemappings"
         fi

      else
         testResult FAILED  "Unable to map backend role to role"
         testResult SKIPPED "remove a role-mapping"
         testResult SKIPPED "adding multiple role-mappings"
         testResult SKIPPED "delete all rolemappings"
      fi

#add a role mapping to non-existent role
#add a non-existent
   else
      delete_role xxtestrolexx
      log_error "TST: Role created for role-mapping function tests does not exist"

      testResult SKIPPED "add a role-mapping"
      testResult SKIPPED "remove a role-mapping "
      testResult SKIPPED "adding multiple role-mappings"
      testResult SKIPPED "delete all rolemappings"
  fi
else
   log_error "TST: Unable to create role for role-mapping function tests"

   testResult SKIPPED "add a role-mapping"
   testResult SKIPPED "remove a role-mapping "
   testResult SKIPPED "adding multiple role-mappings"
   testResult SKIPPED "delete all rolemappings"
fi

newTest "Role-mapping: Work with non-existent role"
newSubTest "Attempt to add role to non-existent role"
add_rolemapping xxxrole_does_not_existxxx xxxtest_back_end_rolexxx
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED "add_rolemapping exited w/o error when passed a non-existent role  [$rc]"
else
   testResult SUCCESS "add_rolemapping exited w/ error when passed a non-existent role [$rc]" 
fi

newSubTest "Attempt to remove role from non-existent role"
remove_rolemapping xxxrole_does_not_existxxx xxxtest_back_end_rolexxx
rc="$?"
if [ $rc == 0 ]; then
   testResult SUCCESS "remove_rolemapping exited w/o error when passed a non-existent role  [$rc]"
else
   testResult FAILED "remove_rolemapping exited w/ error when passed a non-existent role [$rc]"
fi

newSubTest "Attempt to remove ALL roles from non-existent role"
delete_rolemappings xxxrole_does_not_existxxx
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED "delete_rolemappings exited w/o error when passed a non-existent role  [$rc]"
else
   testResult SUCCESS "delete_rolemappings exited w/ error when passed a non-existent role [$rc]"
fi


# KIBANA-TENANT Functions
newTest "Work with a new Kibana-tenant"

newSubTest "Create tenant with description"
create_kibana_tenant test_tenant "This is a tenant used in testing the create_kibana_tenant function"
rc="$?"
if [ $rc == 0 ]; then
   testResult SUCCESS "create_kibana_tenant exited w/o error [$rc]"

   newSubTest "Confirm kibana_tenant_exists"
   kibana_tenant_exists test_tenant
   rc="$?"
   if [ $rc == 0 ]; then
      testResult SUCCESS "Confirmed Kibana tenant exists [$rc]"

      newSubTest "Delete Kibana-tenant"
      delete_kibana_tenant test_tenant
      rc="$?"
      if [ $rc == 0 ]; then
         testResult SUCCESS "Kibana-tenant deleted  [$rc]"

         newSubTest "Confirm deleted Kibana-tenant does not exist"
         kibana_tenant_exists test_tenant
         rc="$?"
         if [ $rc == 0 ]; then
            testResult FAILED  "Deleted Kibana tenant still exists [$rc]"
         else
            testResult SUCCESS "Deleted Kibana tenant no longer exists [$rc]"
         fi

      else
         testResult FAILED  "Deleting Kibana-tenant exited w/ error  [$rc]"
         testResult SKIPPED "confirmation deleted Kibana-tenant does not exist"
      fi

   else
      testResult FAILED  "Unable to confirmed Kibana tenant exists [$rc]"
      testResult SKIPPED "Kibana-tenant deletion"
      testResult SKIPPED "confirmation deleted Kibana-tenant does not exist"

   fi
else
   testResult FAILED  "create_kibana_tenant exited w/ error [$rc]"
   testResult SKIPPED "confirmed Kibana tenant exists"
   testResult SKIPPED "Kibana-tenant deletion"
   testResult SKIPPED "confirmation deleted Kibana-tenant does not exist"
fi

newTest "Other Kibana-tenant functions"

newSubTest "Confirm non-existent Kibana-tenant does not exist"
kibana_tenant_exists xxx_not_a_real_kibana_tenant_xxx
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED  "kibana_tenant_exists reports non-existent Kibana-tenant exists [$rc]"
else
   testResult SUCCESS "kibana_tenant_exists correctly reports non-existent Kibana-tenant does not exists [$rc]"
fi

newSubTest "Delete non-existent Kibana-tenant"
delete_kibana_tenant xxx_not_a_real_kibana_tenant_xxx
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED  "delete_kibana_tenant exited w/o error when deleting non-existent Kibana-tenant  [$rc]"
else
   testResult SUCCESS "delete_kibana_tenant exited w/ error when deleting non-existent Kibana-tenant  [$rc]"
fi

newSubTest "Delete non-existent Kibana-tenant"
delete_kibana_tenant xxx_not_a_real_kibana_tenant_xxx
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED  "delete_kibana_tenant exited w/o error when deleting non-existent Kibana-tenant  [$rc]"
else
   testResult SUCCESS "delete_kibana_tenant exited w/ error when deleting non-existent Kibana-tenant  [$rc]"
fi

#06JAN22 Commented out b/c Kibana API allows you to create tenants with invalid names!
#newSubTest "Attempt to create Kibana-tenant with invalid name"
#TODO: Validate against Viya tenant rules or Kibana tenant rules?
##create_kibana_tenant A  #tenant names must be 2+ chars long
##rc="$?"
##if [ $rc == 0 ]; then
##   testResult FAILED  "create_kibana_tenant exited w/o error when passed invalid tenant name [$rc]"
##else
##   testResult SUCCESS "create_kibana_tenant exited w/ error when passed invalid tenant name [$rc]"
##fi


#User-related Functions
newTest "Work with user-related functions"

newSubTest "Confirm that a non-existent user exists"
user_exists testuser
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED  "userExists indicates non-existent user exists [$rc]"
else
   testResult SUCCESS "userExists indicates testuser does NOT exist  [$rc]"
fi

newSubTest "Create user"
$V4M_REPO/logging/bin/user.sh CREATE -ns _all_ -t _all_ -u testuser
rc="$?"
if [ $rc == 0 ]; then
   testResult SUCCESS  "Call to script [user.sh] completed without errors [$rc]"
else
   testResult FAILED "Call to script [user.sh] completed with non-zero exit code [$rc]"
fi

newSubTest "Confirm testuser exists"
user_exists testuser
rc="$?"
if [ $rc == 0 ]; then
   testResult SUCCESS  "userExists function confirms 'testuser' exists [$rc]"
else
   testResult FAILED "userExists function failed to confirm user exists  [$rc]"
fi

newSubTest "Delete testuser"
delete_user testuser
rc="$?"
if [ $rc == 0 ]; then
   testResult SUCCESS  "delete_user function completed successfully [$rc]"
else
   testResult FAILED "delete_user function completed with non-zero rc [$rc]"
fi

newSubTest "Confirm testuser was deleted"
user_exists testuser
rc="$?"
if [ $rc == 0 ]; then
   testResult FAILED  "userExists indicates testuser  still exists [$rc]"
else
   testResult SUCCESS "userExists indicates testuser no longer exists [$rc]"
fi


# testing complete, exiting
log_info "TST: $this_script exiting"
echo ""
log_info "TST: Test Results Summary for: $this_script"
printTestSummary
exit $tests_failed


