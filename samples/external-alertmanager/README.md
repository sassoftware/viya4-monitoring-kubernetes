# Using an External Alertmanager

In a typical deployment, each cluster uses a separate instance of Alertmanager. If you have multiple clusters, you might want alerts from all clusters to come from a single instance of Alertmanager. You might also have an existing instance of Alertmanager and want alerts to come from the existing instance. Use this sample to configure monitoring to use an external instance of Alertmanager.

## Using This Sample

You customize your monitoring deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. The configuration files in this sample provide a starting point for the configuration files for a deployment that supports an external instance of Alertmanager. See the 
[main README](../../README.md#customization) to for information about the customization process.

If you also need to use values from another sample, manually copy the values to your configuration files after you add the values in this sample. 

1. The sample uses the value of `my-alertmanager` for the external Alertmanager instance. If you use a name other than `my-alertmanager`, change `alertmanager-endpoint.yaml` and `$USER_DIR/monitoring/user-values-prom-operator.yaml` to specify the name of your Alertmanager instance.

2. Define a service that points to the Alertmanager instance that you want to use.

3. Deploy monitoring using the standard deployment script:

```bash
/my_repository_path/monitoring/bin/deploy_monitoring_cluster.sh
VIYA_NS=<your_viya_namespace> monitoring/bin/deploy_monitoring_viya.sh
``` 

4. Deploy the `alertmanager-endpoint.yaml` file to the monitoring namespace:

```bash
kubectl apply -n monitoring -f $USER_DIR/alertmanager-endpoint.yaml
```




