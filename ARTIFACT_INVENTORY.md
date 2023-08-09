

# Inventory of Container Images and Helm Charts used within the SAS Viya Montoring for Kubernetes Project
The following tables provide information on the container images and Helm charts used by the SAS Viya Montoring for Kubernetes Project.  This information can be useful to users:
* interested in pre-pulling container images; or
* interested in deploying onto an air-gapped Kubernetes cluster.

## Container Images
| Subsystem| Fully qualified container image name (registry/repository/image_name:version)|
|----|----|
| logging | cr.fluentbit.io/fluent/fluent-bit:2.1.4|
| logging | docker.io/library/busybox|
| logging | docker.io/opensearchproject/opensearch:2.8.0|
| logging | docker.io/opensearchproject/opensearch-dashboards:2.8.0|
| logging | gcr.io/heptio-images/eventrouter:v0.3|
| logging | quay.io/prometheuscommunity/elasticsearch-exporter:v1.5.0|
| metrics | docker.io/ghostunnel/ghostunnel:v1.7.1|
| metrics | docker.io/grafana/grafana:9.5.2|
| metrics | docker.io/library/busybox:1.31.1|
| metrics | docker.io/prom/pushgateway:v1.5.1|
| metrics | k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.8.2|
| metrics | quay.io/kiwigrid/k8s-sidecar:1.24.0|
| metrics | quay.io/prometheus/alertmanager:v0.25.0|
| metrics | quay.io/prometheus/node-exporter:v1.5.0|
| metrics | quay.io/prometheus/prometheus:v2.44.0|
| metrics | quay.io/prometheus-operator/prometheus-config-reloader:v0.65.1|
| metrics | quay.io/prometheus-operator/prometheus-operator:v0.65.1|
| metrics | registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20221220-controller-v1.5.1-58-g787ea74b6|

# Helm Chart Repositories
| Subsystem | Component | Helm Repository | Helm Repository URL |
|--|--|--|--|
| logging | Fluent Bit | fluent | https://fluent.github.io/helm-charts |
| logging | OpenSearch and OpenSearch Dashboards | opensearch | https://opensearch-project.github.io/helm-charts |
| metrics | Grafana | grafana | https://grafana.github.io/helm-charts |
| both | Several (including Prometheus, Kube-Prometheus-stack, Prometheus Pushgateway and Elasticsearch Exporter) | prometheus-community | https://prometheus-community.github.io/helm-charts |
# Helm Chart Information

| Subsystem | Component | Helm Chart Repo | Helm Chart Name |Helm Chart Version | Helm archive file name|
|--|--|--|--|--|--|
|logging| Elasticsearch Exporter| prometheus-community| prometheus-elasticsearch-exporter| 5.2.0| prometheus-elasticsearch-exporter-5.2.0.tgz
logging| Fluent Bit| fluent| fluent-bit| 0.30.4| fluent-bit-0.30.4.tgz
metrics| Grafana (On Openshift)| grafana| grafana| 6.56.4| grafana-6.56.4.tgz
metrics| Kube Prometheus Stack| prometheus-community| kube-prometheus-stack| 45.28.0| kube-prometheus-stack-45.28.0.tgz
logging| Opensearch| opensearch| opensearch| 2.13.0| opensearch-2.13.0.tgz
logging| Opensearch Dashboard| opensearch| opensearch-dashboards| 2.11.0| opensearch-dashboards-2.11.0.tgz
metrics| Pushgateway| prometheus-community| prometheus-pushgateway| 1.11.0| prometheus-pushgateway-1.11.0.tgz

