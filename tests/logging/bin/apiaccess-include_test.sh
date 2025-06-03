#! /bin/bash

this_script=`basename "$0"`

TEST_REPO=${TEST_REPO:-$V4M_REPO}
source $TEST_REPO/tests/logging/bin/testing-include.sh

#NOTE: The following two fields should be checked/changed with every edit
#      version_number must be incremented after adding/removing tests
version_number="1.1"
tests_expected=24


#NOTE: Variable/function names referencing 'es' and 'kb' reflect project history.
#      We originally used the OpenDistro for Elasticsearch project which
#      deployed Elasticsearch and Kibana.  We now deploy OpenSearch project
#      which include OpenSearch and OpenSearch dashboards as replacements
#      for those two earlier applications, respectively.


cd $V4M_REPO
LOG_COLOR_ENABLE=${LOG_COLOR_ENABLE:-false}
source $V4M_REPO/bin/common.sh
source $V4M_REPO/logging/bin/common.sh

source $V4M_REPO/logging/bin/secrets-include.sh
source $V4M_REPO/logging/bin/apiaccess-include.sh


PASSED_LOG_NS=${LOG_NS:-logging}

# Bad Namespace
LOG_NS="no_namespace"
unset es_api_url
unset espfpid

newTest "Attempt to get OpenSearch URL with 'bad' namespace"
newSubTest "Check exit code"
get_es_api_url
rc=$?

if [ "$rc" != "0" ]; then
   testResult SUCCESS "Non-zero exit code from get_es_api_url w/bad namespace"
else
   testResult FAILED "get_es_api_url exited w/ zero exit code w/bad namespace"
fi

newSubTest "Check es_api_url var"
if [ -z "$es_api_url" ]; then
   testResult SUCCESS "No OpenSearch URL returned w/bad namespace"
else
   testResult FAILED "URL returned w/bad namespace"
   log_info "TST: es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"
fi


unset sec_api_url
unset es_api_url
unset espfpid

LOG_NS=${PASSED_LOG_NS:-logging}
get_credentials_from_secret admin


# Determine how OpenSearch will be accessed by default
if [ "$LOG_ALWAYS_PORT_FORWARD" ==  "true" ]; then
   service_type="PortForwarding"
elif [ "$OPENSHIFT_CLUSTER" == "true" ] && [ "$(kubectl -n $LOG_NS get route/v4m-es-client-service 2>/dev/null)" ]; then
   service_type="OpenShiftRoute"
else
   service_type=$(get_k8s_info "$LOG_NS" "service/v4m-es-client-service" '{.spec.type}')
   if [ "$service_type" == "ClusterIP" ]; then
      if kubectl -n $LOG_NS get ingress v4m-es-client-service 2>/dev/null 1>&2; then
         service_type="Ingress"
      else
         service_type="PortForwarding"
      fi
   fi
fi

log_info "TST: OpenSearch will be accessed via [$service_type]"

# Get OSD URL
newTest "Get OpenSearch Dashboards URL (default access method)"
newSubTest "Check exit code"
get_kb_api_url
rc=$?

if [ "$rc" != "0" ]; then
   testResult FAILED "Non-zero exit code from get_kb_api_url [$rc]"
else
   testResult SUCCESS "get_kb_api_url exit code=0"
fi

# Get OpenSearch URL
newTest "Get OpenSearch URL (default access method)"
newSubTest "Check exit code"
get_es_api_url
rc=$?

if [ "$rc" != "0" ]; then
   testResult FAILED "Non-zero exit code from get_es_api_url"
else
   testResult SUCCESS "get_es_api_url exit code=0"
fi

newSubTest "Work with returned URL"
if [ -z "es_api_url" ]; then
   testResult FAILED "No OpenSearch URL returned"
   testResult SKIPPED "did not attempt to use null OpenSearch URL"
   testResult SKIPPED "did not attempt subsequent call to get_es_api_url"
else
   testResult SUCCESS "OpenSearch URL was returned"
   log_info "TST: es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"

   newSubTest "Attempt to access OpenSearch"
   if testURL "$es_api_url" "OpenSearch"; then
      testResult SUCCESS "OpenSearch was accessible via returned URL"
   else
      testResult FAILED "OpenSearch was NOT accessible via returned URL"
   fi

   newSubTest "Subsequent call to get_es_api_url"

   last_url="$es_api_url"
   last_pfpid="$espfpid"

   get_es_api_url
   rc=$?

   log_info "TST: es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"

   if [ "$rc" != "0" ]; then
      testResult FAILED "Non-zero exit code from get_es_api_url"
   else
      testResult SUCCESS "get_es_api_url exiting w/ exit code '0'"
   fi

   newSubTest "Compare new OpenSearch URL with previous URL"
   if [ "$es_api_url" != "$last_url" ];then
      testResult FAILED "OpenSearch URL returned on subsequent call did not match original url"
   else
      testResult SUCCESS "OpenSearch URL returned on subsequent call matched original url"
   fi

   newSubTest "Compare new port-forwarding PID with previous PID"
   if [ "$espfpid" != "$last_pfpid" ]; then
      testResult FAILED "Port-forwarding PID returned on subsequent call did not match original PID"
   else
      testResult SUCCESS "Port-forwarding PID returned on subsequent call matched original PID"
   fi
fi

if [ "$service_type" == "PortForwarding" ]; then
   log_info "TST: Stopping port-forwarding"
   stop_es_portforwarding
   set +e  #needed b/c stop_portforwarding function hard-codes enabling errexit (TODO: Fix)
fi



unset es_api_url
get_credentials_from_secret admin

# sec_api_url
newTest "Get Security API URL"
newSubTest "Get sec_api_url (no existing OpenSearch URL)"
get_sec_api_url
rc=$?

if [ "$rc" != "0" ]; then
   testResult FAILED "Non-zero exit code from get_sec_api_url"
elif [ -z "sec_api_url" ]; then
   testResult FAILED "No Security URL returned"
   log_info "TST: sec_api_url: $sec_api_url es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"
else
   testResult SUCESS "Security URL returned"
   log_info "TST: sec_api_url: $sec_api_url es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"
fi

unset sec_api_url #unset to force re-getting

newSubTest "Subsequent call to get_sec_api_url"
get_sec_api_url
rc=$?

if [ "$rc" != "0" ]; then
   testResult FAILED "Non-zero exit code from get_sec_api_url"
   testResult SKIPPED "Did not attempt to access Security API URL"
elif [ -z "sec_api_url" ]; then
   testResult FAILED "No Security URL returned"
   log_info "TST: sec_api_url: $sec_api_url es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"
   testResult SKIPPED "Did not attempt to access Security API URL"
else
   testResult SUCESS "Security URL returned"
   log_info "TST: sec_api_url: $sec_api_url es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"

   newSubTest "Attempt to access security URL"
   if testURL "$sec_api_url/account" "Security"; then
      testResult SUCCESS "Security API URL accessible"
   else
      testResult FAILED  "Security API URL NOT accessible"
   fi
fi

stop_es_portforwarding  # stop port-forwarding
unset sec_api_url


unset es_api_url
get_credentials_from_secret admin

# ism_api_url
newTest "Get Index State Management API URL"
newSubTest "Get sec_ism_url (no existing OpenSearch URL)"
get_ism_api_url
rc=$?

if [ "$rc" != "0" ]; then
   testResult FAILED "Non-zero exit code from get_ism_api_url"
elif [ -z "ism_api_url" ]; then
   testResult FAILED "No ISM URL returned"
   log_info "TST: ism_api_url: $ism_api_url es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"
else
   testResult SUCESS "ISM URL returned"
   log_info "TST: ism_api_url: $ism_api_url es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"
fi

unset ism_api_url #unset to force re-getting

newSubTest "Subsequent call to get_ism_api_url"
get_ism_api_url
rc=$?

if [ "$rc" != "0" ]; then
   testResult FAILED "Non-zero exit code from get_ism_api_url"
   testResult SKIPPED "Did not attempt to access ISM API URL"
elif [ -z "ism_api_url" ]; then
   testResult FAILED "No ISM URL returned"
   log_info "TST: ism_api_url: $ism_api_url es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"
   testResult SKIPPED "Did not attempt to access ISM API URL"
else
   testResult SUCESS "ISM URL returned"
   log_info "TST: ism_api_url: $ism_api_url es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"

   newSubTest "Attempt to access ISM URL"
   if testURL "$ism_api_url/explain" "ISM"; then
      testResult SUCCESS "ISM API URL accessible"
   else
      testResult FAILED  "ISM API URL NOT accessible"
   fi
fi

stop_es_portforwarding  # stop port-forwarding
unset ism_api_url


newTest "Get OpenSearch URL (force port-forwarding)"

unset es_api_url
unset espfpid
LOG_ALWAYS_PORT_FORWARD=true

newSubTest "Check URL returned"

get_es_api_url
rc=$?

if [ -z "es_api_url" ]; then
   testResult FAILED "No OpenSearch URL returned"
   testResult SKIPPED "Did not attempt to access OpenSearch"
   testResult SKIPPED "Did not attempt to stop port-forwarding"
   testResult SKIPPED "Did not attempt determine if port-forwarding PID was active "
   testResult SKIPPED "Did not check es_api_url var"
   testResult SKIPPED "Did not attempt to access OpenSearch API after stopping port-forwarding"
   testResult SKIPPED "Did not attempt redundant call to stop port-forwarding"
   testResult SKIPPED "Did not test exit trap call to stop_portforwarding"
else
   testResult SUCCESS "OpenSearch URL returned"
fi

newSubTest "Check for OpenSearch port-forwarding PID"
if  [ -z "espfpid" ]; then
   testResult FAILED "No OpenSearch port-forwarding PID returned"
   testResult SKIPPED "Did not attempt to access OpenSearch"
   testResult SKIPPED "Did not attempt to stop port-forwarding"
   testResult SKIPPED "Did not attempt determine if port-forwarding PID was active "
   testResult SKIPPED "Did not check es_api_url var"
   testResult SKIPPED "Did not attempt to access OpenSearch API after stopping port-forwarding"
   testResult SKIPPED "Did not attempt redundant call to stop port-forwarding"
   testResult SKIPPED "Did not test exit trap call to stop_portforwarding"
else
   testResult SUCCESS "OpenSearch port-forwarding PID returned"
   log_info "TST: es_api_url: $es_api_url  espfpid: $espfpid rc: $rc"

   newSubTest "Attempt to access OpenSearch"
   if testURL "$es_api_url" "OpenSearch"; then
      testResult SUCCESS "OpenSearch was accessible via returned URL"
   else
      testResult FAILED "OpenSearch was NOT accessible via returned URL"
   fi

   newSubTest "Stopping port-forwarding"
   stop_es_portforwarding
   set +e  #needed b/c stop_portforwarding function hard-codes enabling errexit (TODO: Fix)
   log_info "TST: es_api_url: $es_api_url  espfpid: $espfpid"
   if [ "$espfpid" != "" ]; then
      testResult FAILED  "OpenSearch port-forward PID still set after port-forwarding stopped"

      newSubTest "Confirm port-forwarding has been stopped"
      if  ps -p "$espfpid" >/dev/null;  then
         testResult FAILED "OpenSearch port-forwarding still active after port-forwarding stopped"
      else
         testResult SUCCCESS "Port-forwarding process no longer active"
      fi
   else
      testResult SUCCESS "OpenSearch port-forward PID was properly unset"

      testResult SKIPPED "No need to confirm port-forwarding has been stopped"
   fi

   newSubTest "Confirm OpenSearch URL unset after port-forwarding stopped"
   # This test will fail due to known issue (TODO: Fix)
   if [ -n "$es_api_url" ]; then
      testResult FAILED "OpenSearch URL still set after port-forwarding stopped"
   else
      testResult SUCCESS "OpenSearch URL was properly unset"
   fi

   newSubTest "Attempt to access OpenSearch after port-forwarding stopped."
   if testURL "$es_api_url" "OpenSearch"; then
      testResult FAILED "OpenSearch accessible after port-forwarding stopped"
   else
      testResult SUCCESS "OpenSearch NOT accessible after port-forwarding stopped"
   fi

   newSubTest "Redundant stopping of OpenSearch portforwarding"
   stop_es_portforwarding
   set +e  #needed b/c stop_portforwarding function hard-codes enabling errexit (TODO: Fix)
   log_info "TST: es_api_url: $es_api_url  espfpid: $espfpid"

   if [ "$espfpid" != "" ]; then
      testResult FAILED  "OpenSearch port-forward PID set after redundant stop_port_forwarding call"
   else
      testResult SUCCESS "OpenSearch port-forward PID was properly unset (after redundant stop_port_forwarding call)"
   fi

   log_info "TST: Restarting port-forwarding"

   newSubTest "Test exit trap calling stop_port_forwarding"
   unset es_api_url   # needed b/c stop_portforwarding does not blank es_api_url  (TODO: Fix)
   get_es_api_url
   log_info "TST: es_api_url: $es_api_url  espfpid: $espfpid"
   testResult TBD "Confirm PID [$espfpid] is no longer executing to determine success/failure of this test"
   if [ "$LOG_DEBUG_ENABLE" != "true" ]; then
      log_info "TST: Enable 'debug' level logging to see messages confirming port-forwarding process has been terminated."
   fi
fi


log_info "TST: $this_script exiting"
printTestSummary

exit $tests_failed

#NOTE: Testing wrapper should confirm port-forwarding is stopped as part of exit trap too

