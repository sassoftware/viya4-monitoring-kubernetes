# Inventory of Container Images and Helm Charts Used by SAS Viya Monitoring for Kubernetes

The following tables provide information about the container images and Helm charts used by SAS Viya Monitoring for Kubernetes.  This information can be useful to users who want to do the following tasks:

* pre-pull container images
* deploy into an air-gapped Kubernetes cluster

**Note:** For more information about deploying in an air-gapped environment, refer to  
[Configure SAS Viya Monitoring for Kubernetes for an Air-Gapped Environment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n0grd8g2pkfglin12bzm3g1oik2p.htm).

## Table 1. Container Images

This table provides the fully qualified container-image names required for the air-gapped configuration.
These names use the following format: 

registry/repository/image_name:version

| Subsystem| Component | Fully Qualified Container-Image Name (registry/repository/image_name:version)|
|----|----|----|
| Logging | BusyBox | docker.io/library/busybox|
| Logging | Fluent Bit | cr.fluentbit.io/fluent/fluent-bit:2.1.4|
| Logging | Elasticsearch Exporter | quay.io/prometheuscommunity/elasticsearch-exporter:v1.5.0|
| Logging | Eventrouter | gcr.io/heptio-images/eventrouter:v0.3|
| Logging | OpenSearch | docker.io/opensearchproject/opensearch:2.8.0|
| Logging | OpenSearch Dashboards| docker.io/opensearchproject/opensearch-dashboards:2.8.0|
| Metrics | Alertmanager | quay.io/prometheus/alertmanager:v0.25.0|
| Metrics | BusyBox | docker.io/library/busybox:1.31.1|
| Metrics | Ghostunnel | docker.io/ghostunnel/ghostunnel:v1.7.1|
| Metrics | Grafana | docker.io/grafana/grafana:9.5.2|
| Metrics | Ingress-NGINX Controller | registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20221220-controller-v1.5.1-58-g787ea74b6|
| Metrics | Kube State Exporter | k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.8.2|
| Metrics | Node Exporter | quay.io/prometheus/node-exporter:v1.5.0|
| Metrics | **Prometheus** | quay.io/prometheus/prometheus:v2.44.0|
| Metrics | Prometheus Operator | quay.io/prometheus-operator/prometheus-operator:v0.65.1|
| Metrics | Prometheus Operator (config reloader) | quay.io/prometheus-operator/prometheus-config-reloader:v0.65.1|
| Metrics | Prometheus Pushgateway | docker.io/prom/pushgateway:v1.5.1|
| Metrics | Sidecar | quay.io/kiwigrid/k8s-sidecar:1.24.0|

## Table 2. Helm Chart Repositories

| Subsystem | Component | Helm Repository | Helm Repository URL |
|--|--|--|--|
| Logging | Fluent Bit | fluent | https://fluent.github.io/helm-charts |
| Logging | OpenSearch and OpenSearch Dashboards | opensearch | https://opensearch-project.github.io/helm-charts |
| Metrics | Grafana | grafana | https://grafana.github.io/helm-charts |
| Both | Several (including Prometheus, Kube Prometheus Stack, Prometheus Pushgateway and Elasticsearch Exporter) | prometheus-community | https://prometheus-community.github.io/helm-charts |

## Table 3. Helm Chart Information

| Subsystem | Component | Helm Chart Repository | Helm Chart Name |Helm Chart Version | Helm Archive File Name|
|--|--|--|--|--|--|
| Logging | Elasticsearch Exporter| prometheus-community| prometheus-elasticsearch-exporter| 5.2.0| prometheus-elasticsearch-exporter-5.2.0.tgz
| Logging | Fluent Bit| fluent| fluent-bit| 0.30.4| fluent-bit-0.30.4.tgz
| Logging | OpenSearch| opensearch| opensearch| 2.13.0| opensearch-2.13.0.tgz
| Logging | OpenSearch Dashboard| opensearch| opensearch-dashboards| 2.11.0| opensearch-dashboards-2.11.0.tgz
| Metrics | Grafana (on OpenShift)| grafana| grafana| 6.56.4| grafana-6.56.4.tgz
| Metrics | Kube Prometheus Stack| prometheus-community| kube-prometheus-stack| 45.28.0| kube-prometheus-stack-45.28.0.tgz
| Metrics | Prometheus Pushgateway| prometheus-community| prometheus-pushgateway| 1.11.0| prometheus-pushgateway-1.11.0.tgz
