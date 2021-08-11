# Sample - TLS Enablement for Logging

## Overview

TLS enablement for SAS Viya logging is divided into two parts:

- **TLS for in-cluster communications**, which is between logging components within
the cluster (between the Elasticsearch nodes and between Elasticsearch and other logging components). TLS must be enabled on these connections.

In-cluster communications must always take place through TLS-enabled connections. TLS for in-cluster communications is configured using a separate process, 
either automatically (using cert-manager to generate certificates) 
or by manually generating certificates. See [Notes_on_using_TLS](../../../logging/Notes_on_using_TLS.md) for information about configuring TLS for 
in-cluster communications. 

- **TLS for communications into the cluster**, which is between Ingress or a 
user's browser (if NodePorts are used) and Kibana. TLS is optional on these connections, although enabling TLS is a best practice.

This sample demonstrates how to enable TLS for communications into the 
cluster by deploying logging with TLS enabled for connections between the 
user and Kibana. The `TLS_ENABLE` environment variable controls whether 
connections to Kibana use TLS.

## Using This Sample

You customize your logging deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. See the 
[logging README](../../../logging/README.md#log_custom) for information about the customization process.

The customization files in this sample provide a starting point for the customization files for a deployment that supports logging with TLS enabled. 

In order to use the values in this sample in the customization files for your deployment, copy the customization files from this sample to your local customization directory, then modify the files further as needed.

If you also need to use values from another sample, manually copy the values to your customization files after you add the values in this sample. 

After you finish modifying the customization files, deploy logging using the standard deployment script:

```bash
my_repository_path/logging/bin/deploy_logging_open.sh
```
## Specifying TLS for Connections to Kibana

Specify `TLS_ENABLE=true` in the `user.env` file to require TLS for connections to Kibana. Connections to Elasticsearch (when enabled) always use TLS, regardless of the value of `TLS_ENABLE`.

If you specify `TLS_ENABLE=true`, the `kibana-tls-secret` Kubernetes secret 
must be present. By default, the `deploy_logging_open.sh` deployment script automatically obtains the certificates from cert-manager and creates 
the `kibana-tls-secret` secret.

See [Notes_on_using_TLS](../../../logging/Notes_on_using_TLS.md) for 
information about creating this secret manually. 

## Specifying TLS for Ingress

If you are using ingress and want to enable TLS on traffic into the cluster, 
you must manually create two Kubernetes secrets.

1. Issue this command to generate the required secrets:

```bash
kubectl -n <namespace> create secret generic <secret-name> --from-file=tls.crt=<tls_cert_name>.pem --from-file=tls.key=<key_name>.key --from-file=ca.crt=<CA_key_name>.pem
```
By default, the value of `namespace` that is used during the deployment process is `logging`. Run the command for for each of these values of `secret-name`:

- `elasticsearch-ingress-tls-secret`
- `kibana-ingress-tls-secret`

Use the appropriate values for `tls_cert_name`, `key_name`, and `CA_key_name` for each secret that that is being generated.

2. After you have obtained the certificates for the secrets, use this command to generate the secrets:

```bash
kubectl create secret tls $SECRET_NAME -n $NAMESPACE --key $CERT_KEY --cert $CERT_FILE
```

Use `elasticsearch-ingress-tls-secret` and `kibana-ingress-tls-secret` as values for `$SECRET_NAME`. Use the name of the namespace into which the logging components 
were deployed (such as `logging`) for the value of `$NAMESPACE`.

3. In your local copy of the file 
`$USER_DIR\samples\tls\logging\user-values-elasticsearch-open.yaml`, update the 
values `kibana.logging.host.cluster.example.com` and `elasticsearch.logging.host.cluster.example.com` to reflect the namespace into which you have deployed the 
log monitoring components and the correct ingress host information.

4. If you are using an ingress controller other than NGINX, modify the annotation 
`nginx.ingress.kubernetes.io/backend-protocol: HTTPS` as needed in the `user-values-elasticsearch-open.yaml` file. Refer to the documentation for your ingress controller. 


