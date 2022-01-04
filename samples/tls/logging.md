# Sample - TLS Enablement for Logging

## Overview

Transport Layer Security (TLS) enablement for SAS Viya logging is divided into two types:

- TLS for in-cluster communications
- TLS for communications into the cluster

**TLS for in-cluster communications** is communication between logging components within the cluster. The communication can be between the Elasticsearch nodes or between Elasticsearch and other logging components. TLS must be enabled on these connections.

In-cluster communications must always take place through TLS-enabled
connections. TLS for in-cluster communications is configured by using either of the following processes:

- automatic configuration by using cert-manager to generate certificates
- manual configuration by generating certificates

See [Notes_on_using_TLS](../../../logging/Notes_on_using_TLS.md)
for information about configuring TLS for in-cluster communications.

**TLS for communications into the cluster** is communication between Ingress or a
user's browser (if NodePorts are used) and Kibana. TLS is optional on these
connections, although enabling TLS is a best practice.

This sample demonstrates how to enable TLS for communication into the
cluster by deploying logging with TLS enabled for connections between the
user and Kibana. The `TLS_ENABLE` environment variable controls whether
connections to Kibana use TLS.

## Using This Sample

Customize your logging deployment by specifying values in the `user.env` and
`*.yaml` files. These files are stored in a local directory outside of your
repository. The local directory is identified by the `USER_DIR` environment variable. See the
[logging README](../../../logging/README.md#log_custom) for information about the customization process.

The customization files in this sample provide a starting point for the
customization files required for a deployment that supports logging with TLS enabled.

There are two versions of this sample:

- host-based ingress
- path-based ingress

The difference between the two is in the URL that is used to access the applications:

- For host-based ingress, the
application name is part of the host name itself (for example,
`https://kibana.host.cluster.example.com/`).
- For path-based ingress, the host name is fixed and the application name is appended as a path on the URL
(for example, `https://host.cluster.example.com/kibana`).

In order to use the values in this sample in the customization files for your deployment, complete the following steps:

1. Copy the customization files from either the `host-based-ingress`
or `path-based-ingress` subdirectories to your local customization directory (that is, your `USER_DIR`).
2. In the configuration files, replace all instances of `host.cluster.example.com` with the host name that is used in your environment.
3. (Optional) Modify the files further as needed.

After you finish modifying the customization files, deploy monitoring by using the standard deployment script:

<pre>
<i>repository_path</i>/logging/bin/deploy_logging_open.sh
</pre>
where *repository_path* is the path that is used for your repository.

## Specifying TLS for Connections to Kibana

Specify `TLS_ENABLE=true` in the `user.env` file to require TLS for connections
to Kibana. When connections to Elasticsearch are enabled, TLS is always used regardless of the value of `TLS_ENABLE`.

If you specify `TLS_ENABLE=true`, the `kibana-tls-secret` Kubernetes secret
must be present. By default, the `deploy_logging_open.sh` deployment script
automatically obtains the certificates from cert-manager and creates the
`kibana-tls-secret` secret.

See [Notes_on_using_TLS](../../../logging/Notes_on_using_TLS.md) for
information about creating this secret manually.

## Specifying TLS for Ingress

If you are using ingress and want to enable TLS on communications into the cluster,
you must manually create the following two Kubernetes secrets:

- `elasticsearch-ingress-tls-secret`
- `kibana-ingress-tls-secret`

**Note:** The process of generating the TLS certificates for these secrets is outside the scope for this example.

1. After you have obtained the TLS certificates for each secret, use the following command to generate the secrets. You must run the command for each secret name.

```bash
kubectl create secret tls $SECRET_NAME -n $NAMESPACE --key $CERT_KEY --cert $CERT_FILE
```

    where:

- `$SECRET_NAME` is the one of the following values:

  - The first time use `elasticsearch-ingress-tls-secret`.
  - The second time use `kibana-ingress-tls-secret`.

- `$NAMESPACE` is the value `logging` by default. If you deployed the logging components into a namespace with a different name, use that value instead.

- `$CERT_KEY` is the TLS certificate key file associated with the secret name. Be sure to use the correct .key file in each instance of this command.

- `$CERT_FILE` is the TLS certificate file associated with the secret name. Be sure to use the correct .crt file in each instance of this command.


1. In your local copy of the file
`$USER_DIR\samples\tls\logging\user-values-elasticsearch-open.yaml`, update the
values in `kibana.logging.host.cluster.example.com` and
`elasticsearch.logging.host.cluster.example.com` with the following information:
   - the namespace into which you have deployed the logging and monitoring components 
   - the correct ingress host information

3. If you are using an ingress controller other than NGINX, modify the
annotation `nginx.ingress.kubernetes.io/backend-protocol: HTTPS` as needed in
the `user-values-elasticsearch-open.yaml` file. Refer to the documentation for
your ingress controller.
