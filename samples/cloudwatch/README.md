# Amazon CloudWatch Integration

This sample describes how to configure Amazon CloudWatch to collect metrics
from the services and components in SAS Viya. Complete the deployment
and configuration steps in this document to enable Amazon CloudWatch to collect
and visualize metric information from both SAS Viya as well as the monitoring
components deployed from this repository. This sample currently does not
provide information for using Amazon applications to view SAS Viya log
messages.

## CloudWatch Agent

AWS uses the CloudWatch agent to collect metrics. There are two types of
CloudWatch agents that you might want to use in your environment:

- The CloudWatch agent with Prometheus monitoring scrapes metrics from
Prometheus sources, such as SAS Viya. The metrics can then be converted and
mapped for display in CloudWatch. 

Because SAS Viya monitoring uses
Prometheus, this sample explains how to deploy and configure only the
CloudWatch agent for use with Prometheus.

- The default CloudWatch agent collects metrics from AWS nodes. Although
these metrics are not specific to SAS Viya, you might want to use both agents
so you can obtain a complete view of your environment's performance. For
information about using the default agent, see the
[CloudWatch documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html).
If you do use the default agent, you must add tolerations to the agent's
daemonset definition so that the agent can run on nodes that are tainted to
support SAS Viya workload node placement. See
[CloudWatch Agent Daemonset and Workload Node Placement](#wnp_tolerations).

## Deployment

Follow these steps to deploy CloudWatch and enable it to collect metrics from
SAS Viya:

1. Attach CloudWatchAgentServerPolicy to IAM roles
2. Identify the cluster and region
3. Deploy the CloudWatch Prometheus agent
4. Apply SAS Viya customizations
    - Customize the Prometheus scrape configuration
    - Customize the mapping of performance log events to CloudWatch metrics

### Attach CloudWatchAgentServerPolicy to IAM Roles

The CloudWatch agent requires proper permissions to create performance log
events and CloudWatch metrics. AWS uses Identity and Access Management (IAM)
roles to set these permissions. See the
[IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
documentation for more information.

Follow these steps to set permissions:

1. Sign in to the AWS Management Console and open the IAM console.
2. In the navigation pane of the console, select `Roles`.
3. In the Search field, enter the name of the Amazon EKS cluster on which SAS
Viya is deployed (such as `my-cluster`) to filter the roles listed.
4. Select the role that contains `AWS service: eks` in the `Trusted entities`
column.
5. Select `Attach Policies`.
6. Search for `CloudWatchAgentServerPolicy`. If the
`CloudWatchAgentServerPolicy` does not exist, see:
[Creating IAM Roles for Use with the CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent-commandline.html).
7. Select the check box next to `CloudWatchAgentServerPolicy`.
8. Select `Attach Policy`.
9. Repeat steps 4 through 8 for the role that contains `AWS service: ec2` in
the `Trusted entities` column.  

### Identify Cluster and Region

You must identify the Amazon EKS cluster on which SAS Viya is deployed and the
region for the cluster. These values are needed to construct the correct
endpoint for CloudWatch.


Use values for your EKS cluster to set the `ClusterName` and `RegionName` environment variables.

```bash
ClusterName=my-cluster
RegionName=us-east-1
```

After you set these environment variables, you can copy and paste the command in the next section to deploy the Cloudwatch agent.

### Deploy CloudWatch Agent for Prometheus

Run the following code from the command line to deploy the CloudWatch agent for
Prometheus metrics:

```bash
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/service/cwagent-prometheus/prometheus-k8s.yaml | 
sed "s/{{cluster_name}}/${ClusterName}/;s/{{region_name}}/${RegionName}/" | 
kubectl apply -f -
```

### Apply SAS Viya Customizations

This sample includes configuration files that transform the scraped SAS Viya
Prometheus metrics into performance log events and then map the performance
log events to Cloudwatch metrics.

#### Configure Scraped Metrics

Run this command to configure the metrics scraped by Prometheus and convert
them into performance log events:

```bash
kubectl apply -f sas-prom-config.yaml
```

#### Map Performance Log Events to CloudWatch Metrics

Run these commands to map the performance log events that were created from
Prometheus metrics to CloudWatch metrics and restart the agent in order to
apply the configuration changes:

```bash
cat sas-prom-cwagentconfig.yaml \
  | sed "s/{{cluster_name}}/${ClusterName}/;s/{{region_name}}/${RegionName}/" \
  | kubectl apply -f -
# Restart the CloudWatch Prometheus agent
kubectl delete pod -n amazon-cloudwatch -l app=cwagent-prometheus
```

## Visualizing Metrics

After you configure metric collection for CloudWatch, you can create dashboard
widgets in CloudWatch to visualize the collected metric data. Metrics
collected by the CloudWatch agent for Prometheus are stored in the
`/aws/containerinsights/[cluster-name]/prometheus` log group.

To access the metrics:

1. From the AWS web console, navigate to CloudWatch.
2. In the navigation bar on the left, choose `Metrics`.
3. Select the `ContainerInsights/Prometheus` namespace.

The Cloudwatch **Metrics** view displays a set of tiles, with each tile corresponding to a common set of dimensions, You can hover over a tile's dimensions to display the complete list of dimensions associated with the tile. 

The dimensions for a metric correspond to the metric's Prometheus labels, and are used to specify attributes about the source of the metric. Metrics use different dimensions, depending on the type of data being collected, For example, a metric collecting the memory of a CAS node might include dimensions such as the cluster name, the CAS node name, and the CAS node type. A metric collecting the memory usage of a SAS service might also use the cluster name, but include the SAS service base and SAS service name. 

All of the metrics that use a common set of dimensions are grouped under a tile that is labeled with the list of dimensions. In order to find the a specific metric, you must find the tile with the corresponding set of dimensions.

Because each metric has many dimensions and because many SAS Viya metrics are collected for Cloudwatch, it can
be difficult to find a specific metric or metrics. You can use
the reference tables in [CloudWatch SAS Viya Metrics](reference.md) to locate
SAS Viya metrics and identify the tile with which they are associated. The tables provide these cross-reference listings: 

- the metrics associated with each set of dimensions
- the dimensions and metrics associated with each type of source (such as CAS, SAS services written in Go, or SAS services written in Java)
- the dimensions associated with each each metric

After you find the metric you are interested in, you can create a graph from
the metric data. For example, these are the steps to create a graph of
`go_memstats_alloc_bytes` (memory usage) of SAS Viya services that are
written in Go:

1. Go to [CloudWatch SAS Viya Metrics](reference.md) and expand the
**By Metric** table.
2. Locate the `go_memstats_alloc_bytes` metric. The table indicates that it is
associated with the `'ClusterName,job,namespace,node,pod,sas_service_base,service`
dimensions.
3. From the AWS web console, navigate to CloudWatch.
4. In the navigation bar on the left, choose `Metrics`.
5. Select the `ContainerInsights/Prometheus` namespace.
6. Select the tile with the `'ClusterName,job,namespace,node,pod,sas_service_base,service`
dimension. A table appears that lists all of the metrics associated with that dimension.
7. Locate the `go_memstats_alloc_bytes` metric.
8. Click on the arrow next to the metric and select `Search for this only`.
9. Select the checkbox for the SAS Viya services that you want to include in the
graph.

## CloudWatch Agent Daemonset and Workload Node Placement<a name=wnp_tolerations></a>

The SAS Viya workload node placement configuration uses annotations and node taints
to schedule pods on appropriate nodes. The default CloudWatch agent is deployed
as a daemonset and runs on every node. If you use the default CloudWatch agent,
you must add tolerations to the agent's daemonset definition to enable the agent
to run on nodes that are tainted for SAS Viya workload node placement.

Here is a sample `tolerations` code snippet that you can add to the daemonset to
allow it to properly schedule a pod on every node in the cluster:

```yaml
tolerations:
- key: "workload.sas.com/class"
  operator: Exists
  effect: NoSchedule
```

## Limitations

The mapping between performance log events and CloudWatch metrics is defined
in the `cwagentconfig` configmap in the `amazon-cloudwatch` namespace. This
sample provides customized mapping in the `sas-prom-cwagentconfig.yaml` file,
but this mapping does not include every every possible dimension (or Prometheus
label). A complete mapping would require every possible combination of labels
from every source and every metric be defined in the mapping configuration. This
sample might be updated in later releases to include additional combinations of
dimensions for key metrics.

## References

Refer to theses sources for more information:

- [Set up CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights-Prometheus-Setup.html)
- [Creating IAM Roles for Use with the CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent-commandline.html)
- [Example performance log events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-reference-performance-logs-EKS.html)
- [Scraping Additional Prometheus sources and Importing Those Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights-Prometheus-Setup-configure-ECS.html)
