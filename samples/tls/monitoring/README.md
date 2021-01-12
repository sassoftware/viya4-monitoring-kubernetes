# Sample - TLS Enablement for Monitoring

## Overview

This sample demonstrates how to deploy monitoring components with TLS enabled.

All components have TLS enabled on ingress. Due to limitations in the
underlying Helm charts, some components might not have TLS enabled in-cluster.
See the **Limitations and Known Issues** section below for details.

## Ingress

If you use this sample for HTTPS for ingress, the following secrets must be
manually populated in the `monitoring` namespace (or `MON_NS` value)
**BEFORE** you deploy cluster monitoring.

* kubernetes.io/tls secret - `prometheus-ingress-tls-secret`
* kubernetes.io/tls secret - `alertmanager-ingress-tls-secret`
* kubernetes.io/tls secret - `grafana-ingress-tls-secret`

Generating these certificates is outside the scope of this example. However,
you can use the process documented in ["Configure NGINX Ingress TLS for SAS Applications"](https://go.documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=calencryptmotion&docsetTarget=n1xdqv1sezyrahn17erzcunxwix9.htm&locale=en#n0oo2yu8440vmzn19g6xhx4kfbrq)
in SAS Viya Administration documentation and specify the `monitoring` namespace.

## In-Cluster TLS

The monitoring components use these secrets for the TLS certificates that
handle interactions between services:

* `grafana-tls-secret`
* `prometheus-tls-secret`
* `alertmanager-tls-secret`

If any of the required certificates do not exist, the deployment process will
attempt to use [cert-manager](https://cert-manager.io/) to generate the missing
certificates. If the required certificates do not exist and cert-manager is
not available, the deployment process will fail. cert-manager is not required
if TLS is disabled or if all of the TLS secrets exist prior to deployment.

For in-cluster (east-west traffic) TLS for monitoring components,  
[cert-manager](https://cert-manager.io/) populates these secrets, which
contain pod certificates:

* kubernetes.io/tls secret - `prometheus-tls-secret`
* kubernetes.io/tls secret - `alertmanager-tls-secret`
* kubernetes.io/tls secret - `grafana-tls-secret`

## Using This Sample

You customize your logging deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. See the 
[main README](../../README.md#customization) to for information about the customization process.

The customization files in this sample provide a starting point for the customization files for a deployment that supports monitoring with TLS enabled. 

In order to use the values in this sample in the customization files for your deployment, copy the customization files from this sample to your local customization directory, then modify the files further as needed.

If you also need to use values from another sample, manually copy the values to your customization files after you add the values in this sample. 

After you finish modifying the customization files, deploy monitoring using the standard deployment script:

```bash
my_repository_path/monitoring/bin/deploy_monitoring_cluster.sh
```

## Notes On Customization Values

Set `MON_TLS_ENABLE=true` in the `$USER_DIR/monitoring/user.env` file. This variable modifies the deployment of Prometheus,
Grafana, and Alertmanager to be TLS-enabled.

Edit `$USER_DIR/monitoring/user-values-prom-operator.yaml` and replace
any sample hostnames with hostnames for your deployment. Specifically, you must replace
`host.cluster.example.com` with the name of the ingress node. Often, the ingress node is the cluster master node, but your environment might be different.

## Limitations and Known Issues

* There is a [bug in the Prometheus template](https://github.com/prometheus-community/helm-charts/issues/152)
that prevents mounting the TLS certificates for the reverse proxy sidecar for Alertmanager.
HTTPS is still
supported for Alertmanager at the ingress level, but it is not supported for
the pod (in-cluster).

* The Prometheus node exporter and kube-state-metrics exporters do not currently
support TLS. These components are not exposed over ingress, so in-cluster
access is over HTTP and not HTTPS.

* If needed, a self-signed cert-manager issuer is created that generates
self-signed certificates when TLS is enabled and the secrets do not already
exist. By default, in-cluster traffic between monitoring components
(not ingress) is configured to skip TLS CA verification.
