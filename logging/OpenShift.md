# SAS Viya Log Monitoring on OpenShift

## NOTE: OpenShift Support is Experimental

Support for SAS Viya Logging on OpenShift continues to be developed, so it is
currently considered to be EXPERIMENTAL. Variable names, defaults, and usage
may change until deployment on OpenShift is officially supported.

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
therefore not recommended. Using both logging solutions results in two
daemonsets being used, each of which deploys separate log collection pods
(Fluent Bit for SAS Viya Logging and Fluentd for Openshift cluster logging)
on every node in the cluster. Every log message would also have to be stored
in two separate storage systems.

## Deploy SAS Viya Logging on OpenShift

You must use this procedure to deploy SAS Viya Logging on OpenShift. Do not use
the standard logging deployment script (deploy_logging_open.sh).

1. Follow the instructions in the [logging README](../README.md#l_pre_dep) to
perform the standard predeployment tasks (create a local copy of the
repository and customize your deployment). See [Customization](#l_os_cust)
for information about customization on OpenShift.

2. Use this command to log on to the cluster:

```bash
oc login [cluster-hostname] -u [userID]
```

3. Use this command to deploy SAS Viya Logging for OpenShift:

```bash
./logging/bin/deploy_logging_open_openshift.sh
```

## <a name="l_os_cust"></a>Customization

#### General Customization

Customization of SAS Viya Logging on OpenShift deployment follows the same
process as in a standard logging deployment, which uses the USER_DIR
environment variable to specify the location of your customization files.
See the [logging README](../logging/README.md#log_custom) for information
about the customization process.

### OpenShift-Specific Customization and Information

#### OpenShift Infrastructure Message Retention

An additional index management policy, named `viya_infra_idxmgmt_policy`, is added
in an OpenShift environment. The policy manages log messages from OpenShift
infrastructure namespaces (which is ny namespace that starts with "openshift").
Because the OpenShift infrastructure namespaces can generate a large number of
log messages, you can use the policy to change the number of days tha t these
log messages are retained. To change the retention period, modify the
`INFRA_LOG_RETENTION_PERIOD` environment variable. The default value is `1` (1 day).

***Note:*** See [Log Retention](Log_Retention.md) for information
about the index policies and log message retention for SAS Viya, Kubernetes,
and logging components.

#### Access Using Route Objects

OpenShift uses [route](https://docs.openshift.com/enterprise/3.0/architecture/core_concepts/routes.html)
objects, a feature unique to OpenShift, to access Kibana and (optionally) the
Elasticsearch API endpoint. This makes it unnecessary to configure ingress
objects or surface nodePorts. No customizations are required, even if you are
using ingress, because the `deploy_logging_open_openshift.sh` script defines
a route for Kibana.

#### TLS

OpenShift route objects that are created as part of SAS Viya Logging
deployment are TLS-enabled. The routes are configured
with re-encrypt termination, which means that traffic is encrypted between the user
and OpenShift and again within the OpenShift cluster. The TLS certificates used on
OpenShift come from the same Kubernetes secrets as a standard logging deployment:

***In-Cluster TLS:***

- `es-transport-tls-secret`
- `es-rest-tls-secret`
- `es-admin-tls-secret`

***Ingress TLS:***

- `kibana-ingress-tls-secret`
- `elasticsearch-ingress-tls-secret`

By default, the deployment process uses cert-manager to obtain and manage the
certificates used for in-cluster TLS. If the Ingress secrets are not populated,
default certificates are provided by OpenShift.

You can also use your own TLS certificates to populate the Kuberbetes secrets.
See [Notes_on_using_TLS](Notes_on_using_TLS.md) for information about replacing
the in-cluster secrets and [Sample - TLS Enablement for Logging](../samples/tls/logging/README.md)
for information about replacing the Ingress secrets.

#### Enable Access to the Elasticsearch API Endpoint

You can make the Elasticsearch API accessible so that users can query Elasticsearch
by using the `getlogs.sh` script or curl commands. To make the API endpoint
accessible, set the `OPENSHIFT_ES_ROUTE_ENABLE` environment variable to `true` before
you deploy the logging components.

If you need to make the API endpoint accessible after deployment is complete, run
the `create_openshift_route.sh` script and pass the `ELASTICSEARCH` argument:

```bash
./logging/bin/create_openshift_route.sh ELASTICSEARCH
```

To remove access to the API endpoint, use the oc command to delete the route:

```bash
oc -n $LOG_NS delete route v4m-es-client-service
```

***Note:*** Do not use the `es_nodeport_enable.sh` and `es_nodeport_enable.sh` scripts
in an OpenShift environment.

#### Customizing Routes

Routes may be configured to be host-based (default) or path-based. When
using host-based routes, the name of the application is part of the hostname
in the URL (for example:
`https://v4m-kibana-monitoring.apps.my-openshift-cluster.com`).
When using path-based routes, the application name only appears as part of the
path at the end of the URL (for example:
`https://v4m-logging.apps.my-openshift-cluster.com/kibana`).

Specify `OPENSHIFT_PATH_ROUTES=true` in the `$USER_DIR/user.env` file
(applies to both logging and monitoring) or the `$USER_DIR/logging/user.env`
file (for only logging components) to use path-based routes.

The hostnames for Kibana and Elasticsearch can be configured using
`OPENSHIFT_ROUTE_HOST_KIBANA` and/or `OPENSHIFT_ROUTE_HOST_ELASTICSEARCH`
(if the Elasticsearch route is enabled) in `$USER_DIR/user.env` or
`$USER_DIR/logging/user.env`. Note that OpenShift does not allow the use
of the same across namespaces, so do not use the same hostname across
logging and monitoring.

## Remove SAS Viya Logging on OpenShift

To remove the monitoring components, run this command:

```bash
./logging/bin/remove_logging_open_openshift.sh
```

By default, the removal script does not remove all of the associated Kubernetes
objects. The Kubernetes configuration maps (configMaps), secrets and
persistent value claims (PVC) created in the logging namespace during the
deployment process are not removed so that you can redeploy the logging
components without losing data or having to regenerate TLS certificates. The
logging namespace is also not removed in case you deployed the logging
components into a namespace that also hosts other content. You can specify
environment variables to override the default behavior and control which
objects are removed.
