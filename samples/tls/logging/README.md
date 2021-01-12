# Sample - TLS Enablement for Logging

## Overview

This sample demonstrates how to deploy logging components with TLS enabled.
For now, only ingress is covered. In-cluster TLS will be supported in the
future.

All components have TLS enabled on ingress. Due to limitations in the
underlying Helm charts, some components might not have TLS enabled in-cluster.

If you use this sample for HTTPS for ingress, the following secrets must be
manually populated in the `logging` namespace (or `LOG_NS` value) **BEFORE**
you run any of the scripts in this repository:

* kubernetes.io/tls secret - `kibana-ingress-tls-secret`
* kubernetes.io/tls secret - `elasticsearch-ingress-tls-secret`

Generating these certificates is outside the scope of this example. However, you
can use the process documented in ["Configure NGINX Ingress TLS for SAS Applications"](https://go.documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=calencryptmotion&docsetTarget=n1xdqv1sezyrahn17erzcunxwix9.htm&locale=en#n0oo2yu8440vmzn19g6xhx4kfbrq) in SAS Viya Administration documentation and specify the `logging` namespace.

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

Set `MON_TLS_ENABLE=true` in the `$USER_DIR/logging/user.env` file. This variable modifies the deployment of Open Distro for Elasticsearch to be TLS-enabled.

Edit `$USER_DIR/logging/user-values-elasticsearch-open.yaml` and replace
any sample hostnames with hostnames for your deployment. Specifically, you must replace
`host.cluster.example.com` with the name of the ingress node. Often, the ingress node is the cluster master node, but your environment might be different.

