from robot.utils import asserts
from os import environ
from utils import BaseTest
import re, sys, os, requests

class MonitoringExtra(BaseTest): # This test class inherits from BaseTest
	
	def monitoring_another_test(self): # marked inactive in the test suite, so it won't run.
		self.log.trace("Just a no-op example")		

def main():
	print("Running as a script...")
	print("Testing complete")

if __name__ == '__main__':
	main()