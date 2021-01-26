# Sample - TLS Enablement for Monitoring

## Overview

This sample demonstrates how to deploy monitoring components with TLS enabled.

If you enable TLS, in-cluster communications between monitoring components use TLS. 

If you enable TLS and are using nodeports, connections between the user and monitoring components also use TLS.

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

* Set `TLS_ENABLE=true` in the `$USER_DIR/monitoring/user.env` file to specify that Prometheus, Grafana, and Alertmanager are deployed with TLS enabled for connections to these components. Due to limitations in the underlying Helm charts, some components might not have TLS enabled for in-cluster connections between components. See the **Limitations and Known Issues** section below for details.

* Edit `$USER_DIR/monitoring/user-values-prom-operator.yaml` and replace
any sample hostnames with hostnames for your deployment. Specifically, you must replace
`host.cluster.example.com` with the name of the ingress node. Often, the ingress node is the cluster master node, but your environment might be different.

* If you are using ingress, manually populate these secrets in the `monitoring` namespace (or `MON_NS` value) **before** you deploy cluster monitoring.

* kubernetes.io/tls secret - `prometheus-ingress-tls-secret`
* kubernetes.io/tls secret - `alertmanager-ingress-tls-secret`
* kubernetes.io/tls secret - `grafana-ingress-tls-secret`

Use cert-manager, if available, to create these certificates. If cert-manager is not available, you must create the certificates manually by using the `kubectl -n monitoring create secret` command.

* If you are using ingress and are using an ingress controller other than NGINX, modify the annotation 
`nginx.ingress.kubernetes.io/backend-protocol: HTTPS` as needed in the `user-values-prom-operator.yaml` file. Refer to the documentation for your ingress controller. 

### Secrets for In-Cluster TLS

The standard deployment script for the monitoring components use these secrets for the TLS certificates that
handle interactions between components:

* kubernetes.io/tls secret - `prometheus-tls-secret`
* kubernetes.io/tls secret - `alertmanager-tls-secret`
* kubernetes.io/tls secret - `grafana-tls-secret`

If any of the required certificates do not exist, the deployment process attempts to use [cert-manager](https://cert-manager.io/) to generate the missing
certificates. If the required certificates do not exist and cert-manager is
not available, the deployment process fails. cert-manager is not required
if TLS is disabled or if all of the TLS secrets exist prior to deployment.

### Limitations and Known Issues

* The Prometheus node exporter and kube-state-metrics exporters do not currently
support TLS. These components are not exposed over ingress, so in-cluster
access is over HTTP and not HTTPS.

* If needed, a self-signed cert-manager issuer is created that generates
self-signed certificates when TLS is enabled and the secrets do not already
exist. By default, in-cluster traffic between monitoring components
(not ingress) is configured to skip TLS CA verification.
