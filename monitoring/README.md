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

### Clone the Repository

* From a command line, create a directory to contain the cloned repository.
* Change to the directory you created.
* Clone the repository
* `cd` to the repository directory
* If you have already cloned the repository, use the `git pull` command to
ensure that you have the most recent updates.

If you have already cloned the repository, use the `git pull` command to ensure
that you have the most recent updates.

## Customize the Deployment

### user.env

The `monitoring/user.env` file contains flags to customize the components that are
deployed as well as to specify some script behavior (such as enable debug).

### user-values-*.yaml

The monitoring stack uses the following Helm charts:

* **Prometheus Operator**
  * [Chart](https://github.com/helm/charts/blob/master/stable/prometheus-operator/README.md)
  * [Default values](https://github.com/helm/charts/blob/master/stable/prometheus-operator/values.yaml)
* **Prometheus Pushgateway**
  * [Chart](https://github.com/helm/charts/tree/master/stable/prometheus-pushgateway)
  * [Default values](https://github.com/helm/charts/blob/master/stable/prometheus-pushgateway/values.yaml)

These charts are highly customizable. Although the default values might be
suitable, you might need to customize some values (such as for ingress,
for example).

Specify override values in the files `monitoring/user-values-prom-operator.yaml`
and/or `monitoring/user-values-pushgateway` as needed. The default values and
links to the Helm chart documentation are in the `user-values*.yaml` files.

## Deploy Cluster Monitoring Components

To deploy the monitoring components for the cluster, issue this command:

```bash
# Deploy cluster monitoring (can be done before or after deploying Viya)
monitoring/bin/deploy_monitoring_cluster.sh
```

NodePorts are used by default. The applications are available on these default ports:

* Grafana - Port 31100 `http://master-node.yourcluster.example.com:31100`
* Prometheus - Port 31090 `http://master-node.yourcluster.example.com:31090`
* AlertManager - Port 31091 `http://master-node.yourcluster.example.com:31091`

The default credentials for Grafana are `admin`:`admin`.

## Deploy SAS Viya Monitoring Components

To enable direct monitoring of SAS Viya components, run the following command,
which deploys ServiceMonitors and the Prometheus Pushgateway for each SAS Viya
namespace:

```bash
# Deploy exporters and ServiceMonitors for a Viya deployment
# Specify the Viya namespace by setting VIYA_NS
VIYA_NS=<your_viya_namespace> monitoring/bin/deploy_monitoring_viya.sh
```

By default, the components are deployed into the namespace `monitoring`.

## Update Monitoring Components

Updates in-place are supported if you use Helm 3.x. To update, re-run the
`deploy_monitoring_cluster.sh` and/or `deploy_monitoring_viya.sh`
scripts to pick up the latest versions of the applications, dashboards, service
monitors, and exporters.

If you use Helm 2.x, you must remove and re-install the monitoring components
to update them.

## Remove Monitoring Components

To remove the monitoring components, run the following commands:

```bash
cd <kube-viya-monitoring repo directory>

# Remove SAS Viya monitoring
# Run this section once per Viya namespace
export VIYA_NS=<your_viya_namespace>
monitoring/bin/remove_monitoring_viya.sh

# Remove cluster monitoring
monitoring/bin/remove_monitoring_cluster.sh
```

## Miscellaneous Notes and Troubleshooting

### Expose kube-proxy Metrics

Some clusters are deployed with the kube-proxy metrics listen
address set to `127.0.0.1`, which prevents Prometheus from collecting
metrics. To enable kube-proxy metrics, which are used in the
`Kubernetes / Proxy` dashboard, run this command:

```bash
kubectl edit cm -n kube-system kube-proxy
# Change metricsBindAddress to 0.0.0.0:10249
# Restart kube-proxy pods
kubectl delete po -n kube-system -l k8s-app=kube-proxy
# Pods will automatically be recreated
```
