# Troubleshooting

## Issue: Fluent Bit Runs without Errors, but No Logs Are Produced

### Description

If you move the Docker root directory in your Kubernetes cluster, symbolic links
are created to the directory from which Fluent Bit reads log files. However, 
Fluent Bit cannot read the files in the directory, 
which are present only as links. Because Fluent Bit can see the directory, it 
does not issue an error message, but it does not process any logs to be 
displayed in Kibana.

### Solution

1. If you have not already deployed the logging components, copy the `../samples/generic-base` sample directory (including the `/logging` and `/monitoring` subdirectories) to a separate local path. Do not create the local directory before copying the sample directory.

```bash
cp samples/generic-base <my_directory> -R
```

The logging and monitoring components require this directory structure:
```bash
<my_directory>/logging
<my_directory>/monitoring
```
If you have already deployed logging, this directory and its contents should 
already be in your local path, so 
you do not need to copy the directory again. 

See the [main README](../README.md#customization) for information about the customization process.

2. Edit `<my_directory>/logging/user-values-fluent-bit-open.yaml` and uncomment these lines:

```bash
#extraVolumeMounts:
#- mountPath: /fluent-bit/etc/viya-parsers.conf
#  name: parsers-config
#  subPath: viya-parsers.conf
#- mountPath: /data01/var/lib/docker/containers
#  name: path2dockercontainers
#  readOnly: true
#extraVolumes:
#- configMap:
#    defaultMode: 420
#    name: fb-viya-parsers
#  name: parsers-config
#- hostPath:
#    path: /data01/var/lib/docker/containers
#    type: ""
#  name: path2dockercontainers
```

Add the uncommented lines if they are not present in your copy of `user-values-fluent-bit-open.yaml`.

3. Replace the `mountPath` and `hostPath: path` values with the location to 
which your Docker root directory has been mapped.

```bash
- mountPath: /<my_Docker_root_directory>/containers

...

- hostPath:
    path: /<my_Docker_root_directory>/containers
```

4. Set the `USER_DIR` environment variable to your local directory into which 
you copied the `/generic-base` sample. For example, if you copied the files from 
the `/generic_base` directory to `/home/my_directory/logging`, enter this 
command:

```bash
export USER_DIR=/home/my_directory
```

5. If you previously deployed the logging components, run the Fluent Bit deployment script to redeploy only the Fluent Bit pods:

```bash
./logging/bin/deploy_logging_fluentbit_open.sh
```

If you have not yet deployed the logging components, run the standard deployment script:

```bash
./logging/bin/deploy_logging_open.sh
```

## Issue: Manually Deleting the Logging Namespace Does Not Delete All Components 

### Description

The logging components should be removed by using the `remove_logging_open.sh` script. See [Remove Logging Components](README.md#lremove) for more information. If you attempt to remove the logging components by only deleting the namespace into which the components are deployed, components in other locations are not removed and redeployment of logging fails.

### Solution

Run this command to delete all of the logging components that are in locations 
other than the logging namespace.

```bash
kubectl delete psp v4m-es-psp
```

## Issue: Deployment Does Not Complete If the Deployment Machine Cannot Reach Kibana

### Description

The deployment fails during the "Configuring Kibana" step of the process with 
messages similar to the following:

```
INFO STEP 4: Configuring Kibana
INFO Configuring Kibana
INFO The Kibana pod is ready...continuing
INFO The Kibana REST endpoint does not appear to be quite ready [000]; sleeping for [30] more seconds before checking again.
INFO The Kibana REST endpoint does not appear to be quite ready [000]; sleeping for [30] more seconds before checking again.
INFO The Kibana REST endpoint does not appear to be quite ready [000]; sleeping for [30] more seconds before checking again.
The Kibana REST endpoint has NOT become accessible in the expected time; exiting.
Review the Kibana pod's events and log to identify the issue and resolve it before trying again.
```

This happens when Kibana cannot be accessed from the machine on which the deployment process is running via the same
URL your end-users will be using.  This might the case if your environment has been configured to allow access only via
a private network inaccessible to the deployment machine.  In these situations, setting the `LOG_ALWAYS_PORT_FORWARD` 
property to `true` forces the deployment scripts to use Kubernetes port-forwarding when accessing the Kibana and/or 
Elasticsearch APIs rather than the end-user URLs.

### Solution

Set the `LOG_ALWAYS_PORT_FORWARD` environment variable to `true` before (re-)running the deployment script.  This should be done 
by modifying (or adding) the appropriate line in the `$USER_DIR/logging/user.env` file.  See the [main README](../README.md#customization) 
for information about the customization process and how to set up a USER_DIR.

## Issue: Log Messages Require More Storage

### Description

You might need to increase storage in the following situations:

* The persistent volume claims (PVCs) associated with the Elasticsearch nodes 
(pods) that are used for storage (that is, the nodes with a role of "data") are 
running low on space. 
* You are considering an increase to how long log messages are retained. 
Longer retention periods require more storage.
 
**Tip:** In the default configuration, these pods have names that start with 
"v4m-es-data-*". 

### Solution

**Note:** Some Kubernetes storageClass resources do not support expansion. To 
determine whether the storageClass resources used by the Elasticsearch data node 
PVCs support expansion, enter the following command: 

`kubectl describe storageClass default` 

* Where ***storageClass*** is the name of your specific storageClass.
* Where ***default*** is the name of the storageClass that is used for the PVCs 
that you are checking.  
  
If the `AllowVolumeExpansion` property is `True`, the expansion of existing PVCs 
is supported and the following procedure should work.

To increase storage, complete the following steps:

1. Scale down the statefulSet that controls the Elasticsearch data nodes by 
entering the following command:
   
    `kubectl -n logging scale statefulset v4m-es-data --replicas=0`

   * Where ***logging*** is the namespace into which the log-monitoring 
   components have been deployed in your installation.
   * This command terminates the existing v4m-es-data-* pods.
   * In some cases, it might be necessary to wait a few minutes until the 
   PVCs are detached from the underlying Kubernetes nodes.  Be patient. 
   Resizing the PVC fails if the PVCs are still attached.

2. Resize the existing PVCs by entering the following command (all on one line):
   
   `kubectl -n logging patch pvc data_node -p '{"spec":{"resources":{"requests":{"storage":"xxGi"}}}}'`
   * Where ***logging*** is the namespace into which the log-monitoring 
   components have been deployed in your installation.
   * Where ***data_node*** is the Elasticsearch data node (pod) to resize 
   (for example, data-v4m-es-data-0).
   * Where ***nnGi*** is the amount (for example, 70Gi) to increase the PVC 
   storage.
   * Repeat this command for each of the three Elasticsearch data nodes (that 
   is, data-v4m-es-data-0, data-v4m-es-data-1, and data-v4m-es-data-2).

3. Scale up the statefulSet that controls the Elasticsearch data nodes by 
entering the following command:
  
    `kubectl -n logging scale statefulset v4m-es-data --replicas=3`
   * Where ***logging*** is the namespace into which the log-monitoring 
   components have been deployed in your installation.
   * This command results in the creation of three new v4m-es-data-* pods that 
   are linked to the existing (but now larger) PVCs.

If you are maintaining customized configuration information (that is, using the 
USER_DIR functionality), consider updating the contents of the 
`logging/user-values-elasticsearch.yaml` file to reflect the larger PVC size. Doing 
so ensures that your updated configuration is re-created if you redeploy 
the log-monitoring components. 

**Note:** This procedure adjusts only the size of the existing PVCs and does not 
change the PVC specification included in the statefulSet definition.  If you 
scale up the statefulSet to increase the number of Elasticsearch data nodes beyond 
the existing three pods, the new pods are linked to PVCs using the original 
size. At that point, you must repeat this procedure to increase the size of the 
PVCs linked to the new pod.
