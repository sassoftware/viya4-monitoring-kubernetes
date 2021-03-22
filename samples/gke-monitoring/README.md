# Google Clould Platform Monitoring Sample

The purpose of this sample is to demonstrate how to collect metrics from SAS
services in [Google Cloud Operations](https://cloud.google.com/products/operations).

## Prometheus Required

Metrics for SAS Viya components (including third-party technologies like
Postgres and RabbitMQ) are exposed through Prometheus-compatible HTTP(S)
metric endpoints.

Google [supports Prometheus metrics](https://cloud.google.com/stackdriver/docs/solutions/gke/prometheus)
by watching data as it is collected by a running Prometheus server, then
converting and exporting that data to Google Cloud Operations. This process
relies on the deployment and configuration of a Prometheus server, like
the one provided by this project.

## Sidecar

The [Stackdriver Prometheus Sidecar](https://github.com/Stackdriver/stackdriver-prometheus-sidecar)
is provided by Google to support exporting metrics collected by Prometheus
to Google Cloud Operations. It is provided as a sidecar (extra container) that
is added to the Prometheus pod with a shared volume mount so it can read the
Prometheus server data directly.

## Deployment

Although the sidecar can be deployed in to Prometheus pods deployed in a
variety of ways, this sample only directly supports
[Prometheus custom resources](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#prometheus)
such as those deployed in the monitoring stack of this project.

The included `patch-prometheus.sh` script will add the sidecar to a deployed
Prometheus custom resource. The script supports several environment variables,
some of which are required, while others have reasonable defaults that can be
overridden.

Required parameters:

* `GCP_PROJECT` - The associated GCP project
* `GCP_REGION` - The primary region of the cluster
* `GKE_CLUSTER` - The name of the GKE cluster

Optional parameters:

* `MON_NS` - The namespace of the Prometheus custom resource (default `monitoring`)
* `PROM_NAME` - The name of the Prometheus custom resource (default `v4m-prometheus`)
* `PROM_PATH` - Used to indicate that Prometheus is served off of a subpath
(default `/`). Make sure to end this value with a trailing `/`.
* `GKE_SIDECAR_VERSION` - The version of the Stackdriver Prometheus Sidecar to
use (default `0.8.2`). Releases can be found [here](https://github.com/Stackdriver/stackdriver-prometheus-sidecar/releases).

Example:

```bash
cd samples/gke-monitoring
export GCP_PROJECT=mygcpproject
export GCP_REGION=us-east1
export GKE_CLUSTER=my-awesome-cluster
./patch-prometheus.sh
```

The Prometheus pod will automatically restart. It will take 1-2 minutes for the
sidecar to start exporting metrics to Google Cloud Operations.

## Viewing Metrics

Once the sidecar is successfully exporting metrics, they will visible in the
Metrics Explorter in Google Cloud Operations Monitoring. From the Google
Cloud Platform Console, choose the top-left drop-down menu, then navigate to
Operations->Monitoring->Metrics explorer.

All metrics collected from Prometheus will start with
`external.googleapis.com/prometheus`, but searching for the base metric name
(e.g. `go_memstats_alloc_bytes`) works as well.

Building charts and dashboards using Metrics Explorer is outside the scope of
this sample, but ample documentation is available online.

## Troubleshooting

### Check pod status

```bash
kubectl get po -n monitoring prometheus-v4m-prometheus-0
```

### Check sidecar logs

```bash
kubectl logs -n monitoring prometheus-v4m-prometheus-0 -c sidecar -f
```
