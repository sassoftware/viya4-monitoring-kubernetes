# Using an External AlertManager

In some scenarios, it may be desirable to configure a single AlertManager
instance - either for multiple clusters or to simply connect with existing
infrastructure.

## Installation

Copy this directory to a separate local path then set the `USER_DIR`
environment variable to this path:

```bash
export USER_DIR=/your/path/to/external-alertmanager
```

Next, define a service that points to the AlertManager instance to use.
Edit `alertmanager-endpoint.yaml` to point to the existing AlertManager
instance, then deploy it to the monitoring namespace.

```bash
kubectl apply -n monitoring -f $USER_DIR/alertmanager-endpoint.yaml
```

If the service name `my-alertmanager` was changed, make the same change
to your copy of `user-values-prom-operator.yaml`.

Deploy monitoring:

```bash
monitoring/bin/deploy_monitoring_cluster.sh
```
