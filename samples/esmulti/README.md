# Multi-purpose Elasticsearch Nodes

This sample demonstrates how to deploy Elasticsearch with its nodes performing all three roles: master, data and
client/ingest rather than using the differentiated (single-role) configuration we are currently using.  While
multi-role Elasticsearch nodes are widely used, they are not natively supported by the Open Distro for Elasticsearch
Helm chart we use as part of our deployment.  This means we have to patch various Kubernetes objects during the
deployment process to enable them. We are still are still evaluating things, including performance, before making them
part of our default configuration.

## Preparation for Deployment

1. Copy this sample directory (including sub-directories) to a separate local path.

See the [main README](../../README.md#customization) for information about the customization process.

2. Set the `USER_DIR` environment variable to the local path:

```bash
export USER_DIR=/path/to/my/copy/esmulti
```

3. To enable multi-purpose Elasticsearch nodes, the `ES_MULTIPURPOSE_NODES` environment variable has
been set to `true` in the `$USER_DIR/logging/user.env` file.


4. Review the contents of the `$USER_DIR/logging/user-values-elasticsearch-open.yaml` file and make any
adjustments necessary. Information on some possible things that you may want to adjust are described in the ***'Things to Consider'*** section below below.

5. Deploy logging using the standard deployment script:

```bash
/path/to/this/repo/logging/bin/deploy_logging_open.sh
```
## Things to Consider

### Storage
* When "master" nodes are also serving as "data" nodes they will need more disk space than needed when they are only serving as "master" nodes.  The master.persistence.size property in the user-values-elasticsearch-open.yaml mentioned above
can be used to control how much storage is assigned to the master nodes.  You should review the setting and adjust it as necessary.

### Deploying additional "Data" and/or "Client" nodes

* When multi-purpose Elasticsearch nodes are used, there is generally no reason to deploy additional nodes performing only a single capability.  However, if that is necessary for your particular use-case it is possible to adjust the configuration to do so.
  * If adding "data" nodes, uncomment the data stanza in the user values yaml file and update the replicas value to specify the number of _additional_ data nodes needed.  Remember that the master nodes will continue to serve as data nodes as well.
  * If adding "client" nodes, uncomment the client stanza in the user values yaml file and update the replicas value to specify the number of _additional_ *client* nodes needed.  Remember that the master nodes will continue to serve as client nodes as well.

* This sample deploys "master" nodes and updates them to also take on the "data" and "client" roles.  While it is possible to add additional single-purpose "data" and "client" nodes (as discussed above), it is not possible to add additional single-purpose "master" nodes.  Deploying nodes with other combinations of roles  is also not supported.

