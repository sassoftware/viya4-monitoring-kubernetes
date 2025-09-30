
# Monitoring SAS SpeedyStore (SingleStore)
## Overview
This sample demonstrates how to extend SAS Viya Monitoring for Kubernetes to monitor the SingleStore instance embedded within SAS SpeedyStore.  This allows administrators to monitor their SingleStore cluster using the same Grafana instance they use to monitor the rest of their SAS Viya deployment.

This sample is derived from the blog post Using [Grafana dashboards for monitoring SAS SpeedyStore](https://communities.sas.com/t5/SAS-Communities-Library/Using-Grafana-dashboards-for-monitoring-SAS-SpeedyStore/ta-p/973178) written by Michael Goddard from SAS Education.  The blog post was, in turn, based on work Michael did in preparing to cover the topic as part of the [SAS® SpeedyStore: Architect and Deploy the SAS® Viya® Platform with SingleStore](https://learn.sas.com/course/view.php?id=6393) workshop available in [learn.sas.com](https://learn.sas.com/).  This sample includes Grafana dashboards developed and made available by SingleStore.

**Note: There may be other ways to achieve these same objectives, this sample documents one possible approach.**

## Using this Sample
Enabling this monitoring will required configuring components in both SingleStore and Grafana.  While we will describe how to configure the SingleStore components, you are strongly encouraged to review the official SingleStore documentation for a more comprehensive discussion of how to monitor SingleStore effectively, the options for doing so and additional implementation details.  After configuring the SingleStore components, this sample covers defining the datasource within Grafana and deploying the SingleStore-specific Grafana dashboards.

The diagram below. taken from the [SingleStore documentation](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/), provides a high-level overview of metric collection and reporting process.  As shown, the SingleStore pipeline extracts metrics from the SingleStore cluster and stores them within a metrics database.  Grafana pulls metric data directly from this metrics database to populate the dashboards administrators view.

![Overview of SingleStore Monitoring Process ](images/cluster_monitoring_hl_architecture-mfjdOm.webp)

### Overview of Process
* Set-up
  * Set the VIYA_NS environent variable
* SingleStore
  * Configure the SingleStore pipeline
  * Configure  metrics database
  * Configure "monitoring user"
* Grafana
  * Configure Grafana
  * Load SingleStoer Grafana Dashboards

### Configure the SingleStore pipeline and metrics database

The SingleStore Toolbox is used to deploy, administer, and manage a SingleStore cluster. We will use the `sdb-admin start-monitoring-kube` command to configure and start the monitoring. It has a number of flags to control its operations.  See the SingleStore documentation for more information: [start-monitoring-kube](https://docs.singlestore.com/db/v8.9/reference/singlestore-tools-reference/sdb-admin-commands/start-monitoring-kube/).


To configure and start the monitoring, including the metrics database, we will submit the following command:

`sdb-admin start-monitoring-kube --cluster-name sas-singlestore-cluster --namespace {VIYA_NS} --user root --password {ROOT_PWD} --exporter-host {CLUSTER_MASTER_IP}`

But before submitting the command, we will review the parameters being passed to the command.

#### Set the VIYA_NS environent variable

Since you will need to refer repeatedly to the namespace in which SAS Viya (and SingleStore) is deployed, it is helpful to define an environment variable, `VIYA_NS`,to identify the namespace and reference it in subsequent commands.

You can use the following command to do this:

 `export VIYA_NS=myviya`

#### The `cluster-name` parameter
The default name for the SingleStore cluster in a SAS SpeedyStore deployment is: ***sas-singlestore-cluster***.  However, it is possible to change this name, so it is important to confirm the actual cluster name before configuring the monitroing. To get the cluster name, submit the following command via the SingleStore CLI:

 `show global variables like 'cluster_name%';`

#### The `user` and `password` parameters
A core part of the monitoring is the exporter process which collects the metric data from the cluster. The exporter process is typically run as the SingleStore 'root' user due to the permissions required.  In addition, we will need the password for the SingleStore 'root' user.  Note: It is possible to run the process as another user but the user must have the low level permissions needed to create and control the metrics database and pipelines.  Setting up an alternate user is out-of-scope for this sample and we will use the 'root' user.

You can use the following command to get the password for the 'root' user:

`ROOT_PWD=$(kubectl -n ${VIYA_NS} get secret sas-singlestore-cluster -o yaml | grep "ROOT_PASSWORD"|awk '{print $2}'|base64 -d --wrap=0)`

#### The `exporter-host` parameter
As shown in the diagram above, the export process runs on the Master Aggregator. Therefore, you need to target the SingleStore Master node; i.e. the **node-sas-singlestore-cluster-master-0** node (pod) in a SAS SpeedyStore deployment.  You need to provide the fully-qualified host name or IP address for the exporter host. The name needs to be resolvable by the host running the `sdb-admin` command.  Since the fully-qualified host name may not be resolvable, we will use the IP address for the `exporter-host` parameter instead.

You can obtain the IP address for the Master node by submitting the following command:

`CLUSTER_MASTER_IP=$(kubectl -n ${NS} get pods -o wide | grep 'node-sas-singlestore-cluster-master-0' | awk '{print $6}')`

#### Accessing the Kubernetess Cluster
The `sb-admin` command needs to access the Kubernetes cluster on which SAS Viya and SingleStore are running.  It does this through a Kubernetes configuration file.  By default, the command will use the file defined in the KUBECONFIG environment variable or the ~/.kube/config file are used to discover the cluster. Alternatively, the `--config-file` option can be used to specify the kube config.

#### Run the `sb-admin start-monitoring-kube` command
After setting all of the required parameters, submit the following command to configure and start the monitoring, including the metrics database:

`sdb-admin start-monitoring-kube --cluster-name sas-singlestore-cluster --namespace {VIYA_NS} --user root --password {ROOT_PWD} --exporter-host {CLUSTER_MASTER_IP}`

After running the command, the exporter process, the pipeline and the metrics database are created. To confirm this, you can use the SingleStore Studio. For example, in the screenshot below, you can see the newly created **'metrics'** database:
![Screenshot showing SingleStore Studio with the 'metrics' database highlighted](images/02_MG_202508_metrics-database.png)

### Configure "monitoring user"
Grafana will need to connect to the 'metrics' database and you should create a specific user to be used for that purpose. While the permissions required by this user to pull metrics from the database are fairly limited, it can be helpful to grant additional permissions so the user can be used to manage the metrics database, pipelines and the exporter process.

For example, you might grant the following permissions:

`GRANT CLUSTER, SHOW METADATA, SELECT, PROCESS ON *.* to '{S2MonitorUser}'@'%';`

`GRANT SELECT, CREATE, INSERT, UPDATE, DELETE, EXECUTE, INDEX, ALTER, DROP, CREATE DATABASE, LOCK TABLES, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, CREATE PIPELINE, DROP PIPELINE, ALTER PIPELINE, START PIPELINE, SHOW PIPELINE ON metrics.* to '{S2MonitorUser}'@'%';`

Alternatively, you might GRANT the "monitoring user" minimal permissions, and create a second user ("monitoring administrator") to manage the metrics database, pipelines and the exporter process.

|**TO DO: Where do you submit those commands? SingleStore CLI?**

|**TO DO: Does the first GRANT statement  only grant the _minimal_ permissions needed to pull metirics?  And the 2nd grants the extended permissions needed to be an administrator?**

|**TO DO: Is the user name *S2MonitorUser*?**

### Configure Grafana Datasource
Grafana datasources provide connection information allowing Grafana to access metric information in response to user queries and to populate dashboards.

The file [speedystore-datasource.yaml](speedystore-datasource.yaml) in this directory defines the datasource that will allow Grafana to access the 'metrics' database created above.  However, before it can be used, it needs to be edited to provide the proper credentials (i.e. the ***user*** and ***password*** fields in the file).  If the name of the SingleStore cluster is not ***sas-singlestore-cluster***, you will need to update the ***url*** field in the file as well.

Copy the file to some location, update the necessary information and save your changes.  We suggest copying the file into your `$USER_DIR/monitoring` sub-directory, i.e. the same directory used for any other customizations related to the metric monitoring components you have made to your deployment of SAS Viya Monitoring.

Then submit the following command to create the datasource:

`kubectl -n $VIYA_NS create secret generic grafana-metrics-connection --from-file=$USER_DIR/monitoring/speedystore-datasource.yaml`

After secret has been created, you need to apply a specific label to the secret to trigger the automatic provisioning (Ioading) of the datasource into Grafana.

You can use the following command to apply the necessary label:

`kubectl -n $VIYA_NS label secret grafana-metrics-connection "grafana_datasource=1"`

### Import SingleStore Dashboards
To import the SingleStore dashboards into Grafana, you can use the `deploy_dashboards.sh` script found in the `monitoring/bin` sub-directory of this repository.

You can use the following command to import all of the SingleStore dashboards:

`./monitoring/bin/deploy_dashboards.sh samples/speedy/dashboards`

Or, if you can import specific dashboards individually using the same script.  For example, following command imports the ***Cluster View*** dashboard into Grafana:

`./monitoring/bin/deploy_dashboards.sh samples/speedy/dashboards/clusterview.yaml`

### Validate
Once the dashboards have been imported into Grafana, you should  be all set to monitor the SingleStore instance embedded in SAS SpeedyStore.

To validate the configuration, sign into Grafana and review each of the SingleStore dashboards you've imported.  All of the imported dashboards have the ***"sas-speedystore"*** and ***"singlestore"*** tags.  While the data shown will vary based on user activity, all of the dashboards should be available with no errors or warning icons or messages.

## The Grafana Dashboards
* [Cluster View](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/#cluster-view)
* [Detailed Cluster View by Node](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/#detailed-cluster-view-by-node)
* [Disk Usage](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/#disk-usage)
* [Historical Workload Monitoring](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/#historical-workload-monitoring)
* [Memory Usage](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/#memory-usage)
* [Pipeline Summary](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/#pipeline-summary)
* [Pipeline Performance](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/#pipeline-performance)
* [Query History](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/#query-history)
* [Resource Pool Monitoring](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/#resource-pool-monitoring)

## Acknowledgements

## References
[SingleStore Documentation: Configure Monitoring](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/)

[SingleStore Documentation: Detailed Discussion of each dashboard including metrics shown and when to use them](https://docs.singlestore.com/db/v8.9/user-and-cluster-administration/cluster-health-and-performance/configure-monitoring/view-the-dashboards/)


