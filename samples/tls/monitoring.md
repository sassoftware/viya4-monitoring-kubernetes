# Sample - TLS Enablement for Monitoring

## Overview

This sample demonstrates how to deploy monitoring components with TLS enabled.

Using the `TLS_ENABLE=true` environment variable will enable TLS for in-cluster
communications between monitoring components.

If you enable TLS by specifying `TLS_ENABLE=true` and are using nodeports,
connections between the user and the monitoring components also use TLS.

To use TLS (HTTPS) for ingress, you do not have to specify the
`TLS_ENABLE=true` environment variable, but you must manually populate
Kubernetes ingress secrets as specified below.

## Using This Sample

You customize your monitoring deployment by specifying values in `user.env` and
`*.yaml` files. These files are stored in a local directory outside of your
repository that is identified by the `USER_DIR` environment variable. See the
[monitoring README](../../../monitoring/README.md#mon_custom) for information
about the customization process.

The customization files in this sample provide a starting point for the
customization files for a deployment that supports monitoring with TLS enabled.

There are two variations of this sample - one that uses host-based ingress and
the other that uses path-based ingress. The difference between the two is
in the URL used to access the applications. For host-based ingress, the
application name will be part of the hostname itself (for example,
`https://grafana.host.cluster.example.com/`). For path-based ingress, the
hostname is fixed and the application name is appended as a path on the URL
(for example, `https://host.cluster.example.com/grafana`).

In order to use the values in this sample in the customization files for your
deployment, copy the customization files from either the `host-based-ingress`
or `path-based-ingress` subdirectories to your local customization directory
(your `USER_DIR`), then modify the files further as needed. The one required
change is to replace all instances of `host.cluster.example.com` with the
actual hostname to be used in your environment.

After you finish modifying the customization files, deploy monitoring using the
standard deployment script:

```bash
my_repository_path/monitoring/bin/deploy_monitoring_cluster.sh
```

## Notes On Customization Values

* Set `TLS_ENABLE=true` in the `$USER_DIR/monitoring/user.env` file to specify
that Prometheus, Grafana, and Alertmanager are deployed with TLS enabled for
connections to these components. Due to limitations in the underlying Helm
charts, some components might not have TLS enabled for in-cluster connections
between components. See the **Limitations and Known Issues** section below for
details.

* Edit `$USER_DIR/monitoring/user-values-prom-operator.yaml` and replace any
sample hostnames with hostnames for your deployment. Specifically, you must
replace `host.cluster.example.com` with the name of the ingress node. Often,
the ingress node is the cluster master node, but your environment might be different.

* If you are using ingress with TLS (HTTPS), you must manually populate these
Kubernetes secrets with TLS certificates before you deploy cluster monitoring:

* `prometheus-ingress-tls-secret`
* `alertmanager-ingress-tls-secret`
* `grafana-ingress-tls-secret`

You can use the following command to generate the necessary secret for each set
of TLS certificates:

```bash
kubectl create secret tls $SECRET_NAME -n $NAMESPACE --key $CERT_KEY --cert $CERT_FILE
```

Use `prometheus-ingress-tls-secret`, `alertmanager-ingress-tls-secret`, and
`grafana-ingress-tls-secret` as values for `$SECRET_NAME`. Use `monitoring` for
the value of `$NAMESPACE`.

The process of generating the certificates for these secrets is out of scope for
this example.

* If you are using ingress and are using an ingress controller other than NGINX,
modify the annotation `nginx.ingress.kubernetes.io/backend-protocol: HTTPS` as
needed in the `user-values-prom-operator.yaml` file. Refer to the documentation
for your ingress controller.

### Secrets for In-Cluster TLS

The standard deployment script for the monitoring components use these TLS
secrets for the TLS certificates that handle interactions between components:

* `prometheus-tls-secret`
* `alertmanager-tls-secret`
* `grafana-tls-secret`

If any of the required certificates do not exist, the deployment process
attempts to use [cert-manager](https://cert-manager.io/) (version v1.0 or
later) to generate the missing certificates. If the required certificates
do not exist and cert-manager is not available, the deployment process fails.
cert-manager is not required if TLS is disabled or if all of the TLS secrets
exist prior to deployment.

### Limitations and Known Issues

* The Prometheus node exporter and kube-state-metrics exporters do not
currently support TLS. These components are not exposed over ingress, so
in-cluster access uses HTTP rather than HTTPS.

* If needed, a self-signed cert-manager issuer is created that generates
self-signed certificates when TLS is enabled and the secrets do not already
exist. By default, in-cluster traffic between monitoring components
(not ingress) is configured to skip TLS CA verification.
