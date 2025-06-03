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

class MonitoringScripts(BaseTest): # This test class inherits from BaseTest
	
	
	def monitoring_change_admin_pw(self):

		self.log.trace("Starting change grafana admin pw test")
		
		#Find the original pw for the admin user
		
		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/monitoring/bin/change_grafana_admin_password.sh", "-p", "admin"])
		if rc != 0:
			self.log.error("Attempt to change the admin password failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully changed the admin password.")
			self.log.debug(stdout)
		
		#Find the Grafana service
		
		#out, err, rc = self._basic_call(["kubectl", "describe", "pods", "-n", "monitoring"])
		#out_list = out.splitlines()
		#print ("kubectl output = " + str(out_list))
		
			
		#See if new pw is successful in grafana
		
		#response = self._rest_get("https://" + es_service.dns + ":" + str(port), auth=("admin", "admin"))
		#print ("response=" + str(response))

		#Change the password back to the original
		
		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/monitoring/bin/change_grafana_admin_password.sh", "-p", "Go4thsas"])
		if rc != 0:
			self.log.error("Attempt to change the admin password back to original failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			self.log.info("Successfully changed the admin password back to original.")
			self.log.debug(stdout)
			
	def monitoring_create_logging_datasource(self):

		self.log.trace("Starting create logging datasource script test")
		
		#Run the create logging datasource script
		
		stdout, stderr, rc = self._basic_call([self.v4m_repo + "/monitoring/bin/create_logging_datasource.sh"])
		if rc != 0:
			self.log.error("Attempt to run create_logging_datasource.sh failed.")
			self.log.debug(stderr)
			self.log.debug(stdout)
		else:
			stdout_list = stdout.splitlines()
			print ("log output = " + str(stdout_list))
			
			for index, line in enumerate(stdout_list):
				if "INFO Logging data source in Grafana has been configured. " in line:
					print ("I found the logging datasource creation configuration message.")
					break
			
			self.log.info("Successfully ran create_logging_datasource script.")
			self.log.debug(stdout)		
		
			
def main():
	print("Running as a script...")
	testObject=MonitoringScripts(False)
	testObject.monitoring_change_admin_pw()
	testObject.monitoring_create_logging_datasource()
	print("Testing complete")


if __name__ == '__main__':
	main()