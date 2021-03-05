# Automatically Deployed Dashboards

The dashboards in this directory are automatically deployed when you deploy the monitoring components. If you remove the monitoring components using the `remove_monitoring_cluster.sh` script, the dashboards are removed as well.

## User-Provided Dashboards

You can add dashboards to this directory so that they are also automatically deployed. The dashboards must be in `.json` format and must not be in a subdirectory under this directory. 

## Original Dashboard Sources

These dashboards provided as part of the monitoring deployment are based on public community dashboards from grafana.com: 

- [Istio](https://grafana.com/orgs/istio)
- [Kubernetes Cluster](https://grafana.com/grafana/dashboards/8721)
- [Kubernetes Deployments](https://grafana.com/grafana/dashboards/741)
- [NGINX Ingress controller](https://grafana.com/grafana/dashboards/9614)
- [Prometheus Alerts](https://grafana.com/grafana/dashboards/5450)
- [Elasticsearch](https://grafana.com/grafana/dashboards/2322)
- [RabbitMQ Erlang](https://grafana.com/grafana/dashboards/11350)
- [RabbitMQ Overview](https://grafana.com/grafana/dashboards/10991)
- [Java Micrometer](https://grafana.com/grafana/dashboards/4701)
- [Postgres](https://grafana.com/grafana/dashboards/9628)

All other provided dashboards were manually created by SAS.
