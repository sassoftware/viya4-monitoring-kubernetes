# Using an External AlertManager

In a typical deployment, each cluster uses a separate instance of AlertManager.
If you have multiple clusters, you might want alerts from all clusters to come
from a single instance of AlertManager. You might also have an existing
instance of AlertManager and want alerts to come from the existing instance.
Use this sample to configure monitoring to use an external instance of
AlertManager.

## Using This Sample

You customize your monitoring deployment by specifying values in `user.env` and
`*.yaml` files. These files are stored in a local directory outside of your
repository that is identified by the `USER_DIR` environment variable. See the
[monitoring README](../../monitoring/README.md#mon_custom) for information
about the customization process.

The customization files in this sample provide a starting point for the
customization files for a deployment that supports an external instance of
AlertManager.

In order to use the values in this sample in the customization files for your
deployment, copy the customization files from this sample to your local
customization directory and modify the files further as needed.

If you also need to use values from another sample, manually copy the values
to your customization files after you add the values in this sample.

1. The sample uses the value of `my-external-alertmanager` for the external
AlertManager instance. If you use a name other than `my-external-alertmanager`,
change `alertmanager-endpoint.yaml` and
`$USER_DIR/monitoring/user-values-prom-operator.yaml` to specify the name of
your AlertManager instance.

2. Define a service that points to the AlertManager instance that you want to
use.

3. Deploy monitoring using the standard deployment script:

```bash
my_repository_path/monitoring/bin/deploy_monitoring_cluster.sh
VIYA_NS=<your_viya_namespace> monitoring/bin/deploy_monitoring_viya.sh
```

4. Deploy the `alertmanager-endpoint.yaml` file to the monitoring namespace:

```bash
kubectl apply -n monitoring -f $USER_DIR/alertmanager-endpoint.yaml
```
