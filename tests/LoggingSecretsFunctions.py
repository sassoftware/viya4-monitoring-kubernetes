from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class LoggingSecretsFunctions(BaseTest): # This test class inherits from BaseTest

    def logging_k8s_secrets_functions(self):

        #set-up
        temp_namespace = "unit-test-ns"

        os.environ["TEST_NAMESPACE"] = temp_namespace

        secret_name = "test-secret1"
        user_name = "test-user1"

        self.log.info("Testing bash functions from secrets-include.sh")
        out, err, rc = self._call([os.getenv("TEST_REPO") + "/tests/logging/bin/test_secrets-include.sh"]) # returns 3 values, stdout, stderr, and rc
        asserts.assert_equal(rc, 0, "test_secerts-include.sh failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (rc, out, err))


        asserts.assert_not_none(re.fullmatch(r"INFO User directory: .+", out[0]))
        asserts.assert_not_none(re.fullmatch(r"INFO Helm client version: \d+\.\d+\.\d+",out[1]))
        asserts.assert_not_none(re.fullmatch(r"INFO Kubernetes client version: v\d+\.\d+\.\d+", out[2]))
        asserts.assert_not_none(re.fullmatch(r"INFO Kubernetes server version: v\d+\.\d+\.\d+", out[3]))
        asserts.assert_not_none(re.fullmatch(r"INFO Loading user environment file: .+", out[4]))

        ##prep
        asserts.assert_equal(out[6], "INFO Prep Start")
        #Skipping line since it will vary depending on whether test namespace exists or not
        asserts.assert_equal(out[8], "INFO Prep End")

        ##test of function: create_user_secret
        asserts.assert_equal(out[9], "INFO Test #1 Start")
        asserts.assert_equal(out[10], "INFO Created secret for OpenSearch user credentials [testuser]")
        asserts.assert_equal(out[11], "secret/internal-user-testuser labeled")
        asserts.assert_equal(out[12], "INFO Test #1 End")

        ##test of function: get_credentials_from_secret
        asserts.assert_equal(out[13], "INFO Test #2 Start")
        asserts.assert_equal(out[14], "INFO Expected username retrieved from secret")
        asserts.assert_equal(out[15], "INFO Expected password retrieved from secret")
        asserts.assert_equal(out[16], "INFO Test #2 End")

        ##test of function: create_secret_from_file
        asserts.assert_equal(out[17], "INFO Test #3 Start")
        asserts.assert_equal(out[18], "INFO Created secret for OpenSearch config file [secret.yaml]")
        asserts.assert_equal(out[19], "secret/some-random-secret labeled")
        asserts.assert_equal(out[20], "NAME                 TYPE     DATA   AGE")
        ###asserts.assert_equal(out[21], "some-random-secret   Opaque   1      2s")
        asserts.assert_not_none(re.fullmatch(r"some-random-secret   Opaque   1      \w+", out[21]))
        asserts.assert_equal(out[22], "INFO Test #3 End")

        ## clean-up messages
        asserts.assert_equal(out[23], "INFO Cleanup Start")
        asserts.assert_equal(out[24], 'secret "some-random-secret" deleted')
        asserts.assert_equal(out[25], 'secret "internal-user-testuser" deleted')
	#Skipping line since it will vary depending on whether test namespace was created during test execution
        asserts.assert_equal(out[27], "INFO Cleanup End")


def main():
	print("Running as a script...")
	testObject = LoggingSecretsFunctions(False)
	testObject.logging_k8s_secrets_functions()
	print("Testing complete")


if __name__ == '__main__':
	main()
