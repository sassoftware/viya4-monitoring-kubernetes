# Alert Rules Structure

This directory contains Grafana alert rules for monitoring SAS Viya environments. The alerts are organized into subdirectories by component/category:

- `cas/` - Alerts for CAS (Cloud Analytic Services)
- `database/` - Alerts for database services
- `platform/` - Alerts for Viya platform components
- `other/` - Miscellaneous alerts

## Alert Files Structure

Each alert is stored in its own YAML file with a descriptive name. This modular approach makes it easier to:

- Manage individual alerts
- Track changes in version control
- Enable/disable specific alerts
- Customize alerts for specific environments

## Alert File Format

Each alert file follows this structure:

```yaml
apiVersion: 1
groups:
  - interval: 5m  # How often the alert is evaluated
    folder: Category Name  # The folder where the alert appears in Grafana
    name: SAS Viya Alerts  # The alert group name
    orgId: 1
    rules:
      - title: Alert Title  # The name of the alert
        annotations:
          description: Detailed explanation of the alert condition
          summary: Brief summary of the alert
        condition: C  # The condition reference letter
        data:
          # The alert query and evaluation conditions
        execErrState: Error
        for: 5m  # Duration before alert fires
        labels:
          severity: warning  # Alert severity
        noDataState: NoData
        uid: unique-alert-id  # Unique identifier for the alert
```

## Customizing Alerts

To customize an alert:

1. Copy the alert file to your user directory
2. Modify the alert parameters as needed (thresholds, evaluation intervals, etc.)
3. Deploy the monitoring components to apply your custom alerts

### Required Customizations

The following elements need to be adjusted to match your specific environment:

#### 1. Namespace Specifications
- Change `namespace="viya"` to match your SAS Viya namespace in:
  - `platform/viya-pod-restart-count-high.yaml`
- Verify the pattern `job=~"sas-.*"` in `platform/high-viya-api-latency.yaml` matches your service naming convention

#### 2. Persistent Volume Claims
- Update PVC names in:
  - `other/nfs-share-high-usage.yaml`: `persistentvolumeclaim="cas-default-data"`
  - `database/crunchy-backrest-repo.yaml`: `persistentvolumeclaim=~"sas-crunchy-platform-postgres-repo1"`
  - `database/crunchy-pgdata-usage-high.yaml`: `persistentvolumeclaim=~"sas-crunchy-platform-postgres-00-.*"`

#### 3. Container Names
- Verify container names in:
  - `database/catalog-db-connections-high.yaml`: `container="sas-catalog-services"`
  - `platform/viya-readiness-probe-failed.yaml`: `container="sas-readiness"`

#### 4. Alert Thresholds
Adjust thresholds based on your environment size and requirements:
- `cas/cas-thread-count-high.yaml`: > 400 threads
- `cas/cas-memory-usage-high.yaml`: > 300 GB
- `database/postgresql-connection-utilization-high.yaml`: > 85%
- `platform/rabbitmq-ready-queue-backlog.yaml`: > 10,000 messages
- `platform/rabbitmq-unacked-queue-backlog.yaml`: > 5,000 messages
- `platform/viya-pod-restart-count-high.yaml`: > 20 restarts
- `other/nfs-share-high-usage.yaml`: > 85% full
- `platform/high-viya-api-latency.yaml`: > 1 second (95th percentile)
- `database/crunchy-pgdata-usage-high.yaml` and `database/crunchy-backrest-repo.yaml`: > 50% full

#### 5. Verify Metric Availability
Ensure the following metrics are available in your Prometheus instance:
- CAS metrics: `cas_thread_count`, `cas_grid_uptime_seconds_total`
- Database metrics: `sas_db_pool_connections`, `pg_stat_activity_count`, `pg_settings_max_connections`
- RabbitMQ metrics: `rabbitmq_queue_messages_ready`, `rabbitmq_queue_messages_unacknowledged`
- Kubernetes metrics: `kube_pod_container_status_restarts_total`, `kube_pod_container_status_ready`
- HTTP metrics: `http_server_requests_duration_seconds_bucket`
- SAS Job Launcher: `:sas_launcher_pod_status:` (recording rule)

### Alert Expression Format

Alert expressions in these samples use a multi-part approach for better compatibility with newer Grafana versions:

- **Part A**: Fetches the raw metric
- **Part B**: Reduces the result (using the "reduce" function)
- **Part C**: Applies the threshold using a dedicated threshold component

This approach addresses issues where direct threshold comparisons (e.g., `metric > threshold`) might not work properly in recent Grafana versions. If you experience "no data" results when the underlying metric has data, ensure your alert is using this multi-part approach.

For example, instead of:
```yaml
expr: cas_thread_count > 400
```

Use:
```yaml
# Part A: Fetch the metric
expr: cas_thread_count

# Part B: Reduce the result
type: reduce
expression: A

# Part C: Apply threshold
type: threshold
expression: B
evaluator:
  type: gt
  params:
    - 400
```

For more detailed information on Grafana alerting, see the [Grafana documentation](https://grafana.com/docs/grafana/latest/alerting/).