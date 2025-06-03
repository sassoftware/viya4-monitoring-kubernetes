from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class MonitoringBasic(BaseTest):
    
    def monitoring_common_test(self):
        self.log.info("Verifying %s/monitoring/bin/common.sh" % os.getenv("TEST_REPO"))
                
        #self.log.info("Test 1 - Defaults")
        #testScript = "/tests/monitoring/mon-user-env_test1.sh"
        #out, err, rc = self._call([os.getenv("TEST_REPO") + testScript])
        #asserts.assert_equal(rc, 0, "%s failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (testScript, rc, out, err))
        #asserts.assert_equal(out[1], "MON_NS=monitoring", "Expected MON_NS=[monitoring], but got [%s]" % out[1])
        #asserts.assert_equal(out[2], "MON_TLS_ENABLE=", "Expected MON_TLS_ENABLE=[], but got [%s]" % out[2])
        #asserts.assert_equal(out[3], "TLS_ENABLE=false", "Expected TLS_ENABLE=[false], but got [%s]" % out[3])

        self.log.info("Test 2 - Custom namespace and MON_TLS_ENABLE")
        testScript = "/tests/monitoring/mon-user-env_test2.sh"
        out, err, rc = self._call([os.getenv("TEST_REPO") + testScript])
        asserts.assert_equal(rc, 0, "%s failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (testScript, rc, out, err))
        asserts.assert_equal(out[1], "MON_NS=my-custom-namespace", "Expected MON_NS=my-custom-namespace, but got [%s]" % out[1])
        asserts.assert_equal(out[2], "MON_TLS_ENABLE=true", "Expected MON_TLS_ENABLE=[true], but got [%s]" % out[2])
        asserts.assert_equal(out[3], "TLS_ENABLE=true", "Expected TLS_ENABLE=[true], but got [%s]" % out[3])

        self.log.info("Test 3 - Default namespace and TLS_ENABLE")
        testScript = "/tests/monitoring/mon-user-env_test3.sh"
        out, err, rc = self._call([os.getenv("TEST_REPO") + testScript])
        asserts.assert_equal(rc, 0, "%s failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (testScript, rc, out, err))
        asserts.assert_equal(out[1], "MON_NS=monitoring", "Expected MON_NS=monitoring, but got [%s]" % out[1])
        asserts.assert_equal(out[2], "MON_TLS_ENABLE=", "Expected MON_TLS_ENABLE=[], but got [%s]" % out[2])
        asserts.assert_equal(out[3], "TLS_ENABLE=true", "Expected TLS_ENABLE=[true], but got [%s]" % out[3])

        #self.log.info("Test 4 - Override base user.env with monitoring/user.env")
        #testScript = "/tests/monitoring/mon-user-env_test4.sh"
        #out, err, rc = self._call([os.getenv("TEST_REPO") + testScript])
        #asserts.assert_equal(rc, 0, "%s failed to run successfully\nrc=%d\nout=%s\nerr=%s" % (testScript, rc, out, err))
        #asserts.assert_equal(out[1], "MON_NS=my-override-namespace", "Expected MON_NS=my-override-namespace, but got [%s]" % out[1])
        #asserts.assert_equal(out[2], "MON_TLS_ENABLE=", "Expected MON_TLS_ENABLE=[], but got [%s]" % out[2])
        #asserts.assert_equal(out[3], "TLS_ENABLE=false", "Expected TLS_ENABLE=[false], but got [%s]" % out[3])

def main():
    print("Running as a script...")
    testObject = MonitoringBasic(False)
    testObject.monitoring_common_test()
    print("Testing complete")

if __name__ == '__main__':
    main()