# SAS Viya Monitoring for Kubernetes

## Version 0.1.3 (11NOV20)

* **Overall**
  * Support added for the [SAS Viya Workload Node Placement](https://go.documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p0om33z572ycnan1c1ecfwqntf24.htm&locale=en)
    * By default, monitoring and logging pods are deployed to untainted nodes
    * A new flag, `NODE_PLACEMENT_ENABLE` supports deploying pods to appropriate
    workload node placement nodes
  * [Helm 2.x has reached end-of-life](https://github.com/helm/helm/releases/tag/v2.17.0)
  and is no longer supported. Helm 3.x is now required.

* **Monitoring**
  * Several helm charts have moved from [stable](https://charts.helm.sh/stable)
  to [prometheus-community](https://github.com/prometheus-community/helm-charts).
  * The [prometheus-operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator)
  helm chart has been deprecated and moved to
  [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack).
  * SAS Java and Go ServiceMonitors converted to PodMonitors to properly
  support merged services

* **Logging**
  * Support for SAS Viya move to Crunchy Data 4.5
  * Support for [changing retention period](logging/Log_Retention.md) of log messages
  * Node anti-affinity for Elasticsearch replicas
  * Support for multi-role Elasticsearch nodes (including [sample](samples/esmulti/README.md)
  to demonstrate usage) 
  * Additional documentation on using TLS
  * Removed traces of support for ODFE "demo" security configuration
  * [Alternate monitoring solution](logging/AZURE_LOG_ANALYTICS_WORKSPACES.md)(proof-of-concept): Fluent Bit
  ==> Azure Monitor (Log Analytics workspace)

## Version 0.1.2 (20OCT20)

* **Monitoring**
  * Support for sas-elasticsearch metric collection
  * Refreshed Istio dashboard collection
  * Samples refactored out of monitoring/logging directories into a top-level
  `samples` directory. Additionally, each subdirectory is structured to be
  compatible with [`USER_DIR`](README.md/#customization) customizations.
  * A new sample, [`generic-base`](samples/generic-base) has been created as
  a template for customization. It contains a full set of user response files
  available to customize.
  * Documentation for the samples has been improved
* **Logging**
  * Kubernetes events are now stored in the index associated with the namespace
  of the source of the event instead of a global (cluster) index
  * Multiple fixes to RBAC scripts

## Version 0.1.1 (22SEP20)

* Adjust to breaking Helm 3.3.2 change([Issue #1](https://github.com/sassoftware/viya4-monitoring-kubernetes/issues/1))
* Refactored samples into a top-level `samples` directory
* Force in-cluster TLS for logging ([Issue #2](https://github.com/sassoftware/viya4-monitoring-kubernetes/issues/2))

## Version 0.1.0 (16Sept20)

* Initial versioned release
