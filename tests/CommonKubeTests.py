from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class CommonKubeTests(BaseTest):
    
    def common_kubectl_admin_test(self):
        self.log.trace("Verifying kubectl is available with admin credentials")
        self._basic_call(["kubectl", "auth", "can-i", "create", "namespace", "--all-namespaces"])

    def common_kube_version_test(self):
        self.log.info("Verifying kube-include.sh version parsing")
        out, err, rc = self._call([os.getenv("TEST_REPO") + "/tests/common/kube-include_tests.sh"]) # returns 3 values, stdout, stderr, and rc
        asserts.assert_equal(rc, 0, "kube-include_tests.sh failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (rc, out, err))
        
        asserts.assert_not_none(re.match(r"KUBE_CLIENT_VER=v1\.\d+\.\d+", out[0]))
        asserts.assert_not_none(re.match(r"KUBE_SERVER_VER=v1\.\d+\.\d+", out[1])) 

def main():
    print("Running as a script...")
    testObject = CommonKubeTests(False)
    testObject.common_kubectl_admin_test()
    testObject.common_kube_version_test()
    print("Testing complete")

if __name__ == '__main__':
    main()
