# Multi-Role Elasticsearch Nodes

This sample demonstrates how to deploy Elasticsearch so that each of its nodes perform all three roles: primary (also known as master), data and
client/ingest. The sample deploys the nodes as primary nodes and updates them to include the data and client roles. In a standard configuration, each role is performed be a separate node. 

Although multi-role Elasticsearch nodes are widely used, they are not natively supported by the Open Distro for Elasticsearch
Helm chart that is used to deploy the logging components. In order to enable multi-role Elasticsearch nodes, the deployment process must patch various Kubernetes objects. Because performance and other criteria are being evaluated, this process is experimental and is not yet an option in the standard configuration.

## Preparation and Deployment

1. Copy the `../samples/esmulti` sample directory (including sub-directories) to a separate local path.

See the [main README](../../README.md#customization) for information about the customization process.

2. Set the `USER_DIR` environment variable to the local path:

```bash
export USER_DIR=/path/to/my/copy/esmulti
```

3. Note that the `ES_MULTIPURPOSE_NODES` environment variable has
been set to `true` in the `$USER_DIR/logging/user.env` file in order to enable multi-role Elasticsearch nodes.


4. Review the contents of the `$USER_DIR/logging/user-values-elasticsearch-open.yaml` file and make any changes needed for your environment. These are two areas that could be customized:

 **Storage:** When primary nodes also serve as data nodes, they need more disk space than when they serve only as primary nodes.  The `master.persistence.size` property specifies the amount of storage that is assigned to the primary nodes. Review this setting and adjust it as necessary. 

 **Additional data or client nodes:** If you are using multi-role Elasticsearch nodes, you usually do not need to deploy additional nodes that perform only a data or client role. However, if additional nodes are required for your scenario, make these changes:
   - To add data nodes, uncomment the `data` stanza and update the `replicas` value to specify the number of _additional_ data nodes needed. When determining the total number of data nodes needed, remember that all of the primary nodes also continue to serve as data nodes.
   - To add client nodes, uncomment the `client` stanza and update the `replicas` value to specify the number of _additional_ client nodes needed. When determining the totla number of client nodes needed, remember that all of the primary nodes also continue to serve as client nodes.

 Note that you cannot add additional nodes that perform only the primary role. You also cannot deploy nodes that use different combinations of roles 

5. Deploy logging using the standard deployment script:

```bash
/path/to/this/repo/logging/bin/deploy_logging_open.sh
```


