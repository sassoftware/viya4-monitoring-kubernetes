# Multi-Role Elasticsearch Nodes

This sample demonstrates how to deploy Elasticsearch so that each of its nodes
perform all three roles: primary (also known as master), data and
client/ingest. The sample deploys the nodes as primary (master) nodes and
updates them to include the data and client roles. While it is possible to
deploy additional data and client nodes, these additional nodes cannot be made
multi-role; this sample only supports enabling multi-role for primary nodes.
In the standard configuration of this project, each node performs a single role.

Although multi-role Elasticsearch nodes are widely used, they are not natively
supported by the Open Distro for Elasticsearch Helm chart that is used to
deploy the logging components of this project. In order to enable multi-role
Elasticsearch nodes, the deployment process must patch various Kubernetes
objects. Because performance and other criteria are still being evaluated,
this use of multi-role nodes is experimental and is not yet part of our
standard configuration.

## Using This Sample

You customize your logging deployment by specifying values in `user.env` and
`*.yaml` files. These files are stored in a local directory outside of your
repository that is identified by the `USER_DIR` environment variable. See the
[logging README](../../logging/README.md#log_custom) to for information about
the customization process.

The customization files in this sample provide a starting point for the
customization files for a deployment that supports multi-role Elasticsearch nodes.

In order to use the values in this sample in the customization files for your
deployment, copy the customization files from this sample to your local
customization directory, then modify the files further as needed.

If you also need to use values from another sample, manually copy the values to
your customization files after you add the values in this sample.

After you finish modifying the customization files, deploy logging using the
standard deployment script:

```bash
my_repository_path/logging/bin/deploy_logging_open.sh
```

## Notes On Customization Values

The `ES_MULTIROLE_NODES` environment variable is set to `true` in the
`user.env` file in order to enable multi-role Elasticsearch nodes.

You must review the contents of the `user-values-elasticsearch-open.yaml` file
and make any changes needed for your environment. These are two areas that you
could customize:

 **Storage:** When primary nodes also serve as data nodes, they need more disk
 space than when they serve only as primary nodes.  The
 `master.persistence.size` property specifies the amount of storage that is
 assigned to the primary nodes. Review this setting and adjust it as necessary.

 **Additional data or client nodes:** If you are using multi-role Elasticsearch
 nodes, you usually do not need to deploy additional nodes that perform only a
 data or client role. However, if additional nodes are required for your
 scenario, make these changes:

- To add data nodes, update the `replicas` value in the `data` stanza to
  specify the number of _additional_ data nodes needed. When determining the
  total number of data nodes needed, remember that all of the primary nodes
  also continue to serve as data nodes.
- To add client nodes, update the `replicas` value in the `client` stanza to
specify the number of _additional_ client nodes needed. When determining the
total number of client nodes needed, remember that all of the primary nodes
also continue to serve as client nodes.

Note that you cannot add additional nodes that perform only the primary role.
You also cannot deploy nodes that perform different combinations of roles.
