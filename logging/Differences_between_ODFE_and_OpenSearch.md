# Differences between Open Distro for Elasticsearch and OpenSearch

## Overview

In release 1.2.0 (June 2022), the SAS Viya Monitoring for Kubernetes solution makes the following changes:

* OpenSearch is deployed instead of the Open Distro for Elasticsearch (ODFE) distribution of Elasticsearch.
* OpenSearch Dashboards is deployed instead of Kibana.

This topic describes the changes between the deployments. It assumes you have an understanding of the deployment process for the current log-monitoring solution including the customization process.

**Note:** Other than the differences described in this topic, you should not see any significant differences when using the log-monitoring solution configured with OpenSearch.

## Important Considerations

When preparing to migrate, be sure to remember the following considerations:

* The migration is nonreversible. You cannot reverse an OpenSearch-based deployment to a deployment that uses Open Distro for Elasticsearch without losing collected log messages.
* You cannot run an Open Distro for Elasticsearch-based deployment and an OpenSearch-based deployment in the same cluster, even if they are deployed to different Kubernetes namespaces.
  
## Differences

### Products

The unstructured data store and search back-end component, formerly Elasticsearch, is now OpenSearch. 

The visualization and reporting application, formerly Kibana, is now OpenSearch Dashboards.

### Helm Charts

Although OpenSearch is virtually identical to Open Distro for Elasticsearch, the Helm chart used to deploy OpenSearch is different. This required the following changes in the customization process: 

* The names of the YAML files used to customize the deployment have changed.
* The structure of these YAML files has changed. 

See [Compiled Differences](#compiled_dif_table) for more information.

### Deployment Topology

The topology of the search back-end is different. 

* The Open Distro for Elasticsearch search back-end is configured by default to use eight Kubernetes pods composed of two Elasticsearch client nodes, three Elasticsearch master nodes, and three Elasticsearch data nodes.
* For the OpenSearch search back-end, the default configuration is three Kubernetes pods composed of three OpenSearch "multi-role" nodes.
* The Java memory settings have increased from 1GB to 4GB for each OpenSearch node.

### NodePort Accessibility

If you had not configured access via Ingress, the Open Distro for Elasticsearch-based deployment script automatically made Kibana accessible via NodePort.

The OpenSearch deployment script does not do this automatically. If you want to make OpenSearch Dashboards accessible via NodePort, you must set the environment variable `KB_KNOWN_NODEPORT_ENABLE` to `true` before running the `logging/bin/deploy_logging.sh` script.

When this option is set, OpenSearch Dashboards is accessible on the same port (31033) that was used by Kibana.

**Note:** NodePorts are not suitable for production deployments.

**Note:** As of release 1.2.1, if you do not set the environment variable `KB_KNOWN_NODEPORT_ENABLE` to `true` before running the `logging/bin/deploy_logging.sh` script, you can now use the `configure_nodeport.sh` 
script after deployment.
See [Configure Access to OpenSearch](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n0l4k3bz39cw2dn131zcbat7m4r1.htm).

### Migrate an Existing Deployment

To migrate an existing deployment of the log monitoring project, run the `./logging/bin/deploy_logging.sh` script.
If an existing deployment is detected in the namespace, that deployment
is migrated to the OpenSearch-based deployment.

### Remove OpenSearch-based Log Monitoring

To remove log monitoring that uses OpenSearch instead of ODFE, run the `logging/bin/remove_logging.sh` script. The new script supports all the same environment variables as the prior script.

### Running Other Scripts

Other than the scripts described in the [table](#compiled_dif_table), the remaining log monitoring scripts work with either search back-end. 

**Note:** When running the administrative scripts with an existing ODFE-based deployment, you must set the `LOG_SEARCH_BACKEND` environment variable to `ODFE` prior to running the script. By default, these scripts assume the search back-end is OpenSearch.

See [Compiled Differences](#compiled_dif_table) for the list of changed script file names.

### <a name="compiled_dif_table"></a>Compiled Differences

Open Distro for Elasticsearch (Release 1.1.8 and earlier) | Experimental OpenSearch (Release 1.1.8)  | Production OpenSearch (Release 1.2.0 and later)
----|----|----
**Script File Name Changes between Releases**
logging/bin/deploy_logging_open.sh | logging/bin/deploy_logging_opensearch.sh | logging/bin/deploy_logging.sh 
logging/bin/deploy_logging_open_openshift.sh | logging/bin/deploy_logging_opensearch_openshift.sh |	logging/bin/deploy_logging_openshift.sh
logging/bin/remove_logging_open.sh | logging/bin/remove_logging_opensearch.sh | logging/bin/remove_logging.sh
logging/bin/remove_logging_open_openshift.sh | logging/bin/remove_logging_opensearch_openshift.sh | logging/bin/remove_logging_openshift.sh
**YAML File Name Changes between Releases** **Note:** The OpenSearch YAML files required format changes from the Elasticsearch YAML file. See the Ingress sample and the TLS sample  for more details. | |
$USER_DIR/logging/user-values-elasticsearch-open.yaml (Elasticsearch configuration changes) | $USER_DIR/user-values-elasticsearch-opensearch.yaml | $USER_DIR/logging/user-values-opensearch.yaml
$USER_DIR/logging/user-values-elasticsearch-open.yaml (Kibana configuration changes) | 	$USER_DIR/user-values-osd-opensearch.yaml | $USER_DIR/logging/user-values-osd.yaml
**Kubernetes Resource Name Changes between Releases** ||
**Kubernetes Pods** ||
v4m-es-data-0, v4m-es-data-1, v4m-es-data-2; v4m-es-master-0, v4m-es-master-1, v4m-es-master-2; v4m-es-client--xxxxxxxxxx-xxxxx, v4m-es-client-xxxxxxxxxx-xxxxx	| v4m-es-0, v4m-es-1, v4m-es-2 | v4m-search-0, v4m-search-1, v4m-search-2
v4m-es-kibana-xxxxxxxx-xxxxx | v4m-osd-xxxxxxxxxx-xxxxx	| v4m-osd-xxxxxxxxxx-xxxxx
**Kubernetes Services** ||
v4m-es-client-service |	v4m-es; v4m-es-headless	v4m-search; | v4m-search-headless
v4m-es-data-svc | Eliminated | Eliminated
v4m-es-discovery | Eliminated | Eliminated
v4m-es-kibana-svc | v4m-osd | v4m-osd
v4m-es-client-service | v4-es | v4m-search
**Kubernetes Ingress** ||
v4m-es-kibana-ing | v4m-osd | v4m-osd