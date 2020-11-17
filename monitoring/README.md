# Monitoring

## Introduction

This document outlines the steps needed to deploy a set of monitoring
components that provide the ability to monitor resources in a SAS Viya 4.x
environment. These components support monitoring of SAS Viya 4.x resources
for each SAS Viya namespace as well as monitoring for Kubernetes cluster
resources.

You must have cluster-admin access to any cluster in which you deploy these
components. You cannot deploy successfully if you have access only to a
namespace or a subset of namespaces.

### Components

These components are deployed:

* Prometheus Operator
* Prometheus
* Alert Manager
* Grafana
* node-exporter
* kube-state-metrics
* Prometheus adapter for Kubernetes metrics APIs
* Prometheus Pushgateway
* Grafana dashboards
* Kubernetes cluster alert definitions

## Perform Pre-Deployment Tasks

Before deploying, you must select the release that you want to deploy, then create a local copy of the repository. 

### Select the Release to Copy

1. Click on **tags** above the repository tree.
2. On the **Tags** page, click [Releases](https://github.com/sassoftware/viya4-monitoring-kubernetes/releases) to view the list of available releases.
3. Use the release notes to determine the release you want to deploy.

### Create a Local Copy of the Repository

There are two methods to create a local copy of the repository: cloning or downloading a 
compressed copy.

#### Clone the Repository

1. From the main page for the repository, click **Code**.
2. Copy the HTTPS URL for the repository.
3. From a directory where you want to create the local copy, enter the 
command `git clone <https_url>`. 
4. Change to the `viya4-monitoring-kubernetes` directory.
5. Enter the command `git checkout --track origin/<release_number>`

#### Download a Compressed Copy of the Repository

1. On the [Releases](https://github.com/sassoftware/viya4-monitoring-kubernetes/releases) page, locate the release that you want to deploy.
2. Expand **Assets** for the release, which is located below the release notes.
3. Select either **Source code (.zip)** or **Source code (.tar.gz)** to download the repository 
as a compressed file.
4. Expand the downloaded file to create a local copy of the repository. The repository is created
in a directory named `viya4-monitoring-kubernetes-<release_number>`.  

If you use TLS to encrypt network traffic, you must perform manual steps prior
to deployment. See the **TLS Support** section below for more information.

## Customize the Deployment

### USER_DIR

Setting the `USER_DIR` environment variable allows for any user customizations
to be stored outside of the directory structure of this repository. The default
`USER_DIR` is the root of this repository. A directory referenced by `USER_DIR`
should include `user*` files in the same relative structure as they exist in
this repository.

The following files are automatically used by the monitoring scripts if they
are present in `USER_DIR`:

* `user.env`
* `monitoring/user.env`
* `monitoring/user-values-prom-operator.yaml`
* `monitoring/user-values-pushgateway.yaml`

### user.env

The `monitoring/user.env` file contains environment variable flags that customize
the components that are deployed or to alter some script behavior (such as to
enable debug output). All values in `user.env` files are exported as environment
variables available to the scripts. A `#` as the first character in a line
is treated as a comment.

### user-values-*.yaml

The monitoring stack uses the following Helm charts:

* **kube-prometheus-stack** - used by `deploy_monitoring_cluster.sh`
  * [Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
  * [Default values](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml)
* **prometheus-pushgateway** - used by `deploy_monitoring_viya.sh`
  * [Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-pushgateway)
  * [Default values](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-pushgateway/values.yaml)

These charts are highly customizable. Although the default values might be
suitable, you might need to customize some values (such as for ingress,
for example). The kube-prometheus-stack helm chart includes the Prometheus
Operator and aggregates other helm charts such as Grafana and the Prometheus
Node Exporter. Links to the charts and default values are included in the
`user-values-prom-operator.yaml` file.

**Note:** If you are using a cloud provider, you must use ingress, rather than
NodePorts. Use the samples in the
[samples/ingress](/samples/ingress)
area of this repository to set up either host-based or path-based ingress.

## Workload Node Placement

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

### Recommendations

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

The default credentials for Grafana are `admin`:`admin`.

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

## TLS Support

You can use the `TLS_ENABLE` or `MON_TLS_ENABLE` settings in user.env
to enable TLS support, which encrypts network traffic
between pods for use by the monitoring pods.

You must perform manual steps prior to deployment in order to enable TLS.
In addition, configuring HTTPS ingress involves a separate set of
steps, which are similar to those needed for SAS Viya.

See the [TLS Sample](samples/tls) for more information.

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
