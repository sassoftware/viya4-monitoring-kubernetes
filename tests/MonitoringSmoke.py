from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class MonitoringSmoke(BaseTest): # This test class inherits from BaseTest
	
	def cluster_install_smoke_test(self):
		self.log.trace("Starting test for the deploy_monitoring_cluster.sh script.")
		
		self._load_process_logs()
		key = "monitoring_install"
		error_count = 0
		for line in self.process_logs[key]:
			if "ERROR" in line:
				error_count += 1
				self.log.debug(line)
		summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-1]
		self.log.info("Process Results: " + summary) # Skips empty lines and debug lines
		error_status = error_count + self.process_rcs[key]
		
		asserts.assert_equal(error_status, 0, "Script deploy_monitoring_cluster.sh failed to run successfully.")
		self.log.trace("Completed test for monitoring_install")

	def viya_install_smoke_test(self):
		self.log.trace("Starting test for the deploy_monitoring_viya.sh script.")
		
		self._load_process_logs()
		key = "namespace_install"
		error_count = 0
		for line in self.process_logs[key]:
			if "ERROR" in line: 
				error_count += 1
				self.log.debug(line)
		summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-1]
		self.log.info("Process Results: " + summary) # Skips empty lines and debug lines
		error_status = error_count + self.process_rcs[key]

		asserts.assert_equal(error_status, 0, "Script deploy_monitoring_viya.sh failed to run successfully.")
		self.log.trace("Completed test for namespace_install")

	def cluster_uninstall_test(self):
		self.log.trace("Starting test for the remove_monitoring_cluster.sh script.")
		
		self._load_process_logs()
		key = "monitoring_remove"
		error_count = 0
		for line in self.process_logs[key]:
			if "ERROR" in line:
				error_count += 1
				self.log.debug(line)
		summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-1]
		self.log.info("Process Results: " + summary) # Skips empty lines and debug lines
		error_status = error_count + self.process_rcs[key]
		
		asserts.assert_equal(error_status, 0, "Script remove_monitoring_cluster.sh failed to run successfully.")
		self.log.trace("Completed test for monitoring_remove key")

	def viya_uninstall_test(self):
		self.log.trace("Starting test for the remove_monitoring_viya.sh script.")
		
		self._load_process_logs()
		key = "namespace_remove"
		error_count = 0
		for line in self.process_logs[key]:
			if "ERROR" in line: 
				error_count += 1
				self.log.debug(line)
		summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-1]
		self.log.info("Process Results: " + summary) # Skips empty lines and debug lines
		error_status = error_count + self.process_rcs[key]

		asserts.assert_equal(error_status, 0, "Script remove_monitoring_viya.sh failed to run successfully.")
		self.log.trace("Completed test for namespace_remove key")
			

def main():
	print("Running as a script...")
	print("Testing complete")

if __name__ == '__main__':
	main()