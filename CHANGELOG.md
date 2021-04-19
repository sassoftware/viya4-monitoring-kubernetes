# SAS Viya Monitoring for Kubernetes

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
  * [Alternate monitoring solution](logging/AZURE_LOG_ANALYTICS_WORKSPACES.md)(proof-of-concept):
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
