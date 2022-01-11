# Sample - TLS Enablement for Monitoring

## Overview

This sample demonstrates how to deploy monitoring components with Transport 
Layer Security (TLS) enabled.

Using the `TLS_ENABLE=true` environment variable enables TLS for in-cluster
communications between monitoring components.

If you enable TLS by specifying `TLS_ENABLE=true` and you are using NodePorts,
connections between the user and the monitoring components also use TLS.

To use TLS (HTTPS) for ingress, you do not have to specify the
`TLS_ENABLE=true` environment variable. However, you must manually populate
Kubernetes ingress secrets as described below.

## Using This Sample

Customize your monitoring deployment by specifying values in the `user.env` and
`*.yaml` files. These files are stored in a local directory outside of your
repository. The local directory is identified by the `USER_DIR` environment 
variable. See the
[monitoring README](../../../monitoring/README.md#mon_custom) for information
about the customization process.

The customization files in this sample provide a starting point for the
customization files required for a deployment that supports monitoring with TLS 
enabled.

There are two versions of this sample:

- host-based ingress
- path-based ingress

The difference between the two is in the URL that is used to access the 
applications:

- For host-based ingress, the
application name is part of the host name itself (for example,
`https://grafana.host.cluster.example.com/`).
- For path-based ingress, the host name is fixed and the application name is 
  appended as a path on the URL
(for example, `https://host.cluster.example.com/grafana`).

In order to use the values in this sample in the customization files for your 
deployment, complete the following steps:

1. Copy the customization files from either the `host-based-ingress`
or `path-based-ingress` subdirectories to your local customization directory 
(that is, your `USER_DIR`).
2. In the configuration files, replace all instances of 
   `host.cluster.example.com` with the host name that is used in your 
   environment.
3. (Optional) Modify the files further as needed.

After you finish modifying the customization files, deploy monitoring by using 
the standard deployment script:

<pre>
<i>repository_path</i>/monitoring/bin/deploy_monitoring_cluster.sh
</pre>
where *repository_path* is the path that is used for your repository.


## Notes on Customization Values

- Set `TLS_ENABLE=true` in the `$USER_DIR/monitoring/user.env` file to specify
that Prometheus, Grafana, and Alertmanager are deployed with TLS enabled for
connections to these components. Due to limitations in the underlying Helm
charts, some components might not have TLS enabled for in-cluster connections
between components. 
See [Limitations and Known Issues](#Limitations-and-Known-Issues) for
details.

- Edit the `$USER_DIR/monitoring/user-values-prom-operator.yaml` file and 
replace any sample host names with the host names for your deployment. 
Specifically, you must replace `host.cluster.example.com` with the name 
of the ingress node. Typically, the ingress node is the cluster primary node.

## Specifying TLS for Ingress

If you are using ingress with TLS (HTTPS), you must manually create the following 
Kubernetes secrets with TLS certificates before you deploy cluster monitoring:

- `prometheus-ingress-tls-secret`
- `alertmanager-ingress-tls-secret`
- `grafana-ingress-tls-secret`

**Note:** The process of generating the TLS certificates for these secrets is 
outside the scope for this example.

1. After you have obtained the TLS certificates for each secret, use the 
following command to generate the secrets. You must run the command for each 
secret name.

<pre>
kubectl create secret tls <i>secret_name</i> --namespace <i>namespace</i> --key=<i>cert_key_file</i> --cert=<i>cert_file</i>
</pre>

  where:

- *secret_name* is the one of the following values:
  - The first time use `prometheus-ingress-tls-secret`.
  - The second time use `alertmanager-ingress-tls-secret`.
  - The third time use `grafana-ingress-tls-secret`.

- *namespace* is the value `monitoring`.
- *cert_key_file* is the TLS certificate key file associated with the secret name. 
  Be sure to use the correct .key file in each instance of this command.
- *cert_file* is the TLS certificate file associated with the secret name. 
  Be sure to use the correct .crt file in each instance of this command.

2. If you are using ingress and are using an ingress controller other than NGINX, modify the
annotation `nginx.ingress.kubernetes.io/backend-protocol: HTTPS` as needed in
the `user-values-prom-operator.yaml` file. Refer to the documentation for
your ingress controller.

### Secrets for In-Cluster TLS

The standard deployment script for the monitoring components use the following TLS
secrets for the TLS certificates that handle interactions between components:

- `prometheus-tls-secret`
- `alertmanager-tls-secret`
- `grafana-tls-secret`

If any of the required certificates do not exist, the deployment process
attempts to use [cert-manager](https://cert-manager.io/) (version 1.0 or
later) to generate the missing certificates. If the required certificates
do not exist and cert-manager is not available, the deployment process fails.
cert-manager is not required if TLS is disabled or if all of the TLS secrets
exist prior to deployment.

### Limitations and Known Issues

- The Prometheus node exporter and kube-state-metrics exporters do not
currently support TLS. These components are not exposed over ingress, so
in-cluster access uses HTTP instead of HTTPS.

- If needed, a self-signed cert-manager issuer is created. The issuer  generates
self-signed certificates when TLS is enabled and the secrets do not already
exist. By default, in-cluster traffic between monitoring components
(not ingress) is configured to skip TLS CA verification.
