# Amazon CloudWatch Integration

This sample describes how to configure Amazon CloudWatch to collect metrics
from the services and components in SAS Viya. Completing the deployment
and configuration steps here will enable Amazon CloudWatch to collect and
visualize the metrics exposed by a SAS Viya deployment as well as the logging
components of this project

* Microservices
* CAS
* CAS Operator
* Deployment Operator
* RabbitMQ
* Postgres
* Elasticsearch
* Fluent Bit

## Deployment

The deployment process for enabling CloudWatch to collect metrics from SAS Viya
components involves several steps:

* Identify Cluster and Region
* Deploy CloudWatch Prometheus Agent
* Deploy CloudWatch Agent
* Apply SAS Customizations
  * Customize the Prometheus scrape configuration
  * Customize the mapping of Performance Log Events to CloudWatch metrics

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

### Deploy CloudWatch Agent

```bash
FluentBitHttpPort='2020'
FluentBitReadFromHead='Off'
[[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
[[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${ClusterName}'/;s/{{region_name}}/'${RegionName}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f - 
```

#### Add tolerations for Cloudwatch daemonset

The SAS Viya workload node placement strategy uses node taints and annotations
to direct pods to and away from specific nodes. For the CloudWatch agent to
successfully deploy on all nodes in the cluster, a toleration for the
`workload.sas.com/class` taint must be added to the daemonset.

```bash
kubectl patch deployment -n amazon-cloudwatch --patch "$(cat cwagent-daemonset-tolerations.yaml)"
```

### Apply SAS Configuration

```bash
# Prometheus scrape config
# Scraped metrics will become Performance Log Events
kubectl apply -f sas-prom-config.yaml
# Map Performance Log Events to CloudWatch metrics
kubectl apply -f sas-prom-cwagentconfig.yaml
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

The mapping between Performance Log Events and CloudWatch metrics is defined
in the `cwagentconfig` configmap in the `amazon-cloudwatch` namespace. That
configmap is customized here in the file `sas-prom-cwagentconfig.yaml`. The
dimentions (labels in Prometheus) available in the metrics is less flexible
than using Grafana with Prometheus. This sample may be enhanced over time
to include more dimensions for more metrics.

## External Links

* [Set up CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights-Prometheus-Setup.html)
* [Example Performance Log Events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-reference-performance-logs-EKS.html)
