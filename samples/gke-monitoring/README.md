# Viewing SAS Viya Metrics Using Google Cloud Operations

Google GKE uses [Google Cloud Operations](https://cloud.google.com/products/operations)
to view metric data. In order for Google Cloud Operations to view metric data
collected in Prometheus, such as from SAS Viya services, that data must be
collected from Prometheus, converted, and exported Google Cloud Operations.

Use this sample to deploy the components needed to enable Google Cloud
Operations to view SAS Viya metric data.

## Components

These components are required to view SAS Viya metric data in Google Cloud
Operations:

- Prometheus server
- Stackdriver Prometheus sidecar

### Prometheus Server

SAS Viya metrics are provided as HTTP-HTTPS metric endpoints that are read by
a Prometheus server, such as the one deployed with the SAS Viya Monitoring
components.

Google [supports Prometheus metrics](https://cloud.google.com/stackdriver/docs/solutions/gke/prometheus)
by watching data as it is collected by the Prometheus server. Google then converts
and exports that data to Google Cloud Operations.

Before using this sample, you must [deploy the SAS Viya Monitoring components](../README.md),
including the Prometheus server.

### Stackdriver Prometheus Sidecar

Google uses the [Stackdriver Prometheus sidecar](https://github.com/Stackdriver/stackdriver-prometheus-sidecar)
to export metrics collected by Prometheus to Google Cloud Operations. The
sidecar (or extra container) is added to the Prometheus pod with a shared
volume mount so that the sidecar can directly read the Prometheus server data.

Although there are several ways to deploy the sidecar to a Prometheus pod,
this sample directly supports only
[Prometheus custom resources](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#prometheus)
such as those deployed by the SAS Viya Monitoring components in
this repository.

## Using This Sample

The `patch-prometheus.sh` script in this sample adds the sidecar to a deployed
Prometheus custom resource. The script uses environment variables to customize
the deployment for your environment. Required environment variables do not have
a default value, so the script fails if the environment variable values are not provided.

These environment variables are required:

- `GCP_PROJECT` - the Google Cloud Platform project
- `GCP_REGION` - the primary region of the Google Cloud Platform cluster
- `GKE_CLUSTER` - the name of the Google Kubernetes Environment cluster

These environment variables are optional:

- `MON_NS` - the namespace of the Prometheus custom resource (default
`monitoring`)
- `PROM_NAME` - the name of the Prometheus custom resource (default
`v4m-prometheus`)
- `PROM_PATH` - the sub-path to Prometheus from the Prometheus URL. This
value must end with `/`, which is the default value. For example, if you are
using host-based ingress, the Prometheus URL might be
`http://prometheus.host.mycluster.example.com`, so you would use the default
value of `/`. If you are using path-based ingress, the Prometheus URL might be
`http://host.mycluster.example.com/prometheus`, so you would specify a value
of `prometheus/`.
- `GKE_SIDECAR_VERSION` - the version of the Stackdriver Prometheus sidecar to
use. The default value is `0.8.2`. See the list of releases on [Stackdriver
Prometheus sidecar on GitHub](https://github.com/Stackdriver/stackdriver-prometheus-sidecar/releases).

This is an example deployment:

```bash
cd samples/gke-monitoring
export GCP_PROJECT=mygcpproject
export GCP_REGION=us-east1
export GKE_CLUSTER=my-awesome-cluster
./patch-prometheus.sh
```

After you run the script, the Prometheus pod automatically restarts. The
sidecar starts exporting metrics to Google Cloud Operations one to two minutes
after the pod restarts.

## Viewing Metrics

After the sidecar starts successfully exporting metrics, the metrics are
visible in the
Metrics Explorer in Google Cloud Operations Monitoring.

To view the metrics, from the Google Cloud Platform Console, select
**Operations** -> **Monitoring** -> **Metrics Explorer**.

All metrics collected from Prometheus begin with
`external.googleapis.com/prometheus`. You can also search for the base metric
name (such as `go_memstats_alloc_bytes`).

You can create charts and dashboards for viewing the SAS Viya metric data. See
the [Metric Explorer documentation](https://cloud.google.com/monitoring/charts/dashboards)
for information about building charts and dashboards.

## Troubleshooting

### Check Pod Status

Use this command to check the status of the Prometheus pod and verify that it
is running correctly:

```bash
kubectl get po -n monitoring prometheus-v4m-prometheus-0
```

### Check Sidecar Logs

Use this command to view the logs for the Stackdriver Prometheus sidecar:

```bash
kubectl logs -n monitoring prometheus-v4m-prometheus-0 -c sidecar -f
```
