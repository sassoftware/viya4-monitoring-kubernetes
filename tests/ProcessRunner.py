import re
import os
import subprocess
import glob
import shutil
import json
from contextlib import contextmanager
import time
from utils import BaseTest

class ProcessRunner(BaseTest):
    
    def v4m_install_process(self, v4m_monitoring=None, v4m_logging=None, v4m_namespace=None, user_dir="ud1-daily-custom", airgap=False):
        self.log.trace("Starting V4M install process")
        
        v4m_monitoring = True if v4m_monitoring is None else False # only send false in robot file
        v4m_logging = True if v4m_logging is None else False # only send false in robot file
        v4m_namespace = True if v4m_namespace is None else False # only send false in robot file
        airgap = True if airgap else False # only send true in robot file
        
        self._setup(user_dir, v4m_namespace, airgap)
        self._modify_userdir()
        
        if v4m_monitoring and v4m_logging and v4m_namespace:
            components = "V4M cluster and namespace"
        elif not v4m_namespace and not v4m_monitoring:
            components = "V4M logging"
        elif not v4m_namespace and not v4m_logging:
            components = "V4M monitoring cluster only"
        elif not v4m_namespace:
            components = "V4M cluster only"
        elif not v4m_logging and not v4m_monitoring:
            components = "V4M monitoring namespace only"
        elif not v4m_logging:
            components = "V4M monitoring cluster and namespace"
        elif not v4m_monitoring:
            components = "V4M logging and monitoring namespace only"
        else:
            self._error_exit("Pardon me? All arguments are false, can't install nothing.")
        
        self.log.info("Installing " + components + " on the designated cluster")
        self._v4m_install(v4m_monitoring=v4m_monitoring, v4m_logging=v4m_logging, v4m_namespace=v4m_namespace, airgap=airgap)
        
        self.log.info("Process Results:")
        for logs in self.process_logs:
            self.log.info(">> " + [line for line in self.process_logs[logs] if line and not line.startswith("DEBUG")][-1]) # Skips empty lines and debug lines
        
        self._export_process_logs()
        
        if self.process_fail: self._failure_exit(components + " installation completed but was not successful.")
        
        self.log.trace("Completed " + components + " install")
    
    def v4m_uninstall_process(self, v4m_monitoring=None, v4m_logging=None, v4m_namespace=None, user_dir="ud1-daily-custom", airgap=False):
        self.log.trace("Starting V4M uninstall process")
        
        v4m_monitoring = True if v4m_monitoring is None else False # only send false in robot file
        v4m_logging = True if v4m_logging is None else False # only send false in robot file
        v4m_namespace = True if v4m_namespace is None else False # only send false in robot file
        airgap = True if airgap else False # only send true in robot file
        
        self._setup(user_dir, v4m_namespace, airgap)
        self._modify_userdir()
        
        if v4m_monitoring and v4m_logging and v4m_namespace:
            components = "V4M cluster and namespace"
        elif not v4m_namespace and not v4m_monitoring:
            components = "V4M logging"
        elif not v4m_namespace and not v4m_logging:
            components = "V4M monitoring cluster only"
        elif not v4m_namespace:
            components = "V4M cluster only"
        elif not v4m_logging and not v4m_monitoring:
            components = "V4M monitoring namespace only"
        elif not v4m_logging:
            components = "V4M monitoring cluster and namespace"
        elif not v4m_monitoring:
            components = "V4M logging and monitoring namespace only"
        else:
            self._error_exit("Pardon me? All arguments are false, can't uninstall nothing.")
        
        self.log.info("Uninstalling " + components + " on the designated cluster")
        self._remove_v4m(v4m_monitoring=v4m_monitoring, v4m_logging=v4m_logging, v4m_namespace=v4m_namespace)
        
        self.log.info("Process Results:")
        for logs in self.process_logs:
            self.log.info(">> " + [line for line in self.process_logs[logs] if line and not line.startswith("DEBUG")][-1]) # Skips empty lines and debug lines
        
        self._export_process_logs()
        
        if self.process_fail: self._failure_exit(components + " removal completed but was not successful.")
        
        self.log.trace("Completed " + components + " uninstall")
    
    def v4m_update_process(self, v4m_monitoring=None, v4m_logging=None, v4m_namespace=None, user_dir="ud1-daily-custom", airgap=False):
        self.log.trace("Starting V4M update process")
        
        v4m_monitoring = True if v4m_monitoring is None else False # only send false in robot file
        v4m_logging = True if v4m_logging is None else False # only send false in robot file
        v4m_namespace = True if v4m_namespace is None else False # only send false in robot file
        airgap = True if airgap else False # only send true in robot file
        
        self._setup(user_dir, v4m_namespace, airgap)
        self._modify_userdir()
        
        if v4m_monitoring and v4m_logging and v4m_namespace:
            components = "V4M cluster and namespace"
        elif not v4m_namespace and not v4m_monitoring:
            components = "V4M logging"
        elif not v4m_namespace and not v4m_logging:
            components = "V4M monitoring cluster only"
        elif not v4m_namespace:
            components = "V4M cluster only"
        elif not v4m_logging and not v4m_monitoring:
            components = "V4M monitoring namespace only"
        elif not v4m_logging:
            components = "V4M monitoring cluster and namespace"
        elif not v4m_monitoring:
            components = "V4M logging and monitoring namespace only"
        else:
            self._error_exit("Pardon me? All arguments are false, can't uninstall nothing.")
        
        self.log.info("Updating " + components + " on the designated cluster")
        self._remove_v4m(v4m_monitoring=v4m_monitoring, v4m_logging=v4m_logging, v4m_namespace=v4m_namespace)
        self._v4m_install(v4m_monitoring=v4m_monitoring, v4m_logging=v4m_logging, v4m_namespace=v4m_namespace, airgap=airgap)
        
        self.log.info("Process Results:")
        for logs in self.process_logs:
            self.log.info(">> " + [line for line in self.process_logs[logs] if line and not line.startswith("DEBUG")][-1]) # Skips empty lines and debug lines
        
        self._export_process_logs()
        
        if self.process_fail: self._failure_exit(components + " update completed but was not successful.")
        
        self.log.trace("Completed " + components + " update")
    
    def process_test_test(self):
        self.log.trace("Starting test for the V4M process tests")
        self.process_report = []
        
        self._load_process_logs()
        self.log_report = ["<table border=1><tr><th>Process</th><th>Error Count</th><th>Summary Line</th></tr>"]
        # TODO actively determine which processes were supposed to run.
        for key in self.process_logs:
            testProcess = {}
            if key == "monitoring_install":
                self.log.info("V4M Monitoring install was attempted.")
                process_name = "Cluster Monitoring Install"
                for line in self.process_logs[key]:
                    if "DEBUG Temporary directory" in line:
                        self.log.trace(line)
                        tmp_dir = line.split("[")[1].split("]")[0]
                        self.log.debug("Identified temp directory: " + tmp_dir)
                        shutil.copytree(tmp_dir, self.log_dir + "/mon-cluster-install-tmp")
                summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-2]
            if key == "logging_install":
                self.log.info("V4M Logging install was attempted.")
                process_name = "Logging Install"
                for line in self.process_logs[key]:
                    if "DEBUG Temporary directory" in line:
                        self.log.trace(line)
                        tmp_dir = line.split("[")[1].split("]")[0]
                        self.log.debug("Identified temp directory: " + tmp_dir)
                        shutil.copytree(tmp_dir, self.log_dir + "/logging-install-tmp")
                summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-2]
            if key == "namespace_install":
                self.log.info("V4M Namespace Monitoring install was attempted.")
                process_name = "Namespace Monitoring Install"
                for line in self.process_logs[key]:
                    if "DEBUG Temporary directory" in line:
                        self.log.trace(line)
                        tmp_dir = line.split("[")[1].split("]")[0]
                        self.log.debug("Identified temp directory: " + tmp_dir)
                        shutil.copytree(tmp_dir, self.log_dir + "/mon-viya-install-tmp")
                summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-2]
            if key == "monitoring_remove":
                self.log.info("V4M Monitoring removal was attempted.")
                process_name = "Cluster Monitoring Removal"
                for line in self.process_logs[key]:
                    if "DEBUG Temporary directory" in line:
                        self.log.trace(line)
                        tmp_dir = line.split("[")[1].split("]")[0]
                        self.log.debug("Identified temp directory: " + tmp_dir)
                        shutil.copytree(tmp_dir, self.log_dir + "/mon-cluster-remove-tmp")
                summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-2]
            if key == "logging_remove":
                self.log.info("V4M Logging removal was attempted.")
                process_name = "Logging Removal"
                for line in self.process_logs[key]:
                    if "DEBUG Temporary directory" in line:
                        self.log.trace(line)
                        tmp_dir = line.split("[")[1].split("]")[0]
                        self.log.debug("Identified temp directory: " + tmp_dir)
                        shutil.copytree(tmp_dir, self.log_dir + "/logging-remove-tmp")
                summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-2]
            if key == "namespace_remove":
                self.log.info("V4M Namespace Monitoring removal was attempted.")
                process_name = "Namespace Monitoring Removal"
                for line in self.process_logs[key]:
                    if "DEBUG Temporary directory" in line:
                        self.log.trace(line)
                        tmp_dir = line.split("[")[1].split("]")[0]
                        self.log.debug("Identified temp directory: " + tmp_dir)
                        shutil.copytree(tmp_dir, self.log_dir + "/mon-viya-remove-tmp")
                summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-2]
            if key == "monitoring_certs":
                self.log.info("V4M Monitoring TLS Cert generation was attempted.")
                process_name = "Monitoring TLS Cert Generation"
                summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-1]
            if key == "logging_certs":
                self.log.info("V4M Logging TLS Cert generation was attempted.")
                process_name = "Logging TLS Cert Generation"
                summary = [line for line in self.process_logs[key] if line and not line.startswith("DEBUG")][-1]
            
            # This section serces no purpose except as an example of usage.
            info_count = 0
            debug_count = 0
            error_count = 0
            for line in self.process_logs[key]:
                if "INFO" in line: info_count += 1
                if "DEBUG" in line: debug_count += 1
                if "ERROR" in line: error_count += 1
            self.log.info("There were " + str(info_count) + " INFOs, " + str(debug_count) + " DEBUGs, and " + str(error_count) + " ERRORs.")
            try:
                self.log.info("Line 7: " + self.process_logs[key][6])
                self.log.info("Line 27: " + self.process_logs[key][26])
                self.log.info("Line 42: " + self.process_logs[key][41])
                self.log.info("Line 121: " + self.process_logs[key][120])
                self.log.info("Line 343: " + self.process_logs[key][342])
            except IndexError:
                pass
            self.log.info("Process Results: " + summary) # Skips empty lines and debug lines
            error_status = error_count + self.process_rcs[key]
            error_class = "Fail" if error_status else "Pass"
            testProcess["name"] = process_name
            testProcess["errors"] = error_count
            testProcess["results"] = summary
            self.process_report.append(testProcess)
            self.log_report.append("<tr class=\"" + error_class + "\"><td>" + process_name + "</td><td>" + str(error_count) + "</td><td>" + summary + "</td></tr>")
        
        self.log_report.append("</table>")
        with open(self.log_dir + "/process_report.html", "w") as report_html:
            report_html.writelines(self.log_report)

        with open(self.log_dir + "/process_report.json", "w") as report_json:
            process_dict = {}
            process_dict["REPORT"] = self.process_report
            json.dump(process_dict, report_json)
        
        self.log.trace("Completed test and the process report for the V4M process tests")
    
    # Support methods for the tests
    def _setup(self, user_dir, v4m_namespace, airgap=False):
        """This function is designed to setup for a V4M process, including setting
            VIYA_NS, MON_NS, and LOG_NS in the user.env file.
        
        :param: user_dir : string
            This string will be appended to '<repopath>/data/' and set as the user_dir
        """
        self.log.trace("Starting setup for a process test.")
        self.user_dir = self.data_dir + "/" + user_dir
        self.charts_dir = self.log_dir + "/helmcharts"
        if airgap: self.log.trace("Including airgap setup")
        
        with open(self.user_dir + "/user.env", "a") as env_file:
            if self.viya_namespace is None:
                if v4m_namespace:
                    self._error_exit("Viya namespace was not provided. Namespace install will fail.")
                else:
                    self.log.warn("Viya namespace was not provided. Namespace installs will fail.")
            else:
                env_file.write("\nVIYA_NS=" + self.viya_namespace)
            env_file.write("\nMON_NS=" + self.monitoring_namespace)
            env_file.write("\nLOG_NS=" + self.logging_namespace)
            if airgap:
                env_file.write("\nAIRGAP_DEPLOYMENT=true")
                env_file.write("\nAIRGAP_REGISTRY=ops4viya.azurecr.io")
                env_file.write("\nAIRGAP_HELM_FORMAT=tgz")
                env_file.write("\nAIRGAP_HELM_REPO=" + self.charts_dir)
        os.environ["USER_DIR"] = self.user_dir
        self.process_logs = {}
        self.process_rcs = {}
        self.process_fail = False
        
        self.log.trace("Completed setup for a process test.")
    
    def _airgap_setup(self, v4m_monitoring=True, v4m_logging=True): # Uses existing registry, should create new one to avoid conflicts
        self.log.trace("Starting airgap setup")
        # Step 1
        # TODO save costs by creating and destroying a premium registry each time
        # self.private_registry = time.strftime("%m-%d_%H%M-%S", time.localtime())
        self.private_registry = self.ops_acr
        _ = self._safe_call(["sudo", "docker", "login", "--username", self.acr_app_id, "--password", self.acr_app_secret, self.private_registry])
        _ = self._safe_call(["helm", "registry", "login", "-u", self.acr_app_id, "-p", self.acr_app_secret, self.private_registry]) # Step 6.5
        
        parsed_container_list = [ # TODO this list should absolutely be parsed
            "docker.io/library/busybox",
            "cr.fluentbit.io/fluent/fluent-bit:2.1.4",
            "cr.fluentbit.io/fluent/fluent-bit:2.1.10", # both versions are intentionally in ARTIFACT_INVENTORY
            "quay.io/prometheuscommunity/elasticsearch-exporter:v1.5.0",
            "gcr.io/heptio-images/eventrouter:v0.3",
            "docker.io/opensearchproject/opensearch:2.10.0",
            "docker.io/opensearchproject/opensearch-dashboards:2.10.0",
            "quay.io/prometheus/alertmanager:v0.26.0",
            "docker.io/ghostunnel/ghostunnel:v1.7.1",
            "docker.io/grafana/grafana:10.2.1",
            "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20221220-controller-v1.5.1-58-g787ea74b6",
            "registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.0",
            "quay.io/prometheus/node-exporter:v1.7.0",
            "quay.io/prometheus/prometheus:v2.47.1",
            "quay.io/prometheus-operator/prometheus-operator:v0.69.1",
            "quay.io/prometheus-operator/prometheus-config-reloader:v0.69.1",
            "docker.io/prom/pushgateway:v1.6.2",
            "quay.io/kiwigrid/k8s-sidecar:1.25.2"
        ]
        
        for container_image in parsed_container_list:
            acr_image = self.private_registry + "/" + "/".join(container_image.split("/")[1:])
            if container_image.split("/")[2].startswith("prometheus-operator"):
                self.prom_version = container_image.split(":")[1]
            _ = self._safe_call(["sudo", "docker", "pull", container_image])
            _ = self._safe_call(["sudo", "docker", "tag", container_image, acr_image])
            _ = self._safe_call(["sudo", "docker", "push", acr_image])
        
        # Step 2
        helm_repos = { # this list should probably be parsed
            "prometheus-community": "https://prometheus-community.github.io/helm-charts",
            "fluent": "https://fluent.github.io/helm-charts",
            "opensearch": "https://opensearch-project.github.io/helm-charts",
            "grafana": "https://grafana.github.io/helm-charts"
        }
        
        for name, url in helm_repos.items():
            _ = self._safe_call(["helm", "repo", "add", name, url])
        _ = self._safe_call(["helm", "repo", "update"])
        
        # Step 3 (skipping step 4)
        helm_charts = [ # TODO this list should also definitely be parsed
            {
                "repo": "prometheus-community",
                "name": "prometheus-elasticsearch-exporter",
                "version": "5.3.1"
            },
            {
                "repo": "prometheus-community",
                "name": "kube-prometheus-stack",
                "version": "54.0.1"
            },
            {
                "repo": "prometheus-community",
                "name": "prometheus-pushgateway",
                "version": "2.4.2"
            },
            {
                "repo": "fluent",
                "name": "fluent-bit",
                "version": "0.40.0"
            },
            {
                "repo": "opensearch",
                "name": "opensearch",
                "version": "2.15.0"
            },
            {
                "repo": "opensearch",
                "name": "opensearch-dashboards",
                "version": "2.13.0"
            },
            {
                "repo": "grafana",
                "name": "grafana",
                "version": "6.58.9"
            },
            {
                "repo": "grafana",
                "name": "tempo",
                "version": "1.5.0"
            }
        ]
        
        os.makedirs(self.charts_dir)
        
        for chart in helm_charts:
            _ = self._safe_call(["helm", "pull", "--destination", self.charts_dir, "--version", chart["version"], chart["repo"] + "/" + chart["name"]])
        
        # Step 5
        crd_list = [ # this list should probably be parsed
            "monitoring.coreos.com_alertmanagerconfigs.yaml",
            "monitoring.coreos.com_alertmanagers.yaml",
            "monitoring.coreos.com_prometheuses.yaml",
            "monitoring.coreos.com_prometheusrules.yaml",
            "monitoring.coreos.com_podmonitors.yaml",
            "monitoring.coreos.com_servicemonitors.yaml",
            "monitoring.coreos.com_thanosrulers.yaml",
            "monitoring.coreos.com_probes.yaml"
        ]
        
        for crd in crd_list:
            url = "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/" + self.prom_version + "/example/prometheus-operator-crd/" + crd
            _ = self._safe_call(["wget", url, "-P", self.user_dir + "/monitoring/prometheus-operator-crd/" + self.prom_version])
        
        # Step 6
        secret_dir = self.data_dir + "/airgap-secrets"
        if self.viya_namespace:
            _, _, viya_rc = self._basic_call(["kubectl", "-n", self.viya_namespace, "get", "secret", "v4m-image-pull-secret"])
            if viya_rc:
                _ = self._safe_call(["kubectl", "apply", "-f", secret_dir + "/viya_secret.yaml"])
        if v4m_monitoring:
            _, _, mon_rc = self._basic_call(["kubectl", "-n", self.monitoring_namespace, "get", "secret", "v4m-image-pull-secret"])
            if mon_rc:
                _ = self._safe_call(["kubectl", "apply", "-f", secret_dir + "/mon_secret.yaml"])
        if v4m_logging:
            _, _, log_rc = self._basic_call(["kubectl", "-n", self.logging_namespace, "get", "secret", "v4m-image-pull-secret"])
            if log_rc:
                _ = self._safe_call(["kubectl", "apply", "-f", secret_dir + "/log_secret.yaml"])
        
        shutil.rmtree(self.log_dir + "/user-dir") # remove the existing user_dir (without crds)
        shutil.copytree(self.user_dir, self.log_dir + "/user-dir") # add new user_dir (with crds)
        
        self.log.trace("Completed airgap setup")
    
    def _v4m_install(self, v4m_monitoring=True, v4m_logging=True, v4m_namespace=True, airgap=False):
        """This function is designed to install V4M using the pre-configured user-dir.
        
        :param: v4m_monitoring : boolean
            True installs the cluster monitoring pieces, false does not.
        :param: v4m_logging : boolean
            True installs the cluster logging pieces, false does not.
        :param: v4m_namespace : boolean
            True installs the viya namespace monitoring piece, false does not.
        
        :output: self.process_logs : dictionary
            The logs from each script are stored as a list in the dictionary
        :output: self.process_rcs : dictionary
            The return code from each script are stored as an integer in the dictionary
        :output: self.process_fail : boolean
            True if any of the scripts returned a non-zero returncode.
        """
        self.log.trace("Starting the V4M install process.")
        
        with open(self.cert_repo + "/v4m-settings.env", "w") as settings:
            settings.write("MON_NS=" + self.monitoring_namespace)
            settings.write("\nLOG_NS=" + self.logging_namespace)
            settings.write("\nINGRESS_HOSTNAME=" + self.host)
            settings.write("\nOPENSSL_CNF=v4m.csr.cnf")
            settings.write("\nOVERWRITE_SECRETS=false") # switch to true for NDU? isn't required...
            settings.write("\nLOG_DEBUG_ENABLE=true")
            settings.write("\nCMD_DEBUG_ENABLE=true")
        
        print("TRACE: Generating V4M TLS Certs")
        with self._cd(self.cert_repo):
            if v4m_monitoring: self._execute_process([self.cert_repo + "/gen_monitoring_ingress_certs.sh"], "monitoring_certs", self.log_dir + "/gen_monitoring_ingress_certs.log")
            if v4m_logging: self._execute_process([self.cert_repo + "/gen_logging_ingress_certs.sh"], "logging_certs", self.log_dir + "/gen_logging_ingress_certs.log")
        
        if airgap: self._airgap_setup(v4m_monitoring, v4m_logging)
        
        if self.cloud_platform == "OCP" or self.cloud_platform == "ARO":
            self.log.trace("Installing the cluster v4m pieces on OCP")
            if v4m_monitoring: self._execute_process([self.v4m_repo + "/monitoring/bin/deploy_monitoring_openshift.sh"], "monitoring_install", self.log_dir + "/deploy_monitoring_openshift.log")
            if v4m_logging: self._execute_process([self.v4m_repo + "/logging/bin/deploy_logging_openshift.sh"], "logging_install", self.log_dir + "/deploy_logging_openshift.log")
        else:
            self.log.trace("Installing the cluster v4m pieces on " + self.cloud_platform)
            if v4m_monitoring: self._execute_process([self.v4m_repo + "/monitoring/bin/deploy_monitoring_cluster.sh"], "monitoring_install", self.log_dir + "/deploy_monitoring_cluster.log")
            if v4m_logging: self._execute_process([self.v4m_repo + "/logging/bin/deploy_logging.sh"], "logging_install", self.log_dir + "/deploy_logging.log")
        
        # install namespace monitoring pieces, if desired
        if v4m_namespace:
            self.log.trace("Installing the monitoring namespace pieces.")
            self._execute_process([self.v4m_repo + "/monitoring/bin/deploy_monitoring_viya.sh"], "namespace_install", self.log_dir + "/deploy_monitoring_viya.log")
            self._safe_call(["kubectl", "-n", self.viya_namespace, "delete", "pods", "-l", "app=sas-workload-orchestrator"])
        
        self.log.trace("Completed V4M install process.")
    
    def _modify_userdir(self):
        self.log.trace("Starting user directory modifications for a process test.")
        
        if self.cloud_platform == "OCP" or self.cloud_platform == "ARO":
            self.log.trace("Enabling User Workloads on " + self.cloud_platform)
            stdout, stderr, returncode = self._basic_call(["kubectl", "apply", "-f", self.user_dir + "/aro-v4m.yaml"])
            if self.cloud_platform == "ARO": stdout, stderr, returncode = self._basic_call(["kubectl", "apply", "-f", self.user_dir + "/azuredisk-v4m.yaml"])
            shutil.copytree(self.user_dir, self.log_dir + "/user-dir")
            return
        
        if self.cloud_platform == "AKS":
            self.log.trace("Prepping files for AKS install")
            stdout, stderr, returncode = self._basic_call(["kubectl", "apply", "-f", self.user_dir + "/azuredisk-v4m.yaml"])
            shutil.copyfile(self.user_dir + "/monitoring/unused/user-values-pushgateway.yaml", self.user_dir + "/monitoring/user-values-pushgateway.yaml")
            shutil.copyfile(self.user_dir + "/monitoring/unused/azure-values.yaml", self.user_dir + "/monitoring/user-values-prom-operator.yaml")
            shutil.copyfile(self.user_dir + "/logging/unused/azure-opensearch.yaml", self.user_dir + "/logging/user-values-opensearch.yaml")
            shutil.copyfile(self.user_dir + "/logging/unused/user-values-osd.yaml", self.user_dir + "/logging/user-values-osd.yaml")
        elif self.cloud_platform == "OS":
            self.log.trace("Prepping files for Openstack install")
            shutil.copyfile(self.user_dir + "/logging/unused/user-values-fluent-bit-open.yaml", self.user_dir + "/logging/user-values-fluent-bit-open.yaml")
            shutil.copyfile(self.user_dir + "/monitoring/unused/other-values.yaml", self.user_dir + "/monitoring/user-values-prom-operator.yaml")
            shutil.copyfile(self.user_dir + "/logging/unused/other-opensearch.yaml", self.user_dir + "/logging/user-values-opensearch.yaml")
            shutil.copyfile(self.user_dir + "/logging/unused/user-values-osd.yaml", self.user_dir + "/logging/user-values-osd.yaml")
        elif self.cloud_platform == "EKS":
            self.log.trace("Prepping files for EKS install")
            shutil.copyfile(self.user_dir + "/monitoring/unused/other-values.yaml", self.user_dir + "/monitoring/user-values-prom-operator.yaml")
            shutil.copyfile(self.user_dir + "/logging/unused/other-opensearch.yaml", self.user_dir + "/logging/user-values-opensearch.yaml")
            shutil.copyfile(self.user_dir + "/logging/unused/user-values-osd.yaml", self.user_dir + "/logging/user-values-osd.yaml")
        elif self.cloud_platform == "GKE":
            self.log.trace("Prepping files for GKE install")
            shutil.copyfile(self.user_dir + "/monitoring/unused/other-values.yaml", self.user_dir + "/monitoring/user-values-prom-operator.yaml")
            shutil.copyfile(self.user_dir + "/logging/unused/other-opensearch.yaml", self.user_dir + "/logging/user-values-opensearch.yaml")
            shutil.copyfile(self.user_dir + "/logging/unused/user-values-osd.yaml", self.user_dir + "/logging/user-values-osd.yaml")
        
        self.log.trace("Modifying files for non-OCP install")
        self._replace_in_file("host.mycluster.example.com", self.host, self.user_dir + "/monitoring/user-values-prom-operator.yaml")
        self._replace_in_file("host.mycluster.example.com", self.host, self.user_dir + "/logging/user-values-osd.yaml")
        self._replace_in_file("host.mycluster.example.com", self.host, self.user_dir + "/logging/user-values-opensearch.yaml")
        
        shutil.copytree(self.user_dir, self.log_dir + "/user-dir")
        
        self.log.trace("Completed user directory modifications.")
    
    def _remove_v4m(self, v4m_monitoring=True, v4m_logging=True, v4m_namespace=True):
        """This function is designed to remove V4M using the pre-configured user-dir.
        
        :param: v4m_monitoring : boolean
            True uninstalls the cluster monitoring pieces, false does not.
        :param: v4m_logging : boolean
            True uninstalls the cluster logging pieces, false does not.
        :param: v4m_namespace : boolean
            True uninstalls the viya namespace monitoring piece, false does not.
        
        :output: self.process_logs : dictionary
            The logs from each script are stored as a list in the dictionary
        :output: self.process_rcs : dictionary
            The return code from each script are stored as an integer in the dictionary
        :output: self.process_fail : boolean
            True if any of the scripts returned a non-zero returncode.
        """
        self.log.trace("Starting the V4M uninstall process.")
        
        if self.cloud_platform == "OCP" or self.cloud_platform == "ARO":
            self.log.trace("Removing the cluster v4m pieces from OCP")
            if v4m_monitoring: self._execute_process([self.v4m_repo + "/monitoring/bin/remove_monitoring_openshift.sh"], "monitoring_remove", self.log_dir + "/remove_monitoring_openshift.log")
            if v4m_logging: self._execute_process([self.v4m_repo + "/logging/bin/remove_logging_openshift.sh"], "logging_remove", self.log_dir + "/remove_logging_openshift.log")
        else:
            self.log.trace("Removing the cluster v4m pieces from " + self.cloud_platform)
            if v4m_monitoring: self._execute_process([self.v4m_repo + "/monitoring/bin/remove_monitoring_cluster.sh"], "monitoring_remove", self.log_dir + "/remove_monitoring_cluster.log")
            if v4m_logging: self._execute_process([self.v4m_repo + "/logging/bin/remove_logging.sh"], "logging_remove", self.log_dir + "/remove_logging.log")
        
        if v4m_namespace:
            self.log.trace("Removing the monitoring namespace pieces.")
            self._execute_process([self.v4m_repo + "/monitoring/bin/remove_monitoring_viya.sh"], "namespace_remove", self.log_dir + "/remove_monitoring_viya.log")
        
        self.log.trace("Completed V4M removal process.")
    
    def _replace_in_file(self, current, new, filepath):
        with open(filepath) as file:
            data = file.read()
        
        newdata = data.replace(current, new)
        with open(filepath, "w") as file:
            file.write(newdata)
    
    def _remove_files(self, path):
        remove_list = []
        if "*" in path:
            for obj in glob.glob(path):
                remove_list.append(obj)
        else:
            remove_list = [path]
        
        if remove_list:
            for element in remove_list:
                if os.path.isfile(element):
                    os.remove(element)
                    if os.path.isfile(element):
                        self.log.error("Could not delete " + element)
                else:
                    shutil.rmtree(element)
                    if os.path.isdir(element):
                        self.log.error("Could not delete " + element)
        else:
            self.log.info("Nothing to delete in " + path)
    
    def _export_process_logs(self):
        """This method exports the process logs currently in the self.process_logs
            dictionary and the return codes currently in the self.process_rcs for
            later use. Overwrites previously stored process logs and return codes!
        """
        self.log.trace("Exporting process logs")
        with open(self.data_dir + '/process_logs.json', 'w', encoding="utf-8") as process_json:
            process_json.write(json.dumps(self.process_logs))
        
        self.log.trace("Exporting process return codes")
        with open(self.data_dir + '/process_rcs.json', 'w', encoding="utf-8") as process_rc:
            process_rc.write(json.dumps(self.process_rcs))
    
    def _execute_process(self, command, logname, filename):
        ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        
        full_output = []
        with open(filename, "w", encoding="utf-8") as log_file:
            while process.poll() is None:
                line = process.stdout.readline().decode('utf-8')
                if line:
                    self.log.trace(line.strip())
                    no_color = ansi_escape.sub('', line)
                    log_file.write(no_color)
                    full_output.append(no_color.strip())
            remainder = process.stdout.read().decode('utf-8')
            if remainder:
                self.log.trace(remainder)
                no_color = ansi_escape.sub('', remainder)
                log_file.write(no_color)
                lines = no_color.splitlines()
                full_output.extend(lines)
        
        self.process_logs[logname] = full_output
        self.process_rcs[logname] = process.returncode
        self._export_process_logs()
        
        if process.returncode == 0:
            self.log.info(str(command[0]) + " script completed successfully.")
        else:
            self.log.error(str(command[0]) + " script did not complete successfully.")
            self.process_fail = True
    
    @contextmanager
    def _cd(self, newdir):
        prevdir = os.getcwd()
        os.chdir(os.path.expanduser(newdir))
        try:
            yield
        finally:
            os.chdir(prevdir)

def main():
    print("Running as a script...")
    # testObject = MonitoringBasic(False)
    # testObject.monitoring_env_exists_test()
    # testObject.monitoring_cmd_exists_test()
    # testObject.monitoring_kubectl_admin_test()
    print("Testing complete")

if __name__ == '__main__':
    main()