# Sample - TLS Enablement for Logging

## Overview

This sample demonstrates how to deploy logging components with TLS enabled for connections to Kibana.

All logging components use TLS for connections between components within the cluster.

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

* If you are using ingress, set the environment variable `TLS_ENABLED=true` in the `user.env` file in order to use TLS for connections between the user and Kibana.  

* Manually populate these secrets in the `logging` namespace (or `LOG_NS` value) **before**
you run the deployment script:

  * kubernetes.io/tls secret - `kibana-ingress-tls-secret`
  * kubernetes.io/tls secret - `elasticsearch-ingress-tls-secret`

Generating these certificates is outside the scope of this example. However, you
can use the process documented in ["Configure NGINX Ingress TLS for SAS Applications"](https://go.documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=calencryptmotion&docsetTarget=n1xdqv1sezyrahn17erzcunxwix9.htm&locale=en#n0oo2yu8440vmzn19g6xhx4kfbrq) in SAS Viya Administration documentation and specify the `logging` namespace.

If any of the required certificates do not exist, the deployment process attempts to use [cert-manager](https://cert-manager.io/) to generate the missing
certificates.

* If you are using an ingress controller other than NGINX, modify the annotation 
`nginx.ingress.kubernetes.io/backend-protocol: HTTPS` in the `user-values-elasticsearch-open.yaml` file. Refer to the documentation for your ingress controller. 

### Nodeports

If you are using nodeports,  set the environment variable `TLS_ENABLED=true` in the `user.env` file in order to use TLS for connections between the user and Kibana. 


