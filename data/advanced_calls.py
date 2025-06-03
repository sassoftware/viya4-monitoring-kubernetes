import select
import tempfile
import re
import json
from v4mtesting.tests.ProcessRunner import ProcessRunner


class CustomUserDir(ProcessRunner):
	
	def test_pull_request_install(self):
		self.log.trace("Starting V4M install process for a pull request branch")
		
		# These are already set, but you can modify them if needed.
		self.viya_namespace = "Artemis2"
		self.monitoring_namespace = "monitoring"
		self.logging_namespace = "logging"
		
		self._setup("custom_user_dirs/branch-user-dir") # This path is appended to the data directory.
		self._v4m_install(v4m_monitoring=True, v4m_logging=True, v4m_namespace=True)
		
		self.log.info("Process Results:")
		for key in self.process_logs:
			self.log.info(">> " + [i for i in self.process_logs[key] if i][-2]) # skip the last line, which is a "delete tmp dir" line
		
		if self.process_fail: self.log.fail("Pull request branch installation completed but was not successful.") # Keep going to attempt cleanup
		
		self.process_fail = False # Clear it in case it's True from the install runs.
		self._remove_v4m(v4m_monitoring=True, v4m_logging=True, v4m_namespace=True)
		
		self.log.info("Cleanup Results:")
		for key in self.process_logs:
			if "remove" in key: # The remove logs are appended in process_logs, so we want to skip the install logs
				self.log.info(">> " + [i for i in self.process_logs[key] if i][-2]) # skip the last line, which is a "delete tmp dir" line
		
		self._export_process_logs() # Makes process logs available for further tests.
		
		if self.process_fail: self._error_exit("Cleanup failed: cluster in unknown state.")
		
		self.log.trace("Completed install")
	

class LocalCommand(object):
	def run(self, background=False):
		self.background = background
		try:
			self.call = subprocess.Popen(self.command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE) # stderr=subprocess.STDOUT for redirect
			self._process_stdin()
			if self.background:
				time.sleep(1)
				self.out = []
				self.err = []
				self.pollout = select.poll()
				self.pollerr = select.poll()
				self.pollout.register(self.call.stdout)
				self.pollerr.register(self.call.stderr)
				return self.call
			self.out, self.err = self.call.communicate()
			self.rc = self.call.returncode
		except:
			self.out = "Command execution failed: details in stderr."
			_, val, _ = sys.exc_info()
			self.err = str(val)
			self.rc = 42
			return (self.out, self.err, self.rc)
		
		self.output = (self.out, self.err, self.rc)
		return self._modify_output()
	
	def terminate(self):
		time.sleep(1)
		endtime = time.time() + 10
		while self.pollout.poll(1) and time.time() < endtime:
			self.out.append(self.call.stdout.readline().strip())
		endtime = time.time() + 10
		while self.pollerr.poll(1) and time.time() < endtime:
			self.err.append(self.call.stderr.readline().strip())
		self.call.terminate()
		endtime = time.time() + 30
		self.rc = self.call.poll()
		while self.rc is None and time.time() < endtime: 
			self.rc = self.call.poll()
		polltime = time.time() + 30 - endtime
		#self.call.stdin.close()
		#self.out, self.err = self.call.communicate()
		self.rc = self.call.returncode
		self.output = (self.out, self.err, self.rc)
		return self._modify_output()
	
	def stdin(self, stdin):
		self.input = tempfile.TemporaryFile()
		if isinstance(stdin, basestring): # if string
			self.input.write(stdin)
			self.input.seek(0)
		else:
			try: # if closed file
				with open(stdin, 'r') as data:
					self.input.write(data.read())
					self.input.seek(0)
			except TypeError: # Hopefully an open file
				self.input.write(stdin.read())
				self.input.seek(0)
				stdin.seek(0)
		if self.background and hasattr(self, "call"): self._process_stdin()
	# One-off commands that are defined in the methods, not passed in.
	def _process_stdin(self):
		if not self.input is None:
			for line in self.input:
				if self.tmp in line: line = line.replace(self.tmp, self.local)
				self.call.stdin.write(line)
			self.input = None
	
	def _json(self, json):
		json_file = tempfile.TemporaryFile()
		for line in json.splitlines():
			if isinstance(line, unicode): line = line.encode('utf-8')
			json_file.write(line + '\n')
		json_file.seek(0)
		self.json = None
		try:
			self.json = json.load(json_file)
			return
		except:
			# logutil.debug("Output is not a json object", self.console)
			pass
		finally:
			json_file.seek(0)
		self.json = []
		try:
			for jsonObject in self._decode_stacked():
				self.json.append(jsonObject)
		except ValueError:
			# logutil.debug("Output contains content that is not a json object", self.console)
			pass
		finally:
			if not self.json: self.json = None
	
	def _decode_stacked(self, position=0, decoder=json.JSONDecoder()):
		not_whitespace = re.compile(r'[^\s]')
		while True:
			match = not_whitespace.search(self.outstr, position)
			if not match:
				return
			position = match.start()

			try:
				jsonObject, position = decoder.raw_decode(self.outstr, position)
			except ValueError:
				raise
			yield jsonObject
