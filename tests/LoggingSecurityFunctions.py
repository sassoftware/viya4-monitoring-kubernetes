from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class LoggingSecurityFunctions(BaseTest): # This test class inherits from BaseTest
	
	
	def logging_apiacccess(self):
		self.log.info("Calling apiaccess-include_test.sh to test functions related to ODFE API calls")
		testScript = "/tests/logging/bin/apiaccess-include_test.sh"
		out, err, rc = self._call([os.getenv("TEST_REPO") + testScript])
		asserts.assert_equal(rc, 0, "%s failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (testScript, rc, out, err))

	def logging_rbac(self):
		self.log.info("Calling rbac-include_test.sh to test functions related to ODFE access controls")
		testScript = "/tests/logging/bin/rbac-include_test.sh"
		out, err, rc = self._call([os.getenv("TEST_REPO") + testScript])
		asserts.assert_equal(rc, 0, "%s failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (testScript, rc, out, err))


	

def main():
	print("Running as a script...")
	testObject =LoggingSecurityFunctions(False)
	testObject.logging_apicccess()
	testObject.logging_rbac()
	print("Testing complete")


if __name__ == '__main__':
	main()
