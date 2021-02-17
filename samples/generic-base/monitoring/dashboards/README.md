# User-Provided Dashboards

The `$USER_DIR/monitoring/dashboards` directory can be used to supply
a set of additional Grafana dashboards to deploy with the monitoring
stack.

## Community Dashboards

Grafana maintains a community site of [public dashboards](https://grafana.com/grafana/dashboards).
Simply download the `.json` file and place it with a filename that is
a [valid kubernetes resource name](https://kubernetes.io/docs/concepts/overview/working-with-objects/names).

## Troubleshooting

### Data Sources

Many publicly available dashboards use a generic data source definition that
triggers Grafana to prompt the user to resolve to an actual data source during
a manual import operation. This data source is usually something like
`${DS_PROMETHEUS}`, but the name can vary.

Since these dashboards are provisioned during deployment and not manually
imported, there is no opportunity to resolve the data source, causing errors
when the dashboard is eventually viewed. To work around this issue, perform
a global replace of the generic data source with `Prometheus`. For example:

* Find: `"datasource": "${DS_PROMETHEUS}"`
* Replace: `"datasource": "Prometheus"`

### Size

Dashboards provided here are provisioned as configmaps. Some extremely detailed
dashboards may be too large. In this case, the dashboards must be deployed
using the Grafana user interface.
