# Sample - TLS Enablement for Logging

## Overview

This sample demonstrates how to deploy logging components with TLS enabled.

All communication within the cluster between the logging components takes place through TLS-enabled connections.

The `TLS_ENABLE` environment variable controls whether connections from the user to Kibana use TLS.

## Using This Sample

You customize your logging deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. See the 
[main README](../../README.md#customization) to for information about the customization process.

The customization files in this sample provide a starting point for the customization files for a deployment that supports logging with TLS enabled. 

In order to use the values in this sample in the customization files for your deployment, copy the customization files from this sample to your local customization directory, then modify the files further as needed.

If you also need to use values from another sample, manually copy the values to your customization files after you add the values in this sample. 

After you finish modifying the customization files, deploy logging using the standard deployment script:

```bash
my_repository_path/logging/bin/deploy_logging_open.sh
```
## Notes On Customization Values

### TLS 

Specify `TLS_ENABLE=true` in the `user.env` file to use TLS for communications between the ingress object and Kibana. Connections between the ingress object and Elasticsearch always use TLS, regardless of the value of `TLS_ENABLE`.

### Ingress

* Manually populate these TLS secrets for ingress in the `logging` namespace (or `LOG_NS` value) **before** you run the deployment script.

* `kibana-ingress-tls-secret`
* `elasticsearch-ingress-tls-secret`

After you have obtained the certificates for the secrets, use this command to generate the secrets:

```bash
kubectl create secret tls "$SECRET_NAME" -n "$NAMESPACE" --key "$CERT_KEY" --cert "$CERT_FILE"
```

Use `kibana-ingress-tls-secret` and `elasticsearch-ingress-tls-secret` as values for `$SECRET_NAME`.

The process of generating the certificates for these secrets is out of scope for this example.

* If you are using an ingress controller other than NGINX, modify the annotation 
`nginx.ingress.kubernetes.io/backend-protocol: HTTPS` as needed in the `user-values-elasticsearch-open.yaml` file. Refer to the documentation for your ingress controller. 

### Secrets for In-Cluster TLS

The standard deployment script for the logging components use these TLS secrets for the TLS certificates that handle interactions between components:

* `es-rest-tls-secret`
* `es-transport-tls-secret`
* `kibana-tls-secret`

By default, the deployment process uses [cert-manager](https://cert-manager.io/) to generate the certificates. If cert-manager is not available, you can manually generate the certificates. If the required certificates do not exist and cert-manager is not available, the deployment process fails. cert-manager is not required if TLS is disabled or if all of the TLS secrets exist prior to deployment.

