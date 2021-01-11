# Logging

## Introduction

This document outlines the steps needed to deploy a set of log collection and
monitoring components for SAS Viya. These components provide a
comprehensive solution for collecting, transforming and surfacing all of the
log messages generated throughout SAS Viya. These components collect logs
from all pods in a Kubernetes cluster, not only the pods used for SAS Viya.

You must have cluster-admin access to any cluster in which you deploy these
components. You cannot deploy successfully if you have access only to a
namespace or a subset of namespaces.

### Components

These components are deployed:

* [Fluent Bit](https://fluentbit.io/) - Log collection with limited transformation
* [Elasticsearch](https://www.elastic.co/) - Unstructured document storage and query engine
* [Kibana](https://www.elastic.co/kibana) - User interface for query and visualization
* [Prometheus Exporter for Elasticsearch](https://github.com/justwatchcom/elasticsearch_exporter) -
Provides detailed Elasticsearch performance information for Prometheus

## Perform Pre-Deployment Tasks
Before deploying, you must select the release that you want to deploy, then create a local copy of the repository. 

### Select the Release to Copy

1. Click on **tags** above the repository tree.
2. On the **Tags** page, click [Releases](https://github.com/sassoftware/viya4-monitoring-kubernetes/releases) to view the list of available releases.
3. Use the release notes to determine the release you want to deploy.

### Create a Local Copy of the Repository

There are two methods to create a local copy of the repository: 
- download a compressed copy 
- clone the repository

#### Download a Compressed Copy of the Repository

1. On the [Releases](https://github.com/sassoftware/viya4-monitoring-kubernetes/releases) page, locate the release that you want to deploy.
2. Expand **Assets** for the release, which is located below the release notes.
3. Select either **Source code (.zip)** or **Source code (.tar.gz)** to download the repository 
as a compressed file.
4. Expand the downloaded file to create a local copy of the repository. The repository is created
in a directory named `viya4-monitoring-kubernetes-<release_number>`.

#### Clone the Repository

1. From the main page for the repository, click **Code**.
2. Copy the HTTPS URL for the repository.
3. From a directory where you want to create the local copy, enter the 
command `git clone <https_url>`. 
4. Change to the `viya4-monitoring-kubernetes` directory.
5. Enter the command `git checkout <release_number>`

### Customize the Deployment

The process of customizing the logging deployment consists of: 
- creating the location for your local customization files
- using the `USER_DIR` environment variable to specify the location of the customization files
- copying the customization files from one of the provided samples to your local directory
- specifying customization variables and parameters in the customization files

See the [main README](../README.md#customization) to for information about the customization process.

After you create the location for your customization files, you can customize the components that you deploy for logging by specifying environment variables and Helm chart parameters in this set of customization files (in this example, contained in the *my-viya4mon-user-dir* root directory):

```text
my-viya4mon-user-dir/user.env

my-viya4mon-user-dir/logging/user.env
my-viya4mon-user-dir/logging/user-values-elasticsearch-open.yaml
my-viya4mon-user-dir/logging/user-values-es-exporter.yaml
my-viya4mon-user-dir/logging/user-values-fluent-bit-open.yaml
```

You specify the environment variables in the `user.env` files and the Helm chart parameters in the `*.yaml` configuration files. 

In order to minimize the potential for errors, you should not manually create the customization files, but use one of the set of sample files as the starting point for your own customizations. 

#### Specifying Environment Variables in user.env Files

Environment variables control script behavior and high-level options such as TLS and workload node placement. Note that you can also specify environment variables on a command line, but specifying the variables in `user.env` is recommended, in order to maintain a consistent set of values for future deployments. The values in the top-level `user.env` file (`my-viya4mon-user-dir/user.env`) apply to both the monitoring and logging deployments. The values in `my-viya4mon-user-dir/logging/user.env` apply only to the logging deployment.

Any line whose first character is `#` is treated as a comment and ignored.

#### Specifying the Default Kibana Password

You can set the `ES_ADMIN_PASSWD` environment variable to specify the default password for Kibana. If you do not specify a default password, one is randomly generated.

#### Specifying the Retention Period for Log Messages

You can also modify values in the `user.env` file to change the retention period for log messages. By default, messages from SAS Viya and Kubernetes pods are retained for three days and messages from logging components are retained for one day. See [Log_Retention.md](Log_Retention.md) for information about changing the log retention period. 

### Modify user-values-*.yaml to Change Helm Chart Values

The logging stack uses the following Helm charts:

* **Opendistro Elasticsearch**
  * [Chart](https://github.com/opendistro-for-elasticsearch/opendistro-build/tree/master/helm)
  * [Default values](https://github.com/opendistro-for-elasticsearch/opendistro-build/blob/master/helm/opendistro-es/values.yaml)
* **Fluent Bit**
  * [Chart](https://github.com/helm/charts/tree/master/stable/fluent-bit)
  * [Default values](https://github.com/helm/charts/blob/master/stable/fluent-bit/values.yaml)
* **Elasticsearch Exporter**
  * [Chart](https://github.com/helm/charts/tree/master/stable/elasticsearch-exporter)
  * [Default values](https://github.com/helm/charts/blob/master/stable/elasticsearch-exporter/values.yaml)

To change any of the Helm chart values used by either the Elasticsearch
(including Kibana) or Fluent Bit charts, edit the appropriate
`user-values-*.yaml` file listed below:

* For Elasticsearch (and Kibana), modify
`logging/user-values-elasticsearch-open.yaml`.

* For Fluent Bit, modify `logging/user-values-fluent-bit-open.yaml`.
Note that the Fluent Bit configuration files are generated from a
Kuberenetes configMap which is created from the
`fluent-bit_config.configmap_open.yaml` file. Therefore, any edits that you
make in the `user-values-fluent-bit-open.yaml` file that are intended to
affect the Fluent Bit configuration files are ignored. However, edits
affecting other aspects of the Fluent Bit Helm chart execution are processed.

When you edit the `user-values-fluent-bit.yaml` file, ensure that the parent
item of any item that you uncomment is also uncommented.  For
example, if you uncommented the `storageClass` item for the Elasticsearch
master nodes, you must also uncomment the `persistence` item, the
`master` item and the `elasticsearch` item, as shown below:

```yaml
# Sample user-values-elasticsearch-open.yaml

elasticsearch:     # Uncommented b/c 'master' is uncommented
  master:          # Uncommented b/c 'persistenance' is uncommented
    persistence:   # Uncommented b/c 'storageClass' is uncommented
      storageClass: alt-storage  # Uncommented to direct ES to alt-storage storageClass
```

### Workload Node Placement

SAS Viya is deployed using a workload node placement strategy, which uses the 
`workload.sas.com/class` taint to optimize the placement of its components on 
Kubernetes nodes. By default, the logging components do **not** participate in the 
workload node placement strategy. This is the recommended approach, because it enables the 
logging components to function even if `workload.sas.com/class`-tainted nodes 
are scaled to zero (in other words, are shut down). Therefore, by default, 
most of the logging components are deployed to cluster nodes that do not
have `workload.sas.com/class` taints. On Microsoft Azure, this results
in pods being deployed on nodes in the `system` nodepool. 

To deploy the logging components so that they participate in the SAS Viya workload node
placement strategy rather than use this recommended deployment, set `NODE_PLACEMENT_ENABLE` to `true` in `$USER_DIR/logging/user.env`.

### Evaluate Storage Considerations

#### Provision Persistent Volumes or Persistent Volume Claims

Multiple persistent volume claims (PVCs) are created when Elasticsearch is
installed. The deployment script assumes that your cluster has some form of
dynamic volume provisioning in place that will automatically provision
storage to support PVCs. However, if your cluster
does not have such a provisioner, you must manually create the
necessary persistent volumes (PVs) before you run the deployment scripts.

#### Using a Different Kubernetes Storage Class

To prevent Elasticsearch and your SAS Viya deployment from competing for
the same disk space, you might want to direct the Elasticsearch PVCs
to a different Kubernetes storageClass. This prevents contention
and insulates each one from storage issues that are caused by the other. For
example, if you use different storageClasses and your SAS Viya deployment
runs out of disk space, Elasticsearch continues to operate.

To specify an alternate storageClass to use, modify the appropriate
`user-values-*.yaml` file used for Helm processing, as described above.
By default, the lines referencing the storageClass in the persistence stanza of the
`user-values-*.yaml` file are commented out, which specifies that
the default storage class is used. To direct the Elasticsearch PVCs to use an
alternate storageClass, edit the file to uncomment the appropriate lines
and confirm the storageClassName matches your preferred storageClass.
The example used in the section ___"Modify user-values-*.yaml"___ above
illustrates this change.

## Deploy SAS Viya Logging

To deploy the logging components, ensure that you are in the directory into
which you cloned the repository and issue this command:

```bash
./logging/bin/deploy_logging_open.sh
```

The script creates the namespace into which the components are deployed. By default, the components are deployed into the namespace `logging`.

## Update Logging Components

Updates in place are supported. To update, re-run the
`deploy_logging_open.sh` script to install the latest versions of all components, indexes, and dashboards.

## Remove Logging Components

To remove all logging components, run the following command:

```bash
cd <viya4-monitoring-kubernetes repo directory>

logging/bin/remove_logging_open.sh
```

The script removes configmaps and secrets that were created by the deployment script. PersistentVolumeClaims and Kubernetes secrets that were created manually are not removed.  

## Validate Your Deployment

### Access Kibana

If the deployment process completes without errors, a message such as this
appears in the console window:

```text
=====================================================================
== Access Kibana using this URL: http://myK8snode:31033/app/kibana ==
=====================================================================
```

The message provides the URL address for the Kibana application. To validate
that the deployment was successful and confirm that all of the logging components
are working, access Kibana and review the log messages that are collected.

__Note:__ The displayed URL for Kibana might not be correct if you defined
ingress objects or if your networking rules alter how hosts are accessed. If
this is the case, contact your Kubernetes administrator to determine the proper
host, port and/or path to access Kibana.

### Use Kibana to Validate Logging

* Obtain the default password for the Kibana admin user. Unless you set the `ES_ADMIN_PASSWD` environment variable (either in the `user.env` file or on the command line) to specify a default password during deployment, the default password is randomly generated and displayed during deployment.

If you want to change the password, issue this command:

```bash
logging/bin/change_internal_password.sh admin <newPassword>
```
  
* Start Kibana in a browser using the URL provided at the end of the
deployment process.
* Click on the __Dashboard__ icon in the toolbar.
  * If the Dashboard page displays the header __Editing New Dashboard__, select
  the __Dashboard__ icon again. The Dashboards page appears and displays a list
  of dashboards.
  * In the list of dashboards, click on __Log Message Volumes with Level__.
  * The __Log Message Volumes with Level__ dashboard appears, which shows the
  log message volumes over time broken down by the source of the log messages.
  * The __Log Messages__ table (below the charts) displays log messages, with
  the newest messages at the top, based on the current filters. You can filter
  messages by entering text in the query box, selecting  __Add filter__, or
  clicking a log source entry in the legend next to the
  __Message Volumes over Time by Source__ chart.

* Select the __Discover__ icon in the toolbar to display the Discover page. Use
this page to review the collected log messages. You can use the query box or
__Add filter__ to filter the messages that are displayed.
