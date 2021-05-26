# SAS Viya Log Monitoring on OpenShift

## Overview

If you deploy SAS Viya on Red Hat OpenShift, you can use either OpenShift 
cluster logging or SAS Viya Logging (the components contained in this 
repository) to view SAS Viya log messages. 

If the optional OpenShift cluster logging has already been deployed, you can use 
it to view SAS Viya log messages. However, the messages from third-party components 
of SAS Viya will be displayed differently than the messages from the SAS Viya components, 
which might make message parsing and interpretation more difficult.

If Openshift cluster logging has not been installed, you can choose to deploy 
SAS Viya Logging. Deploying SAS Viya Logging on 
OpenShift uses a different process than deploying on generic Kubernetes, so you 
must follow the procedure in this document. 

Although you can deploy SAS Viya Logging even if the OpenShift 
cluster logging is also deployed, this configuration is inefficient and 
therefore not recommended. Using both logging solutions results in two daemonsets   
being used, each of which deploys separate log collection pods (Fluent Bit for 
SAS Viya Logging and Fluentd for Openshift cluster logging) on every node in the cluster. 
Every log message would also have to be stored in two separate storage systems.  

## Deploy SAS Viya Logging on OpenShift

You must use this procedure to deploy SAS Viya Logging on OpenShift. Do not use the standard logging deployment script (deploy_logging_open.sh).

1. Follow the instructions in the [logging README](../README.md#l_pre_dep) to perform the standard predeployment tasks (create a local copy of the repository and customize 
your deployment). See [Customization](#l_os_cust) for information about customization on OpenShift.

2. Use this command to log on to the cluster:
```bash
oc login [cluster-hostname] -u [userID]
```

3. Use this command to deploy SAS Viya Logging for OpenShift:
```bash
./logging/bin/deploy_logging_open_openshift.sh
```

## <a name="l_os_cust"></a>Customization 

Customization of SAS Viya Logging on OpenShift deployment follows the same process as in a standard logging deployment, which uses the USER_DIR environment variable to specify the location of your customization files. See the [logging README](../logging/README.md#log_custom) for information about the customization process.

To change the number of days that log messages from OpenShift infrastructure components 
are retained, modify the `INFRA_LOG_RETENTION_PERIOD` environment variable. The default 
value is `1` (1 day).

No customizations are required, even if you are using ingress, because the `deploy_logging_openshift.sh` script defines a route for Kibana.

OpenShift uses [route](https://docs.openshift.com/enterprise/3.0/architecture/core_concepts/routes.html) objects, a feature unique to OpenShift, to access Kibana and (optionally) the Elasticsearch API endpoint. This makes it unnecessary to configure ingress objects or surface nodePorts.

## Remove SAS Viya Logging on OpenShift

To remove the monitoring components, run this command:
```bash
./logging/bin/remove_logging_open_openshift.sh
```
By default, the removal script does not remove all of the associated Kubernetes objects. The Kubernetes configuration maps (configMaps), secrets and persistent value claims (PVC) 
created in the logging namespace during the deployment process are not removed so that you can 
redeploy the logging components without losing data or having to regenerate TLS 
certificates. The logging namespace is also not removed in case you deployed the logging components into a namespace that also hosts other content. You can specify 
environment variables to override the default behavior and control which objects are removed.
