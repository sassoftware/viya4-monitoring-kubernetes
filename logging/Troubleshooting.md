# Troubleshooting

## Issue: Fluent Bit runs without errors, but no logs are produced

### Description
If you move the Docker root directory in your Kubernetes cluster, symbolic links are created to the 
directory from which Fluent Bit reads log files. However, Fluent Bit cannot read the files in the directory, 
which are present only as links. Because Fluent Bit can see the directory, it does not issue an error 
message, but it does not process any logs to be displayed in Kibana.

### Solution
1. If you have not already deployed the logging components, copy the `../samples/generic-base` sample directory (including the `/logging` and `/monitoring` sub-directories) to a separate local path. Do not create the local directory before copying the sample directory.
```bash
cp samples/generic-base <my_directory> -R
```

The logging and monitoring components require this directory structure:
```bash
<my_directory>/logging
<my_directory>/monitoring
```
If you have already deployed logging, this directory and its contents should already be in your local path, so 
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

3. Replace the `mountPath` and `hostPath: path` values with the location to which your Docker root directory has been mapped.
```bash
- mountPath: /<my_Docker_root_directory>/containers

...

- hostPath:
    path: /<my_Docker_root_directory>/containers
```

4. Set the `USER_DIR` environment variable to your local directory into which you copied the `/generic-base` sample. For example, if you copied the files from the `/generic_base` directory to `/home/my_directory/logging`, you would issue this command:

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

## Issue: Manually deleting the logging namespace does not delete all components 

### Description
The logging components should be removed by using the `remove_logging_open.sh` script. See [Remove Logging Components](README.md#lremove) for more information. If you attempt to remove the logging components by only deleting the namespace into which the components are deployed, components in other locations are not removed and redeployment of logging fails.

### Solution
Run this command to delete all of the logging components that are in locations 
other than the logging namespace.

```bash
kubectl delete psp v4m-es-psp
```

## Issue: Deployment does not complete if Elastisearch/Kibana is not reachable from the deployment machine

### Description
The deployment scripts fails during the "Configuring Kibana" step of the process with messages like the following:
```
INFO STEP 4: Configuring Kibana
INFO Configuring Kibana
INFO The Kibana pod is ready...continuing
INFO The Kibana REST endpoint does not appear to be quite ready [000]; sleeping for [30] more seconds before checking again.
INFO The Kibana REST endpoint does not appear to be quite ready [000]; sleeping for [30] more seconds before checking again.
INFO The Kibana REST endpoint does not appear to be quite ready [000]; sleeping for [30] more seconds before checking again.
```
This happens when Kibana cannot be accessed from the machine on which the deployment process is running via the same
URL your end-users will be using.  This might the case if your environment has been configured to only allow access via
a private network inaccessable to the deployment machine.  In these situations, setting the LOG_ALWAYS_PORT_FORWARD 
property to "true" will force the deployment scripts to use Kubernetes port-forwarding when accessing the Kibana and/or 
Elasticsearch APIs rather than the end-user URLs.

### Solution
Set the LOG_ALWAYS_PORT_FORWARD environment variable to "true" before (re-)running the deployment script.  
This should be done by modifying (or adding) the appropriate line in the $USER_DIR/logging/user.env file.  
See the [main README](../README.md#customization) for information about the customization process and 
how to set up a USER_DIR.
