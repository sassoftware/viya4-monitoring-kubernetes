from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os


class LoggingInstall(BaseTest):
	def check_logging_install(self):
		self.log.trace("Starting test for the deploy_logging.sh script.")
		
		self._load_process_logs()
		key = "logging_install"
		error_count = 0
		for line in self.process_logs[key]:
			if "ERROR" in line:
				error_count += 1
				self.log.debug(line)
		summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-1]
		self.log.info("Process Results: " + summary) # Skips empty lines and debug lines
		error_status = error_count + self.process_rcs[key]

		asserts.assert_equal(error_status, 0, "Script deploy_logging.sh failed to run successfully.")
		self.log.trace("Completed test for namespace_install")

	def check_logging_uninstall(self):
		self.log.trace("Starting test for the remove_logging.sh script.")
		
		self._load_process_logs()
		key = "logging_remove"
		error_count = 0
		for line in self.process_logs[key]:
			if "ERROR" in line:
				error_count += 1
				self.log.debug(line)
		summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-1]
		self.log.info("Process Results: " + summary) # Skips empty lines and debug lines
		error_status = error_count + self.process_rcs[key]

		asserts.assert_equal(error_status, 0, "Script remove_logging.sh failed to run successfully.")
		self.log.trace("Completed test for namespace_install")
		


def main():
	print("Running as a script...")
	testObject = LoggingInstall(False)
	testObject.logging_secrets_create_user()
	print("Testing complete")

if __name__ == '__main__':
	main()