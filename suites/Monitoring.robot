*** Comments ***
http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#creating-test-suites

# This section is where files are imported and parameters are set
*** Settings ***
Resource		../data/global_resources.tsv
# If your python class takes parameters, these must be included
Library			../tests/MonitoringBasic.py		True
Library			../tests/MonitoringScripts.py		True
# Note the robot variable syntax below. Variables can be set in other files and imported.
Library			../tests/MonitoringExtra.py		${dataDir}
Test Timeout	300

# This section contains the test cases
*Test Case*
# The first line is the name of the test case. I'm fairly certain it can be any string.
Monitoring Basic Tests
	# Here is where metadata about the test is listed. We currently only use tags.
	[Tags]						level-0
	# This line is the name of the method that is to be called. In this case, MonitoringBasic.monitoring_base_test()
	# It must exactly match, except that () is excluded, and _ becomes a space. It doesn't matter which imported
	# library it is from, the framework will figure it out.
	monitoring common test
Monitoring Change Admin PW Test
	[Tags]	regression				level-0
	monitoring change admin pw
Monitoring Create Logging Datasource Test
	[Tags]	regression				level-0
	monitoring create logging datasource