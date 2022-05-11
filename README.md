# SAS® Viya® Monitoring for Kubernetes

SAS® Viya® Monitoring for Kubernetes provides simple scripts and customization
options to deploy monitoring, alerts, and log aggregation for SAS Viya 4.

Monitoring and logging can be deployed independently or together. There are
no hard dependencies between the two.

## Monitoring - Metrics and Alerts

The monitoring solution includes these components and your right to use each
such component is governed by its applicable open source license:

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

The logging solution includes these components and your right to use each such component is governed by its applicable open source license:

- [Fluent Bit](https://fluentbit.io/)
  - Custom Fluent Bit parsers
- [OpenSearch](https://opensearch.org/docs/latest/opensearch/index/)
  - Custom index pattern for logs
  - Namespace separation
  - [Elasticsearch Exporter](https://github.com/helm/charts/tree/master/stable/elasticsearch-exporter)
- [OpenSearch Dashboards](https://opensearch.org/docs/latest/dashboards/index/)
  - Custom dashboards for OpenSearch Dashboards

  This is an example of OpenSearch Dashboards displaying log message volumes.

  ![OpenSearch Dashboards - Log Message Volume Dashboard](img/screenshot-logs-dashboard.png)

See the documentation at [SAS Viya: Logging](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=callogging&docsetTarget=titlepage.htm)
for more information about using the logging components.

## Prerequisites

- A Kubernetes cluster that meets the prerequisites for SAS Viya 4
- [Helm](https://helm.sh) version 3.x
- `kubectl` version 1.20+ with cluster-admin access
- [Git](https://git-scm.com/) version 1.8 or later
- [Bash](https://www.gnu.org/software/bash/)

## Installation

### Monitoring

See the [monitoring README](monitoring/README.md) to deploy the monitoring
components, including Prometheus Operator, Prometheus, Alertmanager, Grafana,
metric exporters, service monitors, and custom dashboards.

### Logging

See the [logging README](logging/README.md) to deploy the logging components,
including Fluent Bit, OpenSearch, and OpenSearch Dashboards.

## Customization

For most deployment scenarios, the process of customizing the monitoring and
logging deployments consists of:

- creating the location for your local customization files
- using the `USER_DIR` environment variable to specify the location of the
  customization files
- copying the customization files from one of the provided samples to your
  local directory
- specifying customization variables and parameters in the customization files

Other scenarios use different customization steps that are specific to each scenario.

Samples are provided for several common deployment scenarios. Each sample
includes detailed information about the customization process and values for
the scenario.

See the [monitoring README](monitoring/README.md) and [logging README](logging/README.md)
for detailed information about the customization process and about determining
valid customization values. See the README file for each [sample](samples/README.md)
for detailed information about customization for each deployment scenario.

### Default StorageClass

The default cluster StorageClass is used for both monitoring and logging
unless the value is overidden in the  `user-*.yaml` files for monitoring or
logging. The deployment scripts issue a warning if no default StorageClass is
available, even if the value is properly set by the user. In this case,
you can safely ignore the warning.
