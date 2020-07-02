# Sample - TLS Enablement for Monitoring

## Overview

This sample demonstrates how to deploy monitoring components with TLS enabled.

All components will have TLS enabled on ingress. Due to limitations in the
underlying helm charts, some components may not have TLS enabled in-cluster.
See the Limitations/Known Issues section below for details.

When using this sample for HTTPS for ingress, the following secrets are
expected to be populated in the `monitoring` namespace (or `MON_NS` value)
manually **BEFORE** running any scripts in this repository:

* kubernetes.io/tls secret - `prometheus-ingress-tls-secret`
* kubernetes.io/tls secret - `alertmanager-ingress-tls-secret`
* kubernetes.io/tls secret - `grafana-ingress-tls-secret`

Generating these certificates is outside the scope of this README, but the
same process described by the SAS Viya deployment documentation can be used
here, just using the `monitoring` namespace instead.

For in-cluster (east-west traffic) TLS for monitoring components,
[cert-manager](https://cert-manager.io/) is used to populate the following
secrets containing pod certificates (existing secrets are not overwritten,
so they can still be manually populated):

* kubernetes.io/tls secret - `prometheus-tls-secret`
* kubernetes.io/tls secret - `alertmanager-tls-secret`
* kubernetes.io/tls secret - `grafana-tls-secret`

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

Next, copy the sample TLS helm user response file to your `USER_DIR`:

```bash
cp path/to/this/repo/monitoring/samples/tls/user-values-prom-operator.yaml $USER_DIR/monitoring/
```

Edit `$USER_DIR/monitoring/user-values-prom-operator.yaml` and replace
any hostnames with the real values. Specifically, replace
`host.cluster.example.com` with the name of the ingress node (many times
this is the cluster master node, but environments vary).

Any other desired customizations to the YAML should be completed at this
time as well.

Once `USER_DIR` is properly set per the above instructions, deploy cluster
monitoring normally:

```bash
path/to/this/repo/monitoring/bin/deploy_monitoring_cluster.sh
```

## Limitations/Known Issues

There is a [bug in the AlertManager helm template](https://github.com/helm/charts/issues/22939)
that prevents mounting the TLS certificates for the reverse proxy sidecar.
It is expected that this issue will be addressed before GA. HTTPS is still
supported for alertmanager at the ingress level, just not for the pod (in-cluster).

The Prometheus node exporter and kube-state-metrics exporters do not currently
support TLS. These components are not exposed over ingress, so in-cluster
access will be over HTTP and not HTTPS.

A self-signed cert-manager Issuer is created if needed which will generate
self-signed certificates when TLS is enabled and the secrets do no already
exist. In cluster traffic between monitoring components (not ingress) is
configured to skip TLS CA verification by default.
