# Overview

This document describes how to enable monitoring of SAS Viya components on
OpenShift. The instructions are not specific to any particular cloud provider,
but tweaks may be necessary.

OpenShift includes cluster monitoring by default, so the steps outlined here
deploy components that integrate with the existing OpenShift monitoring
infrastructure, avoiding the need to deploy a redundant monitoring stack.
The steps below leverage both the cluster and user workload monitoring
capabilities of OpenShift to monitor SAS Viya deployments.

In the end, we will end up with the OpenShift user-workload Prometheus
instances using the PodMonitors and ServiceMonitors deployed by the
viya4-monitoring-kubernetes project to scrape metrics from SAS Viya components.
A new instance of Grafana will then be deployed. This Grafana instance will use
the OpenShift 'thanos-querier' service as its Prometheus data source which
allows access to both cluster and user (SAS Viya) metrics. The same set of
dashboards used in viya4-monitoring-kubernetes will be available in Grafana.

## Deployment

OpenShift publishes documentation that describes how to enable monitoring of
user workloads. These instructions are based on that official documentation.

### Download Artifacts

The files used below are available here: openshift-monitoring.zip

Extract the files in the zip. The directory where those files reside will be
referred to as OPENSHIFT_SAMPLE_DIR.

Follow the instructions to download a copy of the viya4-monitoring-kubernetes
repository. This location will be referred to as V4M_REPO_DIR.

### Enable User Workload Monitoring

If the cluster-monitoring-config configmap in the openshift-monitoring
namespace does not exist, create it:

```bash
kubectl apply -f $OPENSHIFT_SAMPLE_DIR/cluster-monitoring-config.yaml
```

If it already exists, edit it to ensure it contains: `enableUserWorkload: true`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    enableUserWorkload: true
```

Once the config map is created, OpenShift will deploy a new Prometheus instance
to the openshift-user-workload-monitoring project/namespace. You can check
that the expected resources exist:

```plaintext
$ kubectl get po -n openshift-user-workload-monitoring
NAME                                   READY   STATUS    RESTARTS   AGE
prometheus-operator-7d4b859dfd-p95wc   2/2     Running   0          20h
prometheus-user-workload-0             5/5     Running   1          3d6h
prometheus-user-workload-1             5/5     Running   1          3d6h
thanos-ruler-user-workload-0           3/3     Running   0          3d6h
thanos-ruler-user-workload-1           3/3     Running   0          3d6h
```

The default configuration works reasonably well. User workspace monitoring
configuration options are documented [here](https://docs.openshift.com/container-platform/4.7/monitoring/configuring-the-monitoring-stack.html).

### Deploy SAS Viya Monitoring Components

As with other environments, each SAS Viya namespace must be enabled for
monitoring. On OpenShift, a small customization is needed to properly
configure the Prometheus Pushgateway.

```yaml
# Chart: https://github.com/helm/charts/tree/master/stable/prometheus-pushgateway
# Default values: https://github.com/helm/charts/blob/master/stable/prometheus-pushgateway/values.yaml

securityContext: null
```

To deploy the components, run:

```bash
USER_DIR=$OPENSHIFT_SAMPLE_DIR VIYA_NS=[YOUR_VIYA_NAMESPACE] $V4M_REPO_DIR/monitoring/bin/deploy_monitoring_viya.sh
```

### Deploy Additional ServiceMonitors

ServiceMonitors usually deployed through the
`$V4M_REPO_DIR/monitoring/bin/deploy_monitoring_cluster.sh` script need to be
deployed so that additional cluster-wide components can be scraped, if present.

#### Eventrouter ServiceMonitor

```bash
kubectl apply -n monitoring -f $V4M_REPO_DIR/monitoring/monitors/kube/podMonitor-eventrouter.yaml 2>/dev/null

# Elasticsearch ServiceMonitor
kubectl apply -n monitoring -f $V4M_REPO_DIR/monitoring/monitors/logging/serviceMonitor-elasticsearch.yaml

# Fluent Bit ServiceMonitors
kubectl apply -n monitoring -f $V4M_REPO_DIR/monitoring/monitors/logging/serviceMonitor-fluent-bit-v2.yaml

# Rules for SAS Jobs dashboards
for f in $V4M_REPO_DIR/monitoring/rules/viya/rules-*.yaml; do
  kubectl apply -n monitoring -f $f
done
```

Grafana
The cluster-wide Grafana instance deployed by default in OpenShift is
read-only. Enabling user workload monitoring on OpenShift does not deploy
another instance of Grafana, so we will deploy our own to the
monitoring project/namespace.

The customized helm values are below. Note that a future step will replace
the `${BEARER_TOKEN}` in this file.

```yaml
sidecar:
  dashboards:
    enabled: true
    label: grafana_dashboard
  datasources:
    enabled: true
    label: grafana_datasource
persistence:
  type: pvc
  enabled: true
  # Provide custom storageClassName here if needed
  # storageClassName: nfs-client
  finalizers:
    - kubernetes.io/pvc-protection
  accessModes:
    - ReadWriteOnce
  size: 5Gi
# dashboards:
#   default_home_dashboard_path: /tmp/dashboards/viya-welcome-dashboard.json
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    # OpenShift Thanos querier allows access to both cluster
    # and user workload monitoring
    - access: proxy
      editable: false
      isDefault: true
      jsonData:
        httpHeaderName1: 'Authorization'
        timeInterval: 5s
        tlsSkipVerify: true
      name: Prometheus
      secureJsonData:
        # Replace BEARER_TOKEN below with a token for grafana-serviceaccount
        httpHeaderValue1: 'Bearer ${BEARER_TOKEN}'
      type: prometheus
      url: 'https://thanos-querier.openshift-monitoring.svc.cluster.local:9091'
initChownData:
  enabled: false
# Set to null to disable securityContext for OpenShift
securityContext: null
serviceAccount:
  # Service account created prior to helm install since the token is needed
  # above in the datasource configuration
  create: false
  name: grafana-serviceaccount
testFramework:
  enabled: false
"grafana.ini":
  analytics:
    check_for_updates: false
  log:
    mode: console
  "log.console":
      format: json
```

To make Grafana accessible, we will configure ingress. We will use a separate
file for the ingress configuration.

```yaml
# Replace 'host.mycluster.example.com' with the ingress hostname of your
# OpenShift cluster
"grafana.ini":
  server:
    protocol: http
    domain: grafana.monitoring.apps.host.mycluster.example.com
    root_url: http://grafana.monitoring.apps.host.mycluster.example.com/
    serve_from_sub_path: false
ingress:
  enabled: true
  path: /
  hosts:
  - grafana.monitoring.apps.host.mycluster.example.com
```

### Grant Access for Grafana to Query Openshift Prometheus

Before Grafana can be deployed, we must grant access to a custom serviceaccount
to query metrics from the OpenShift managed Prometheus instances.

[Reference](https://www.redhat.com/en/blog/custom-grafana-dashboards-red-hat-openshift-container-platform-4)

```bash
kubectl create ns monitoring
kubectl create serviceaccount -n monitoring grafana-serviceaccount
oc adm policy add-cluster-role-to-user cluster-monitoring-view -z grafana-serviceaccount -n monitoring
oc serviceaccounts get-token grafana-serviceaccount -n monitoring
```

Copy the token from the output of the second command and replace
`${BEARER_TOKEN}` with the copied token in
`$OPENSHIFT_SAMPLE_DIR/monitoring/grafana-common-values.yaml`.

### Deploy Grafana

Using helm 3.x, deploy Grafana:

```bash
helm upgrade --install --namespace monitoring grafana-viya \
  -f $OPENSHIFT_SAMPLE_DIR/monitoring/grafana-common-values.yaml \
  -f $OPENSHIFT_SAMPLE_DIR/monitoring/grafana-ingress-values.yaml grafana/grafana
```

### Deploy Grafana Dashboards

To deploy all Grafana dashboards (both cluster and SAS dashboards), run:

```bash
DASH_NS=monitoring $OPENSHIFT_SAMPLE_DIR/monitoring/bin/deploy_dashboards.sh
```

To deploy only the SAS Viya dashboards:

```bash
DASH_NS=monitoring KUBE_DASH=false LOGGING_DASH=false $OPENSHIFT_SAMPLE_DIR/monitoring/bin/deploy_dashboards.sh
```

The dashboards should be available almost immediately.

### Access Grafana

Grafana will be accessible at the hostname specified in
`$OPENSHIFT_SAMPLE_DIR/monitoring/grafana-ingress-values.yaml` from above.
The initial Grafana admin password can be obtained by running:

```bash
kubectl get secret --namespace monitoring grafana-viya -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
