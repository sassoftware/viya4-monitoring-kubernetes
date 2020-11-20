# Troubleshooting

## Issue: Fluent Bit runs without errors, but no logs are produced

### Description
If you move the Docker root directory in your Kubernetes cluster, symbolic links are created to the 
directory from which Fluent Bit reads log files. However, Fluent Bit cannot read the files in the directory, 
which are present only as links. Because Fluent Bit can see the directory, it does not issue an error 
message, but it does not process any logs to be displayed in Kibana.

### Solution
1. Copy the `../samples/generic-base` sample directory (including sub-directories) to a separate local path.

See the [main README](../../README.md#customization) for information about the customization process.

2. Set the `USER_DIR` environment variable to the local path:

```bash
export USER_DIR=/path/to/my/copy/generic-base
```

3. Edit `$USER_DIR/logging/user-values-fluent-bit-open.yaml` and uncomment these lines:
```bash
#extraVolumeMounts:
#- mountPath: /fluent-bit/etc/viya-parsers.conf
#  name: parsers-config
#  subPath: viya-parsers.conf
#- mountPath: /data01/var/lib/docker/containers
#  name: data01containers
#  readOnly: true
#extraVolumes:
#- configMap:
#    defaultMode: 420
#    name: fb-viya-parsers
#  name: parsers-config
#- hostPath:
#    path: /data01/var/lib/docker/containers
#    type: ""
#  name: data01containers
```
4. Replace the `mountPath` and `hostPath: path` values with the location to which your Docker root directory has been mapped.
```bash
- mountPath: /<my_Docker_root_directory>/containers

...

- hostPath:
    path: /<my_Docker_root_directory>/containers
```
5. Redeploy the Fluent Bit pods to pick up the change by running the Fluent Bit deployment script:

```bash
/path/to/this/repo/logging/bin/deploy_logging_fluentbit_open.sh
```