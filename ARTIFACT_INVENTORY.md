# Inventory of Container Images and Helm Charts Used by SAS Viya Monitoring for Kubernetes

The following tables provide information about the container images and Helm charts used by SAS Viya Monitoring for Kubernetes.  This information can be useful to users who want to do the following tasks:

* pre-pull container images
* deploy into an air-gapped Kubernetes cluster

**Note:** For more information about deploying in an air-gapped environment, refer to
[Configure SAS Viya Monitoring for Kubernetes for an Air-Gapped Environment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=n0auhd4hutsf7xn169hfvriysz4e.htm#n0grd8g2pkfglin12bzm3g1oik2p).

## Table 1. Container Images

This table provides the fully qualified container-image names for the components of SAS Viya Monitoring for Kubernetes.
These names use the following format:
registry/repository/image_name:version

| Subsystem| Component | Fully Qualified Container-Image Name (registry/repository/image_name:version)|
|----|----|----|
| Logging | [Fluent Bit](https://github.com/fluent/fluent-bit) | cr.fluentbit.io/fluent/fluent-bit:4.0.8 |
| Logging | [Elasticsearch Exporter](https://github.com/prometheus-community/elasticsearch_exporter) | quay.io/prometheuscommunity/elasticsearch-exporter:v1.9.0 |
| Logging | initContainer (Fluent Bit, OpenSearch) | docker.io/library/busybox:latest |
| Logging | [OpenSearch](https://github.com/opensearch-project/OpenSearch) | docker.io/opensearchproject/opensearch:2.19.3 |
| Logging | [OpenSearch Dashboards](https://github.com/opensearch-project/OpenSearch-Dashboards) | docker.io/opensearchproject/opensearch-dashboards:2.19.3 |
| Metrics | [Alertmanager](https://github.com/prometheus/alertmanager) | quay.io/prometheus/alertmanager:v0.28.1 |
| Metrics | [Grafana](https://github.com/grafana/grafana) | docker.io/grafana/grafana:12.2.0 |
| Metrics | [Admission Webhook](https://github.com/kubernetes/ingress-nginx) | registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.6.3 |
| Metrics | [Kube State Metrics](https://github.com/kubernetes/kube-state-metrics) | registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.17.0 |
| Metrics | [Node Exporter](https://github.com/prometheus/node_exporter) | quay.io/prometheus/node-exporter:v1.9.1 |
| Metrics | [Prometheus](https://github.com/prometheus/prometheus) | quay.io/prometheus/prometheus:v3.7.1 |
| Metrics | [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator) | quay.io/prometheus-operator/prometheus-operator:v0.86.1 |
| Metrics | [Configuration Reloader](https://github.com/prometheus-operator/prometheus-operator/tree/main/cmd/prometheus-config-reloader) | quay.io/prometheus-operator/prometheus-config-reloader:v0.86.1 |
| Metrics | [Prometheus Pushgateway](https://github.com/prometheus/pushgateway) | quay.io/prometheus/pushgateway:v1.11.1 |
| Metrics | [Auto-load Sidecars](https://github.com/kiwigrid/k8s-sidecar) | quay.io/kiwigrid/k8s-sidecar:1.30.9 |
| Metrics | OpenShift OAUTH Proxy (Grafana, OpenShift only) | registry.redhat.io/openshift4/ose-oauth-proxy:latest |
| Metrics | [Tempo](https://github.com/grafana/tempo) | docker.io/grafana/tempo:2.7.0 |

## Table 2. Helm Chart Repositories
This table identifies the Helm repositories that contain the Helm charts used by SAS Viya Monitoring for Kubernetes.
These repositories must be made available to Helm in your environment. Use the `helm repo add` command.

| Subsystem | Component | Helm Repository | Helm Repository URL |
|--|--|--|--|
| Logging | [Fluent Bit](https://github.com/fluent/helm-charts) | fluent | https://fluent.github.io/helm-charts |
| Logging | [OpenSearch and OpenSearch Dashboards](https://github.com/opensearch-project/helm-charts) | opensearch | https://opensearch-project.github.io/helm-charts |
| Metrics | [Grafana](https://github.com/grafana/helm-charts) | grafana | https://grafana.github.io/helm-charts |
| Both | [Prometheus Community](https://github.com/prometheus-community/helm-charts) | prometheus-community | https://prometheus-community.github.io/helm-charts |

## Table 3. Helm Chart Information
This table identifies the Helm charts used by SAS Viya Monitoring for Kubernetes.

| Subsystem | Component | Helm Chart Repository | Helm Chart Name |Helm Chart Version | Helm Archive File Name|
|--|--|--|--|--|--|
| Logging | [Elasticsearch Exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-elasticsearch-exporter)| prometheus-community | prometheus-elasticsearch-exporter | 7.0.0 | prometheus-community/prometheus-elasticsearch-exporter-7.0.0.tgz |
| Logging | [Fluent Bit](https://github.com/fluent/helm-charts/tree/main/charts/fluent-bit)| fluent | fluent-bit | 0.52.0 | fluent/fluent-bit-0.52.0.tgz |
| Logging | [OpenSearch](https://github.com/opensearch-project/helm-charts/tree/main/charts/opensearch)| opensearch | opensearch | 2.35.0 | opensearch/opensearch-2.35.0.tgz |
| Logging | [OpenSearch Dashboards](https://github.com/opensearch-project/helm-charts/tree/main/charts/opensearch-dashboards)| opensearch | opensearch-dashboards | 2.31.0 | opensearch/opensearch-dashboards-2.31.0.tgz |
| Metrics | [Grafana (on OpenShift)](https://github.com/grafana/helm-charts/tree/main/charts/grafana)| grafana | grafana | 9.4.5 | grafana/grafana-9.4.5.tgz |
| Metrics | [Kube Prometheus Stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)| prometheus-community | kube-prometheus-stack | 78.4.0 | prometheus-community/kube-prometheus-stack-78.4.0.tgz |
| Metrics | [Prometheus Pushgateway](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-pushgateway)| prometheus-community | prometheus-pushgateway | 3.4.1 | prometheus-community/prometheus-pushgateway-3.4.1.tgz |
| Metrics | [Tempo](https://github.com/grafana/helm-charts/tree/main/charts/tempo)| grafana | tempo | 1.18.1 | grafana/tempo-1.18.1.tgz |

## Table 4. Miscellaneous Component Version Information
This table provides version information for some miscellaneous components deployed by SAS Viya Monitoring for Kubernetes.

| Component | Version | Project Repository | Notes |
|--|--|--|--|
| OpenSearch Datasource Plugin (Grafana) | 2.31.1 | https://github.com/grafana/opensearch-datasource/releases |Allows Grafana to surface log messages stored in OpenSearch |
