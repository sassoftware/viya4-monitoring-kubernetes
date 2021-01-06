# Ingress

This sample demonstrates how to deploy monitoring and logging components
configured with ingress instead of node ports. You can choose to use host-based routing or path-based routing. Use host-based routing if the monitoring applications (Prometheus, Alertmanager, and Grafana) will be on different hosts. Use path-based routing if the applications use different paths on the same host.

If you are using a cloud provider, you must deploy using ingress.

## Using This Sample

You customize your deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. The configuration files in this sample provide a starting point for the configuration files for a deployment that supports ingress instead of node ports. See the 
[main README](../../README.md#customization) to for information about the customization process.

In order to use the values in this sample in the customization files for your deployment, copy the configuration files from this sample to your local configuration directory, then modify the files further as needed.
If you also need to use values from another sample, manually copy the values to your configuration files after you add the values in this sample. 

After you finish modifying the configuration files, deploy monitoring and logging using the standard deployment scripts:

```bash
/path/to/this/repo/monitoring/bin/deploy_monitoring_cluster.sh
```

```bash
/my_repository_path/logging/bin/deploy_logging_open.sh
```

## Notes On Configuration Values

To enable TLS, edit `$USER_DIR/user.env` and set `TLS_ENABLED` to `true`

### Monitoring 

The monitoring deployment process requires that the user response file be
named `$USER_DIR/monitoring/user-values-prom-operator.yaml`.

  - If you are using host-based routing, rename the
`user-values-prom-host.yaml` to `user-values-prom-operator.yaml`. 

  - If you are using path-based routing, rename the `user-values-prom-path.yaml` to `user-values-prom-operator.yaml`.

Edit `$USER_DIR/monitoring/user-values-prom-operator.yaml` and replace
all instances of `host.cluster.example.com` with hostnames that match your cluster.

### Logging

The logging deployment process requires that the user response file be
named `$USER_DIR/logging/user-values-elasticsearch-open.yaml`.

  - If you are using host-based routing, rename the
`user-values-elasticsearch-host.yaml` to `user-values-elasticsearch-open.yaml`. 

  - If you are using path-based routing, rename the `user-values-elasticsearch-path.yaml` to `user-values-elasticsearch-open.yaml`.

Edit `$USER_DIR/logging/user-values-elasticsearch-open.yaml` and replace
all instances of `host.cluster.example.com` with hostnames that match your cluster

## Access the Applications

If you deploy using host-based ingress, the applications are available at these
locations (with hostnames replaced with those in the actual environment that you specified):

* Grafana - `https://grafana.host.mycluster.example.com`
* Prometheus - `https://prometheus.host.mycluster.example.com`
* Alertmanager - `https://alertmanager.host.mycluster.example.com`
* Kibana - `https://kibana.host.mycluster.example.com`

If you deploy using path-based ingress, the applications are available at these
locations (with hostnames replaced with those in the actual environment that you specified):

* Grafana - `http://host.mycluster.example.com/grafana`
* Prometheus - `http://host.mycluster.example.com/prometheus`
* Alertmanager - `http://host.mycluster.example.com/alertManager`
* Kibana - `http://host.mycluster.example.com/kibana`


