*** Comments ***
http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#creating-test-suites

*** Settings ***
Resource		../data/global_resources.tsv
Library			../tests/ProcessRunner.py	True
Library			../tests/LoggingInstall.py		True
Library			../tests/MonitoringSmoke.py		True
Test Timeout	300

*** Test Cases ***
Install V4M cluster and namespace
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	full
	v4m install process		user_dir=${requested_user_dir}	airgap=True

Install cluster and namespace monitoring
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	no-logging
	v4m install process		v4m_logging=False	user_dir=${requested_user_dir}	airgap=True

Install logging
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	no-monitoring
	v4m install process		v4m_monitoring=False	v4m_namespace=False		user_dir=${requested_user_dir}	airgap=True

Install only namespace monitoring
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	just-namespace
	v4m install process		v4m_monitoring=False	v4m_logging=False	user_dir=${requested_user_dir}	airgap=True

Install V4M cluster only
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	no-viya
	v4m install process		v4m_namespace=False		user_dir=${requested_user_dir}	airgap=True

Test the Process execution
	[Documentation]	C652347
	[Tags]	full	no-logging	no-monitoring	just-namespace	no-viya
	process test test

Check for Successful Logging Installation
	[Tags]	full	no-monitoring	no-viya	level-0	regression
	check logging install

Check for Successful Cluster Monitoring Install
	[Tags]	full	no-logging	no-viya	regression	level-0
	cluster install smoke test

Check for Successful Namespace Monitoring Install
	[Tags]	full	no-logging	just-namespace	regression	level-0
	viya install smoke test
