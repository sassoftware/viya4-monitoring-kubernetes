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

**Important:** This topic requires that you work from the "stable" branch of the SAS Viya Monitoring for Kubernetes repository. 
**Do not** use the "move2opensearch" branch in the repository.

## Differences

### Products

The unstructured data store and search back-end component, formerly Elasticsearch, is now OpenSearch. 

The visualization and reporting application, formerly Kibana, is now OpenSearch Dashboards.

### Helm Charts

While OpenSearch is virtually identical to Open Distro for Elasticsearch, the Helm chart used to deploy OpenSearch is different. This required the following changes in the customization process: 

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

The OpenSearch deployment script does not do this automatically. If you want to make OpenSearch Dashboards accessible via NodePort, you must set the environment variable `KB_KNOWN_NODEPORT_ENABLE` to `True` before running the `logging/bin/deploy_logging_opensearch.sh` script.

Kibana was accessible from port 31033. OpenSearch Dashboards is accessible from port 31034.

**Note:** NodePorts are not suitable for production deployments. NodePorts are intended only as a convenience for internal testing groups working in an OpenStack environment. 

### Migrate an Existing Deployment

To migrate an existing deployment of the log monitoring project, run the `./logging/bin/deploy_logging_opensearch.sh` script.
If an existing deployment is detected in the namespace, that deployment
is migrated to the OpenSearch-based deployment.

### Remove OpenSearch-based Log Monitoring

To remove log monitoring that uses OpenSearch instead of ODFE, run the `logging/bin/remove_logging_opensearch.sh` script. The new script supports all the same environment variables as the prior script.

### Running Other Scripts

Other than the scripts described in the [table](#compiled_dif_table), the remaining log monitoring  scripts work with either search back-end. 

See [Compiled Differences](#compiled_dif_table) for the list of changed script file names.

**Important:** During the experimental phase only, you must set the environment variable `LOG_SEARCH_BACKEND` to `OPENSEARCH` (in uppercase) when you run scripts with OpenSearch.

### <a name="compiled_dif_table"></a>Compiled Differences

Stable Release 1.1.8 and Earlier (ODFE) | OpenSearch Experimental Release 1.1.8  | OpenSearch Production Release 1.2.0
----|----|----
**Script File Name Changes between Releases**
logging/bin/deploy_logging_open.sh | logging/bin/deploy_logging_opensearch.sh | logging/bin/deploy_logging.sh 
logging/bin/deploy_logging_open_openshift.sh | logging/bin/deploy_logging_opensearch_openshift.sh |	logging/bin/deploy_logging_openshift.sh
logging/bin/remove_logging_open.sh | logging/bin/remove_logging_opensearch.sh | logging/bin/remove_logging.sh
logging/bin/remove_logging_open_openshift.sh | logging/bin/remove_logging_opensearch_openshift.sh | logging/bin/remove_logging_openshift.sh
**YAML File Name Changes between Releases** **Note:** The OpenSearch YAML files required format changes from the Elasticsearch YAML file. See samples/ingress or samples/tls for more details. | |
$USER_DIR/logging/user-values-elasticsearch-open.yaml (Elasticsearch configuration changes) | $USER_DIR/user-values-elasticsearch-opensearch.yaml | $USER_DIR/logging/user-values-opensearch.yaml
$USER_DIR/logging/user-values-elasticsearch-open.yaml (Kibana configuration changes) | 	$USER_DIR/user-values-osd-opensearch.yaml | $USER_DIR/logging/user-values-osd.yaml
**Kubernetes Resource Name Changes between Releases** ||
v4m-es-data-0, v4m-es-data-1, v4m-es-data-2; v4m-es-master-0, v4m-es-master-1, v4m-es-master-2; v4m-es-client--xxxxxxxxxx-xxxxx, v4m-es-client-xxxxxxxxxx-xxxxx	| v4m-es-0, v4m-es-1, v4m-es-2 | v4m-search-0, v4m-search-1, v4m-search-2
v4m-es-kibana-xxxxxxxx-xxxxx | v4m-osd-xxxxxxxxxx-xxxxx	| v4m-osd-xxxxxxxxxx-xxxxx
v4m-es-client-service |	v4m-es; v4m-es-headless	v4m-search; | v4m-search-headless
v4m-es-data-svc | Eliminated | Eliminated
v4m-es-discovery | Eliminated | Eliminated
v4m-es-kibana-svc | v4m-osd | v4m-osd
v4m-es-client-service | v4-es | v4m-search
v4m-es-kibana-ing | v4m-osd | v4m-osd