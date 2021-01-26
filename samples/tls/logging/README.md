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

### Ingress

* If you are using ingress, specify `TLS_ENABLED=true` in the `user.env` file to use TLS for communications between the ingress object and Kibana. Connections between the ingress object and Elasticsearch always use TLS, regardless of the value of `TLS_ENABLED`.

* Manually populate these secrets in the `logging` namespace (or `LOG_NS` value) **before**
you run the deployment script:

  * kubernetes.io/tls secret - `kibana-ingress-tls-secret`
  * kubernetes.io/tls secret - `elasticsearch-ingress-tls-secret`

Use cert-manager, if available, to create these certificates. If cert-manager is not available, you must create the certificates manually by using the `kubectl -n logging create secret` command.

* If you are using an ingress controller other than NGINX, modify the annotation 
`nginx.ingress.kubernetes.io/backend-protocol: HTTPS` as needed in the `user-values-elasticsearch-open.yaml` file. Refer to the documentation for your ingress controller. 

### Nodeports

* If you are using nodeports, set the environment variable `TLS_ENABLED=true` in the `user.env` file to use TLS for connections between the user and Kibana.

* If users need to directly connect to Elasticsearch, you must run the `es_enable_nodeport.sh` script to enable the connection. Direct connections to Elasticsearch always use TLS, regardless of the value of the `TLS_ENABLED` variable.

### Secrets for In-Cluster TLS

The standard deployment script for the logging components use these secrets for the TLS certificates that
handle interactions between components:

* kubernetes.io/tls secret - `es-rest-tls-secret`
* kubernetes.io/tls secret - `es-transport-tls-secret`
* kubernetes.io/tls secret - `kibana-tls-secret`

By default, the deployment process uses [cert-manager](https://cert-manager.io/) to generate the certificates. If cert-manager is not available, you can manually generate the certificates using the process in [Notes on Using TLS](../../logging/NOTES_ON_USING_TLS.md). If the required certificates do not exist and cert-manager is not available, the deployment process fails. cert-manager is not required
if TLS is disabled or if all of the TLS secrets exist prior to deployment.

