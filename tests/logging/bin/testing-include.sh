
testno=0
subtestid=0
testID="0.0"

tests_failed=0
tests_tbd=0
tests_skipped=0
tests_passed=0
tests_total=0
tests_expected=0
test_results=0

function testURL {
   local url user pass appname response
   url=$1
   appname=$2
   user=${3:-"$ES_ADMIN_USER"}
   pass=${4:-"$ES_ADMIN_PASSWD"}

   response=$(curl -XGET -s -o /dev/null -w  "%{http_code}"  "$url" -u $user:$pass -k)
   if [[ $response != 2* ]]; then
      log_info "TST: response: $response"
      return 1
   else
      log_info "TST: response: $response"
      return 0
   fi
}

function newTest {
   local msg
   msg=$1
   testno=$((testno+1))
   subtestno=0

   if [ "$subtestno" == "0" ]; then
      testID="$testno"
   else
      testID="$testno.$subtestno"
   fi

   if [ -n "$msg" ]; then
      #log_info "TST: TEST: $testID - $msg"
      log_info "TST: TEST GROUP: $testID - $msg"
   fi
}

function newSubTest {
   local msg
   msg=$1

   subtestno=$((subtestno+1))
   testID="$testno.$subtestno"

   ((tests_total++))

   if [ -n "$msg" ]; then
      log_info "TST: TEST: $testID - $msg"
   fi
}

function testResult {
   local id result msg
   result=$1
   msg=$2
   id=${3:-"$testID"}

   if [ "$result" == "FAILED" ]; then
      ((tests_failed++))
      log_error "TST: TEST: $id RESULT: $result ($msg)"
   elif [ "$result" == "SKIPPED" ]; then
      newSubTest ""
      ((tests_skipped++))
      #need to use testID below to 'catch' new (incremented) id from call to newSubTest
      log_info "TST: TEST: $testID RESULT: $result ($msg)"
   elif [ "$result" == "TBD" ]; then
      ((tests_tbd++))
      log_notice "TST: TEST: $id RESULT: ACTION REQUIRED - $msg"
   else
      ((tests_passed++))
      log_info "TST: TEST: $id RESULT: $result ($msg)"
   fi

}

function printTestSummary {
   log_info "TST: Successful Tests: $tests_passed"
   log_info "TST: Skipped Tests: $tests_skipped"
   log_info "TST: Tests Requiring Further Action: $tests_tbd"
   log_info "TST: Failed Tests: $tests_failed"
   log_info "TST: Total Tests: $tests_total"

   test_results=$(($tests_passed+$tests_skipped+$tests_tbd+$tests_failed))
   log_info "TST: Test Results: $test_results"
   if [[ $tests_total != $test_results  ]];  then
      log_warn "TST: Total number of test results [$test_results] does NOT match total number of tests [$tests_total]"
   fi
   if [[ $tests_expected != $test_results  ]];  then
      log_warn "TST: Total number of test results [$test_results] does NOT match total number of tests expected [$tests_expected]"
   fi
}

# export -f testURL newTest newSubTest testResult printTestSummary
