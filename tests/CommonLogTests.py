from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class CommonLogTests(BaseTest):
        
    def common_log_test(self):
        self.log.info("Verifying log-include.sh functions")
        out, err, rc = self._call([os.getenv("TEST_REPO") + "/tests/common/log-include_tests.sh"])
        asserts.assert_equal(rc, 0, "log-include_test.sh failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (rc, out, err))
        expected = ""
        with open(os.getenv("TEST_REPO") + "/tests/common/log-expected.txt", 'r') as file:
            expected = file.read()
        expectedLines = expected.splitlines()
        for i in range(len(out)):
          asserts.assert_equal(out[i], expectedLines[i], "Incorrect log output.\nExpected:\n%s\nActual:\n%s" % (expectedLines[i], out[i]))

        out, err, rc = self._call([os.getenv("TEST_REPO") + "/tests/common/log-include_tests-no-verbose.sh"])
        asserts.assert_equal(rc, 0, "log-include_test-no-verbose.sh failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (rc, out, err))
        expected = ""
        with open(os.getenv("TEST_REPO") + "/tests/common/log-expected-no-verbose.txt", 'r') as file:
            expected = file.read()
        expectedLines = expected.splitlines()
        for i in range(len(out)):
          asserts.assert_equal(out[i], expectedLines[i], "Incorrect log output.\nExpected:\n%s\nActual:\n%s" % (expectedLines[i], out[i]))

def main():
    print("Running as a script...")
    testObject = CommonLogTests(False)
    testObject.common_log_test()
    print("Testing complete")

if __name__ == '__main__':
    main()
