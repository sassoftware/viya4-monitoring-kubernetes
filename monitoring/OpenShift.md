# SAS Viya Monitoring on OpenShift

## Overview

The deployment process for [Red Hat OpenShift](https://www.openshift.com/) is
handled differently than on vanilla Kubernetes. OpenShift includes nearly the
same stack of monitoring components out of the box as this project:

* Prometheus Operator
* Prometheus
* Alertmanager
* Grafana
* Node Exporter
* kube-state-metrics
* ServiceMontitors for Kuberenetes components
* Grafana dashboards for cluster monitoring

There are some differences, however:

* Separate Prometheus instances are set up to monitor core
Kuberenetes/OpenShift components and user workloads
* [Thanos] is included to provide a single query interface for
the multiple Prometheus instances used by OpenShift
* The Grafana instance is read-only
* There are fewer Prometheus recording rules defining custom
convenience meterics
* API access to the Prometheus instances are authenticated, requiring
a service account and an access token for the new Grafana instance

On OpenShift, the deployment of SAS Viya Monitoring will integrate with the
monitoring components used by OpenShift. Since the included Grafana
instance is read-only, a separate Grafana instance will be deployed to provide
access to dashboards for SAS Viya components.

## Prerequisites

* [Kubernetes](https://kubernetes.io/) version 1.19+
* [OpenShift](https://www.openshift.com/) 4.7+
* [`kubectl`](https://kubernetes.io/docs/tasks/tools/) 1.19+
* [`helm`](https://helm.sh/docs/intro/install/) 3.0+ (3.5+ recommended)
* OpenShift [`oc`](https://docs.openshift.com/container-platform/3.6/cli_reference/get_started_cli.html)
command-line tool 3.0+

## Deployment

The normal `monitoring/bin/deploy_monitoring_cluster.sh` script is not
appropriate for OpenShift and will likely fail if run. Instead, a separate,
dedicated script tailored for OpenShift is provided.

The first step is to log in to the cluster using:

```bash
oc login [cluster-hostname] -u [userID]
```

To deploy SAS Viya Monitoring for OpenShift, run:

```bash
monitoring/bin/deploy_monitoring_openshift.sh
```

Next, enable monitoring of each SAS Viya deployment normally by running:

```bash
VIYA_NS=my-viya-namespace monitoring/bin/deploy_monitoring_viya.sh
```

## Customization

The `deploy_monitoring_openshift.sh` script supports a `USER_DIR` directory
similar to the one used by the generic `deploy_monitoring_cluster.sh` script,
but since only Grafana is deployed, the only supported files are
`$USER_DIR/user.env`, `$USER_DIR/monitoring/user-values-grafana.yaml`, and
`$USER_DIR/monitoring/user.env`.

No customization is required, even for ingress, as the
`deploy_monitoring_openshift.sh` script will define a
[route](https://docs.openshift.com/enterprise/3.0/architecture/core_concepts/routes.html)
for Grafana.
