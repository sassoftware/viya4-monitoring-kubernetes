# Grafana Mimir Integration

This sample adds [Grafana Mimir](https://grafana.com/oss/mimir/) as a long-term metrics
storage backend for the monitoring stack deployed by this project.

Prometheus is configured to forward (remote_write) all scraped metrics to Mimir in
real time. Grafana gains a second datasource — **Mimir** — which can answer queries
spanning months or years of history, well beyond Prometheus's default 7-day local
retention.

## Architecture

```
Prometheus ──remote_write──► Mimir (long-term store, mimir namespace)
                                     │
Grafana ◄─────── query ──────────────┘  (via nginx gateway)
        ◄─────── query ──── Prometheus  (local 7-day window)
```

## POC Limitations

This deployment uses **filesystem storage** and **single replicas** throughout.
It is suitable for evaluation only:

| Limitation | Production remedy |
|---|---|
| Filesystem storage | Replace with S3, GCS, or Azure Blob |
| `replication_factor: 1` | Set to 3 and enable zone-aware replication |
| `remoteWrite` patch is transient | Move config to `user-values-prom-operator.yaml` |

## Prerequisites

- Monitoring stack already deployed via `monitoring/bin/deploy_monitoring_cluster.sh`
- `kubectl`, `helm`, and `yq` available on `PATH`
- A default StorageClass available in the cluster (for Mimir's PVCs)

## Deployment

Run from the root of the repository:

```bash
monitoring/bin/deploy_mimir.sh
```

### Environment variables

| Variable | Default | Description |
|---|---|---|
| `MIMIR_NS` | `mimir` | Namespace to deploy Mimir into |
| `MON_NS` | `monitoring` | Namespace where Prometheus and Grafana are running |
| `MIMIR_CHART_VERSION` | `5.6.0` | mimir-distributed Helm chart version to install |
| `MIMIR_USER_YAML` | `$USER_DIR/monitoring/user-values-mimir.yaml` | Optional user values overlay |

### Custom values

To override any Mimir Helm values (for example, to swap in object storage), create
`$USER_DIR/monitoring/user-values-mimir.yaml`. The deploy script picks it up automatically.

Example — switch to S3:

```yaml
mimir:
  structuredConfig:
    common:
      storage:
        backend: s3
    blocks_storage:
      s3:
        bucket_name: my-mimir-blocks
        endpoint: s3.us-east-1.amazonaws.com
    ruler_storage:
      s3:
        bucket_name: my-mimir-ruler
        endpoint: s3.us-east-1.amazonaws.com

minio:
  enabled: false
```

## Making remoteWrite permanent

The deploy script patches the Prometheus CR directly. This patch is overwritten when
`deploy_monitoring_cluster.sh` runs again. To make it permanent, add the following
to `$USER_DIR/monitoring/user-values-prom-operator.yaml` **before** re-running the
monitoring deploy:

```yaml
prometheus:
  prometheusSpec:
    remoteWrite:
      - url: http://v4m-mimir-nginx.mimir:80/api/v1/push
        headers:
          X-Scope-OrgID: anonymous
```

## Verifying the integration

1. Open Grafana and confirm the **Mimir** datasource appears under
   **Connections → Data sources**.
2. In **Explore**, select the Mimir datasource and run any PromQL query.
   Data should appear immediately (Prometheus starts forwarding on remoteWrite
   configuration).
3. After 8+ days, queries against Mimir will return data that Prometheus's local
   TSDB can no longer serve — this is the key validation step for the POC.

## Removing Mimir

```bash
helm uninstall v4m-mimir -n mimir
kubectl delete ns mimir
kubectl delete cm -n monitoring grafana-datasource-mimir

# Remove remoteWrite from Prometheus CR (if patched directly)
kubectl patch prometheus <cr-name> -n monitoring --type=json \
  -p '[{"op":"remove","path":"/spec/remoteWrite"}]'
```
