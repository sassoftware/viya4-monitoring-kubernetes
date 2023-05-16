# SAS Viya Monitoring for Kubernetes

## Version 1.2.13 (16MAY2023)

* **Overall**
  * [CHANGE] The use of the ["SAS Viya"](https://github.com/sassoftware/viya4-monitoring-kubernetes#sas-viya-monitoring-for-kubernetes) name has been updated to reflect product name changes.
  * [CHANGE] Actual passwords are replaced with asterisks in deployed instances of the v4m Helm chart (e.g. v4m-logs, v4m-metrics, etc.).

* **Metrics**
  * [FIX] Fixed an issue that caused the Prometheus data source to fail in path-based Ingress deployments if Prometheus was not externalized
  * [FEATURE] Added "Go Routines" graph to the SAS Go Service Details dashboard in Grafana

## Version 1.2.12 (18APR2023)
* **Overall**
  * [FEATURE] Information about resource requests and limits added to documentation under [Minimum Resource Requirements](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n039q38k9nedd2n16rbbafwsw0ae.htm).
  * [CHANGE] Revised Kubernetes and OpenShift version-checking logic (inc. changing ERROR message to a WARNING)
  * [CHANGE] Updated Azure deployment sample to replace storage provisioner deprecated in AKS for K8s v1.26+
  * [FIX] Added logic to determine if service account exists before attempting to patch it

* **Metrics**
  * [FIX] Updated invalid defintion for Prometheus and Alertmanager service monitor that prevented the service monitor metrics to be collected.
  * [FIX] Added annotation to Alertmanager ingress resource to enable HTTPS access via nginx
  * [FIX] Added check in `deploy_monitoring_viya.sh` to ensure user workload monitoring is enabled for openshift clusters

* **Logging**
  * [UPGRADE] OpenSearch and OpenSearch Dashboards upgraded from version 2.4.1. to 2.6.0
  * [UPGRADE] Fluent Bit upgraded from version 2.0.8 to 2.0.9
  * [CHANGE]  Extended validation loop when deploying content into OpenSearch Dashboards and added message to user
  * [FIX] Added additional permissions to OpenSearch 'metricgetter' role to permit more metrics to be collected from OpenSearch
  * [CHANGE] The ingress samples, both with host-based and path-based ingress, were modified to work with
    OpenSearch Dashboards 2.4.1.

## Version 1.2.11 (14MAR2023)
* **Overall**
  * [FIX] Updated deployment logic to address an issue that was discovered when deploying with external tools such as Ansible.

* **Metrics**
  * [UPGRADE] - Kube-prometheus-stack has been upgraded from version 41.7.3 to 43.3.1
  * [UPGRADE] - Prometheus has been upgraded from version 2.39.0 to 2.40.7
  * [UPGRADE] - Prometheus Operator has been upgraded from version 0.60.0 to 0.62.0
  * [UPGRADE] - Grafana has been upgraded from version 9.2.3 to 9.3.1
  * [UPGRADE] - Alertmanager has been upgraded from version 0.24.0 to 0.25.0
  * [UPGRADE] - Node Exporter has been upgraded from version 1.3.1 to 1.5.0
  * [UPGRADE] - Kube State Metrics has been upgraded from version 2.5.0 to 2.6.0
  * [UPGRADE] - Pushgateway has been upgraded from version 1.4.3 to 1.5.1
  * [UPGRADE] - K8s-sidecar used with Grafana has been upgraded from 1.19.5 to 1.22.0
  * [CHANGE]  - Replaced ghostunnel for Prometheus and Alertmanager when `TLS_ENABLE=true` with their respective native TLS capability.

* **Logging**
  * [FIX] Adjust priority of ISM Policy for OpenShift infrastructure indices to ensure proper policy assignment
  * [FIX] Corrected messages in logging/bin/change_internal_password.sh showing commands to restart Fluent Bit and Elastic Exporter pods.


## Version 1.2.10 (14FEB2023)
* **Overall**
  * [SECURITY] Disabled the automounting of API credentials for all serviceAccount resources associated with deployed
    components. Automounting of credentials is now enabled at the _pod_ level in a small number of cases (Event Router, 
    Fluent Bit, Kube State Metrics and Prometheus Operator) where needed to support required functionality.  If necessary,
    these changes can be disabled by setting the SEC_DISABLE_SA_TOKEN_AUTOMOUNT environment variable to 'false'.

* **Logging**
  * [UPGRADE] Moved to OpenSearch and OpenSearch Dashboards version 2.4.1.  As part of this change, 
    an initContainer (fsgoup-volume - used to run a chown command) and the Performance Analyzer agent 
    (which ran alongside OpenSearch) were disabled.  Both can be re-enabled, if necessary, by setting
    keys in your $USER_DIR/ user-values-opensearch.yaml file.
  * [CHANGE] The TLS samples, both with host-based and path-based ingress, were modified to work with
    OpenSearch Dashboards 2.4.1.
  * [FIX] On OpenShift, the deployment order of OpenSearch and OpenSearch Dashboards was reversed to resolve a timing
    issue related to the shared serviceAccount.
  * [UPGRADE] Introduced new **experimental** getlogs script written in python, to retrieve OpenSearch logs with filters and save to a file. Relevant documentation can be found [here](./logging/Export_Logs.md#export-logs-python-script---experimental)
  * [UPGRADE] Fluent Bit has been upgraded from version 1.9.9 to 2.0.8

* **Metrics**
  * [FIX] Updated recording rule logic to restore functionality to the SAS Launched Jobs dashboards.

## Version 1.2.9 (17JAN2023)
* **Overall**
  * [FEATURE] Added a new script, renewal-tls-certs.sh, which handles renewing TLS certificates autogenerated during the deployment process, and, restarts application pods to pick up renewed certificates.  The script can also be used to restart application pods for organization using their own custom certs.

* **Metrics**
  * [FEATURE] Added link to the SAS Viya Monitoring for Kubernetes Help Center page on the Welcome screen in Grafana
  * [FEATURE] Add new 'SAS Micro Analytic Serivce' dashboard to Grafana
  * [FIX] Eliminated 'Templating'/'Datasource not found' error in Grafana PostgreSQL Database dashboard

* **Logging**
  * [FIX]  - Improved handling of log messages from RabbitMQ and Consul

## Version 1.2.8 (13DEC2022)

* **Overall**
  * [ANNOUNCEMENT] - The documentation for this project has been redesigned and is now located in the [SAS Viya Monitoring for Kubernetes Help Center](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvwlcm&docsetTarget=titlepage.htm).  
    A limited amount of documentation, primarily related to experimental features, remains available as markdown files in the project repo.

* **Metrics**
  * [FIX] - Restored various container-related metrics that were being filtered out after an update.
  * [FIX] - Restore metrics after move to Crunchy Data v.5
  * [FIX] - Data source created by the create_logging_datasource script no longer shows a depreciation notice.

* **Logging**
  * [FIX]  - Limited Access User Can NOT Generate CSV via OpenSearch Dashboards Reporting

## Version 1.2.7 (02DEC2022)

* **Logging**
  * [FIX] - Pin to specific Helm chart version (4.15.1) in logging/bin/deploy_esexporter.sh
  * [UPGRADE] - Fluent Bit has been upgraded from version 1.9.6 to 1.9.9

## Version 1.2.6 (15NOV2022)

* **Metrics**
  * [FIX] - Remove v4m-kubelet service when removing cluster-level metric monitoring components
  * [FIX] - Added patch for API Token that caused the deploy_monitoring_openshift script to fail during deployment.

* **Logging**
  * [FIX] Updated Fluent Bit processing to handle log messages from Crunchy Data version 5
  * [FIX] Updated Fluent Bit configuration to use `Allowlist_key` instead of `Whitelist_key` modifier as it has been deprecated and is ignored.

## Version 1.2.5 (04NOV22)

* **Metrics**
  * [SECURITY] Upgraded metrics monitoring components to address CVE-2022-37434
  * [DEPRECATION] For security reasons, access to Prometheus and AlertManager via NodePort is no longer enabled by default. Set the environment variable PROM_NODEPORT_ENABLE=true to replicate previous behavior.
  * [UPGRADE] - Kube-prometheus-stack has been upgraded from version 36.6.1 to 41.7.3
  * [UPGRADE] - Prometheus has been upgraded from version 2.36.2 to 2.39.0
  * [UPGRADE] - Prometheus Operator has been upgraded from version 0.57.0 to 0.60.0
  * [UPGRADE] - Grafana has been upgraded from version 9.0.3 to 9.2.3
  * [UPGRADE] - Kube State Metrics has been upgraded from version 2.5.0 to 2.6.0
  * [UPGRADE] - K8s-sidecar used with Grafana has been upgraded from 1.19.2 to 1.19.5
  * [UPGRADE] - TLS Proxy sidecar (ghostunnel) for monitoring components has been upgraded from 1.6.1 to 1.7.0

## Version 1.2.4 (18OCT22)

* **Overall**
  * [CHANGE] Support for Kubernetes 1.21 has been dropped.
  * [FIX] Updated the Dockerfile so that the subdirectories are preserved in the Docker container.

* **Metrics**
  * [FIX] Added Service Monitor definition to permit metric collection from OpenSearch instance within individual SAS Viya deployments.
  * [FIX] Customizations in the user-values-prom-operator.yaml file under the alertmanagerSpec will now be applied correctly.

* **Logging**
  * [UPGRADE] Opensearch and Opensearch Dashboards has been upgraded from 1.32 to 1.35
  * [UPGRADE] Elasticsearch Exporter has been upgraded from 1.2.1 to 1.5.0

## Version 1.2.3 (20SEP22)

* **Overall**
  * [FEATURE] - The V4M container now includes OpenSSL so that you can run the deployment with TLS.
  * [FEATURE] - [IMAGE_INVENTORY.md](https://github.com/sassoftware/viya4-monitoring-kubernetes/blob/master/IMAGE_INVENTORY.md) file now includes init containers that are used in the project.
  * [FIX] - A temporary file created when using OpenSSL for TLS certificate generation is no longer left behind after certs are generated

* **Metrics**
  * [UPGRADE] - Kube-prometheus-stack has been upgraded from version 32.0.0 to 36.6.1
  * [UPGRADE] - Prometheus has been upgraded from version 2.33.1 to 2.36.2
  * [UPGRADE] - Prometheus Operator has been upgraded from version 0.54.0 to 0.57.0
  * [UPGRADE] - Grafana has been upgraded from version 8.4.1 to 9.0.3
  * [UPGRADE] - AlertManager has been upgraded from version 0.23.0 to 0.24.0
  * [UPGRADE] - Kube State Metrics has been upgraded from version 2.3.0 to 2.5.0
  * [UPGRADE] - PushGateway has been upgraded from version 1.4.2 to 1.4.3

* **Logging**
  * [UPGRADE] - Fluent Bit has been upgraded from version 1.8.7 to 1.9.6
  * [FIX] - Removed unnecessary retrieval of the OpenSearch 'admin' credentials from logging/bin/deploy_osd.sh

## Version 1.2.2 (16AUG22)

* **Overall**
  * [CHANGE] - The 'master' branch of the project repository was renamed to "main".

* **Metrics**
  * [CHANGE] - Added 'sas-viya' and 'sas-workload-orchestrator' tags to the two SAS Launched Jobs dashboards in Grafana.
  * [CHANGE] - Support for tenant-level metric monitoring (specifically, deploying tenant-level instances of Prometheus and Grafana) has been moved to "experimental" status. This reflects concerns about its architecture, scalability and supportability.

* **Logging**
  * [CHANGE] - The documentation about log monitoring has been extensively revised and relocated to the [SAS Viya Administration Help Center](http://documentation.sas.com/doc/en/sasadmincdc/default/callogging/titlepage.htm). The affected markdown-based documentation files stored in this repository have been updated to point to the new documentation location.
  * [FIX] - OpenSearch tenant-level indexes with apparently missing tenant information (i.e. index names fitting the pattern "viya_logs-myviya-____-2022-07-23") were being created rather than storing some log messages in namespace-level indexes.
  * [FIX] - A change in the container name used by SAS CAS Server resulted in some log messages not being stored in the right OpenSearch index.

## Version 1.2.1 (19JUL22)

* **Monitoring**
  * [FEATURE] - change_grafana_admin_password script has been created to change the Grafana admin password.
  * [FIX] - Fixed issue where the logging data source would not be successfully created if you changed the Grafana admin password using the kubectl exec command provided at the end of the monitoring deployment tasks.
  * [FIX] - Fixed a bug where the Viya monitoring deployment script would not remove older, v4m-viya Helm chart.

* **Logging**
  * [CHANGE] - The es_nodeport_enable.sh and es_nodeport_disable.sh scripts used to enable and disable access to OpenSearch via NodePort, respectively, have been replaced with bin/configure_nodeport.sh which includes additional functionality.  See [Configure Access Via NodePorts](http://documentation.sas.com/doc/en/sasadmincdc/default/callogging/n0l4k3bz39cw2dn131zcbat7m4r1.htm).
  * [CHANGE] - Completed various clean-up tasks and tweaks related to the move to OpenSearch.  The order in which the log monitoring components are deployed has been modified to reduce start-up time and increase reliability.  Logic related to creating access controls has been moved to deploy_opensearch_content.sh (rather than deploy_osd_content.sh).  Message text has been revised to eliminate references to Elasticsearch and Kibana, replacing them (as appropriate) with references to OpenSearch and OpenSearch Dashboards (respectively).

## Version 1.2.0 (14JUN22)

* **Overall**
  * [CHANGE] - Support for Kubernetes 1.20 and OpenStack 4.7 has been dropped.

* **Monitoring**
  * [CHANGE] - create_elasticsearch_datasource script has been changed to create_logging_datasource and supports both Opensearch and Elasticsearch data source creation.
  * [FIX] - Fixed issue where namespace dropdown on "PostgreSQL" and "PostgreSQL Database" dashboards would not correctly filter information on the dashboards.

* **Logging**
  * [CHANGE] - OpenSearch 1.3.2 replaces Open Distro for Elasticsearch as the search technology used for log monitoring.  This change includes replacing Elasticsearch with OpenSearch and Kibana with OpenSearch Dashboards.  This involves changes in the names and format of the yaml files used with Helm.  See [Differences between Open Distro for Elasticsearch and OpenSearch](https://github.com/sassoftware/viya4-monitoring-kubernetes/blob/master/logging/Differences_between_ODFE_and_OpenSearch.md) for details.  Documentation has been updated to reflect the move to OpenSearch.
  * [CHANGE] - Script and files names related to the deployment of log monitoring components were simplified and standardized.

## Version 1.1.8 (17MAY22)

* **Overall**
  * [FIX] - Fixed some Kubernetes-related messages were being displayed without log levels.
  * [CHANGE] - Running scripts on OpenShift 4.9 no longer generates a WARNING message.

* **Monitoring**
  * [FIX] - Updated SAS Viya logo on the Grafana Welcome screen so that it is easier to see on darker background.
  * [FIX] - Fixed an issue that pod names were concatenated when multiple instances of tenant monitoring have been deployed.
  * [CHANGE] - Combined the functionality of the create_elasticsearch_datasource_cluster.sh and create_elasticsearch_datasource_tenant.sh scripts into one script (create_elasticsearch_datasource.sh).
  
* **Logging**
  * [ANNOUNCEMENT] - In our next release, we expect to move to using OpenSearch rather than Open Distro for Elasticseach as the search back-end supporting our log monitoring capabilities. While this change will have only minor impact on the user interface (primarily some cosmetic changes), it will have a more significant impact on the deployment process. Therefore, this should be considered a breaking change. It will involve:
    * changes to many script names, including the names of the primary deployment and removal scripts;
    * changes to the names and structure of the user value (yaml) files used with the Helm charts;
    * changes to the topology and configuration of search pod; and,
    * changes in product/application terminology (OpenSearch replacing Elasticsearch; OpenSearch Dashboards replacing Kibana).
  * Organizations wanting to get more familiar with the new technology stack are encouraged to deploy it on an experimental basis on a test cluster separate from their current "production" cluster.  This can be done by running the deploy_logging_opensearch.sh script in the logging/bin sub-directory.  Customizations to the OpenSearch and OpenSearch Dashboards configuration can be provided via the user-values-elasticsearch-opensearch.yaml and user-values-osd-opensearch.yaml files, respectively, in the logging sub-directory of the directory identified via the USER_DIR environment variable.  We have OpenSearch-specific files in the Azure Deployment, Ingress and TLS samples to handle two of the most common customization scenarios.  Please note that file names may change as this moves from experimental to production status.
  * The deployment process handles migrating the current set of collected log messages in the many scenarios. However, migration is not supported in some scenarios, such as the configuration documented in the min-logging sample (i.e. sample/min-logging) in the project repository.
  * [CHANGE] - Improved handling of log messages emitted by SingleStore.

## Version 1.1.7 (19APR22)

* **Overall**
  * [FEATURE] - Added a document to the project repository, [IMAGE_INVENTORY.md](https://github.com/sassoftware/viya4-monitoring-kubernetes/blob/master/IMAGE_INVENTORY.md),
    listing all container images used by pods when deploying this
    project using default values and deploying all components.
  * [FIX] - Modified naming of Helm releases of the internal V4M chart used
    to capture deployment information to support deploying log and metric
    monitoring components in the same namespace.
  * [EXPERIMENTAL] - A [Docker file](https://github.com/sassoftware/viya4-monitoring-kubernetes/blob/master/v4m-container/Dockerfile)
    to allow you to work with this project in a containerized environment.
    This eliminates virtually all pre-requisites and concerns about properly
    configuring your environment. See the associated [README.md](https://github.com/sassoftware/viya4-monitoring-kubernetes/tree/master/v4m-container#readme)
    for more information.

* **Monitoring**
  * [EXPERIMENTAL] - A new script, `create_elasticsearch_datasource.sh`, that
    creates datasource(s) which allow collected log messages collected to be 
    viewed within Grafana.

* **Logging**
  * [FEATURE] - New role-based access controls and roles are created during
    initial deployment and the onboarding process to facilitate the creation 
    of datasource(s) which allow collected log messages collected to be 
    viewed in Grafana.
  * [FIX] - Corrected annotations on Grafana ingress objects in the Azure 
    Deployment sample. (Fixes #318)
  * [EXPERIMENTAL] - Running `logging/bin/deploy_logging_opensearch.sh` instead
    of `logging/bin/deploy_logging_open.sh` will deploy log monitoring with
    OpenSearch 1.3.1 (instead of Open Distro for Elasticsearch 1.13.3) as the 
    search back-end.  [OpenSearch](http://opensearch.org) will become the default (only) back-end
    in a coming release.  The files `user-values-elasticsearch-opensearch.yaml` 
    and `user-values-osd-opensearch.yaml` replace the `user-values-elasticsearch.yaml` 
    file for providing user-supplied values during the Helm deployment process 
    and use a different set of keys.

## Version 1.1.6 (15MAR22)

* **Monitoring**
  * [CHANGE] Monitoring component versions were updated
    * kube-prometheus-stack 19.0.3 -> 32.0.0
    * Prometheus Operator 0.51.2 -> 0.54.0
    * Prometheus 2.30.3 -> 2.33.1
    * Grafana 8.2.1 -> 8.4.1
    * node-exporter 1.2.2 -> 1.3.1
    * kube-state-metrics 2.2.1 -> 2.3.0
  * [CHANGE] The PostgreSQL Database and two RabbitMQ dashboards were refreshed from upstream
  * [FIX] The Grafana data source was not configured properly when TLS was enabled and using path-based ingress
  * [DOC] Comments were added to help users specify retention time and size for Prometheus

* **Logging**
  * [FIX] Removed hard-coded references to a specific namespace
  * [FIX] Eliminated a spurious ERROR message generated by trap function
  * [CHANGE] Removed references to deprecated NODE_NAME environment variable from scripts
  * [CHANGE] Replaced hard-coded 90 second wait for Elasticsearch PVC binding with a loop that checks its status
    to allow for quicker execution.

## Version 1.1.5 (15FEB22)

* **Monitoring**
  * [CHANGE] - The SAS Viya Welcome dashboard has been updated with a
    cleaner design and an improved layout
  * [EXPERIMENTAL] - Setting `ELASTICSEARCH_DATASOURCE=true` when running
    `monitoring/bin/deploy_monitoring_cluster.sh`  will configure an
    Elasicsearch data source for Grafana that enables viewing and querying of
    logs from Grafana dashboards. Logging must already be deployed for this
    to function properly.
  * [EXPERIMENTAL] - Enhanced dashboards for SAS Go services, SAS Java
    services, and CAS support viewing logs in Grafana. Setting
    `ELASTICSEARCH_DATASOURCE=true` or `VIYA_LOGS_DASH=true` will deploy
    the updated dashboards to replace the prior versions.

* **Logging**
  * [FEATURE] - Enhanced multi-line support is now enabled by default in
    Fluent Bit
  * [FEATURE] - `logging/bin/change_internal_password.sh` now supports the
    recently added `logadm` user
  
  * [CHANGE] - The deprecated `KB_TLS_ENABLE` flag has been removed. Kibana TLS
    is now controlled via the normal `TLS_ENABLE` and `LOG_TLS_ENABLE` flags
  * [FIX] - Several status check  in scripts have been simplified to use
    `kubectl wait`
  * [FIX] - All logging components now specify Kubernetes resource requests
  * [FIX] - Event router is now properly deployed to the `logging` namespace
    when setting `NODE_PLACEMENT_ENABLE=true` or `LOG_NODE_PLACEMENT_ENABLE=true`
  * [DOC] - The [documentation on how to adjust log retention](logging/Log_Retention.md)
    has been revised to improve clarity and correct errors.  Fixes #261.

## Version 1.1.4 (31JAN22)

* **Logging**

  * [SECURITY] Move to use Open Distro for Elasticsearch 1.13.3 (addresses LOG4J
    security vulnerability)

## Version 1.1.3 (14JAN22)

### **UPDATE: Due to incomplete remediation of the log4j issue, do not use 1.1.3; use a more recent version

* **Overall**
  * [CHANGE] The [ingress sample](samples/ingress) is deprecated in favor of
    the [TLS sample](samples/tls)
  * [FIX] The [TLS Sample](samples/tls) is now more consistent across 
    monitoring/logging and host/path-based ingress
  * [FIX] The [CloudWatch sample](samples/cloudwatch) has been updated to support
    IMDSv2, which is used by [viya4-iac-aws](https://github.com/sassoftware/viya4-iac-aws)
  * [CHANGE] Samples have been reviewed and updated as needed for 
    consistency and correctness

* **Monitoring**

  * No changes this release

* **Logging**
  * [FEATURE] A new Kibana user `logadm` has been created.  This user is intended
    to be the _primary_ Kibana used for routine day-to-day log monitoring.  See
    [The logadm User and Its Access Controls](logging/Limiting_Access_to_Logs.md#the-logadm-user-and-its-access-controls).
  * [CHANGE] Documentation on security and controling access to log messages
    has been revised extensively.  See [Limiting Access to Logs](logging/Limiting_Access_to_Logs.md)
  * [CHANGE] The Event Router component is now deployed to the logging ($LOG_NS) namespace
    instead of to the `kube-system` namespace. During upgrades of existing deployments,
    Event Router will be removed from the `kube-system` namespace and redeployed in the
    logging ($LOG_NS) namespace.
  * [FIX] Upgrade of an existing deployment using Open Distro for Elasticsearch 1.7.0 to the
    current release (which uses Open Distro for Elasticsearch 1.13.2) no longer fails.

## Version 1.1.2 (13DEC21)

### **UPDATE: Due to incomplete remediation of the log4j issue, do not use 1.1.2; use a more recent version

* **Overall**
  * [CHANGE] Samples now use Ingress v1 for Kubernetes 1.22 compatibility

* **Monitoring**
  * [CHANGE] Monitoring components now use Ingress v1 for Kubernetes 1.22 compatibility
  * [FIX] The SAS Jobs dashboards properly handle large numbers of jobs
  * [FIX] The network metric recording rule for SAS Jobs has been fixed to
    support kube-state-metrics 2.x
  * [FIX] Using LOG_COLOR_ENABLE=false now shows log levels in output
  * [FIX] Deployments without an active TERM now run properly again
  * [FIX] Perf/Utilization dashboard metrics display properly again

* **Logging**
  * [SECURITY] Moved to Open Distro for Elasticsearch 1.13.3 (addresses LOG4J
    security vulnerability)
  * [FEATURE] Access controls supporting a new class of users with access to
    all log messages are now created during the deployment process.
  * [FEATURE] Kibana content in a given directory is loaded as a single 'batch'
    rather than individually during the deployment process.
  * [TASK] Feature-flag logic controlling enablement of Kibana tenant spaces
    and other application multi-tenancy related capabilities has been removed
    since these capabilities are no longer optional.
  * [FIX] The path-based ingress sample for accessing Kibana after the move to
    Open Distro for Elasticsearch 1.13.2 now works.
  * [FIX] Improvements for handling failures when deploying specific components
    made in logging deployment scripts
  * [FIX] New Fluent Bit configuration setting to prevent "stale" Kubernetes
    metadata being added to collected log messages.

## Version 1.1.1 (18NOV21)

* **Overall**

  * [FIX] Running in a non-interactive shell (no `$TERM`) caused automated
    deployments to fail

* **Known Issues**
  * On Openshift clusters, upgrading an existing deployment using Open Distro
    for Elasticsearch 1.7.0 to this release (which uses Open Distro for
    Elasticsearch 1.13.2) fails. Deploying this release onto a new OpenShift
    cluster is possible.

## Version 1.1.0 (15NOV21)

* **Overall**

  * [FEATURE] A new flag LOG_VERBOSE_ENABLE is now available to suppress detailed
    logging during script execution. The default setting of this flag is true.

* **Monitoring**
  * [CHANGE] Most monitoring component versions have been updated
    * kube-prometheus-stack Helm chart upgraded from 15.0.0 to 19.0.3
    * Prometheus Operatator upgraded from 0.47.0 to 0.51.2
    * Prometheus upgraded from 2.26.1 to 2.30.3
    * Alertmanager upgraded from 0.21.0 to 0.23.0
    * Grafana upgraded from 7.5.4 to 8.2.1
    * Node Exporter upgraded from 1.0.1 to 1.2.2
    * kube-state-metrics upgraded from 1.9.8 to 2.2.1
  * [FIX] Several dashboards were fixed to adjust to the kube-state-metrics
    2.x metrics
  * [FIX] The KubeHpaMaxedOut alert has been patched to not fire when max
    instances == current instances == 1

* **Logging**
  * [CHANGE] Open Distro for Elasticsearch (i.e. Elasticsearch and Kibana)
    upgraded to version 1.13.2. This includes significant changes to Kibana
    user-interface, see [Important Information About Kibana in the New Release](logging/README.md#important-information-about-kibana-in-the-new-release)
    for details.

  * [FEATURE] A significant number of changes to support application
    multi-tenancy in SAS Viya; including the ability to limit users to log
    messages from a specific Viya deployment and tenant. See
    [Tenant Logging](logging/Tenant_Logging.md) for details.

* **Known Issues**
  * On Openshift clusters, upgrading an existing deployment using Open Distro
    for Elasticsearch 1.7.0 to this release (which uses Open Distro for
    Elasticsearch 1.13.2) fails. Deploying this release onto a new OpenShift
    cluster is possible.

## Version 1.0.13 (20OCT21)

* **Logging**
  * [FIX] Addressed a serious issue (introduced in Version 1.0.12) that
    prevented the successful deployment of the logging components when configured
    using ingress

## Version 1.0.12 (18OCT21)

### **UPDATE: Due to a serious bug, do not use 1.0.12; use a more recent version

* **Overall**
  * [CHANGE] The minimum supported version of OpenShift is now 4.7. OpenShift
    support itself is still experimental
  * [FIX] There is now a check for the presence of the `sha256sum` utility
    in the `PATH`
  * [FIX] There is now a timeout (default 10 min) when deleting namespaces
    using `LOG_DELETE_NAMESPACE_ON_REMOVE` or `MON_DELETE_NAMESPACE_ON_REMOVE`
    The timeout can be set via `KUBE_NAMESPACE_DELETE_TIMEOUT`

* **Monitoring**
  * [FIX] Metrics will be properly collected from the SAS Deployment Operator
  * [CHANGE] Internal improvements, refactoring and preparations for future support
    of application multi-tenancy in SAS Viya
  * [FIX] The two SAS Jobs dashboards have been updated and slightly optimized

* **Logging**
  * [CHANGE] Fluent Bit has been upgraded to version 1.8.7
  * [CHANGE] Internal improvements, refactoring and preparations for future support
    of application multi-tenancy in SAS Viya

## Version 1.0.11 (13SEP21)

* **Monitoring**
  * [FEATURE] SAS Job dashboards now support a 'queue' filter for SAS Workload
  Orchestrator
  * [FEATURE] SAS Job dashboards 'Job' filter now displays user-provided
  job names if available
  * [DEPRECATION] In the next release, NodePorts will be disabled by default
  for Prometheus and AlertManager for security reasons. Set the environment
  variable `PROM_NODEPORT_ENABLE=true` to maintain current behavior as it will
   default to 'false' in the next release

* **Logging**
  * Internal improvements, refactoring and preparations for application multi-
  tenancy in SAS Viya

## Version 1.0.10 (16AUG21)

* **Overall**
  * [FEATURE] The version of `viya4-monitoring-kubernetes` deployed is now
  saved in-cluster for support purposes

* **Monitoring**
  * [FIX] Grafana update fails with PVC multi-attach error

* **Logging**
  * [FEATURE] SAS Update Checker Report added to Kibana
  * [FIX] Enabled NodePort for Elasticsearch causes update-in-place to fail
  * [FIX] Eventrouter references deprecated version of K8s authorization API

## Version 1.0.9 (19JUL21)

* **Overall**
  * [FEATURE] OpenShift version checking has been added
    * Version 4.6.x is supported
    * Version 4.5 or lower generates an error
    * Version 4.7 or higher generates a warning
  * [FEATURE] Integration with the SAS Viya workload node placement strategy
    can be enabled with `NODE_PLACEMENT_ENABLE=true`
  * [FEATURE] OpenShift: Path-based ingress can be enabled
    with `OPENSHIFT_PATH_ROUTES=true`

* **Monitoring**
  * [FIX] OpenShift: Some of the Perf dashboards displayed empty charts
  * [CHANGE] Prometheus version changed from 2.26.0 to 2.26.1
  * [FEATURE] OpenShift: A custom route hostname can be set with
    `OPENSHIFT_ROUTE_HOST_GRAFANA`
  * [FIX] The memory limit of the Prometheus Operator has been increased
    to 1 GiB

* **Logging**
  * [CHANGE] Fluent Bit has been updated to version [1.7.9](https://fluentbit.io/announcements/v1.7.9/)
  * [FEATURE] Fluent Bit disk buffering is now enabled
  * [FIX] Fluent Bit pods were not restarted properly during an
    upgrade-in-place
  * [FIX] OpenShift: Upgrade-in-place now functions properly
  * [FEATURE] OpenShift: A custom route hostname can be set with
    `OPENSHIFT_ROUTE_HOST_KIBANA` and `OPENSHIFT_ROUTE_HOST_ELASTICSEARCH`

## Version 1.0.8 (14JUN21)

* **Monitoring**
  * [EXPERIMENTAL] OpenShift automation
    * Deployment to OpenShift clusters is now supported via
      `monitoring/bin/deploy_monitoring_openshift.sh`
    * OpenShift authentication for Grafana is enabled by default, but can be
      disabled using `OPENSHIFT_AUTH_ENABLE=false`
    * TLS is always enabled for both ingress and in-cluster communication
    * OpenShift support is still under development. Usage and features may
      change until the feature set is finalized.
    * Documentation is available in [Deploying Monitoring on OpenShift](monitoring/OpenShift.md)
  * [FEATURE] The new `NGINX_DASH` environemnt variable now controls whether
  the NGINX dashboard gets deployed when using `deploy_monitoring_*.sh` or
  `deploy_dashboards.sh`.

* **Logging**
  * [EXPERIMENTAL] OpenShift automation
    * Deployment to OpenShift clusters is now supported via
      `logging/bin/deploy_logging_open_openshift.sh`
    * OpenShift support is still under development. Usage and features may
      change until the feature set is finalized.
    * Documentation is available in [Deploying Log Monitoring on OpenShift](logging/OpenShift.md)
  * [FEATURE] Container runtimes other than Docker are now supported.
    The container runtime is now determined during script execution and
    will be used to determine the format of container logs.  However,
    the `KUBERNETES_RUNTIME_LOGFMT` environment varible can be used to
    explicitly identify the format of container logs (e.g. docker or cri-o).

## Version 1.0.7 (17MAY21)

* **Overall**
  * Research was completed that will enable OpenShift support in a future release

* **Monitoring**
  * [CHANGE] Severtal component versions have been updated
    * [Grafana](https://github.com/grafana/grafana/blob/main/CHANGELOG.md#754-2021-04-14):
    7.4.1 -> 7.5.4
    * [Prometheus](https://github.com/prometheus/prometheus/blob/main/CHANGELOG.md#2260--2021-03-31):
    2.24.1 -> 2.26.0
    * [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator/blob/master/CHANGELOG.md#0470--2021-04-13):
    0.45.0 -> 0.47.0
    * [Prometheus Operator Helm Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack):
    13.7.2 -> 15.0.0
    * [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics/blob/master/CHANGELOG.md):
    1.9.7 -> 1.9.8
  * [FIX] Upgrade-in-place of the Prometheus Pushgateway fails
  * [FIX] CAS dashboard: Uptime widget format changed
  * [FIX] CAS dashboard: Dashboard errors with some CAS configurations
  * [Instructions are now available](monitoring/Troubleshooting.md#issue-manually-deleting-the-monitoring-namespace-does-not-delete-all-components)
  for manual cleanup if the monitoring namespace is deleted instead of running
  the remove_* scripts

* **Logging**
  * [Instructions are now available](logging/Troubleshooting.md#issue-manually-deleting-the-logging-namespace-does-not-delete-all-components)
  for manual cleanup if the logging namespace is deleted instead of running
  the remove_* scripts
  * [FIX] The change_internal_password.sh script no longer fails if Helm is not
  installed (Helm was never required)

## Version 1.0.6 (19APR21)

* **Overall**
  * [FEATURE] Custom names for the NGINX controller service are now supported
  via the `NGINX_SVCNAME` environment variable (or `user.env` setting).
  * [CHANGE] Several updates to documentation have been made to improve clarity
  and organize the content in a more useful way.

* **Monitoring**
  * [FEATURE] There is a [new sample](samples/gke-monitoring) that demonstrates
  how to enable Google Cloud's Operation Suite to collect metrics a Prometheus
  instance that is scraping metrics from SAS Viya components
  * [CHANGE] The [Amazon CloudWatch sample](samples/cloudwatch) has been
  updated to include many more metrics and mappings. Almost all metrics exposed
  by SAS Viya and third party components are now mapped properly to sets of
  dimensions. A new [reference](samples/cloudwatch/reference.md) documents
  the metrics by dimention, by source, and by metric name.

* **Logging**
  * [FIX] Missing Kubernetes metadata on log messages from some pods (inc. CAS
  server pod) has been fixed.  Prior to fix, the kube.namespace field was set
  to `missing_ns` and all other `kube.*` fields were not present.

## Version 1.0.5 (15MAR21)

* **Overall**
  * There is a new document discussing support of various
  [Cloud providers](Cloud_Providers.md)

* **Monitoring**
  * [FEATURE] The `monitoring/bin/deploy_dashboards.sh` script now accepts a
  file or directory argument to deploy user-provided dashboards
  * [FEATURE] A new `$USER_DIR/monitoring/dashboards` directory is now
  supported to supply user-provided dashboards at deployment time
  * [FEATURE] The new [CloudWatch sample](samples/cloudwatch) provides
  instructions on configuring the CloudWatch agent to scrape metrics
  from SAS Viya components
  * [FEATURE] The browser-accessible URL for Grafana is now included in
  the output of `monitoring/bin/deploy_monitoring_cluster.sh` (including
  if ingress is configured)
  * [CHANGE] Several component versions have been upgraded
    * [Prometheus](https://github.com/prometheus/prometheus/blob/main/CHANGELOG.md#2240--2021-01-06):
    v2.23.0 -> v2.24.0
    * [Grafana](https://github.com/grafana/grafana/blob/master/CHANGELOG.md#741-2021-02-11):
    7.3.6 -> 7.4.1
    * [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator/blob/master/CHANGELOG.md#0450--2021-01-13):
    0.44.1 -> 0.45.0
    * [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack):
    12.8.0 -> 13.7.2
  * [CHANGE] The following optional Grafana plugins are no longer installed by default:
    * grafana-piechart-panel
    * grafana-clock-panel
    * camptocamp-prometheus-alertmanager-datasource
    * flant-statusmap-panel
    * btplc-status-dot-panel
  * [CHANGE] [cert-manager](https://cert-manager.io/docs/usage/certificate/) resources
  now use 'v1' to align with their use in SAS Viya 4.x

* **Logging**
  * [FEATURE] The browser-accessible URL for Kibana included in the output
  of `logging/bin/deploy_logging_open.sh` now takes into account ingress
  configuration
  * [EXPERIMENTAL] A new _experimental_ script `logging/bin/getlogs.sh`
  allows exporting logs to CSV format [`Documentation`](logging/Export_Logs.md)
  * [FIX] The `logging/bin/change_internal_password.sh` script no longer
  outputs passwords as debug messages

## Version 1.0.4 (15FEB21)

* **Overall**
  * Improved documentation for overall deployment process
  * Improved documentation related to use of TLS
  * Removed references to TLS in ingress sample (samples/ingress); TLS enabled
  ingress shown in TLS sample (samples/tls)

* **Monitoring**
  * [FIX] ENABLE_TLS should set proper port and targetport for v4m-prometheus service
  * [FIX] Remove memory limit on kube-state-metrics
  * [FIX] Kubernetes Cluster Dashboard disk usage not working on EKS

* **Logging**
  * Moved Helm chart from deprecated `stable/fluent-bit` to `fluent/fluent-bit`
  * Fluent Bit version upgraded from 1.5.4 to 1.6.10

## Version 1.0.3 (15Jan21)

* **Overall**
  * Significantly improved documentation for deployment customization
  * `KEEP_TMP_DIR` option added to keep the temporary working directory
  around for troublshooting purposes
  * There is now an early check for `kubectl` cluster admin capabilities

* **Monitoring**
  * Component versions upgraded
    * Helm Chart: 11.1.3->12.8.0
    * Prometheus Operator: 0.43.2->0.44.1
    * Prometheus: v2.22.2-> v2.23.0
    * Grafana: 7.3.1->7.3.6
  * The application filter on the SAS Java Services dashboard is now sorted
  * The Perf/Node Utilization dashboard now uses node names instead of IP
  addresses to identify nodes

* **Logging**
  * Moved Helm chart from deprecated `stable/elasticsearch-exporter` to
  `prometheus-community/elasticsearch-exporter`
  * Improved handling of log message fragment created due to excessively long
  log messages (>16KB)
  * FIX: Eliminated hard-coded namespace in change_internal_password.sh script

## Version 1.0.2 (15Dec20)

* Fixed breaking script error in TLS
* Minor tweaks to SAS Java Services and Perf/Node Utilitzation dashboards

## Version 1.0.1 (14Dec20)

* **Overall**
  * **[BREAKING CHANGE]** - The default passwords for both Grafana and Kibana
  are now randomly generated by default. The generated password is logged
  during the initial deployment. It is possible to explicitly set each
  password via environment variables or `user.env` files.
  * TLS support has been enhanced with improved logging and more accurate
  checking of when `cert-manager` is required
  * Helm 2.x has reached end-of-life and support for it has been removed
* **Monitoring**
  * The `KubeHpaMaxedOut` alert has been modified to only trigger if the
  max replicas is > 1
* **Logging**
  * Refactored deployment/removal scripting internals
  * Added new dashboards & visualizations to Kibana
  * Added support for non-standard Docker root

## Version 1.0.0 (18Nov20)

This is the first public release.

* **Overall**
  * Minor edits and cleanup to README files and sample user response files

* **Monitoring**
  * Grafana version bumped to 7.3.1
  * Prometheus Operator version bumped to 0.43.2
  * Prometheus version bumped to 2.22.2
  * Prometheus Pushgateway version bumped to 1.3.0

## Version 0.1.3 (11NOV20)

* **Overall**
  * [Helm 2.x has reached end-of-life](https://github.com/helm/helm/releases/tag/v2.17.0)
  and is no longer supported. Helm 3.x is now required.
  * Support added for the [SAS Viya Workload Node Placement](https://go.documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p0om33z572ycnan1c1ecfwqntf24.htm&locale=en)
    * By default, monitoring and logging pods are deployed to untainted nodes
    * A new flag, `NODE_PLACEMENT_ENABLE` supports deploying pods to appropriate
    workload node placement nodes

* **Monitoring**
  * Several helm charts have moved from [stable](https://charts.helm.sh/stable)
  to [prometheus-community](https://github.com/prometheus-community/helm-charts).
  * The [prometheus-operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator)
  helm chart has been deprecated and moved to
  [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack).
  * SAS Java and Go ServiceMonitors converted to PodMonitors to properly
  support merged services

* **Logging**
  * Support for SAS Viya move to Crunchy Data 4.5
  * Support for [changing retention period](logging/Log_Retention.md) of log messages
  * Node anti-affinity for Elasticsearch replicas
  * Support for multi-role Elasticsearch nodes (including [sample](samples/esmulti/README.md)
  to demonstrate usage)
  * Additional documentation on using TLS
  * Removed traces of support for ODFE "demo" security configuration
  * [Alternate monitoring solution](logging/Azure_log_analytics_workspaces.md)(proof-of-concept):
  Fluent Bit
  ==> Azure Monitor (Log Analytics workspace)

## Version 0.1.2 (20OCT20)

* **Monitoring**
  * Support for sas-elasticsearch metric collection
  * Refreshed Istio dashboard collection
  * Samples refactored out of monitoring/logging directories into a top-level
  `samples` directory. Additionally, each subdirectory is structured to be
  compatible with [`USER_DIR`](README.md/#customization) customizations.
  * A new sample, [`generic-base`](samples/generic-base) has been created as
  a template for customization. It contains a full set of user response files
  available to customize.
  * Documentation for the samples has been improved
* **Logging**
  * Kubernetes events are now stored in the index associated with the namespace
  of the source of the event instead of a global (cluster) index
  * Multiple fixes to RBAC scripts

## Version 0.1.1 (22SEP20)

* Adjust to breaking Helm 3.3.2 change([Issue #1](https://github.com/sassoftware/viya4-monitoring-kubernetes/issues/1))
* Refactored samples into a top-level `samples` directory
* Force in-cluster TLS for logging ([Issue #2](https://github.com/sassoftware/viya4-monitoring-kubernetes/issues/2))

## Version 0.1.0 (16Sept20)

* Initial versioned release
