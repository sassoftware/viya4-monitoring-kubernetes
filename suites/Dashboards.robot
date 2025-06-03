*** Comments ***
http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#creating-test-suites

*** Settings ***
Resource		../data/global_resources.tsv
Library			../tests/MonitoringProcess.py
Test Timeout	300

*** Test Cases ***
Custom dashboards in user dir during install
	[Documentation]	C652347
	[Tags]	level-0
	install with user dir	${dash_set_three}				# Installs with custom dashboards											# Verify default and set three exist
	install without dash									# Installs, then runs dash deploy with no args								# Verify defaults exist
	install with dash										# Installs with default dashboards											# Verify defaults exist
	
Deploy and update custom dashboards
	[Documentation]	Deploy custom dashboards, then update them
	[Tags]	level-1
	install single dash	${single_dash}	foo					# dash deploy with garbage string (not file or directory)					# Verify failure
	install single dash	${single_dash}	bars.txt			# file exists, but not .json												# Verify failure
	install single dash	${single_dash}	garbage.json		# file exists, but not correct json											# Verify no dashboard
	install single dash	${single_dash}	bars.json			# valid dashboard															# Verify bars exists
	install many dash	${dash_set_one}						# 2 valid dashboards, 2 invalid files										# Verify set one exists
	install many dash	${dash_set_two}	true				# dash deploy with no args, dashboards in $USER_DIR (2 valid, 2 invalid)	# Verify set two exists
	install single dash	${single_dash}	bars_updated.json	# update single dashboard													# Verify bars updated
	install many dash	${updated_set_one}					# update set of dashboards													# Verify set one updated
	install many dash	${updated_set_two}	true			# update set of dashboards, dashboards in $USER_DIR							# Verify set two updated
