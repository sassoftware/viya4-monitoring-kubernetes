# List of Images Deployed By SAS Viya Monitoring for Kubernetes Project

The following images are deployed by the SAS Viya Monitoring for Kubernetes project:

## Cluster-Level Monitoring Images

```plaintext
ghostunnel/ghostunnel:v1.7.1
grafana/grafana:9.5.2
kiwigrid/k8s-sidecar:1.24.0
quay.io/prometheus-operator/prometheus-config-reloader:v0.65.1
quay.io/prometheus-operator/prometheus-operator:v0.65.1
quay.io/prometheus/alertmanager:v0.25.0
quay.io/prometheus/node-exporter:v1.5.0
quay.io/prometheus/prometheus:v2.44.0
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.8.2
busybox:1.31.1
```

## SAS Viya- and Tenant-Level Monitoring Images

```plaintext
ghostunnel/ghostunnel:v1.7.1
grafana/grafana:9.5.2
kiwigrid/k8s-sidecar:1.24.0
quay.io/prometheus-operator/prometheus-config-reloader:v0.65.1
quay.io/prometheus-operator/prometheus-operator:v0.65.1
quay.io/prometheus/prometheus:v2.44.0
prom/pushgateway:v1.5.1
```

## Cluster-Level Logging Images

```plaintext
cr.fluentbit.io/fluent/fluent-bit:2.0.9
gcr.io/heptio-images/eventrouter:v0.3
opensearchproject/opensearch-dashboards:2.6.0
opensearchproject/opensearch:2.6.0
quay.io/prometheuscommunity/elasticsearch-exporter:v1.5.0
busybox:latest
```

## All Images - SAS Viya Monitoring for Kubernetes

**NOTE:**  This is a consolidated list of all images deployed by the SAS Viya  Monitoring for Kubernetes project.

```plaintext
busybox:1.31.1
busybox:latest
cr.fluentbit.io/fluent/fluent-bit:2.0.9
gcr.io/heptio-images/eventrouter:v0.3
ghostunnel/ghostunnel:v1.7.1
grafana/grafana:9.5.2
kiwigrid/k8s-sidecar:1.24.0
opensearchproject/opensearch-dashboards:2.6.0
opensearchproject/opensearch:2.6.0
prom/pushgateway:v1.5.1
quay.io/prometheus-operator/prometheus-config-reloader:v0.65.1
quay.io/prometheus-operator/prometheus-operator:v0.65.1
quay.io/prometheus/alertmanager:v0.25.0
quay.io/prometheus/node-exporter:v1.5.0
quay.io/prometheus/prometheus:v2.44.0
quay.io/prometheuscommunity/elasticsearch-exporter:v1.5.0
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.8.2
```
