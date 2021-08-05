# Sample - TLS Enablement for Logging

## Overview

TLS enablement for SAS Viya logging is divided into two parts:

- **TLS for in-cluster communications**, which is between logging components within
the cluster (between the Elasticsearch nodes and between Elasticsearch and other logging components). TLS must be enabled on these connections.

- **TLS for communications into the cluster**, which is between a user's 
browser and Kibana. TLS is optional on these connections, although enabling
TLS is a best practice.

This sample demonstrates only how to enable TLS for communications into the 
cluster by deploying logging with TLS enabled for connections between the 
user and Kibana. The `TLS_ENABLE` environment variable controls whether 
connections to Kibana use TLS.

In-cluster communications must always take place through TLS-enabled connections. TLS for in-cluster communications is configured using a separate process, 
either automatically (using cert-manager) or manually. See [Notes_on_using_TLS](../../../logging/Notes_on_using_TLS.md) for information about configuring TLS for 
in-cluster communications.


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
## Notes On Customization Values

Specify `TLS_ENABLE=true` in the `user.env` file to require TLS for connections to Kibana. Connections to Elasticsearch (when enabled) always use TLS, regardless of the value of `TLS_ENABLE`.



