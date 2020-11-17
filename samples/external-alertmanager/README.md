# Using an External Alertmanager

In a typical deployment, each cluster uses a separate instance of Alertmanager. If you have multiple clusters, you might want alerts from all clusters to come from a single instance of Alertmanager. You might also have an existing instance of Alertmanager and want alerts to come from the existing instance. Use this sample to configure monitoring to use an external instance of Alertmanager.

## Installation

Follow these steps:

1. Copy the directory in the sample to a separate local path.

2. Set the `USER_DIR` environment variable to the local path:

```bash
export USER_DIR=/your/path/to/external-alertmanager
```

3. Define a service that points to the Alertmanager instance that you want to use.

4. Edit `alertmanager-endpoint.yaml` to point to the existing Alertmanager
instance, then deploy the yaml file to the monitoring namespace:

```bash
kubectl apply -n monitoring -f $USER_DIR/alertmanager-endpoint.yaml
```

5. If you changed the service name `my-alertmanager`, make the same change
to your copy of `user-values-prom-operator.yaml`.

6. Deploy monitoring using the standard deployment script:

```bash
monitoring/bin/deploy_monitoring_cluster.sh
```
