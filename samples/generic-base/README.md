# Generic Base

This sample contains all of the files that can be customized as part of the
monitoring and logging deployments. See the comments in each file for
reference links and variable listings.

## Using This Sample

You customize your deployment by specifying values in `user.env` and `*.yaml`
files. These files are stored in a local directory outside of your
repository that is identified by the `USER_DIR` environment variable. See the
[monitoring README](../../monitoring/README.md#mon_custom) or the
[logging README](../../logging/README.md#log_custom) for information about the
customization process.

The customization files in this sample provide a starting point for
customization if your environment does not match any of the specialized
samples.

In order to use the values in this sample in the customization files for your
deployment, copy the customization files from this sample to your local
customization directory and modify the files further as needed.

If you need to use values from another sample, manually copy the values to
your customization files after you add the values in this sample.

After you finish modifying the customization files, deploy monitoring and
logging using the standard deployment scripts:

```bash
my_repository_path/monitoring/bin/deploy_monitoring_cluster.sh
```

```bash
my_repository_path/logging/bin/deploy_logging_open.sh
```

## Grafana Dashboards

In addition to customizing the deployment, you can also use this sample to add
your own Grafana dashboards. See the [dashboard README](monitoring/dashboards/README.md)
for details about supplying additional Grafana dashboards that will be deployed
(and removed) with the monitoring components.
