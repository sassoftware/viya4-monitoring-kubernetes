# Log Retention

These are the default log retention periods:
  - Messages from SAS Viya and from other Kubernetes pods on the cluster are retained for three days.
  - Messages from logging components are retained for one day.

After the retention period has passed for a message, the message is deleted and can no longer be found by searching.

If you want to change either of these retention periods, follow these steps:

  1. If you have not already set up your `USER_DIR` directory (as discussed in the 'Customize the Deployment' section of the README.md file in the /logging directory), set up an empty directory with a `logging` subdirectory to contain the customization files. Export a `USER_DIR` environment variable that points to this location. For example:

  ```bash
  mkdir -p ~/my-cluster-files/ops/user-dir/logging
  export USER_DIR=~/my-cluster-files/ops/user-dir
  ```
  2. Modify the file `$USER_DIR\logging\user.env`.
     - To change the retention period for messages from SAS Viya and Kubernetes pods on the cluster, change the value of the environment variable `LOG_RETENTION_PERIOD`.
     - To change the retention period for messages from logging components, change the value of the environment variable `OPS_LOG_RETENTION_PERIOD`. 
