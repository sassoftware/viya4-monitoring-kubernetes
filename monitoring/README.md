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

- [select the release that you want to deploy](#mon_sel_rel)
- [create a local copy of the repository](#mon_loc_copy)
- [customize your deployment](#mon_custom)

### <a name="mon_sel_rel"></a>Select the Release to Copy

1. Select the **stable** branch.
2. Click on **tags** above the repository tree.
3. On the **Tags** page, click [Releases](https://github.com/sassoftware/viya4-monitoring-kubernetes/releases)
to view the list of available releases.
4. Use the release notes to determine the release you want to deploy.

### <a name="mon_loc_copy"></a>Create a Local Copy of the Repository

There are two methods to create a local copy of the repository:

* download a compressed copy
* clone the repository

#### Download a Compressed Copy of the Repository

1. On the [Releases](https://github.com/sassoftware/viya4-monitoring-kubernetes/releases)
page, locate the release that you want to deploy.
2. Expand **Assets** for the release, which is located below the release notes.
3. Select either **Source code (.zip)** or **Source code (.tar.gz)** to download
the repository as a compressed file.
4. Expand the downloaded file to create a local copy of the repository. The
repository is created in a directory named `viya4-monitoring-kubernetes-<release_number>`.

#### Clone the Repository

1. From the main page for the repository, click **Code**.
2. Copy the HTTPS URL for the repository.
3. From a directory where you want to create the local copy, enter the
command `git clone <https_url>`.
4. Change to the `viya4-monitoring-kubernetes` directory.
5. Enter the command `git checkout <release_number>`

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

The [TLS Monitoring sample](/samples/tls/monitoring) contains information about specifying the `TLS_ENABLE` environment variable to use TLS for in-cluster communications between the components and to use TLS for connections between the user and the monitoring components when using NodePorts. If you use ingress and also use TLS for communication between monitoring components, you do not have to specify the `TLS_ENABLE` environment variable, but you must manually populate Kubernetes secrets as listed in the sample. 

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

NodePorts are used by default. If you deployed using NodePorts, the monitoring
applications are available at these locations by default:

* Grafana - Port 31100 `http://master-node.yourcluster.example.com:31100`
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
