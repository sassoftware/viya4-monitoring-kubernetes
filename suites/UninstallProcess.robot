*** Comments ***
http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#creating-test-suites

*** Settings ***
Resource		../data/global_resources.tsv
Library			../tests/ProcessRunner.py	True
Library			../tests/LoggingInstall.py	True
Library			../tests/MonitoringSmoke.py		True
Test Timeout	300

*** Test Cases ***
Uninstall V4M cluster and namespace
	[Documentation]	C652347
	[Timeout]	1800
	[Tags]	full
	v4m uninstall process	user_dir=${requested_user_dir}

Uninstall cluster and namespace monitoring
	[Documentation]	C652347
	[Timeout]	1800
	[Tags]	no-logging
	v4m uninstall process		v4m_logging=False	user_dir=${requested_user_dir}

Uninstall logging
	[Documentation]	C652347
	[Timeout]	1800
	[Tags]	no-monitoring
	v4m uninstall process		v4m_monitoring=False	v4m_namespace=False		user_dir=${requested_user_dir}

Uninstall only namespace monitoring
	[Documentation]	C652347
	[Timeout]	1800
	[Tags]	just-namespace
	v4m uninstall process		v4m_monitoring=False	v4m_logging=False	user_dir=${requested_user_dir}

Uninstall V4M cluster only
	[Documentation]	C652347
	[Timeout]	1800
	[Tags]	no-viya
	v4m uninstall process		v4m_namespace=False		user_dir=${requested_user_dir}

Test the Process execution
	[Documentation]	C652347
	[Tags]	full	no-logging	no-monitoring	just-namespace	no-viya
	process test test

Test for Successful Logging uninstall
	[Tags]	full	no-monitoring	no-viya 
	check logging uninstall

Test for Successful Monitoring uninstall
	[Tags]	full	no-logging	no-viya 
	cluster uninstall test

Test for Successful Namespace uninstall
	[Tags]	full	no-logging	just-namespace 
	viya uninstall test
