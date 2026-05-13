# Monitoring

## Architecture

The monitoring stack uses the Grafana LGTM approach with unified signal
collection via Grafana Alloy (k8s-monitoring Helm chart):

| Component | Purpose |
|-----------|---------|
| **k8s-monitoring** (Alloy) | Unified collection: metrics, logs, traces, profiles (future) |
| **Prometheus** | Metrics TSDB (remote-write receiver, exemplar storage) |
| **Grafana Loki** | Log storage with structured metadata for trace correlation |
| **Grafana Tempo** | Distributed trace storage with metrics_generator |
| **Grafana** | Visualization with cross-signal correlation |
| **AlertManager** | Alert routing and notification |
| **Pushgateway** | Batch job metrics (optional) |

### Signal Flow

```
Applications (OTel SDK instrumented)
  │  Logs (with trace_id/span_id)
  │  OTLP traces
  │  Prometheus /metrics
  ▼
k8s-monitoring (Alloy)
  ├── metrics → Prometheus (remote-write)
  ├── logs → Loki (structured metadata: trace_id)
  ├── logs → OpenSearch (via OTel gateway, optional)
  └── traces → Tempo (OTLP)

Tempo metrics_generator
  └── span_metrics + service_graphs → Prometheus (with exemplars)

Grafana
  ├── Metrics → exemplar dots → click → Tempo trace
  ├── Traces → "Logs" tab → Loki (filtered by trace_id)
  └── Logs → trace_id link → Tempo trace
```

### Trace Correlation

Full trace_id correlation across all signals requires applications to be
instrumented with the OpenTelemetry SDK (or Java agent with MDC bridge).
See the "Application Instrumentation Prerequisites" section below.

## Deployment

```bash
monitoring/bin/deploy_monitoring_cluster.sh
```

## Removal

```bash
monitoring/bin/remove_monitoring_cluster.sh
```

## Configuration

User configuration is controlled via:
- `monitoring/user.env` — feature flags, chart versions, storage sizing
- `$USER_DIR/monitoring/user-values-*.yaml` — Helm value overrides per chart

Key environment variables:
- `LOKI_ENABLE` — Enable Loki log storage (default: true)
- `TRACING_ENABLE` — Enable Tempo tracing (default: true)
- `OPENSEARCH_DUAL_EXPORT_ENABLE` — Dual-export logs to OpenSearch (default: true)
- `PUSHGATEWAY_ENABLED` — Deploy Pushgateway (default: true)
- `PROMETHEUS_STORAGE_SIZE` / `LOKI_STORAGE_SIZE` / `TEMPO_STORAGE_SIZE` — PVC sizes

## Application Instrumentation Prerequisites for Correlation

For full trace-to-log-to-metric correlation, applications must:

1. **Generate traces**: Instrument with OTel SDK or Java agent to produce OTLP traces
2. **Emit trace_id in logs**: OTel Java agent auto-injects trace_id/span_id into SLF4J MDC.
   Go/Python services must explicitly include trace context in structured JSON logs.
3. **Log format**: Structured JSON with `trace_id` and `span_id` fields

Without instrumentation, cluster metrics, pod logs, and k8s events still work — only
trace correlation is unavailable.

## Additional Documentation

- [Tenant Monitoring](Tenant_Monitoring.md)
- [OpenShift](OpenShift.md)
- [Troubleshooting](Troubleshooting.md)

For the legacy documentation, see [Getting Started](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=n18d875xbudfken18v75gj7mopxq.htm) in the SAS Viya Monitoring for Kubernetes Help Center.