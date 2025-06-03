from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class CommonBaseTests(BaseTest):
    
    def common_env_exists_test(self):
        self.log.trace("Checking that required env vars exist")
        envs = ["V4M_REPO", "TEST_REPO"]
        self.log.trace("Current env vars:")

        for e in envs:
            asserts.assert_not_equal(e, None, "The required env var [%s] is not set" % e)
            path = os.getenv(e)
            asserts.assert_true(path!=None, "The env var [%s] is not set" % e)
            asserts.assert_true(os.path.isdir(path), "The path [%s] from env var [%s] does not exist" % (path, e))
            
    def common_cmd_exists_test(self):
        self.log.trace("Checking that required commands exist")
        
        cmds = ["kubectl", "helm", "git"]
        for c in cmds:
          _, _, rc = self._call(["which", c]) # returns 3 values, stdout, stderr, and rc
          asserts.assert_true(rc==0, "The required command [%s] was not found" % c)
            
    def common_function_test(self):
        self.log.info("Verifying common.sh functions")
        out, err, rc = self._call([os.getenv("TEST_REPO") + "/tests/common/common-include_tests.sh"]) # returns 3 values, stdout, stderr, and rc
        asserts.assert_equal(rc, 0, "common-include_tests.sh failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (rc, out, err))

        # checkDefaultStorageClass
        self.log.trace("checking function: checkDefaultStorageClass")
        asserts.assert_not_none(r"defaultStorageClass=.+", out[4])
        # randomPassword
        self.log.trace("checking function: randomPassword")
        asserts.assert_not_none(r"randomPassword=.+", out[5])
        asserts.assert_not_none(r"randomPassword=.+", out[6])
        asserts.assert_not_none(r"randomPassword=.+", out[7])
        asserts.assert_not_equal(out[5], out[6])
        asserts.assert_not_equal(out[6], out[7])
        asserts.assert_not_equal(out[5], out[7])
        # USER_DIR
        self.log.trace("checking env var value is properly set: $USER_DIR")
        asserts.assert_equal(out[8],"USER_DIR_ENV_VAR_TEST1=foobar")

        # parseFullImage function call
        self.log.trace("checking function: parseFullImage")
        asserts.assert_equal(out[9],"parseFullImage function called return code [0]")
        asserts.assert_equal(out[10],"REGISTRY [docker.io]")
        asserts.assert_equal(out[11],"REPOS [opensearchproject]")
        asserts.assert_equal(out[12],"IMAGE [opensearch]")
        asserts.assert_equal(out[13],"VERSION [2.17.1]")
        asserts.assert_equal(out[14],"FULL IMAGE ESCAPED [docker.io\/opensearchproject\/opensearch\:2.17.1]")
        asserts.assert_equal(out[15],"full_image [docker.io/opensearchproject/opensearch:2.17.1]")

        # disable_sa_token_automount function calls
        self.log.trace("checking function: disable_sa_token_automount function")
        asserts.assert_equal(out[16],"namespace/commontest created")
        asserts.assert_equal(out[17],"automountServiceAccountToken: <none>")
        asserts.assert_equal(out[18],"serviceaccount/default patched")
        asserts.assert_equal(out[19],"automountServiceAccountToken: false")

        # enable_pod_token_automount function call tests
        self.log.trace("checking function: enable_pod_token_automount")
        asserts.assert_equal(out[20],"deployment.apps/simple-deployment created")
        asserts.assert_equal(out[21],"deployment.apps/simple-deployment patched")
        asserts.assert_equal(out[22],"ERROR Invalid request to function [enable_pod_token_automount]; unsupported resource_type [pod]")
        asserts.assert_equal(out[23],'deployment.apps "simple-deployment" deleted')
        asserts.assert_equal(out[24],'namespace "commontest" deleted')

        # validateNamespace function call tests
        self.log.trace("checking function: validateNamespace")
        asserts.assert_equal(out[25],"ERROR [ABC] is not a valid namespace name")
        asserts.assert_equal(out[26],"ERROR [a_b_c] is not a valid namespace name")
        asserts.assert_equal(out[27],"DEBUG Namespace [abc123] passes validation")

    def common_function_test2(self):
        self.log.info("Verifying common.sh clean-up functions: cleanup & errexit_msg")
        out, err, rc = self._call([os.getenv("TEST_REPO") + "/tests/common/common-include_tests2.sh"]) # returns 3 values, stdout, stderr, and rc

        #NOTE: Script is designed to exit with a non-zero exit code
        asserts.assert_equal(rc, 1)

        # test of cleanup and errexit_msg function calls
        self.log.trace("checking functions: cleanup & errexit_msg")
        asserts.assert_equal(out[4],"ERROR Exiting script [common-include_tests2.sh] due to an error executing the command [kubectl get foo bar baz 2> /dev/null].")
        asserts.assert_not_none(out[5],r'DEBUG Deleted temporary directory: \[/tmp/sas.mon.\w{8}\]')

def main():
    print("Running as a script...")
    testObject = CommonBaseTests(False)
    testObject.common_env_exists_test()
    testObject.common_cmd_exists_test()
    testObject.common_function_test2()
    testObject.common_function_test()
    print("Testing complete")

if __name__ == '__main__':
    main()
