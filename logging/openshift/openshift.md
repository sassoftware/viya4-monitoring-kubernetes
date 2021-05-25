# SAS Viya Log Monitoring on OpenShift

## Overview

If you deploy SAS Viya on Red Hat OpenShift, you can use either the OpenShift logging components 
or the SAS Viya logging components to view SAS Viya log messages. 

If the optional OpenShift logging components have already been deployed, you can use 
them to view SAS Viya log messages. However, the messages from third-party components 
of SAS Viya will be displayed differently than the messages from the SAS Viya components, 
which might make message parsing and interpretation more difficult.

If the Openshift logging components have not been installed, you can choose to deploy 
the SAS Viya logging components. Deploying the SAS Viya logging components on 
OpenShift uses a different process than deploying on generic Kubernetes, so you 
must follow the procedure in this document. 

Although you can deploy the SAS Viya logging components even if the the OpenShift 
logging components are also deployed, this configuration is inefficient and 
therefore not recommended. Using both sets of components results in two daemonsets   
being used, each of which deploys separate log collection pods (Fluent Bit for 
SAS Viya logging and Fluentd for Openshift logging) on every node in the cluster. 
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
