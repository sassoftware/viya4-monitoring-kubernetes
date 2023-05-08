# SAS Viya Platform Metric Monitoring on OpenShift

## Red Hat OpenShift

See [Monitoring on Red Hat OpenShift](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1o8xyp2vatupan1nhgknbzhp7tm.htm) in the SAS Viya Monitoring for Kubernetes Help Center.

## Azure Red Hat OpenShift (EXPERIMENTAL)

On Azure Red Hat OpenShift, it is necessary to manually enable user workload
monitoring. This can be done before or after following the OpenShift
instructions above.

To manually enable user workload monitoring, add the following line to the
`cluster-monitoring-config` configmap in the `openshift-monitoring` namespace
under `config.yaml`:

```plaintext
enableUserWorkload: true
```

The `data:` section might look something like this after editing:

```yaml
data:
  config.yaml: |
    alertmanagerMain: {}
    prometheusK8s: {}
    enableUserWorkload: true
```

## References

* [Understanding the monitoring stack](https://docs.openshift.com/container-platform/4.7/monitoring/understanding-the-monitoring-stack.html)
* [Configuring built-in monitoring with Prometheus](https://docs.openshift.com/container-platform/4.7/operators/operator_sdk/osdk-monitoring-prometheus.html)
* [Configuring the monitoring stack](https://docs.openshift.com/container-platform/4.7/monitoring/configuring-the-monitoring-stack.html)
* [Enabling monitoring for user-defined projects](https://docs.openshift.com/container-platform/4.7/monitoring/enabling-monitoring-for-user-defined-projects.html)
* [OpenShift oauth-proxy](https://github.com/openshift/oauth-proxy)
* [Thanos](https://github.com/thanos-io/thanos)
