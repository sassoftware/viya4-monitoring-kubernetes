# Logging

## Introduction

This document outlines the steps needed to deploy SAS Viya Logging, which is 
a set of log collection and
monitoring components for SAS Viya. These components provide a
comprehensive solution for collecting, transforming and surfacing all of the
log messages generated throughout SAS Viya. These components collect logs
from all pods in a Kubernetes cluster, not only the pods used for SAS Viya.

You must have cluster-admin access to any cluster in which you deploy these
components. You cannot deploy successfully if you have access only to a
namespace or a subset of namespaces.

**Note:** If you are deploying SAS Viya Logging on OpenShift, you must follow the deployment process documented in [SAS Viya Logging on OpenShift](/logging/OpenShift.md).

### Important Information about OpenSearch and OpenSearch Dashboards

>As of release 1.2.0, this project uses OpenSearch and OpenSearch Dashboards version 1.3.

**Notes:**

* OpenSearch replaces Elasticsearch.
* OpenSearch Dashboards replaces Kibana.
* Some configuration options, environment variables, and other aspects of this project might still include references to the prior product names. This is intentional. Doing so supports backward compatibility and continuity for users of this project. These references might change at a later date.

### Components

These components are deployed:

* [Fluent Bit](https://fluentbit.io/) - Log collection with limited transformation
* [OpenSearch](http://opensearch.org/docs/1.3) - Unstructured document storage and query engine
* [OpenSearch Dashboards](http://opensearch.org/docs/1.3/dashboards) - User interface for query and visualization
* [Prometheus Exporter for Elasticsearch](https://github.com/prometheus-community/elasticsearch_exporter) - Provides detailed Elasticsearch performance information for Prometheus

## <a name="l_pre_dep"></a>Perform Pre-Deployment Tasks

Before deploying, you must perform these tasks:

- [create a local copy of the repository](#log_loc_copy)
- [customize your deployment](#log_custom)

Note: If you are deploying in a highly secure environment in which the deployment scripts are run on a machine whose network traffic is routed through a proxy server, ensure that `localhost` is included in the list of hosts that are not routed through the proxy server. If it is not included, the OpenSearch deployment fails, because the deployment scripts use port forwarding to make REST API calls to OpenSearch and OpenSearch Dashboards.  

### <a name="log_loc_copy"></a>Create a Local Copy of the Repository

There are two methods to create a local copy of the repository: 
- download a compressed copy 
- clone the repository

#### Download a Compressed Copy of the Repository

1. On the main page of the repository, click on Releases (on the right side of the repository contents area) to display the [Releases](https://github.com/sassoftware/viya4-monitoring-kubernetes/releases) page. 
2. Locate the release that you want to deploy. Typically, you should download the latest release, which is the first one listed.
3. Expand **Assets** for the release, which is located below the release notes.
4. Select either **Source code (.zip)** or **Source code (.tar.gz)** to download the repository 
as a compressed file.
5. Expand the downloaded file to create a local copy of the repository. The repository is created
in a directory named `viya4-monitoring-kubernetes-<release_number>`.

#### Clone the Repository

1. From the main page for the repository, select the **stable** branch, which is the most recent officially released version. The **master** branch is the branch under active development.
2. From the main page for the repository, click **Code**.
3. Copy the HTTPS URL for the repository.
4. From a directory where you want to create the local copy, enter the command `git clone --branch stable <https_url>`. You can replace `stable` with the tag associated with a specific release if you need a version other than the current stable version. For example, if you are developing a repeatable process and need to ensure the same release of the repo is used every time, specify the tag associated with that specific release rather than stable. Note that the tag and release names are typically the same, but you should check the Releases page to verify the tag name.
5. Change to the `viya4-monitoring-kubernetes` directory.
6. Enter the command `git checkout <release_number>`. If you used the command `git clone --branch <my_branch> <https_url>` in Step 4 to specify the branch, release, or tag, you do not have to perform this step

### <a name="log_custom"></a>Customize the Deployment

For most deployment scenarios, the process of customizing the logging deployments consists of:
- creating the location for your local customization files
- using the `USER_DIR` environment variable to specify the location of the customization files
- copying the customization files from one of the provided samples to your local directory
- specifying customization variables and parameters in the customization files

Other scenarios use different customization steps that are specific to each scenario.

[Samples](#lsample) are provided for several common deployment scenarios. Each sample includes detailed information about the customization process and values for the scenario. 

#### Creating the Location for Customization Files

The `USER_DIR` environment variable enables you to use a directory outside of the local repository to contain the customization files. By using a location outside of the repository, you can put the customization files in a location that is under version control, and you can preserve your customizations when you deploy new versions of the monitoring and logging applications. You could also create different sets of configuration files for different cluster types, and then use the `USER_DIR` variable to specify the configuration files to use based on the cluster type on which you were deploying.

For example, to create a root customization directory named *my-viya4mon-user-dir* (that can later be specified by the `USER_DIR` environment variable) and then create a directory for the logging customization files:

```bash
mkdir ~/my-viya4mon-user-dir
mkdir ~/my-viya4mon-user-dir/logging
```

Note that these commands create a customization directory tree in the current user's home directory.

#### Using USER_DIR to Specify the Location of Customization Files

Use the `USER_DIR` environment variable to specify the root location of your local customization files.

This example sets the `USER_DIR` environment variable to the *my-viya4mon-user-dir* directory:

```bash
export USER_DIR=~/my-viya4mon-user-dir
```
The monitoring and logging deployment scripts use the customization files contained in the directories under the `USER_DIR` location.

#### <a name="lcustomization"></a>Specifying Customization Variables and Parameters

After you create the location for your customization files, you can customize the components that you deploy for logging by specifying environment variables and Helm chart parameters in this set of customization files (in this example, contained in the *my-viya4mon-user-dir* root directory):

```text
my-viya4mon-user-dir/user.env

my-viya4mon-user-dir/logging/user.env
my-viya4mon-user-dir/logging/user-values-opensearch.yaml
my-viya4mon-user-dir/logging/user-values-osd.yaml
my-viya4mon-user-dir/logging/user-values-es-exporter.yaml
my-viya4mon-user-dir/logging/user-values-fluent-bit-open.yaml
```

You specify the environment variables in the `user.env` files and the Helm chart parameters in the `*.yaml` customization files. 

In order to minimize the potential for errors, you should not manually create the customization files, but use one of the set of sample files as the starting point for your own customizations. 

#### <a name="lsample"></a>Using Customization Samples

The samples are provided to demonstrate how to customize the deployment of the monitoring components for specific situations. The samples provide instructions and example `*.yaml` files that you can modify to fit your environment. Although each example focuses on a specific scenario, you can combine multiple samples by merging the appropriate values in each deployment file.

If your situation matches one of the specialized samples, you can copy the customization files for the sample that most closely matches your environment from the repository to your customization file directory. This enables you to start your customization with a set of values that are valid for your situation. You can then make further modifications to the files.

If your situation does not match any of the specialized samples, copy the [generic-base sample](/samples/generic-base) as a base for your customization files, and then change the values or copy values from other samples to match your environment.

If more than one sample applies to your environment, you can manually copy the values from the other sample files to the files in your customization directory.

See the [Samples page](/samples) for a list of provided samples.

#### Specifying Environment Variables in user.env Files

Environment variables control script behavior and high-level options such as TLS and workload node placement. Note that you can also specify environment variables on a command line, but specifying the variables in `user.env` is recommended, in order to maintain a consistent set of values for future deployments. The values in the top-level `user.env` file (`my-viya4mon-user-dir/user.env`) apply to both the monitoring and logging deployments. The values in `my-viya4mon-user-dir/logging/user.env` apply only to the logging deployment.

Any line whose first character is `#` is treated as a comment and ignored.

#### Specifying the Default OpenSearch Dashboards Password

You can set the `ES_ADMIN_PASSWD` environment variable to specify the default password for OpenSearch Dashboards. If you do not specify a default password, one is randomly generated.

#### Using Ingress for Cloud Providers

If you are using a cloud provider, you must use Ingress, rather than
NodePorts. Use the samples in the [samples/ingress](/samples/ingress)
area of this repository to set up either host-based or path-based Ingress.

#### Specifying the Retention Period for Log Messages

You can also modify values in the `user.env` file to change the retention period for log messages. By default, messages from SAS Viya and Kubernetes pods are retained for three days and messages from logging components are retained for one day. See [Log_Retention.md](Log_Retention.md) for information about changing the log retention period. 

#### TLS Support

The [TLS Logging sample](/samples/tls/logging) contains information about specifying the `TLS_ENABLE` environment variable to use TLS for connections between the user (or an Ingress object) and the logging components. In-cluster communications between logging components always use TLS. If you use Ingress and also use TLS for communication between the user and the logging components, you must also manually populate Kubernetes secrets as listed in the sample. 

#### Modify user-values-*.yaml to Change Helm Chart Values

The logging stack uses the following Helm charts:

* **OpenSearch**
  * [Chart](https://github.com/opensearch-project/helm-charts/tree/1.x/charts/opensearch) 
  * [Default values](https://github.com/opensearch-project/helm-charts/blob/1.x/charts/opensearch/values.yaml)
* **OpenSearch Dashboards**
  * [Chart](https://github.com/opensearch-project/helm-charts/tree/1.x/charts/opensearch-dashboards)
  * [Default values](https://github.com/opensearch-project/helm-charts/blob/1.x/charts/opensearch-dashboards/values.yaml)
* **Fluent Bit**
  * [Chart](https://github.com/helm/charts/tree/master/stable/fluent-bit)
  * [Default values](https://github.com/helm/charts/blob/master/stable/fluent-bit/values.yaml)
* **Elasticsearch Exporter**
  * [Chart](https://github.com/helm/charts/tree/master/stable/elasticsearch-exporter)
  * [Default values](https://github.com/helm/charts/blob/master/stable/elasticsearch-exporter/values.yaml)

To change any of the Helm chart values used by either the OpenSearch
(including OpenSearch Dashboards) or Fluent Bit charts, edit the appropriate
`user-values-*.yaml` file listed below:

* For OpenSearch, modify
`logging/user-values-opensearch.yaml`.
* For OpenSearch Dashboards, modify `logging/user-values-osd.yaml`

* For Fluent Bit, modify `logging/user-values-fluent-bit-open.yaml`.
Note that the Fluent Bit configuration files are generated from a
Kuberenetes configMap which is created from the
`fluent-bit_config.configmap_open.yaml` file. Therefore, any edits that you
make in the `user-values-fluent-bit-open.yaml` file that are intended to
affect the Fluent Bit configuration files are ignored. However, edits
affecting other aspects of the Fluent Bit Helm chart execution are processed.

When you edit any of the `user-values-*.yaml` files, ensure that the parent
item of any item that you uncomment is also uncommented.  For
example, in the `user-values-opensearch.yaml` file, if you uncommented 
the `storageClass` item for the OpenSearch master nodes, you must also 
uncomment the `persistence` item, as shown below:

```yaml
# Sample user-values-opensearch.yaml

persistence:                   #uncomment b/c storageClass is uncommented
  storageClass: alt-storage    #uncomment to direct OpenSearch to use the alt-storageClass 
```

#### Workload Node Placement

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

Multiple persistent volume claims (PVCs) are created when OpenSearch is
installed. The deployment script assumes that your cluster has some form of
dynamic volume provisioning in place that will automatically provision
storage to support PVCs. However, if your cluster
does not have such a provisioner, you must manually create the
necessary persistent volumes (PVs) before you run the deployment scripts.

#### Using a Different Kubernetes Storage Class

To prevent OpenSearch and your SAS Viya deployment from competing for
the same disk space, you might want to direct the OpenSearch PVCs
to a different Kubernetes storageClass. This prevents contention
and insulates each one from storage issues that are caused by the other. For
example, if you use different storageClasses and your SAS Viya deployment
runs out of disk space, OpenSearch continues to operate.

To specify an alternate storageClass to use, modify the appropriate
`user-values-*.yaml` file used for Helm processing, as described above.
By default, the lines referencing the storageClass in the persistence stanza of the
`user-values-opensearch.yaml` file are commented out, which specifies that
the default storage class is used. To direct the OpenSearch PVCs to use an
alternate storageClass, edit the file to uncomment the appropriate lines
and confirm the storageClassName matches your preferred storageClass.
The example used in the section ___"Modify user-values-*.yaml"___ above
illustrates this change.

## Deploy SAS Viya Logging

To deploy the logging components, ensure that you are in the directory into
which you cloned the repository and issue this command:

```bash
./logging/bin/deploy_logging.sh
```

The script creates the namespace into which the components are deployed. By default, the components are deployed into the namespace `logging`.

**Note:* If you are deploying SAS Viya Logging on OpenShift, you must follow the deployment process documented in [SAS Viya Logging on OpenShift](/logging/OpenShift.md).**

## Update Logging Components

Updates in place are supported. To update, re-run the
`deploy_logging.sh` script to install the latest versions of all components, indexes, and dashboards.

## <a name="login_kibana"></a>Log In to OpenSearch Dashboards

Use the following steps to log in to OpenSearch Dashboards:

1. In the "Login to OpenSearch Dashboards" window, enter your OpenSearch Dashboards credentials and click __Log In__. The "Select your tenant" window appears.
2. In the __Choose from custom__ list, confirm that your tenant is selected by default. If not, select your tenant from the list.
4. Click __Confirm__. OpenSearch Dashboards opens.

## <a name="lremove"></a>Remove Logging Components

To remove the logging components, run the following command:

```bash
cd <viya4-monitoring-kubernetes repo directory>

logging/bin/remove_logging.sh
```

The script removes configmaps and secrets that were created by the deployment script. PersistentVolumeClaims and Kubernetes secrets that were created manually are not removed.  

**Note: If you deployed SAS Viya Logging on OpenShift, you must use this script to remove the logging components:**
```bash
cd <viya4-monitoring-kubernetes repo directory>

logging/bin/remove_logging_openshift.sh
```

## Validate Your Deployment

### Access OpenSearch Dashboards

If the deployment process completes without errors, a message 
appears in the console window containing the URL address for OpenSearch Dashboards and the URL for OpenSearch (if you enabled access to OpenSearch). The URL for OpenSearch Dashboards is different depending on whether you use nodeports or Ingress to access OpenSearch Dashboards. 

To validate that the deployment was successful and confirm that all of the logging components
are working, access OpenSearch Dashboards and review the log messages that are collected.

__Note:__ The displayed URL for OpenSearch Dashboards might not be correct if your networking rules alter how hosts are accessed. If this is the case, contact your Kubernetes administrator to determine the proper host, port and/or path to access OpenSearch Dashboards.

### Use OpenSearch Dashboards to Validate Logging

* Obtain the default password for the OpenSearch Dashboards admin user. Unless you set the `ES_ADMIN_PASSWD` environment variable (either in the `user.env` file or on the command line) to specify a default password during deployment, the default password is randomly generated and displayed during deployment.

If you want to change the password, issue this command:

```bash
logging/bin/change_internal_password.sh admin <newPassword>
```
  
* Start OpenSearch Dashboards in a browser using the URL provided at the end of the
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

## Configure Access Via NodePorts (optional)

You can enable access via NodePorts to enable users to access an application, 
such as OpenSearch, so that they can issue queries using API calls or scripts. 
See [Configure Access Via NodePorts](http://documentation.sas.com/doc/en/sasadmincdc/default/callogging/n0l4k3bz39cw2dn131zcbat7m4r1.htm).