*** Comments ***
http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#creating-test-suites

# This section is where files are imported and parameters are set
*** Settings ***
Resource		../data/global_resources.tsv
# If your python class takes parameters, these must be included
Library			../tests/CommonBaseTests.py		True
Library			../tests/CommonKubeTests.py		True
Library			../tests/CommonHelmTests.py		True
Library			../tests/CommonLogTests.py		True
Library			../tests/CommonVersionTests.py	        True
Test Timeout	300

# This section contains the test cases
*** Test Cases ***
# The first line is the name of the test case. I'm fairly certain it can be any string.
Common Base Tests
	# Here is where metadata about the test is listed. We currently only use tags.
	[Tags]						level-0
	# Methods to be called
	common env exists test
	common cmd exists test
    common function test
Common Kube Tests
    [Tags]						level-0
	common kubectl admin test
	common kube version test
Common Helm Tests
    [Tags]						level-0
	common helm version test
Common Log Tests
    [Tags]						level-0
	common log test
Common Version Tests
    [Tags]						level-0
	common version test1
	common version test2
	common version test3
