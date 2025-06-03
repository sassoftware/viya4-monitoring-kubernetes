*** Comments ***
http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#creating-test-suites

*** Settings ***
Resource		../data/global_resources.tsv
Library			../tests/ProcessRunner.py	True
Library			../tests/LoggingInstall.py		True
Library			../tests/MonitoringSmoke.py		True
Test Timeout	300

*** Test Cases ***
Non-Disruptive Update of V4M cluster and namespace
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	full	ndu
	v4m install process		user_dir=${requested_user_dir}

Non-Disruptive Update of cluster and namespace monitoring
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	no-logging	ndu
	v4m install process		v4m_logging=False	user_dir=${requested_user_dir}

Non-Disruptive Update of logging
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	no-monitoring	ndu
	v4m install process		v4m_monitoring=False	v4m_namespace=False		user_dir=${requested_user_dir}

Non-Disruptive Update of only namespace monitoring
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	just-namespace	ndu
	v4m install process		v4m_monitoring=False	v4m_logging=False	user_dir=${requested_user_dir}

Non-Disruptive Update of V4M cluster only
	[Documentation]	C652347
	[Timeout]	2000
	[Tags]	no-viya	ndu
	v4m install process		v4m_namespace=False		user_dir=${requested_user_dir}

Clean update of V4M cluster and namespace
	[Documentation]	C652347
	[Timeout]	3500
	[Tags]	full	clean
	v4m update process

Clean update of cluster and namespace monitoring
	[Documentation]	C652347
	[Timeout]	3000
	[Tags]	no-logging	clean
	v4m update process		v4m_logging=False

Clean update of logging
	[Documentation]	C652347
	[Timeout]	3000
	[Tags]	no-monitoring	clean
	v4m update process		v4m_monitoring=False	v4m_namespace=False

Clean update of only namespace monitoring
	[Documentation]	C652347
	[Timeout]	3000
	[Tags]	just-namespace	clean
	v4m update process		v4m_monitoring=False	v4m_logging=False

Clean update of V4M cluster only
	[Documentation]	C652347
	[Timeout]	3000
	[Tags]	no-viya	clean
	v4m update process		v4m_namespace=False

Test the Process execution
	[Documentation]	C652347
	[Tags]	full	no-logging	no-monitoring	just-namespace	no-viya	clean	ndu
	process test test

Check for Successful Logging Installation
	[Tags]	full	no-monitoring	no-viya	level-0	ndu	regression	clean
	check logging install

Check for Successful Cluster Monitoring Install
	[Tags]	full	no-logging	no-viya	regression	level-0	ndu	clean
	cluster install smoke test

Check for Successful Namespace Monitoring Install
	[Tags]	full	no-logging	just-namespace	regression	level-0	ndu	clean
	viya install smoke test

Test for Successful Logging uninstall
	[Tags]	full	no-monitoring	no-viya	clean 
	check logging uninstall

Test for Successful Monitoring uninstall
	[Tags]	full	no-logging	no-viya	clean
	cluster uninstall test

Test for Successful Namespace uninstall
	[Tags]	full	no-logging	no-viya	clean
	viya uninstall test
