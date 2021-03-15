# Monitoring

## Introduction

This document outlines the steps needed to deploy a set of monitoring
components that provide the ability to monitor resources in a SAS Viya
environment. These components support monitoring of SAS Viya resources
for each SAS Viya namespace as well as monitoring for Kubernetes cluster
resources.

You must have cluster-admin access to any cluster in which you deploy these
components. You cannot deploy successfully if you have access only to a
namespace or a subset of namespaces.

### Components

These components are deployed:

* Prometheus Operator
* Prometheus
* Alertmanager
* Grafana
* node-exporter
* kube-state-metrics
* Prometheus adapter for Kubernetes metrics APIs
* Prometheus Pushgateway
* Grafana dashboards
* Kubernetes cluster alert definitions

If you are using a cloud provider, you must use ingress, rather than
NodePorts. Specify the information needed to use ingress during the customization process.

## Perform Pre-Deployment Tasks

Before deploying, you must perform these tasks:

- [create a local copy of the repository](#mon_loc_copy)
- [customize your deployment](#mon_custom)

### <a name="mon_loc_copy"></a>Create a Local Copy of the Repository

There are two methods to create a local copy of the repository:

* download a compressed copy
* clone the repository

#### Download a Compressed Copy of the Repository

1. On the main page of the repository, click on Releases (on the right side of the repository contents area) to display the [Releases](https://github.com/sassoftware/viya4-monitoring-kubernetes/releases)
page.
2. Locate the release that you want to deploy. Typically, you should download the latest release, which is the first one listed.
3. Expand **Assets** for the release, which is located below the release notes.
4. Select either **Source code (.zip)** or **Source code (.tar.gz)** to download
the repository as a compressed file.
5. Expand the downloaded file to create a local copy of the repository. The
repository is created in a directory named `viya4-monitoring-kubernetes-<release_number>`.

#### Clone the Repository

1. From the main page for the repository, select the **stable** branch, which is the most recent officially released version. The **master** branch is the branch under active development.
2. From the main page for the repository, click **Code**.
3. Copy the HTTPS URL for the repository.
4. From a directory where you want to create the local copy, enter the command `git clone --branch stable <https_url>`. You can replace `stable` with the tag associated with a specific release if you need a version other than the current stable version. For example, if you are developing a repeatable process and need to ensure the same release of the repo is used every time, specify the tag associated with that specific release rather than stable. Note that the tag and release names are typically the same, but you should check the Releases page to verify the tag name. 
5. Change to the `viya4-monitoring-kubernetes` directory.
6. Enter the command `git checkout <release_number>`. If you used the command `git clone --branch <my_branch> <https_url>` in Step 4 to specify the branch, release, or tag, you do not have to perform this step.

### <a name="mon_custom"></a>Customize the Deployment

The process of customizing the monitoring deployment consists of: 
- creating the location for your local customization files
- using the `USER_DIR` environment variable to specify the location of the customization files
- copying the customization files from one of the provided samples to your local directory
- specifying customization variables and parameters in the customization files

See the [main README](../README.md#customization) to for information about the customization process.

After you create the location for your customization files, you can customize the components that you deploy for monitoring by specifying environment variables and Helm chart parameters in this set of customization files (in this example, contained in the *my-viya4mon-user-dir* root directory):

```text
my-viya4mon-user-dir/user.env

my-viya4mon-user-dir/monitoring/user.env
my-viya4mon-user-dir/monitoring/user-values-prom-operator.yaml
my-viya4mon-user-dir/monitoring/user-values-pushgateway.yaml
```

You specify the environment variables in the `user.env` files and the Helm chart parameters in the `*.yaml` customization files. 

In order to minimize the potential for errors, you should not manually create the customization files, but use one of the sets of sample files as the starting point for your own customizations. 

### Using Customization Samples

The samples are provided to demonstrate how to customize the deployment of the monitoring components for specific situations. The samples provide instructions and example `*.yaml` files that you can modify to fit your environment. Although each example focuses on a specific scenario, you can combine multiple samples by merging the appropriate values in each deployment file.

If your situation matches one of the specialized samples, you can copy the customization files for the sample that most closely matches your environment from the repository to your customization file directory. This enables you to start your customization with a set of values that are valid for your situation. You can then make further modifications to the files.

If your situation does not match any of the specialized samples, copy the [generic-base sample](/samples/generic-base) as a base for your customization files, and then change the values or copy values from other samples to match your environment.

If more than one sample applies to your environment, you can manually copy the values from the other sample files to the files in your customization directory.

See the [Samples page](/samples) for a list of provided samples.

#### Specifying Environment Variables in user.env Files

Environment variables control script behavior and high-level options such as TLS and workload node placement. Note that you can also specify environment variables on a command line, but specifying the variables in `user.env` is recommended, in order to maintain a consistent set of values for future deployments. The values in the top-level `user.env` file (`my-viya4mon-user-dir/user.env`) apply to both the monitoring and logging deployments. The values in `my-viya4mon-user-dir/monitoring/user.env` apply only to the monitoring deployment.

Any line whose first character is `#` is treated as a comment and ignored.

#### Specifying the Default Grafana Password 

Specify the `GRAFANA_ADMIN_PASSWORD` environment variable in
`$USER_DIR/monitoring/user.env`to specify the default password for Grafana. If you do not specify a default password, one is randomly generated and displayed during deployment.

#### Using Ingress for Cloud Providers

If you are using a cloud provider, you must use ingress, rather than
NodePorts. Use the samples in the [samples/ingress](/samples/ingress)
area of this repository to set up either host-based or path-based ingress.

#### Modify user-values-*.yaml to Change Helm Chart Values

The monitoring stack uses the following Helm charts:

* **kube-prometheus-stack** - used by `deploy_monitoring_cluster.sh`
  * [Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
  * [Default values](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml)
* **prometheus-pushgateway** - used by `deploy_monitoring_viya.sh`
  * [Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-pushgateway)
  * [Default values](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-pushgateway/values.yaml)

These charts are highly customizable. Although the default values might be
suitable, you might need to customize some values (such as for ingress,
for example). The `kube-prometheus-stack` Helm chart includes the Prometheus
Operator and aggregates other helm charts such as Grafana and the Prometheus
Node Exporter. Links to the charts and default values are included in the
`user-values-prom-operator.yaml` file. 

#### TLS Support

The [TLS Monitoring sample](/samples/tls/monitoring) contains information about specifying the `TLS_ENABLE` environment variable to use TLS for in-cluster communications between the components and to use TLS for connections between the user and the monitoring components when using NodePorts. If you only use TLS (HTTPS) for ingress, you do not have to specify the environment variable `TLS_ENABLE=true`, but you must manually populate Kubernetes ingress secrets as specified in the [TLS Monitoring sample](/samples/tls/monitoring).

#### Workload Node Placement

SAS Viya is deployed using a workload node placement strategy, which uses the
`workload.sas.com/class` taint to optimize the placement of its components on
Kubernetes nodes. By default, the monitoring components do **not** participate
in the workload node placement strategy. This is the recommended approach,
because it enables the monitoring components to function even if
`workload.sas.com/class`-tainted nodes are scaled to zero (in other words, are
shut down). Therefore, by default, most of the monitoring components are
deployed to cluster nodes that do not have `workload.sas.com/class` taints. On
Microsoft Azure, this results in pods being deployed on nodes in the `system`
nodepool.

To deploy the monitoring components so that they participate in the SAS Viya
workload node placement strategy rather than use this recommended deployment,
set `MON_NODE_PLACEMENT_ENABLE` to `true` in `$USER_DIR/monitoring/user.env`.

#### Workload Node Placement Recommendations

The default configuration of the Prometheus instance that is included in Istio
monitors the entire Kubernetes cluster. This configuration is typically not
preferred if you are deploying the monitoring components in this repository.

This is because the Prometheus instance that is included with Istio discovers
and scrapes pods that have the `prometheus.io/*` annotations, including SAS
Viya components. If you also deployed the Prometheus instance in this
repository, both instances of Prometheus are scraping the pods, which leads
to higher resource usage.

To prevent this situation, disable cluster-wide scraping of
pods and services that contain the `prometheus.io/*` annotations by disabling
the following jobs in the Istio Prometheus instance:

* `kubernetes-pods`
* `kubernetes-service-endpoints`

### Add Custom Dashboards

The monitoring deployment includes a set of dashboards, but you can also add your own. Many dashboards are available at [Grafana's site of community dashboards](https://grafana.com/grafana/dashboards). Download the `.json` file for a dashboard and save it using a filename that is
a [valid kubernetes resource name](https://kubernetes.io/docs/concepts/overview/working-with-objects/names). There are three methods to add dashboards:

- manually import each dashboard into Grafana
- add dashboards using a script
- automatically deploy dashboards stored in the `$USER_DIR/monitoring/dashboards` directory

#### Manually Import Dashboards

You can use Grafana's import function to import dashboards. 

The advantage of using the import function is that Grafana recognizes if the dashboard's data source is not valid for your environment and prompts you to select your environment's data source. 

The disadvantage is that the process is not automated, so you must re-import the dashboards each time you redeploy the monitoring components. If you have many dashboards to import, the process could also be time-consuming. 

#### Add Dashboards Using a Script

You can use the `deploy_dashboards.sh [dashboard | dashboard_directory]` script to deploy a single dashboard or a directory of dashboards.

Grafana cannot validate the data source of dashboards that are deployed using this script, so you must either manually change the data source or use Grafana to create a dashboard file with the data source resolved. See [Resolve Dashboard Data Sources](#resolve-dashboard-data-sources) for information.

The advantage of using the script is that the process can be automated, so you can automatically re-deploy all of your custom dashboards whenever you re-deploy the monitoring components.

Some detailed dashboards might be too large to deploy using the script, and must be imported manually. If the dashboard is too large, a message is displayed during deployment.

#### Deploy Dashboards in the $USER_DIR/monitoring/dashboards Directory

Dashboards that are stored in the `$USER_DIR/monitoring/dashboards` directory are automatically added when you deploy the monitoring components. The dashboards must be in `.json` format, and they cannot be in a subdirectory under `$USER_DIR/monitoring/dashboards`. If you remove the monitoring components using the `remove_monitoring_cluster.sh` script, the dashboards are removed as well.

Grafana cannot validate the data source of dashboards that are deployed using this directory, so you must either manually change the data source or use Grafana to create a dashboard file with the data source resolved. See [Resolve Dashboard Data Sources](#resolve-dashboard-data-sources) for information.

#### Resolve Dashboard Data Sources

Grafana cannot validate the data source of dashboards that are deployed using either the `deploy_dashboards` script or the `$USER_DIR/monitoring/dashboards` directory, so the dashboards will display incomplete information. 

To specify the data source, you can either manually change the data source in the dashboard's .json file or manually import the dashboard into Grafana (which prompts you to select a data source) and export the dashboard with the valid data source specified.

To manually change the data source, edit the dashboard's `.json` file and change the data source to `Prometheus`. For example:
- Find: `"datasource": "${DS_PROMETHEUS}"`
- Replace with: `"datasource": "Prometheus"`

Follow these steps to use Grafana's import and export functions to create a `.json` file for the dashboard with data sources resolved: 

1. Import the dashboard into Grafana and resolve the data source.
2. In Grafana, select Share, then select the Export tab.
3. Ensure that the `Export for sharing externally` option is not selected.
4. Select `Save to file` to save the `.json` file for the dashboard with the data source resolved.
5. Use the script or directory to import the dashboard during future deployments.

## Deploy Cluster Monitoring Components

To deploy the monitoring components for the cluster, issue this command:

```bash
# Deploy cluster monitoring (can be done before or after deploying Viya)
monitoring/bin/deploy_monitoring_cluster.sh
```

## Deploy SAS Viya Monitoring Components

Scripts may be run from any directory, but a current working directory
of the root of this repository is assumed for the examples below.

To enable direct monitoring of SAS Viya components, run the following command,
which deploys ServiceMonitors and the Prometheus Pushgateway for each SAS Viya
namespace:

```bash
# Deploy exporters and ServiceMonitors for a Viya deployment
# Specify the Viya namespace by setting VIYA_NS
VIYA_NS=<your_viya_namespace> monitoring/bin/deploy_monitoring_viya.sh
```

By default, the components are deployed into the namespace `monitoring`.

## Access Monitoring Applications

If the deployment process completes without errors, a message 
appears in the console window containing the URL address for Grafana. The URL for Grafana is different depending on whether you use nodeports or ingress to access Grafana. 

NodePorts are used by default. If you deployed using NodePorts, Prometheus and AlertManager are available at these locations by default:

* Prometheus - Port 31090 `http://master-node.yourcluster.example.com:31090`
* AlertManager - Port 31091 `http://master-node.yourcluster.example.com:31091`

The default Grafana admin user is `admin`. Unless you set the `GRAFANA_ADMIN_PASSWORD` environment variable (either in the `user.env` file or on the command line) to specify a default password during deployment, the default password is randomly generated and displayed during deployment. 

If you want to change the password, issue this command:
```bash
kubectl exec -n <monitoring_namespace> <grafana_pod> -c grafana -- bin/grafana-cli admin reset-admin-password myNewPassword
```

The randomly-generated password is displayed only during the initial deployment of the monitoring components.  It is not displayed if you redeploy the components.

## Update Monitoring Components

Updates in-place are supported. To update, pull and clone the desired version
of this repository, then re-run the
`deploy_monitoring_cluster.sh` and/or `deploy_monitoring_viya.sh`
scripts to pick up the latest versions of the applications, dashboards, service
monitors, and exporters.

## Remove Monitoring Components

To remove the monitoring components, run the following commands:

```bash
# Remove cluster monitoring
monitoring/bin/remove_monitoring_cluster.sh

# Optional: Remove SAS Viya monitoring
# Run this section once per Viya namespace
export VIYA_NS=<your_viya_namespace>
monitoring/bin/remove_monitoring_viya.sh
```

Removing cluster monitoring does not remove persistent volume claims
by default. A re-install after removal should retain existing data.
Manually delete the PVCs or the namespace to delete previously
collected monitoring data.

## Miscellaneous Notes and Troubleshooting

### Expose kube-proxy Metrics

Some clusters are deployed with the kube-proxy metrics listen
address set to `127.0.0.1`, which prevents Prometheus from collecting
metrics. To enable kube-proxy metrics, which are used in the
`Kubernetes / Proxy` dashboard, run this command:

```bash
kubectl edit cm -n kube-system kube-proxy
# Change metricsBindAddress to 0.0.0.0:10249
# Restart all kube-proxy pods
kubectl delete po -n kube-system -l k8s-app=kube-proxy
# Pods will automatically be recreated
```
