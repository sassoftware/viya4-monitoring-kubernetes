# SAS® Viya® Monitoring for Kubernetes

SAS® Viya® Monitoring for Kubernetes provides simple scripts and customization
options to deploy monitoring, alerts, and log aggregation for SAS Viya 4.x.

Monitoring and logging may be deployed independently or together. There are
no hard dependencies between the two.

## Monitoring - Metrics and Alerts

The monitoring solution includes these components:

- [Prometheus Operator](https://github.com/coreos/prometheus-operator)
  - [Prometheus](https://prometheus.io/docs/introduction/overview/)
  - [Alertmanager](https://prometheus.io/docs/alerting/alertmanager/)
  - [Grafana](https://grafana.com/)
- Prometheus Exporters
  - [node-exporter](https://github.com/prometheus/node_exporter)
  - [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics)
  - [Prometheus Adapter for Kubernetes Metrics APIs](https://github.com/DirectXMan12/k8s-prometheus-adapter)
  - [Prometheus Pushgateway](https://github.com/prometheus/pushgateway)
- Alert definitions
- Grafana dashboards
  - Kubernetes cluster monitoring
  - SAS CAS Overview
  - SAS Java Services
  - SAS Go Services
  - RabbitMQ
  - Postgres
  - Fluent Bit
  - Elasticsearch
  - Istio
  - NGINX

This is an example of a Grafana dashboard for cluster monitoring.
![Grafana - Cluster Monitoring](img/screenshot-grafana-cluster.png)

This is an example of a Grafana dashboard for SAS CAS monitoring.
![Grafana - SAS CAS Monitoring](img/screenshot-grafana-cas.png)

See the documentation at [SAS Viya: Monitoring](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=calmonitoring&docsetTarget=titlepage.htm)
for more information about using the monitoring components.

## Logging - Aggregation, Searching, & Filtering

The logging solution includes these components:

- [Fluent Bit](https://fluentbit.io/)
  - Custom Fluent Bit parsers
- [Elasticsearch](https://www.elastic.co/products/elasticsearch)
  - Custom index pattern for logs
  - Namespace separation
  - [Elasticsearch Exporter](https://github.com/helm/charts/tree/master/stable/elasticsearch-exporter)
- [Kibana](https://www.elastic.co/products/kibana)
  - Custom Kibana dashboards

  This is an example of a Kibana dashboard displaying log message volumes.

  ![Kibana - Log Message Volume Dashboard](img/screenshot-logs-dashboard.png)

See the documentation at [SAS Viya: Logging](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=callogging&docsetTarget=titlepage.htm)
for more information about using the logging components.

## Prerequisites

- A Kubernetes cluster that meets the prerequisites for SAS Viya
- [Helm](https://helm.sh) version 3.x
- `kubectl` with cluster-admin access

## Installation

### Monitoring

See the [monitoring README](monitoring/README.md) to deploy the monitoring
components, including Prometheus Operator, Prometheus, Alertmanager, Grafana,
metric exporters, service monitors, and custom dashboards.

### Logging

See the [logging README](logging/README.md) to deploy the logging components,
including Fluent Bit, Elasticsearch, and Kibana.

## Customization

The process of customizing the monitoring and logging deployments consists of: 
- creating the location for your local customization files
- specifying customization variables and parameters in the customization files
- using the `USER_DIR` environment variable to specify the location of the customization files

### Create the Location for Customization Files

The `USER_DIR` environment variable enables you to use a directory outside of the local repository to contain the customization files. By using a location outside of the repository, you can preserve your customizations when you deploy new versions of the monitoring and logging applications. You could also put the customization files in a location that is under version control.

For example, to create a customization directory named *my_custom_files* that contains directories for monitoring and logging customization files:

```bash
mkdir -p ~/my_custom_files/monitoring
mkdir -p ~/my_custom_files/logging
```

### Specifying Customization Variables and Parameters

After you create the location for your customization files, you can customize the components that you deploy for monitoring and logging by specifying environment variables and Helm chart parameters in this set of customization files (in this example, contained in the *my_custom_files* root directory):

```text
/my_custom_files/user.env

/my_custom_files/monitoring/user.env
/my_custom_files/monitoring/user-values-prom-operator.yaml
/my_custom_files/monitoring/user-values-pushgateway.yaml

/my_custom_files/logging/user.env
/my_custom_files/logging/user-values-elasticsearch-open.yaml
/my_custom_files/logging/user-values-es-exporter.yaml
/my_custom_files/logging/user-values-fluent-bit-open.yaml
```

You specify the environment variables in the `user.env` files and the Helm chart parameters in the `*.yaml` configuration files. Note that you can also specify environment variables on a command line, but specifying the variables in `user.env` is recommended, in order to maintain a consistent set of values for future deployments. 

You do not have to specify values in all of these files. The deployment process ignores any files other than these.

This repository contains several sample configuration files which provide values for specific situations. You can copy the configuration files for a sample from the repository to your customization file directory  in order to provide you with a set of customizations that are valid for the situation. You can then make further modifications to the files. 

If more than one sample applies to your environment, you can manually copy the values from the other sample files to the files in your customization directory.

The [monitoring README](monitoring/README.md) and [logging README](logging/README.md) for information about determining valid values for the `user.env` and `*.yaml` files.

### Using USER_DIR to Specify the Location of Customization Files

Use the `USER_DIR` environment variable to specify the root location of your local customization files.

This example sets the `USER_DIR` environment variable to the *my_custom_files* directory:

```bash
export USER_DIR=~/my_custom_files
```
The monitoring and logging deployment scripts use the customization files contained in the directories user the `USER_DIR` location.

### Default StorageClass

The default cluster StorageClass is used for both monitoring and logging
unless the value is specifically set in `user-*.yaml` files for monitoring or
logging. The deployment scripts issue a warning if no default StorageClass is
available, even if the value is properly set by the user. In this case,
you can safely ignore the warning.
