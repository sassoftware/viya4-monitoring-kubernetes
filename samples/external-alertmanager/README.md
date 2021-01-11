# Using an External Alertmanager

In a typical deployment, each cluster uses a separate instance of Alertmanager. If you have multiple clusters, you might want alerts from all clusters to come from a single instance of Alertmanager. You might also have an existing instance of Alertmanager and want alerts to come from the existing instance. Use this sample to configure monitoring to use an external instance of Alertmanager.

## Using This Sample

You customize your monitoring deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. The configuration files in this sample provide a starting point for the configuration files for a deployment that supports an external instance of Alertmanager. See the 
[main README](../../README.md#customization) to for information about the customization process.

If you also need to use values from another sample, manually copy the values to your configuration files after you add the values in this sample. 

1. Deploy monitoring using the standard deployment script:

```bash
/my_repository_path/monitoring/bin/deploy_monitoring_cluster.sh
VIYA_NS=<your_viya_namespace> monitoring/bin/deploy_monitoring_viya.sh
```

2. Define a service that points to the Alertmanager instance that you want to use.

3. Edit `alertmanager-endpoint.yaml` to point to the existing Alertmanager
instance. 

4. Deploy the `yaml` file to the monitoring namespace:

```bash
kubectl apply -n monitoring -f $USER_DIR/alertmanager-endpoint.yaml
```

5. If you changed the service name `my-alertmanager`, make the same change
to your copy of `user-values-prom-operator.yaml`.



