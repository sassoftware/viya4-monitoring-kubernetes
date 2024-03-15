# Inventory of Container Images and Helm Charts Used by SAS Viya Monitoring for Kubernetes


The following tables provide information about the container images and Helm charts used by SAS Viya Monitoring for Kubernetes.  This information can be useful to users who want to do the following tasks:

* pre-pull container images
* deploy into an air-gapped Kubernetes cluster

**Note:** For more information about deploying in an air-gapped environment, refer to 
[Configure SAS Viya Monitoring for Kubernetes for an Air-Gapped Environment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n0grd8g2pkfglin12bzm3g1oik2p.htm).

## Table 1. Container Images

This table provides the fully qualified container-image names for the components of SAS Viya Monitoring for Kubernetes.
These names use the following format: 
registry/repository/image_name:version

| Subsystem| Component | Fully Qualified Container-Image Name (registry/repository/image_name:version)|
|----|----|----|
| Logging | BusyBox (OpenSearch) | docker.io/library/busybox:latest |
| Logging | Fluent Bit | cr.fluentbit.io/fluent/fluent-bit:2.1.10 |
| Logging | Elasticsearch Exporter | quay.io/prometheuscommunity/elasticsearch-exporter:v1.6.0 |
| Logging | OpenSearch | docker.io/opensearchproject/opensearch:2.10.0 |
| Logging | OpenSearch Dashboards| docker.io/opensearchproject/opensearch-dashboards:2.10.0 |
| Metrics | Alertmanager | quay.io/prometheus/alertmanager:v0.26.0 |
| Metrics | Grafana | docker.io/grafana/grafana:10.2.1 |
| Metrics | Admission Webhook | registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20221220-controller-v1.5.1-58-g787ea74b6 |
| Metrics | Kube State Metrics | registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.0 |
| Metrics | Node Exporter | quay.io/prometheus/node-exporter:v1.7.0 |
| Metrics | Prometheus | quay.io/prometheus/prometheus:v2.47.1 |
| Metrics | Prometheus Operator | quay.io/prometheus-operator/prometheus-operator:v0.69.1 |
| Metrics | Configuration Reloader (Alertmanager, Prometheus) | quay.io/prometheus-operator/prometheus-config-reloader:v0.69.1 |
| Metrics | Prometheus Pushgateway | quay.io/prometheus/pushgateway:v1.6.2 |
| Metrics | Auto-load Sidecars (Grafana) | quay.io/kiwigrid/k8s-sidecar:1.25.2 |
| Metrics | OpenShift OAUTH Proxy (Grafana, OpenShift only) | registry.redhat.io/openshift4/ose-oauth-proxy:latest |
| Metrics | Tempo | docker.io/grafana/tempo:2.2.0 |

## Table 2. Helm Chart Repositories
This table identifies the Helm repositories that contain the Helm charts used by SAS Viya Monitoring for Kubernetes.
These repositories must be made available to Helm in your environment. Use the `helm repo add` command.

| Subsystem | Component | Helm Repository | Helm Repository URL |
|--|--|--|--|
| Logging | Fluent Bit | fluent | https://fluent.github.io/helm-charts |
| Logging | OpenSearch and OpenSearch Dashboards | opensearch | https://opensearch-project.github.io/helm-charts |
| Metrics | Grafana | grafana | https://grafana.github.io/helm-charts |
| Both | Several (including Prometheus, Kube Prometheus Stack, Prometheus Pushgateway and Elasticsearch Exporter) | prometheus-community | https://prometheus-community.github.io/helm-charts |

## Table 3. Helm Chart Information
This table identifies the Helm charts used by SAS Viya Monitoring for Kubernetes.

| Subsystem | Component | Helm Chart Repository | Helm Chart Name |Helm Chart Version | Helm Archive File Name|
|--|--|--|--|--|--|
| Logging | Elasticsearch Exporter| prometheus-community | prometheus-elasticsearch-exporter | 5.3.1 | prometheus-community/prometheus-elasticsearch-exporter-5.3.1.tgz |
| Logging | Fluent Bit| fluent | fluent-bit | 0.40.0 | fluent/fluent-bit-0.40.0.tgz |
| Logging | OpenSearch| opensearch | opensearch | 2.15.0 | opensearch/opensearch-2.15.0.tgz |
| Logging | OpenSearch Dashboard| opensearch | opensearch-dashboards | 2.13.0 | opensearch/opensearch-dashboards-2.13.0.tgz |
| Metrics | Grafana (on OpenShift)| grafana | grafana | 7.0.4 | grafana/grafana-7.0.4.tgz |
| Metrics | Kube Prometheus Stack| prometheus-community | kube-prometheus-stack | 54.0.1 | prometheus-community/kube-prometheus-stack-54.0.1.tgz |
| Metrics | Prometheus Pushgateway| prometheus-community | prometheus-pushgateway | 2.4.2 | prometheus-community/prometheus-pushgateway-2.4.2.tgz |
| Metrics | Tempo | grafana | tempo | 1.5.0 | grafana/tempo-1.5.0.tgz |
