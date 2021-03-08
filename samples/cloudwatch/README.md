# Amazon CloudWatch Integration

This sample describes how to configure Amazon CloudWatch to collect metrics
from the services and components in SAS Viya. Completing the deployment
and configuration steps here will enable Amazon CloudWatch to collect and
visualize the metrics exposed by a SAS Viya deployment as well as the logging
components of viya4-monitoring-kubernetes.

Note that this sample does **not** decribe how to enable CloudWatch for general
use. That topic is covered extensively in
[Amazon's online documentation](https://aws.amazon.com/cloudwatch/getting-started/).

## Deployment

The deployment process for enabling CloudWatch to collect metrics from SAS Viya
components involves several steps:

* Identify Cluster and Region
* Deploy CloudWatch Prometheus Agent
* Apply SAS Customizations
  * Customize the Prometheus scrape configuration
  * Customize the mapping of performance log events to CloudWatch metrics

### Add IAM Role

The CloudWatch Agent requires proper permissions to create Performance Log
Events and CloudWatch metrics. AWS uses [IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
to set these permissions.

In the AWS console, navigate to IAM. From there:

* Choose `Roles` in the left navigation pane
* Start typing the cluster name to filter (e.g. `my-cluster`)
* Click on the role with `AWS service: eks` under the `Trusted entities` column
* Click `Attach Policies`
* Search for `CloudWatchAgentServerPolicy`
* Check the box next to `CloudWatchAgentServerPolicy`
* Choose `Attach Policy`
* Repeat for the role with `AWS service: ec2`

If the `CloudWatchAgentServerPolicy` does not exist, see:
[Creating IAM Roles for Use with the CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent-commandline.html).

### Identify Cluster and Region

Run the following snippit to identify the cluster name and region. Replace the
values of `ClusterName` and `RegionName` with the values for your EKS cluster.

```bash
ClusterName=my-cluster
RegionName=us-east-1
```

### Deploy CloudWatch Prometheus Agent

```bash
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/service/cwagent-prometheus/prometheus-k8s.yaml | 
sed "s/{{cluster_name}}/'${ClusterName}'/;s/{{region_name}}/'${RegionName}'/" | 
kubectl apply -f -
```

### Apply SAS Configuration

```bash
# Prometheus scrape config
# Scraped metrics will become performance log events
kubectl apply -f sas-prom-config.yaml
# Map performance log events to CloudWatch metrics
kubectl apply -f sas-prom-cwagentconfig.yaml
cat sas-prom-cwagentconfig.yaml \
  | sed "s/{{cluster_name}}/${ClusterName}/;s/{{region_name}}/${RegionName}/" \
  | kubectl apply -f -
# Restart agent
kubectl delete pod -n amazon-cloudwatch -l app=cwagent-prometheus
```

### Visualizing Metrics

Metrics collected by the Prometheus CloudWatch agent are stored in the
`/aws/containerinsights/[cluster-name]/prometheus` log group.
dashboard widgets can be created within Amazon CloudWatch.

For example, to create a graph of `go_memstates_alloc_bytes`
(memory usage) of SAS Go-based microservices:

* From the AWS web console, navigate to CloudWatch
* In the navigation bar on the left, choose 'Metrics'
* Choose the `ContainerInsights/Prometheus` namespace
* Choose `ClusterName, job, namespace, pod, sas_service_base`
* Search for or find the `go_memstates_alloc_bytes` metric
* Right-click and choose `Search for this only`
* Select the checkbox of one or more services (rows) to add them
to the graph at the top

## Limitations

The mapping between performance log events and CloudWatch metrics is defined
in the `cwagentconfig` configmap in the `amazon-cloudwatch` namespace. That
configmap is customized here in the file `sas-prom-cwagentconfig.yaml`. The
dimentions (labels in Prometheus) available in the metrics is less flexible
than using Grafana with Prometheus. This sample may be enhanced over time
to include more dimensions for more metrics.

## External Links

* [Set up CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights-Prometheus-Setup.html)
* [Creating IAM Roles for Use with the CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent-commandline.html)
* [Example performance log events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-reference-performance-logs-EKS.html)
