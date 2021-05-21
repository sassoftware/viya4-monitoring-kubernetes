# Log Monitoring on an OpenShift Cluster
## Introduction
The standard log monitoring solution for Viya 4 Monitoring for Kubernetes, composed of Fluent Bit and Elasticsearch, can be deployed into OpenShift environments.  However, deploying on OpenShift involves some additional, OpenShift-specific task.  Therefore, deploying and removing the solution on OpenShift requires the use of OpenShift-specific deployment and removal scripts rather than the standard scripts used on other cloud environments.  

Please note that this log monitoring solution does not integrate with or leverage any native OpenShift log monitoring components.  While it _can_ be deployed alongside the native log monitoring solution, this would be inefficient.  Deploying both log monitoring solutions will  result in two daemonsets, each deploying a separate log collection pod (Fluent Bit for Viya 4 Monitoring for Kubernetes and Fluentd for OpenShift native log monitoring) on every node in the cluster.  While the Fluent Bit pods themselves are fairly light-weight (resource-wise), deploying a redundant daemonset may be considered inefficient. In addition, storing every log message generated in the cluster in two different storage systems would waste storage space.  

>**Therefore, this log monitoring solution should be considered an alternative to the native log monitoring solution.**  

## OpenShift Specific Additions
### Routes
OpenShift has its own networking technology called "routes".  The deployment process configures leverages routes to provide access to Kibana and, optionally, to the Elasticsearch REST API end-point.

### Security
Deploying into OpenShift required some additional security-related additions to the process.  Our use of these configuration techniques is consistent with the configuration of the components of OpenShift "native" log monitoring solution.

**Use of Security Constraint Context (SCC) Objects** OpenShift includes Security Context Constraints (SCC) as a mechanism to limit what pods and containers can do with respect to interacting at the process level with the cluster's nodes.  A number of pre-defined SCCs are included in OpenShift with varying combinations of limits and capabilities. Individual roles can be granted access to specific SCCs to allow them to perform work. 

* To deploy the OpenDistro for Elasticsearch components, the deployment process links the `v4m-es-es` Service Account to the `privileged` SCC.  
* A custom SCC, `v4mlogging`, is created.  This custom SCC is more narrowly defined than the `priviliged` SCC and limits the specific access needed by the v4m-fb ServiceAccount used by the Fluent Bit pods.

**Pod Security Context**
In addition to the custom SCC used with Fluent Bit, the `securityContext.privileged` configuration setting (part of the pod spec definition for the Fluent Bit pods) is set to *`true`* in the Helm chart response file.

## Deploying Logging
To deploy the logging components, use the `./logging/bin/deploy_logging_open_openshift.sh` script rather than the `./logging/bin/deploy_logging_open.sh` script used with other cloud environments.  This driver script deploys the additional OpenShift-specific components and  customizations.
### Command syntax:
`./logging/bin/deploy_logging_open_openshift.sh`

## Removing Logging
To remove the logging components previously deployed, use the `remove_logging_open_openshift.sh` script.  This driver script removes the OpenShift-specific artifacts and then removes the standard log monitoring components of the Viya 4 Monitoring for Kubernetes solution by calling same `remove_logging_open.sh` scritpt used in other cloud providers.  

As a reminder, by default, the removal scripts doe **_not_** remove all of the associated Kubernetes objects.  By default, Kubernetes configuration maps (configMaps), secrets and persistent value claims (PVC) created in the logging namespace during the deployment process are not removed.  This allows you to redeploy the logging solution again later without losing data or having to regenerate TLS certificates.  In addition, as a precaution, the logging namespace is left in-place in case you deployed the logging components into a namespace that also hosts other content.  There are environment variables that can be set to override the default behavior and explicitly control which objects are removed.

### Command syntax:
`./logging/bin/remove_logging_open_openshift.sh`

## Service Monitors
When deploying onto an OpenShift cluster, by default, ServiceMonitors are also deployed to ensure performance metrics for the logging components are made accessible to Prometheus (a standard part of OpenShift monitoring).  While these are the same ServiceMonitors deployed as part of Viya 4 Monitoring for Kubernetes on other cloud providers, they are normally deployed as part of the deployment of the (metric) monitoring components.  However, cross-namespace (metric) discovery is not supported on OpenShift.

## Environment Variable Flags that impact the above
 The environment variables shown below can be used to influence how the deployment and removal scripts operate.  As a general statement, the default values are the approprite values for deploying in an OpenShift environment.  However, if you have a specific need to alter the default behavior, you can set one or more of these environment variables (either from the command line or by including it in the user.env file in your customizations directory.
 
 Default values shown are only appropriate for OpenShift clusters

| Environment Variable | Purpose | Default Value (OpenShift Clusters) |
| -- | --- | -- |
| OPENSHIFT_PREREQS_ENABLE |Deploy OpenShift Prerequisites (e.g. create custom SCCs, link SCC to users, etc.)? | true |
| OPENSHIFT_ROUTES_ENABLE | Create OpenShift Route objects? | true |
| ES_ENDPOINT_ENABLE | Make Elasticsearch API endpoint accessible via OpenShift route? | false |
| KB_KNOWN_NODEPORT_ENABLE | Make Kibana accessible via "known" NodePort (e.g. 31033)?| false |
| DEPLOY_SERVICEMONITORS | Deploy ServiceMonitors for logging components? | true |
| OPENSHIFT_ARTIFACTS_REMOVE | Remove OpenShift artifacts (e.g. custom SCCs)| true |
