# Deploying Monitoring for Tenants

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

### Secrets for In-Cluster TLS

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

* `prometheus-tenant-tls-secret`
* `grafana-tenant-tls-secret`

If any of the required certificates do not exist, the deployment process attempts to use [cert-manager](https://cert-manager.io/) (version v1.0 or later) to generate the missing
certificates. If the required certificates do not exist and cert-manager is
not available, the deployment process fails. cert-manager is not required
if TLS is disabled or if all of the TLS secrets exist prior to deployment.
 
## Deploy Monitoring Components for a Tenant

Before deploying monitoring for a tenant, you must deploy both the cluster 
monitoring components and the SAS Viya monitoring components. See the 
[monitoring README](README.md) for information.

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


