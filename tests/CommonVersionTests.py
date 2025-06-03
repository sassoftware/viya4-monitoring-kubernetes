from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

# NOTE: As of 11FEB25, order matters: the list of expected log lines must reflect the
#       expected relative order (e.g. the 2nd log message listed must follow the 1st).
#       This allows us to avoid reprocessing all output lines and reduces test execution
#       time. Remember: the 'expected' array need not contain *all* log lines generated,
#       but must contain all necessary to validate results.

class CommonVersionTests(BaseTest):
    def common_version_test1(self):
      expected = [
        'INFO Updating SAS Viya Monitoring for Kubernetes version information',
        'Viya Monitoring for Kubernetes [0-9]+.[0-9]+.[0-9]+(-SNAPSHOT)? is installed',
        'INFO Listing helm releases in ver-test-namespace',
        'v4m\s+ver-test-namespace\s+[0-9]+\s+[0-9]{4}-[0-9]{2}-[0-9]{2}\s+[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]+\s+[-+][0-9]+ .+\s+deployed\s+v4m-[0-9]+.[0-9]+.[0-9]+(-SNAPSHOT)?\s+[0-9]+.[0-9]+.[0-9]+(-SNAPSHOT)?',
        'INFO Removing SAS Viya Monitoring for Kubernetes version information'
  ]
      self.run_version_test("version-include_test1.sh", expected)

    def common_version_test2(self):
      expected = [
        'INFO Updating SAS Viya Monitoring for Kubernetes version information',
        'Viya Monitoring for Kubernetes [0-9]+.[0-9]+.[0-9]+(-SNAPSHOT)? is installed',
        'INFO Listing helm releases in ver-test-namespace',
        'v4m\s+ver-test-namespace\s+[0-9]+\s+[0-9]{4}-[0-9]{2}-[0-9]{2}\s+[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]+\s+[-+][0-9]+ .+\s+deployed\s+v4m-[0-9]+.[0-9]+.[0-9]+(-SNAPSHOT)?\s+[0-9]+.[0-9]+.[0-9]+(-SNAPSHOT)?',
        'gitCommit: [0-9a-f]{7}',
        '\s+logging/logging.txt',
        '\s+monitoring/monitoring.txt',
        '\s+path: ' + os.getenv("TEST_REPO") + '/tests/common/version-test-user-dir',
        '\s+user.env: \'# user.env content for test 2\'',
        'INFO Removing SAS Viya Monitoring for Kubernetes version information'
      ]
      self.run_version_test("version-include_test2.sh", expected)

    def common_version_test3(self):
      expected = [
        'Viya Monitoring for Kubernetes 1.2.25 is installed',
        'Viya Monitoring for Kubernetes [0-9]+.[0-9]+.[0-9]+(-SNAPSHOT)? is installed',
        'INFO Version Information for existing Helm release',
        'INFO V4M_CURRENT_VERSION_FULL=1.2.25',
        'INFO V4M_CURRENT_VERSION_MAJOR=1',
        'INFO V4M_CURRENT_VERSION_MINOR=2',
        'INFO V4M_CURRENT_VERSION_PATCH=25',
        'INFO V4M_CURRENT_STATUS=deployed',
        'INFO Information on newly installed Helm release',
        'INFO releaseVersionFull: \[[0-9]+.[0-9]+.[0-9]+(-SNAPSHOT)?\]',
        'INFO releaseVersionMajor: \[[0-9]+\]',
        'INFO releaseVersionMinor: \[[0-9]+\]',
        'INFO releaseVersionPatch: \[[0-9]+\]',
        'INFO releaseStatus: \[deployed\]',
        'INFO Removing SAS Viya Monitoring for Kubernetes version information'
      ]
      self.run_version_test("version-include_test3.sh", expected)

    def run_version_test(self, script, expected):
        fullScript = [os.getenv("TEST_REPO") + "/tests/common/" + script]
        self.log.info("Verifying version-include.sh functions [" + script + "]")
        out, err, rc = self._call(fullScript)
        asserts.assert_equal(rc, 0, "%s failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (script, rc, out, err))

        jstart=0
        for i in range(len(expected)):
          found = False
          self.log.debug("Looking for [%s]" % (expected[i]))

          for j in range(jstart, len(out)):
            self.log.debug("Checking [%s]" % (out[j]) + " J=" + str(j) )
            if re.match(expected[i], out[j]) != None:
              self.log.debug("Matched [%s] to [%s]" % (out[j],expected[i]))
              found = True
              jstart=j+1
              break
          if found == False:
            asserts.fail("Expected [%s] in output" % (expected[i]))
def main():
    print("Running as a script...")
    testObject = CommonVersionTests(False)
    testObject.common_version_test1()
    testObject.common_version_test2()
    testObject.common_version_test3()
    print("Testing complete")

if __name__ == '__main__':
    main()
