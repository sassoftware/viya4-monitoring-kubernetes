from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class CommonHelmTests(BaseTest):
        
    def common_helm_version_test(self):
        self.log.info("Verifying helm-include.sh version parsing and Helm-related functions")
        out, err, rc = self._call([os.getenv("TEST_REPO") + "/tests/common/helm-include_tests.sh"]) # returns 3 values, stdout, stderr, and rc
        asserts.assert_equal(rc, 0, "helm-include_test.sh failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (rc, out, err))
        
        asserts.assert_not_none(re.match(r"HELM_VER_FULL=3\.\d+\.\d+", out[0]))
        asserts.assert_equal(out[1], "HELM_VER_MAJOR=3")
        asserts.assert_not_none(re.fullmatch(r"HELM_VER_MINOR=\d+", out[2]))
        asserts.assert_not_none(re.fullmatch(r"HELM_VER_PATCH=\d+", out[3]))

        #tests of function: get_helmchart_reference
        asserts.assert_equal(out[4], "myrepo/mychart")
        asserts.assert_equal(out[5], "airgapRepo/mychart-1.2.3.tgz")
        asserts.assert_equal(out[6], "oci://airgapRepo/myrepo/mychart")
        asserts.assert_equal(out[7], "'ERROR: Helm chart version not specified'")
        asserts.assert_equal(out[8], "'ERROR: Helm chart name not specified'")
        asserts.assert_equal(out[9], "'ERROR: Helm chart repository not specified'")
        asserts.assert_equal(out[10], "'ERROR: Helm chart name not specified'")

        #tests of function: helm3ReleaseExists
        asserts.assert_equal(out[11], "Helm release [helmtest1] in namespace [helmtest] found")
        asserts.assert_equal(out[12], "Helm release [helmtest2] in namespace [helmtest] NOT found")
        #line13: release "helmtest1" uninstalled
        #line14: namespace "helmtest" deleted

        #tests of function: helmRepoAdd
        asserts.assert_equal(out[15], "INFO Adding [foo] helm repository")
        asserts.assert_equal(out[16], '"foo" has been added to your repositories')
        asserts.assert_equal(out[17], '"foo" has been removed from your repositories')
        asserts.assert_equal(out[18], '0')
        
def main():
    print("Running as a script...")
    testObject = CommonHelmTests(False)
    testObject.common_helm_version_test()
    print("Testing complete")

if __name__ == '__main__':
    main()
