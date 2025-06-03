*** Comments ***
#http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#creating-test-suites

# This section is where files are imported and parameters are set
*** Settings ***
Resource		../data/global_resources.tsv
# If your python class takes parameters, these must be included
Library			../tests/LoggingSecretsFunctions.py	True
Library			../tests/LoggingSecurityFunctions.py	True
Library			../tests/LoggingScripts.py		True
Library			../tests/LoggingCommonFunctions.py	True
Test Timeout	300

# This section contains the test cases
*Test Cases*
Logging Secrets Functions Test
	# Here is where metadata about the test is listed. We currently only use tags.
	[Tags]						level-0
	# This line is the name of the method that is to be called. 
	# It must exactly match, except that () is excluded, and _ becomes a space. It doesn't matter which imported
	# library it is from, the framework will figure it out.
	logging k8s secrets functions
Logging Security Functions Test
	[Tags]						level-0
	logging apiacccess
Logging RBAC Functions Test
	[Tags]						level-0
	logging rbac
Logging Common Functions Test
	[Tags]						level-0
        logging require opensearch
Logging Show App URL Test
	[Tags]	regression				level-0
	logging show app url
Logging Ping OS URL Test
	[Tags]	regression				level-0
	logging ping os url
Logging Change Admin PW Test
	[Tags]	regression				level-0
	logging change admin pw
Logging Change Kibanaserver PW Test
	[Tags]	regression				level-0
	logging change kibanaserver pw
Logging Change Logadm PW Test
	[Tags]	regression				level-0
	logging change logadm pw
Logging Change Logcollector PW Test
	[Tags]	regression				level-0
	logging change logcollector pw
Logging Change Metricgetter PW Test
	[Tags]	regression				level-0
	logging change metricgetter pw
Logging Create User Test
	[Tags]	regression				level-0
	logging create user
Logging Create Tenant Test
	[Tags]	regression				level-0
	logging create tenant
Logging Create Onboard All Test
	[Tags]	regression				level-0
	logging onboard all
#Logging Configure Nodeport Test
#	[Tags]	regression				level-0
#	logging configure nodeport
Logging Create RBAC Test
	[Tags]	regression				level-0
	logging create rbac
Logging Get Generated PW Test
	[Tags]	regression				level-0
	logging get generated pw
Logging Run NonOpenshift Script Test
	[Tags]	aro
	logging run nonopenshift script
Logging Remove NonOpenshift Script Test
	[Tags]	aro
	logging remove nonopenshift script
Logging Run Openshift Script Test
	[Tags]	aks
	logging run openshift script
Logging Remove Openshift Script Test
	[Tags]	aks
	logging remove openshift script
Logging Getlogs Default Parms Test
	[Tags]	regression				level-0
	logging getlogs default parms
Logging Create Openshift Route
	[Tags]	aro
	logging create openshift route
