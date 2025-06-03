from robot.utils import asserts
from os import environ
from utils import BaseTest
import re
import sys
import os
import requests
import subprocess
import glob
import shutil
import json
import base64
import opensearchpy
from contextlib import contextmanager
from urllib.parse import urlparse

class LoggingScripts(BaseTest): # This test class inherits from BaseTest
	
	
	def logging_change_admin_pw(self):

		self.log.trace("Starting change admin pw test")
		
		#Find the original pw for the admin user
		
		stdout, err, rc = self._basic_call(["kubectl", "get", "secret", "internal-user-admin",  "-o=jsonpath='{.data.password}' ", "-n", "logging"])
		if rc != 0:
			self.log.error("Attempt to find the original admin password failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully found the original admin password.")
			self.log.debug(stdout)
			pw_name = base64.b64decode(stdout)
			str_pw = str(pw_name)
			#print ("before strip:  " + str_pw)
			orig_pw = str_pw.strip("b'")
			print ("Original pw is:" + str(orig_pw))


		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/change_internal_password.sh", "admin", "Go4thandtest"])
		if rc != 0:
			self.log.error("Attempt to change the admin password failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully changed the admin password.")
			self.log.debug(stdout)
		
		#Find the Elasticsearch service
		
		
		#out, err, rc = self._basic_call(["kubectl", "describe", "pods", "-n", "logging"])
		#out_list = out.splitlines()
		#print ("kubectl output = " + str(out_list))
		
		#logging_services = self.kubectl.get_services("logging")
		
		#for service in logging_services:
		#	if "v4m-es-client" in service.name:
		#		es_service = service
		#		#print ("I found the es service.")
		#		#print (es_service)
		#		break
				
		#port = es_service.ports["http"]
		#print ("port= " + str(port))
		
		#See if new pw is successful in elasticsearch
		
		#response = self._rest_get("https://" + es_service.dns + ":" + str(port), auth=("admin", "admin"))
		#print ("response=" + str(response))

		#Change the password back to the original
		
		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/change_internal_password.sh", "admin", orig_pw])
		if rc != 0:
			self.log.error("Attempt to change the admin password back to original failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully changed the admin password back to original.")
			self.log.debug(stdout)

	def logging_change_kibanaserver_pw(self):

		self.log.trace("Starting change kibanaserver pw")
		
		admin_name = "kibanaserver"
		pw_name = "admin"

		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/change_internal_password.sh", "kibanaserver", "Go4thandtest"])
		if rc != 0:
			self.log.error("Attempt to change the kibanaserver password failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully changed the kibanaserver password.")
			self.log.debug(stdout)
		
		stdout, stderr, rc = self._basic_call(["kubectl", "-n", "logging", "delete", "pods", "-l", "app=opensearch-dashboards"])
		#stdout, stderr, rc = self._basic_call(["kubectl", "-n", "logging", "delete", "pods", "-l", "'", "app", "=", "opensearch-dashboards", "'"])
		if rc != 0:
			self.log.error("Attempt to bounce opensearch dashboards pod failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully bounced opensearch dashboards pod.")
			self.log.debug(stdout)		
				

	def logging_change_logadm_pw(self):

		self.log.trace("Starting change logadm password test")
		
		#admin_name = "logadm"
		#pw_name = "admin"

		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/change_internal_password.sh", "logadm", "Go4thsas!"])
		if rc != 0:
			self.log.error("Attempt to change the logadm password failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully changed the logadm password.")
			self.log.debug(stdout)
		
		#stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/change_internal_password.sh", "logadm", "Go4thandtest"])
		#if rc != 0:
		#	self.log.error("Attempt to change the admin password back to original failed.")
		#	self.log.debug(stderr)
		#	self.log.debug(stdout)
		#else:
		#	self.log.info("Successfully changed the admin password back to original.")
		#	self.log.debug(stdout)


	def logging_change_logcollector_pw(self):

		self.log.trace("Starting change logcollector password test")
		
		admin_name = "logcollector"
		pw_name = "admin"

		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/change_internal_password.sh", "logcollector", "Go4thandtest"])
		if rc != 0:
			self.log.error("Attempt to change the logcollector password failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully changed the logcollector password.")
			self.log.debug(stdout)
		
		stdout, stderr, rc = self._basic_call(["kubectl", "-n", "logging", "delete", "pods", "-l", "app.kubernetes.io/name=fluent-bit, fbout=es"])
		#stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/change_internal_password.sh", "logcollector", "Go4thsas"])
		if rc != 0:
			self.log.error("Attempt to bounce fluent-bit pods failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully bounced fluent-bit pods.")
			self.log.debug(stdout)			


	def logging_change_metricgetter_pw(self):

		self.log.trace("Starting Log monitoring script process")
		
		admin_name = "metricgetter"
		pw_name = "admin"

		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/change_internal_password.sh", "metricgetter", "Go4thandtest"])
		if rc != 0:
			self.log.error("Attempt to change the metricgetter password failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully changed the metricgetter password.")
			self.log.debug(stdout)
		
		
		stdout, stderr, rc = self._basic_call(["kubectl", "-n", "logging", "delete", "pod", "-l", "app=prometheus-elasticsearch-exporter"])
		#stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/change_internal_password.sh", "metricgetter", "Go4thsas"])
		if rc != 0:
			self.log.error("Attempt to bounce prometheus-elasticsearch-exporter failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully bounced prometheus-elasticsearch-exporter pod.")
			self.log.debug(stdout)			

	def logging_show_app_url(self):
	
			self.log.trace("Starting show app url")
			
			#admin_name = "admin"
			#pw_name = "Go4thsas"
			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/bin/show_app_url.sh"])
			if rc != 0:
				self.log.error("Attempt to run show_app_url.sh failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				stdout_list = stdout.splitlines()
				print ("log output = " + str(stdout_list))
				
				for index, line in enumerate(stdout_list):
					if "You can access OpenSearch Dashboards via the following URL: " in line:
						osd_url=stdout_list[index + 1]
						print ("I found the osd url.")
						print (osd_url)
						break

				self.log.info("Successfully ran show_app_url.sh.")
				self.log.debug(stdout)
				
			#Ping OSD URL
			osd_url=osd_url.strip()
			print (osd_url)
			response = self._rest_get(osd_url, auth=("admin", "Go4thsas"))
			print ("response=" + str(response))
			
			self.log.info("Successfully pinged the OSD url.")
			self.log.debug(stdout)

	def logging_ping_os_url(self):
	
			self.log.trace("Starting ping os url")
			
			admin_name = "admin"
			pw_name = "Go4thsas"
			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/bin/show_app_url.sh"])
			if rc != 0:
				self.log.error("Attempt to run show_app_url.sh failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				stdout_list = stdout.splitlines()
				print ("log output = " + str(stdout_list))
				
				for index, line in enumerate(stdout_list):
					if "You can access OpenSearch via the following URL: " in line:
						os_url=stdout_list[index + 1]
						print ("I found the opensearch url.")
						print (os_url)
						break
				
			#Ping OpenSearch URL
			os_url=os_url.strip()
			print (os_url)
			response = self._rest_get(os_url, auth=("admin", "Go4thsas"))
			print ("response=" + str(response))
			
			self.log.info("Successfully pinged the OpenSearch url.")
			self.log.debug(stdout)


	def logging_create_user(self):
	
			self.log.trace("Starting Create user test")
			
			#admin_name = "admin"
			#pw_name = "Go4thsas"

			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/onboard.sh", "-ns",self.viya_namespace])
			if rc != 0:
				self.log.error("Attempt to onboard the viya namespace failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully onboarded the viya namespace.")
				self.log.debug(stdout)
			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/user.sh", "create", "-ns", self.viya_namespace, "-u", "susan", "-p", "susan"])
			if rc != 0:
				self.log.error("Attempt to run user.sh create failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully created the user.")
				self.log.debug(stdout)
				
			self.log.info("Success! Onboarded namespace and created user")
			self.log.debug(stdout)
			
			self.log.trace("Starting delete user test")
			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/offboard.sh", "-ns",self.viya_namespace])
			if rc != 0:
				self.log.error("Attempt to offboard the viya namespace failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully offboarded the viya namespace.")
				self.log.debug(stdout)
						
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/user.sh", "delete", "-ns", self.viya_namespace, "-u", "susan", "-p", "susan"])
			if rc != 0:
				self.log.error("Attempt to run user.sh delete failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully ran the user.sh delete .")
				self.log.debug(stdout)
			
			self.log.info("Success! Offboarded namespace and deleted user")
			self.log.debug(stdout)

	def logging_create_tenant(self):
	
			self.log.trace("Starting Create tenant test")
			
			#admin_name = "admin"
			#pw_name = "Go4thsas"

			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/onboard.sh", "-t", "susan", "-ns",self.viya_namespace])
			if rc != 0:
				self.log.error("Attempt to onboard the viya namespace failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully onboarded the viya namespace and associated tenant.")
				self.log.debug(stdout)
			
			
			self.log.trace("Starting delete tenant test")
			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/offboard.sh", "-t", "susan", "-ns",self.viya_namespace])
			if rc != 0:
				self.log.error("Attempt to offboard the viya namespace failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully offboarded the viya namespace and tenant.")
				self.log.debug(stdout)
							
	def logging_configure_nodeport(self):
	
			self.log.trace("Starting configure nodeport test")
			
			#admin_name = "admin"
			#pw_name = "Go4thsas"

			#nodeport_list=("OPENSEARCH", "OPENSEARCHDASHBOARDS", "GRAFANA")
			#I did not want to add the Grafana because that should be in the monitoring regressions testing.
			
			#enable/disable OPENSEARCH nodeport
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/bin/configure_nodeport.sh", "OPENSEARCH"])
			if rc != 0:
				self.log.error("Attempt to enable nodeport OPENSEARCH failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully enabled OPENSEARCH nodeport.")
				self.log.debug(stdout)
			
			self.log.trace("Starting disable nodeport test")
			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/bin/configure_nodeport.sh", "OPENSEARCH", "disable"])
			if rc != 0:
				self.log.error("Attempt to disable nodeport OPENSEARCH failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully disabled OPENSEARCH nodeport.")
				self.log.debug(stdout)
				
			#enable/disable OPENSEARCHDASHBOARDS nodeport	
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/bin/configure_nodeport.sh", "OPENSEARCHDASHBOARDS"])
			if rc != 0:
				self.log.error("Attempt to enable nodeport OPENSEARCHDASHBOARDS failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully enabled OPENSEARCHDASHBOARDS nodeport.")
				self.log.debug(stdout)
			
			
			self.log.trace("Starting disable nodeport test")
			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/bin/configure_nodeport.sh", "OPENSEARCHDASHBOARDS", "disable"])
			if rc != 0:
				self.log.error("Attempt to disable nodeport OPENSEARCHDASHBOARDS failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully disabled OPENSEARCHDASHBOARDS nodeport.")
				self.log.debug(stdout)
				
	def logging_onboard_all(self):
	
			self.log.trace("Starting onboard all test")
			
			#admin_name = "admin"
			#pw_name = "Go4thsas"

			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/onboard.sh", "-t", "susan", "-ns",self.viya_namespace, "-u", "susan", "-p", "susan"])
			if rc != 0:
				self.log.error("Attempt to onboard the viya namespace failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully onboarded the viya namespace and associated tenant.")
				self.log.debug(stdout)
			
			
			self.log.trace("Starting offboard all test")
			
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/offboard.sh", "-t", "susan", "-ns",self.viya_namespace])
			if rc != 0:
				self.log.error("Attempt to offboard all failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully offboarded all.")
				self.log.debug(stdout)
				
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/user.sh", "delete", "-ns", self.viya_namespace, "-u", "susan", "-p", "susan"])
			if rc != 0:
				self.log.error("Attempt to run user.sh delete failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully ran the user.sh delete .")
				self.log.debug(stdout)

	def logging_create_rbac(self):
	
			self.log.trace("Starting Create rbac test")
			
			#admin_name = "admin"
			#pw_name = "Go4thsas"

			#Create rbac with only namespace
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/security_create_rbac.sh", self.viya_namespace])
			if rc != 0:
				self.log.error("Attempt to create rbac failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully created rbac.")
				self.log.debug(stdout)
			
			
			self.log.trace("Starting delete rbac test")
			
			#Delete rbac with only namespace
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/security_delete_rbac.sh", self.viya_namespace])
			if rc != 0:
				self.log.error("Attempt to delete the rbac failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully deleted the rbac.")
				self.log.debug(stdout)
				
			#Create a tenant for testing rbac	
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/onboard.sh", "-t", "susan", "-ns",self.viya_namespace])
			if rc != 0:
				self.log.error("Attempt to create tenant failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully created the tenant.")
				self.log.debug(stdout)	
			
			#Create rbac with tenant and namespace 
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/security_create_rbac.sh", self.viya_namespace, "susan"])
			if rc != 0:
				self.log.error("Attempt to create rbac with tenant failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully created rbac with tenant.")
				self.log.debug(stdout)
				
			#Delete rbac with tenant	
			stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/security_delete_rbac.sh", self.viya_namespace, "susan"])
			if rc != 0:
				self.log.error("Attempt to delete the rbac with tenant failed.")
				self.log.debug(stderr)
				self.log.debug(stdout)
			else:
				self.log.info("Successfully deleted the rbac.")
				self.log.debug(stdout)			

	def logging_get_generated_pw(self):

		self.log.trace("Starting get generated pw test")
		
		#Find the original pw for the admin user
		
		stdout, err, rc = self._basic_call(["kubectl", "get", "secret", "internal-user-admin",  "-o=jsonpath='{.data.password}' ", "-n", "logging"])
		if rc != 0:
			self.log.error("Attempt to find the original admin password failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully found the original admin password.")
			self.log.debug(stdout)
			pw_name = base64.b64decode(stdout)
			str_pw = str(pw_name)
			#print ("before strip:  " + str_pw)
			orig_pw = str_pw.strip("b'")
			print ("Original pw is:" + str(orig_pw))
		
		#Get the url for opensearch to test generated pw
			
		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/bin/show_app_url.sh"])
		if rc != 0:
			self.log.error("Attempt to run show_app_url.sh failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			stdout_list = stdout.splitlines()
			print ("log output = " + str(stdout_list))
			
			for index, line in enumerate(stdout_list):
				if "You can access OpenSearch Dashboards via the following URL: " in line:
					osd_url=stdout_list[index + 1]
					print ("I found the osd url.")
					print (osd_url)
					break
			self.log.info("Successfully ran show_app_url.sh.")
			self.log.debug(stdout)
			
		#Ping OSD URL
		osd_url=osd_url.strip()
		print (osd_url)
		response = self._rest_get(osd_url, auth=("admin", orig_pw))
		print ("response=" + str(response))
		
		self.log.info("Successfully pinged the OSD url.")
		self.log.debug(stdout)
		
	def logging_run_nonopenshift_script(self):

		self.log.trace("Starting run NonOpenshift script")
		

		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/deploy_logging.sh"])
		if rc != 0:
			self.log.info("Attempt to run deploy_logging.sh on Openshift correctly failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.error("FAILURE! deploy_logging.sh should not work on Openshift deployment.")
			self.log.debug(stdout)
						
	def logging_remove_nonopenshift_script(self):

		self.log.trace("Starting remove NonOpenshift script")
		

		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/remove_logging.sh"])
		if rc != 0:
			self.log.info("Attempt to run remove_logging.sh on Openshift correctly failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.error("FAILURE! remove_logging.sh should not work on Openshift deployment.")
			self.log.debug(stdout)
						
	def logging_run_openshift_script(self):

		self.log.trace("Starting run Openshift script on nonOpenshift cluster")
		

		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/deploy_logging_openshift.sh"])
		if rc != 0:
			self.log.info("Attempt to run deploy_logging_openshift.sh on nonOpenshift correctly failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.error("FAILURE! deploy_logging_openshift.sh should not work on nonOpenshift cluster deployment.")
			self.log.debug(stdout)
						
	def logging_remove_openshift_script(self):

		self.log.trace("Starting remove Openshift script on nonOpenshift cluster")
		

		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/remove_logging_openshift.sh"])
		if rc != 0:
			self.log.info("Attempt to run remove_logging_openshift.sh on nonOpenshift correctly failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.error("FAILURE! remove_logging_openshift.sh should not work on nonOpenshift cluster deployment.")
			self.log.debug(stdout)

	def logging_getlogs_default_parms(self):

		self.log.trace("Starting getlogs.py default parm test")
		
		#Get connection information for the cluster
		
		#Get the url for opensearch to test generated pw
				
		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/bin/show_app_url.sh"])
		if rc != 0:
			self.log.error("Attempt to run show_app_url.sh failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			stdout_list = stdout.splitlines()
			print ("log output = " + str(stdout_list))
			
			for index, line in enumerate(stdout_list):
				if "You can access OpenSearch via the following URL: " in line:
					os_url=stdout_list[index + 1]
					print ("I found the opensearch url.")
					print (os_url)
					break
				
		#Ping OpenSearch URL to see if it's enabled
		os_url=os_url.strip()
		print (os_url)
		response = self._rest_get(os_url, auth=("admin", "admin"))
		print ("response=" + str(response))
		
		
		self.log.info("Successfully pinged the OpenSearch url.")
		self.log.debug(stdout)
		url=urlparse(os_url)
		print (url.hostname)
		print (url.port)
		
		#Test getlogs.py using default parms
		
		stdout, stderr, rc = self._basic_call(["python3", self.v4m_repo + "/logging/bin/getlogs.py", "--host", url.hostname, "--port", str(url.port), "--user", "admin", "--password", "admin" ])
		if rc != 0:
			self.log.error("Attempt to run getlogs.py failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully ran getlogs.py.")
			self.log.debug(stdout)	
			
	def logging_create_openshift_route(self):

		self.log.trace("Starting create Openshift route script on Openshift cluster")
		

		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/logging/bin/create_openshift_route.sh OpenSearch"])
		if rc != 0:
			self.log.info("Attempt to run create_openshift_route.sh was successful!")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.error("FAILURE! create_openshift_route.sh did not run.")
			self.log.debug(stdout)
			
		#Get the url for opensearch to test generated pw
		
		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/bin/show_app_url.sh"])
		if rc != 0:
			self.log.error("Attempt to run show_app_url.sh failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			stdout_list = stdout.splitlines()
			print ("log output = " + str(stdout_list))
			
			for index, line in enumerate(stdout_list):
				if "You can access OpenSearch via the following URL: " in line:
					os_url=stdout_list[index + 1]
					print ("I found the opensearch url.")
					print (os_url)
					break
			
		#Ping OpenSearch URL
		os_url=os_url.strip()
		print (os_url)
		response = self._rest_get(os_url, auth=("admin", "Go4thsas"))
		print ("response=" + str(response))
		
		self.log.info("Successfully pinged the OpenSearch url after creating the route on openshift.")
		self.log.debug(stdout)


def main():
	print("Running as a script...")
	testObject=LoggingScripts(False)
	testObject.logging_show_app_url()
	testObject.logging_ping_os_url()
	testObject.logging_change_admin_pw()
	testObject.logging_change_kibanaserver_pw()
	testObject.logging_change_logadm_pw()
	testObject.logging_change_logcollector_pw()
	testObject.logging_change_metricgetter_pw()
	testObject.logging_create_user()
	testObject.logging_create_tenant()
	testObject.logging_onboard_all()
	testObject.logging_configure_nodeport()
	testObject.logging_create_rbac()
	testObject.logging_get_generated_pw()
	testObject.logging_run_nonopenshift_script()
	testObject.logging_remove_nonopenshift_script()
	testObject.logging_run_openshift_script()
	testObject.logging_remove_openshift_script()
	testObject.logging_getlogs_default_parms()
	testObject.logging_create_openshift_route()
	print("Testing complete")


if __name__ == '__main__':
	main()
