# Ingress

This sample demonstrates how to deploy monitoring and logging components
configured with ingress instead of node ports. There are examples for both
host-based and path-based ingress.

When deploying on a public cloud provider, nodeport access is usually disabled,
so you must configure ingress to access the applications.

## Installation

```bash
export USER_DIR=/path/to/my/copy/ingress
```

To enable TLS, edit `$USER_DIR/user.env` and set `TLS_ENABLED` to `true`

### Monitoring 

The monitoring deployment process requires that the user response file be
named `$USER_DIR/monitoring/user-values-prom-operator.yaml`, so rename the
`user-values-prom-host.yaml` or `user-values-prom-path.yaml` to
`user-values-prom-operator.yaml` before deploying.

Edit `$USER_DIR/monitoring/user-values-prom-operator.yaml` and replace
all `host.cluster.example.com` with hostnames that match your cluster

Deploy monitoring normally

```bash
/path/to/this/repo/monitoring/bin/deploy_monitoring_cluster.sh
```

### Logging

The monitoring deployment process requires that the user response file be
named `$USER_DIR/logging/user-values-elasticsearch-open.yaml`, so rename the
`user-values-elasticsearch-host.yaml` or `user-values-elasticsearch-path.yaml` to
`user-values-elasticsearch-open.yaml` before deploying.

Edit `$USER_DIR/logging/user-values-elasticsearch-open.yaml` and replace
all `host.cluster.example.com` with hostnames that match your cluster

Deploy logging normally

```bash
/path/to/this/repo/logging/bin/deploy_logging_open.sh
```

## Access the Applications

If you deploy using host-based ingress, the applications are available at these
locations (hostnames replaced with those in the actual environment):

* Grafana - `https://grafana.host.mycluster.example.com`
* Prometheus - `https://prometheus.host.mycluster.example.com`
* AlertManager - `https://alertmanager.host.mycluster.example.com`
* Kibana - `https://kibana.host.mycluster.example.com`

If you deploy using path-based ingress, the applications are available at these
locations (hostnames replaced with those in the actual environment):

* Grafana - `http://host.mycluster.example.com/grafana`
* Prometheus - `http://host.mycluster.example.com/prometheus`
* AlertManager - `http://host.mycluster.example.com/alertManager`
* Kibana - `http://host.mycluster.example.com/kibana`

The default credentials for Grafana and Kibana are `admin`:`admin`.
