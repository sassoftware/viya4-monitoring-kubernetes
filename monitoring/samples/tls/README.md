# Sample - TLS Enablement for Monitoring

## Overview

This sample demonstrates how to deploy monitoring components with TLS enabled.

All components will have TLS enabled on ingress. Due to limitations in the
underlying helm charts, some components may not have TLS enabled in-cluster.
See the Limitations/Known Issues section below for details.

## Instructions

Set up an empty directory with a `monitoring` subdirectory to be used for the
customization files. Export a `USER_DIR` environment variable pointing to this
location. For example:

```bash
mkdir -p ~/my-cluster-files/ops/user-dir/monitoring
export USER_DIR=~/my-cluster-files/ops/user-dir
```

Next, create `$USER_DIR/monitoring/user.env`. The following values
should be set in the file:

* `MON_TLS_ENABLE=true` - This flag modifies the deployment of Prometheus,
Grafana, and AlertManager to be TLS-enabled.
* `MON_INGRESS_HOST` - The hostname of the ingress host for the cluster.
By default, the TLS-enablement will prepend this value with `prometheus.`,
`grafana.`, and `alertmanager.` and use host-based ingress for those
applications.

Next, copy the sample TLS helm user response file to your `USER_DIR`:

```bash
cp path/to/this/repo/monitoring/samples/tls/user-tls-values-prom-operator.yaml $USER_DIR/monitoring/
```

Edit `$USER_DIR/monitoring/user-tls-values-prom-operator.yaml` and replace
any hostnames with the real values.

Any other desired customization should be completed here as well.

Once `USER_DIR` is properly set per the above instructions, deploy cluster
monitoring normally:

```bash
path/to/this/repo/monitoring/bin/deploy_monitoring_cluster.sh
```

## Limitations/Known Issues

There is a [bug in the AlertManager helm template](https://github.com/helm/charts/issues/22939)
that prevents mounting the TLS certificates for the reverse proxy sidecar.
It is expected that this issue will be addressed before GA.

The Prometheus node exporter and kube-state-metrics exporters do not currently
support TLS. These components are not exposed over ingress, so in-cluster
access will be over HTTP and not HTTPS.

When using a self-signed CA, the CA certificate must be added to any machine
using a browser to access the monitoring components over ingress. The process
to import and trust certificates varies by platform.
