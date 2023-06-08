# Namespace Monitoring

This sample demonstrates how to customize a monitoring
deployment to separate cluster monitoring from SAS Viya (namespace)
monitoring.

The basic steps are the following:

* Create the monitoring namespace and label other namespaces for
cluster or SAS Viya Monitoring.
* Deploy cluster monitoring and restrict it to use only cluster dashboards.
* Deploy standard SAS Viya Monitoring to each SAS Viya namespace.
* Create Prometheus custom resources (CRs) that are configured to monitor only
their respective SAS Viya namespaces.
* Deploy Grafana to each SAS Viya namespace to provide visualization.

**Note:** All resources in this sample are configured for host-based ingress.

In this example, all three Prometheus instances share the same instance of
Alertmanager, in order to demonstrate how you can centralize alerts. You
can use Alertmanager CRs to deploy a separate Alertmanager for each instance
of Prometheus.

This sample assumes that you are deploying two SAS Viya namespaces, but you can
customize the files to deploy to any number of namespaces.

## Using This Sample

You customize your monitoring deployment by specifying values in `user.env` and
`*.yaml` files. These files are stored in a local directory outside of your
repository that is identified by the `USER_DIR` environment variable. For information about the customization process, see [Pre-deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1ajbblsxpcgl5n11t13wgtd4d7c.htm) in the SAS Viya Monitoring for Kubernetes Help Center.

The customization files in this sample provide a starting point for the
customization files for a deployment that supports namespace monitoring.

In order to use the values in this sample in the customization files for your
deployment, copy the customization files from this sample to your local
customization directory and modify the files further as needed.

If you also need to use values from another sample, manually copy the values to
your customization files after you specify the values in this sample.

## Notes on Customization Values

After you copy the customization files from this sample to a local path and set
the `USER_DIR` environment variable to the local path, follow these steps:

1. Edit the `.yaml` files that provide values for Grafana, Prometheus and the
Prometheus Operator and make the following modifications:

* Replace the host names (`*.host.cluster.example.com`) with values for your deployment.
* Replace the namespaces (`viya-one` and `viya-two`) with your namespaces.
* Customize any other value in the `.yaml` files as needed for your environment.

2. Change the directory to the base of this repository.

3. Set environment variables to the namespaces:

```bash
# First SAS Viya namespace
export VIYA_ONE_NS=viya-one
# Second SAS Viya namespace
export VIYA_TWO_NS=viya-two
```

4. Create and label the namespaces.

```bash
kubectl create ns monitoring
kubectl label ns kube-system sas.com/cluster-monitoring=true
kubectl label ns ingress-nginx sas.com/cluster-monitoring=true
kubectl label ns monitoring sas.com/cluster-monitoring=true
kubectl label ns cert-manager sas.com/cluster-monitoring=true
kubectl label ns logging sas.com/cluster-monitoring=true

kubectl label ns $VIYA_ONE_NS sas.com/viya-namespace=$VIYA_ONE_NS
kubectl label ns $VIYA_TWO_NS sas.com/viya-namespace=$VIYA_TWO_NS
```

5. Deploy cluster monitoring (including the Prometheus Operator) with a
custom user directory and no SAS Viya dashboards.

```bash
VIYA_DASH=false monitoring/bin/deploy_monitoring_cluster.sh
```

6. Deploy standard SAS Viya Monitoring components for each SAS Viya namespace.

```bash
VIYA_NS=$VIYA_ONE_NS monitoring/bin/deploy_monitoring_viya.sh
VIYA_NS=$VIYA_TWO_NS monitoring/bin/deploy_monitoring_viya.sh
```

7. Deploy Prometheus to each SAS Viya namespace.

```bash
kubectl apply -n viya-one -f $USER_DIR/monitoring/prometheus-viya-one.yaml
kubectl apply -n viya-two -f $USER_DIR/monitoring/prometheus-viya-two.yaml
```

8. Deploy Grafana to each SAS Viya namespace.

```bash
helm upgrade --install --namespace viya-one grafana-viya-one \
  -f $USER_DIR/monitoring/grafana-common-values.yaml \
  -f $USER_DIR/monitoring/grafana-viya-one-values.yaml stable/grafana
helm upgrade --install --namespace viya-two grafana-viya-two \
  -f $USER_DIR/monitoring/grafana-common-values.yaml \
  -f $USER_DIR/monitoring/grafana-viya-two-values.yaml stable/grafana
```

9. Deploy SAS Viya dashboards to each SAS Viya namespace.

```bash
DASH_NS=$VIYA_ONE_NS KUBE_DASH=false LOGGING_DASH=false monitoring/bin/deploy_dashboards.sh
DASH_NS=$VIYA_TWO_NS KUBE_DASH=false LOGGING_DASH=false monitoring/bin/deploy_dashboards.sh
```

## Example Grafana URLs

This sample produces three instances of Grafana:

* An instance that displays metrics for the entire cluster.
* An instance that displays metrics only from the `viya-one` namespace.
* An instance that displays metrics only from the `viya-two` namespace.

These are the sample URLs for the instances of Grafana. The URLs in your
deployment depend on the values that you substitute for the namespace names
and the host names.

* [Cluster Grafana - http://grafana.host.cluster.example.com](http://grafana.host.cluster.example.com)
* [Viya-one Grafana - http://grafana.viya-one.host.cluster.example.com](http://grafana.viya-one.host.cluster.example.com)
* [Viya-two Grafana - http://grafana.viya-two.host.cluster.example.com](http://grafana.viya-two.host.cluster.example.com/)

## References

* [kube-prometheus-stack Helm Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
* [Prometheus Operator Custom Resource Definitions](https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md)
* [Grafana Helm Chart](https://github.com/helm/charts/tree/master/stable/grafana)
