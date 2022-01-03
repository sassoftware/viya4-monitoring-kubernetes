# Ingress

## IMPORTANT NOTE: This sample is deprecated

This sample should only be used for internal development and testing. It is
highly recommended to use the [tls sample](/samples/tls) which provides a more
secure HTTPS-based ingress configuration.

This sample will be removed at some point in the future and TLS (both
in-cluster and for ingress) will become the default.

## Overview

This sample demonstrates how to deploy monitoring and logging components
configured with ingress instead of node ports. You can choose to use host-based
or path-based routing. Host-based routing will make the monitoring applications
(Prometheus, Alertmanager, and Grafana) available by using different hostnames.
Path-based routing allows the use of a common hostname with a different path
per application.

If you are using a cloud provider, you must configure ingress as node ports are
usually disabled by default.

## Using This Sample

You customize your deployment by specifying values in `user.env` and `*.yaml`
files. These files are stored in a local directory outside of your repository
that is identified by the `USER_DIR` environment variable. See the
[monitoring README](../../monitoring/README.md#mon_custom) or the
[logging README](../../logging/README.md#log_custom) for information about the
customization process.

The customization files in this sample provide a starting point for the
customization files for a deployment that supports ingress instead of node ports.

In order to use the values in this sample in the customization files for your
deployment, copy the customization files from this sample to your local
customization directory, then modify the files further as needed.

If you also need to use values from another sample, manually copy the values to
your customization files after you add the values in this sample.

After you finish modifying the configuration files, deploy monitoring and
logging using the standard deployment scripts:

```bash
my_repository_path/monitoring/bin/deploy_monitoring_cluster.sh
```

```bash
my_repository_path/logging/bin/deploy_logging_open.sh
```

### Monitoring

The monitoring deployment process requires that the user response file be
named `$USER_DIR/monitoring/user-values-prom-operator.yaml`.

- If you are using host-based routing, rename the
  `user-values-prom-host.yaml` to `user-values-prom-operator.yaml`.
- If you are using path-based routing, rename the `user-values-prom-path.yaml`
  to `user-values-prom-operator.yaml`.

Edit `$USER_DIR/monitoring/user-values-prom-operator.yaml` and replace
all instances of `host.cluster.example.com` with hostnames that match your cluster.

### Logging

The logging deployment process requires that the user response file be
named `$USER_DIR/logging/user-values-elasticsearch-open.yaml`.

- If you are using host-based routing, rename the
  `user-values-elasticsearch-host.yaml` to `user-values-elasticsearch-open.yaml`.

- If you are using path-based routing, rename the `user-values-elasticsearch-path.yaml`
to `user-values-elasticsearch-open.yaml`.

Edit `$USER_DIR/logging/user-values-elasticsearch-open.yaml` and replace
all instances of `host.cluster.example.com` with hostnames that match your cluster

## Access the Applications

If you deploy using host-based ingress, the applications are available at these
locations (with hostnames replaced with those in the actual environment that
you specified):

- Grafana - `http://grafana.host.mycluster.example.com`
- Prometheus - `http://prometheus.host.mycluster.example.com`
- Alertmanager - `http://alertmanager.host.mycluster.example.com`
- Kibana - `http://kibana.host.mycluster.example.com`

If you deploy using path-based ingress, the applications are available at these
locations (with hostnames replaced with those in the actual environment that you
specified):

- Grafana - `http://host.mycluster.example.com/grafana`
- Prometheus - `http://host.mycluster.example.com/prometheus`
- Alertmanager - `http://host.mycluster.example.com/alertmanager`
- Kibana - `http://host.mycluster.example.com/kibana`
