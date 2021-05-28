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
and
the SAS Viya Monitoring environment

* OpenShift uses separate Prometheus instances to monitor core
Kuberenetes and OpenShift components and to monitor user workloads
* OpenShift includes [Thanos] to provide a single query interface for
the multiple Prometheus instances used by OpenShift
* The Grafana instance in OpenShift is read-only
* SAS Viya Monitoring provides more Prometheus recording rules to define custom
convenience metrics than are provided by OpenShift
* In OpenShift, API access to the Prometheus instances is authenticated, so
a service account and an access token is required to use Grafana

The process of deploying SAS Viya Monitoring on OpenShift integrates the SAS
Viya Monitoring components with those used by OpenShift. Because the instance
of Grafana that is provided on Openshift is read-only, SAS Viya Monitoring
deploys a separate instance of Grafana in order to provide access to dashboards
for SAS Viya components.

**Note:** When deploying on other cloud providers, the ServiceMonitors for SAS
Viya Logging are deployed as part of SAS Viya Monitoring. On OpenShift, these
ServiceMonitors are deployed as part of SAS Viya Logging.

## Prerequisites

* [Kubernetes](https://kubernetes.io/) version 1.19+
* [OpenShift](https://www.openshift.com/) 4.7+
* [`kubectl`](https://kubernetes.io/docs/tasks/tools/) 1.19+
* [`Helm`](https://helm.sh/docs/intro/install/) 3.0+ (3.5+ recommended)
* OpenShift [`oc`](https://docs.openshift.com/container-platform/3.6/cli_reference/get_started_cli.html)
command-line tool 3.0+

## Deploy SAS Viya Monitoring on OpenShift

You must use this procedure to deploy SAS Viya Monitoring on OpenShift. Do not
use the standard monitoring deployment script (deploy_monitoring_cluster.sh).

1. Follow the instructions in the [monitoring README](README.md#mon_pre_dep) to
perform the standard predeployment tasks (create a local copy of the repository and
customize your deployment). See [Customization](#os_mon_cust) for information about
customization on OpenShift.

2. Use this command to log on to the cluster:

```bash
oc login [cluster-hostname] -u [userID]
```

3. Use this command to deploy SAS Viya Monitoring for OpenShift:

```bash
monitoring/bin/deploy_monitoring_openshift.sh
```

4. Use this command to enable monitoring of each SAS Viya deployment:

```bash
VIYA_NS=my-viya-namespace monitoring/bin/deploy_monitoring_viya.sh
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
