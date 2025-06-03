from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class LoggingCommonFunctions(BaseTest): # This test class inherits from BaseTest

    def logging_require_opensearch(self):

        self.log.info("Testing bash functions from common.sh: require_opensearch")

        ##test of function: require_opensearch
        self.log.info("Test #1: LOG_SEARCH_BACKEND == OPENSEARCH")

        os.environ["LOG_SEARCH_BACKEND"] = "OPENSEARCH"
        out, err, rc = self._call([os.getenv("TEST_REPO") + "/tests/logging/bin/test_common.sh"]) # returns 3 values, stdout, stderr, and rc
        asserts.assert_equal(rc, 0, "test_common-include.sh failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (rc, out, err))

        asserts.assert_not_none(re.fullmatch(r"INFO User directory: .+", out[0]))
        asserts.assert_equal(out[1],"INFO LOG_SEARCH_BACKEND set to [OPENSEARCH]")
        asserts.assert_equal(out[2],"INFO Call to require_opensearch function did NOT trigger exit")

        ##test of function: require_opensearch
        self.log.info("Test #2: LOG_SEARCH_BACKEND != OPENSEARCH")

        os.environ["LOG_SEARCH_BACKEND"] = "FOO"
        out, err, rc = self._call([os.getenv("TEST_REPO") + "/tests/logging/bin/test_common.sh"]) # returns 3 values, stdout, stderr, and rc
        #NOTE: This test execution is expected to FAIL with an exit code of 1
        asserts.assert_equal(rc, 1, "test_common-include.sh failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (rc, out, err))

        asserts.assert_not_none(re.fullmatch(r"INFO User directory: .+", out[0]))
        asserts.assert_equal(out[1],"INFO LOG_SEARCH_BACKEND set to [FOO]")
        asserts.assert_equal(out[2],"ERROR This script is only appropriate for use with OpenSearch as the search back-end.")
        asserts.assert_equal(out[3],"ERROR The LOG_SEARCH_BACKEND environment variable is currently set to [FOO]")

def main():
	print("Running as a script...")
	testObject = LoggingCommonFunctions(False)
	testObject.logging_require_opensearch()
	print("Testing complete")


if __name__ == '__main__':
	main()
