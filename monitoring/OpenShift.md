# SAS Viya Monitoring on OpenShift

## Overview

Deploying the monitoring components on [Red Hat OpenShift](https://www.openshift.com/)
uses a different process than deploying on generic Kubernetes. OpenShift
already includes these monitoring components that are used by SAS Viya
Monitoring:

* Prometheus Operator
* Prometheus
* Alertmanager
* Grafana
* Node Exporter
* kube-state-metrics
* ServiceMontitors for Kuberenetes components
* Grafana dashboards for cluster monitoring

These are the differences between the default OpenShift monitoring environment
and the SAS Viya Monitoring environment:

* OpenShift uses separate Prometheus instances to monitor core
Kuberenetes and OpenShift components and to monitor user workloads
* OpenShift includes [Thanos](https://github.com/thanos-io/thanos) to provide a
single query interface for the multiple Prometheus instances used by OpenShift
* SAS Viya Monitoring provides more Prometheus recording rules to define custom
convenience metrics than are provided by OpenShift
* In OpenShift, API access to the [Thanos Querier](https://github.com/thanos-io/thanos/blob/main/docs/components/query.md)
is authenticated
* Users authenticate against OpenShift to access Grafana
* The Grafana instance in OpenShift provides read-only access

The process of deploying SAS Viya Monitoring on OpenShift integrates the SAS
Viya Monitoring components with those used by OpenShift. Because the instance
of Grafana that is provided on Openshift is read-only, SAS Viya Monitoring
deploys a separate instance of Grafana in order to provide access to dashboards
for SAS Viya components.

See the [Grafana helm chart](https://github.com/grafana/helm-charts/tree/main/charts/grafana)
for more information about customizing the deployment. You can provide
user settings for Grafana in the file `$USER_DIR/monitoring/user-values-openshift-grafana.yaml`.

**Note:** When deploying on other cloud providers, the ServiceMonitors for SAS
Viya Logging are deployed as part of SAS Viya Monitoring. On OpenShift, these
ServiceMonitors are deployed as part of SAS Viya Logging.

## Authentication

By default, SAS Viya Monitoring on OpenShift uses OpenShift
authentication to log in to Grafana. Authentication is provided by the OpenShift
oauth-proxy sidecar. To disable OpenShift authentication, set the
`OPENSHIFT_AUTH_ENABLE` environment variable to `false`. This value can also
be set in `$USER_DIR/monitoring/user.env`. Regardless of the value of
`OPENSHIFT_AUTH_ENABLE`, in-cluster TLS (from the ingress controller
to Grafana) and ingress TLS (browser to cluster) is enabled on the Grafana
[route](https://docs.openshift.com/container-platform/4.7/rest_api/network_apis/route-route-openshift-io-v1.html)
(OpenShift's version of ingress).

## Prerequisites

* [Kubernetes](https://kubernetes.io/) version 1.19+
* [OpenShift](https://www.openshift.com/) 4.7
* [`kubectl`](https://kubernetes.io/docs/tasks/tools/) 1.19+
* [`Helm`](https://helm.sh/docs/intro/install/) 3.0+ (3.5+ recommended)
* OpenShift [`oc`](https://docs.openshift.com/container-platform/3.6/cli_reference/get_started_cli.html)
command-line tool 4.0+

## Deploy SAS Viya Monitoring on OpenShift

You must use this procedure to deploy SAS Viya Monitoring on OpenShift. Do not
use the standard monitoring deployment script (deploy_monitoring_cluster.sh).

1. Follow the instructions in the [monitoring README](README.md#mon_pre_dep) to
perform the standard predeployment tasks (create a local copy of the repository and
customize your deployment). See [Customization](#mon_os_cust) for information about
customization on OpenShift.

2. Use this command to log on to the cluster:

```bash
oc login [cluster-hostname] -u [userID]
```

3. Use this command to deploy SAS Viya Monitoring for OpenShift:

```bash
monitoring/bin/deploy_monitoring_openshift.sh
```

Once the configmap is updated, the user workload Prometheus instance will be
created start monitoring user namespaces, including the SAS Viya namespace(s).

4. Use this command to enable monitoring of each SAS Viya deployment:

```bash
VIYA_NS=my-viya-namespace monitoring/bin/deploy_monitoring_viya.sh
```

### Azure Red Hat OpenShift (EXPERIMENTAL)

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

## <a name="mon_os_cust"></a>Customization

Customization of SAS Viya Monitoring on OpenShift deployment follows the same
process as in a standard monitoring deployment, which uses the `USER_DIR`
environment variable to specify the location of your customization files.
See the
[monitoring README](README.md#mon_custom) for information about the
customization process.

However, because SAS Viya Monitoring on OpenShift only deploys Grafana, the
only customization files that are supported in the `USER_DIR` location are:

* `$USER_DIR/user.env`
* `$USER_DIR/monitoring/user-values-openshift-grafana.yaml`
* `$USER_DIR/monitoring/user.env`

No customizations are required, even if you are using ingress, because the
`deploy_monitoring_openshift.sh` script defines a
[route](https://docs.openshift.com/enterprise/3.0/architecture/core_concepts/routes.html)
for Grafana.

### Customizing Routes

Routes may be configured to be host-based (default) or path-based. When
using host-based routes, access to Grafana will be by hostname only - for
example: `https://v4m-grafana-monitoring.apps.my-openshift-cluster.com`. Path-
based routes will result in a url ending in `/grafana` - for example:
`https://v4m-monitoring.apps.my-openshift-cluster.com/grafana`.

Specify `OPENSHIFT_PATH_ROUTES=true` in the `$USER_DIR/user.env` file
(applies to both monitoring and logging) or the `$USER_DIR/logging/user.env`
file (for only logging components) to use path-based routes.

The Grafana hostname can be configured using `OPENSHIFT_ROUTE_HOST_GRAFANA` in
`$USER_DIR/user.env` or `$USER_DIR/monitoring/user.env`. Note that OpenShift
does not allow the use of the same route hostname across namespaces, so do not
use the same custom hostname across logging and monitoring.

## Remove SAS Viya Monitoring on OpenShift

To remove the monitoring components, run these commands:

```bash
# Remove cluster monitoring
monitoring/bin/remove_monitoring_openshift.sh

# Optional: Remove SAS Viya monitoring
# Run this section once per Viya namespace
export VIYA_NS=<your_viya_namespace>
monitoring/bin/remove_monitoring_viya.sh
```

## References

* [Understanding the monitoring stack](https://docs.openshift.com/container-platform/4.7/monitoring/understanding-the-monitoring-stack.html)
* [Configuring built-in monitoring with Prometheus](https://docs.openshift.com/container-platform/4.7/operators/operator_sdk/osdk-monitoring-prometheus.html)
* [Configuring the monitoring stack](https://docs.openshift.com/container-platform/4.7/monitoring/configuring-the-monitoring-stack.html)
* [Enabling monitoring for user-defined projects](https://docs.openshift.com/container-platform/4.7/monitoring/enabling-monitoring-for-user-defined-projects.html)
* [OpenShift oauth-proxy](https://github.com/openshift/oauth-proxy)
* [Thanos](https://github.com/thanos-io/thanos)
