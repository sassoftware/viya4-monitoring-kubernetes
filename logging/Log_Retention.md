# Log Retention

These are the default log retention periods:
  - Messages from SAS Viya and from other Kubernetes pods on the cluster are retained for three days.
  - Messages from logging components are retained for one day.

If you want to change either of these retention periods, follow these steps:

  1. If you have not already set up your `USER_DIR` directory (as discussed in the 'Customize the Deployment' section of the [README.md](README.md) file in the `/logging` directory), set up an empty directory with a `logging` subdirectory to contain the customization files. Export a `USER_DIR` environment variable that points to this location. For example:

  ```bash
  mkdir -p ~/my-cluster-files/ops/user-dir/logging
  export USER_DIR=~/my-cluster-files/ops/user-dir
  ```
  2. Modify the file `$USER_DIR\logging\user.env`.
     - To change the retention period for messages from SAS Viya and Kubernetes pods on the cluster, change the value of the environment variable `LOG_RETENTION_PERIOD`.
     - To change the retention period for messages from logging components, change the value of the environment variable `OPS_LOG_RETENTION_PERIOD`. 

  3. Save the `user.env` file and run the `deploy_logging_open.sh` script to redeploy the logging components.

  # Index Policies and the Index State Management plug-in

  Log retention processing is implemented through the use of index policies, a feature of the Index State Management plug-in to the Open Distro for Elasticsearch.  The two index management policies defined are identical other than the retention period.  For each policy, an incoming message is loaded into memory and placed in the "hot' state, which makes it available to be searched. After the retention period has passed for the message, the message is set to the "doomed" state, which deletes it from memory and prevents it from being found by searching.

  These actions and retention periods are defined by these index management policies:
  - SAS Viya and Kubernetes pods: `/logging/es/odfe/es_viya_logs_idxmgmt_policy.json`
  - Logging components: `/logging/es/odfe/es_viya_logs_idxmgmt_policy.json`

You can modify these policies or create your own. For information about index management, see [Index State Management](https://opendistro.github.io/for-elasticsearch-docs/docs/ism/) in the Open Distro for Elasticsearch documentation.

