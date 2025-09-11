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

### Common Customizations Needed

#### Namespace Adjustments
Some alerts reference specific namespaces that need to be adjusted for your environment:
- In several rules (like `viya-pod-restart-count-high.yaml`), the namespace is set to "viya" with `namespace="viya"`. Change this to match your SAS Viya namespace.

#### Alert Expression Format
Alert expressions in these samples use a multi-part approach for better compatibility with newer Grafana versions:
- Part A: Fetches the raw metric
- Part B: Reduces the result (using the "reduce" function)
- Part C: Applies the threshold using a dedicated threshold component

This approach addresses issues where direct threshold comparisons (e.g., `metric > threshold`) might not work properly in recent Grafana versions.

For more detailed information on Grafana alerting, see the [Grafana documentation](https://grafana.com/docs/grafana/latest/alerting/).