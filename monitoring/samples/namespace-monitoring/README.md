# Namespace Monitoring

This directory contains a set of user response files that enabled the
separation of cluster monitoring from SAS Viya namespace monitoring.

Cluster monitoring components (Prometheus, Alert Manager, Grafana,
and several exporters and associated ServiceMonitors) will be deployed
to the `monitoring` namespace. If the customer already has a cluster
monitoring solution (e.g. OpenShift), this step can be skipped.

Separate instances of Prometheus, Alert Manager, and Grafana will be
deployed to each SAS Viya namespace along with the needed dashboards
and ServiceMonitors.

## Deployment

```bash
# Deploy cluster monitoring (including the Prometheus Operator)
# with a custom user file and no Viya dashboards
VIYA_DASH=false PROM_OPER_USER_YAML=monitoring/samples/namespace-monitoring/cluster-only-values-prom-operator.yaml monitoring/bin/deploy_monitoring_cluster.sh

# Deploy standard Viya monitoring components each Viya namespace
VIYA_NS=anakin monitoring/bin/deploy_monitoring_viya.sh
VIYA_NS=babyyoda monitoring/bin/deploy_monitoring_viya.sh

# Deploy Prometheus to each Viya namespace
kubectl apply -n anakin -f monitoring/samples/namespace-monitoring/prometheus-viya-anakin.yaml
kubectl apply -n babyyoda -f monitoring/samples/namespace-monitoring/prometheus-viya-babyyoda.yaml

# Deploy Grafana to each Viya namespace
helm upgrade --install --namespace anakin grafana-anakin -f monitoring/samples/namespace-monitoring/grafana-viya-anakin.yaml stable/grafana
helm upgrade --install --namespace babyyoda grafana-babyyoda -f monitoring/samples/namespace-monitoring/grafana-viya-babyyoda.yaml stable/grafana

# Deploy SAS Viya dashboards to each Viya namespace
DASH_NS=anakin KUBE_DASH=false LOGGING_DASH=false monitoring/bin/deploy_dashboards.sh
DASH_NS=babyyoda KUBE_DASH=false LOGGING_DASH=false monitoring/bin/deploy_dashboards.sh
```
