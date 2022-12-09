# Deploying Monitoring for Tenants 

>**Important:** The features documented here should be considered _**EXPERIMENTAL**_.
They might be significantly changed, replaced, or removed in later releases. 
Feedback is welcomed about this functionality including requirements, usage
scenarios, and required options.

## Overview

If you are the provider administrator in a multi-tenant environment, you can 
provide monitoring capabilities for the tenant administrators in your 
environment. The tenant administrator can view CAS and SAS job metric 
information for only their tenant. The provider administrator can view 
information for all tenants.

Monitoring components are deployed individually for each tenant, so you 
can choose which tenants can have monitoring capability. The process of 
deploying monitoring components for a tenant deploys instances of 
both Prometheus and Grafana that are specific to the tenant. These 
instances require fewer resources than the instances for cluster 
monitoring, because the tenant-specific Prometheus instance collects 
information only for the tenant and the tenant-specific Grafana 
instance contains its own user definitions and includes only 
three dashboards. 

## Secrets for In-Cluster TLS

For information about TLS for in-cluster communications, see 
[Understanding How Transport Layer Security (TLS) Is Used by SAS Viya Monitoring for Kubernetes](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm) in the Help
Center. 

The [TLS Monitoring sample](/samples/tls/monitoring) contains information about
specifying the `TLS_ENABLE` environment variable to use TLS for in-cluster
communications between the components and to use TLS for connections between
the user and the monitoring components when using NodePorts. If you only use
TLS (HTTPS) for ingress, you do not have to specify the environment variable
`TLS_ENABLE=true`, but you must manually populate Kubernetes ingress secrets
as specified in the [TLS Monitoring sample](/samples/tls/monitoring).

The deployment script for the tenant monitoring components uses these 
TLS secrets for the TLS certificates that handle interactions 
between components:

* `prometheus-<tenant-name>-tls-secret`
* `grafana-<tenant-name>-tls-secret`

If any of the required certificates do not exist, the deployment process attempts to use [cert-manager](https://cert-manager.io/) (version v1.0 or later) to generate the missing
certificates. If the required certificates do not exist and cert-manager is
not available, the deployment process fails. cert-manager is not required
if TLS is disabled or if all of the TLS secrets exist prior to deployment.
 
## Customize and Deploy Monitoring Components for a Tenant

Before deploying monitoring for a tenant, you must deploy both the cluster 
monitoring components and the SAS Viya monitoring components. See the 
following sections in the Help Center for information:

* [Pre-deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1ajbblsxpcgl5n11t13wgtd4d7c.htm)
* [Deploy](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1rhzwx0mcnnnun17q11v85bspyk.htm)
* [Modify the Deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n08465wdbmux9cn1iz6dk2bzdcw4.htm) 

You can customize each tenant's deployment by specifying values 
in a `*.yaml` file for each tenant. These files are stored in a local 
directory outside of your repository that is identified by the `USER_DIR` 
environment variable. See [Pre-deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1ajbblsxpcgl5n11t13wgtd4d7c.htm)
for information about the customization process.

After you create the location for your customization files, you can customize
each tenant's monitoring deployment by specifying Helm chart parameters in 
a tenant's customization file:

`$USER_DIR/monitoring/user-values-grafana-$VIYA_TENANT.yaml`

Each tenant has a separate customization file.

The tenant deployment process uses the 
[public Grafana Helm chart](https://github.com/grafana/helm-charts/tree/main/charts/grafana). 
Overrides for these 
values are specified in `monitoring/multitenant/mt-grafana-values.yaml` and 
`monitoring/multitenant/tls/mt-grafana-tls-values.yaml` (if TLS is enabled).

See [Helm Chart values](https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml) for a complete list of values that you can specify in 
your Helm chart customization file. 

To deploy the monitoring components for a tenant, issue this command: 

```bash
VIYA_NS=<your_viya_namespace> VIYA_TENANT=<tenant_name> monitoring/bin/deploy_monitoring_tenant.sh
```

The value of `your_viya_namespace` is the namespace into which you deployed 
SAS Viya monitoring components. The value of `tenant_name` is the name of 
the tenant for which you are deploying the monitoring components. You can 
specify these values on the command line or in a `user.env` file.  

## Remove Monitoring Components for a Tenant

To remove the monitoring components for a tenant, issue this command: 

```bash
VIYA_NS=<your_viya_namespace> VIYA_TENANT=<tenant_name> monitoring/bin/remove_monitoring_tenant.sh
```

The value of `your_viya_namespace` is the namespace into which you deployed 
SAS Viya monitoring components. The value of `tenant_name` is the name of 
the tenant that contains the monitoring components. You can 
specify these values on the command line or in a `user.env` file.


