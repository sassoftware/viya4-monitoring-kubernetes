# Ingress

## Overview

This sample demonstrates how to configure Kubernetes Ingress for accessing the 
web applications that are deployed as part of the SAS Viya Monitoring for Kubernetes solution.

This sample provides information about two scenarios:

* host-based Ingress
* path-based Ingress

These scenarios differ because of the URL that is used to access the applications:

* For host-based Ingress, the application name is part of the host name itself (for example, `https://grafana.host.cluster.example.com/`).
* For path-based Ingress, the host name is fixed and the application name is appended as a path on the URL (for example, `https://host.cluster.example.com/grafana`).

## Using This Sample

**Note:** For information about the customization process, see 
[Pre-deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1ajbblsxpcgl5n11t13wgtd4d7c.htm).

The customization files in this sample provide a starting point for the
customization files required by a deployment that uses Kubernetes Ingress
for accessing the web applications.

To use the sample customization files in your 
deployment, complete these steps:

1. Copy the customization files from either the `host-based-ingress`
or `path-based-ingress` subdirectories to your local customization directory 
(that is, your `USER_DIR`).
2. In the configuration files, replace all instances of 
   `host.cluster.example.com` with the applicable host name for your 
   environment.
3. (Optional) Modify the files further, as needed.

After you finish modifying the customization files, you can deploy
SAS Viya Monitoring for Kubernetes.  For more information, see
[Deploy](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1rhzwx0mcnnnun17q11v85bspyk.htm).

## Update the YAML Files

Edit the .yaml files within your `$USER_DIR/monitoring` and `$USER_DIR/monitoring`
subdirectories. Replace any sample host names with the applicable host name 
for your deployment. Specifically, you must replace `host.cluster.example.com` with 
the Ingress controller's endpoint.

## Specify TLS Certificates for Use with Ingress

As of release 1.2.15 (19JUL23), SAS Viya Monitoring for Kubernetes is deployed with TLS enabled by default for
intra-cluster communications. The deployment scripts now automatically generate a set of
self-signed TLS certificates for this purpose if you do not specify your own. For details, see [Understanding How Transport Layer Security (TLS) Is Used by SAS Viya Monitoring for Kubernetes](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm).

This sample assumes that access to the web applications also should be secured using
TLS (that is, the web applications should be accessed via HTTPS instead of HTTP). This requires a second set of TLS 
certificates that differ from those used for intra-cluster communication.  However, these certificates are **not** 
created automatically for you.  You must obtain these certificates, create Kubernetes secrets with specific
names, and make them available to SAS Viya Monitoring for Kubernetes.
For details, see [Enable TLS for Ingress](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_002&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm#n1osex1toskmixn19ccxb3lgkwb1).

## Access the Applications

### When Using Host-Based Ingress

**Note:** Be sure to replace the placeholder host names with the host names that you specified in your environment.

When you deploy using host-based Ingress, the following applications are available at these locations:

* Grafana - `https://grafana.host.mycluster.example.com`
* OpenSearch Dashboards - `https://dashboards.host.mycluster.example.com`

If you have chosen to make the following applications available and you have configured host-based
Ingress, the applications are available at these locations:

* Prometheus - `https://prometheus.host.mycluster.example.com`
* Alertmanager - `https://alertmanager.host.mycluster.example.com`
* OpenSearch - `https://search.host.mycluster.example.com`

### When Using Path-Based Ingress

**Note:** Be sure to replace the placeholder host names with the host names that you specified in your environment.

When you deploy using path-based Ingress, the following applications are available at these locations. 

* Grafana - `https://host.mycluster.example.com/grafana`
* OpenSearch Dashboards - `https://host.mycluster.example.com/dashboards`

If you have chosen to make the following applications available and you have configured path-based Ingress, the applications are available at these locations:

* Prometheus - `https://host.mycluster.example.com/prometheus`
* Alertmanager - `https://host.mycluster.example.com/alertmanager`
* OpenSearch - `https://host.mycluster.example.com/opensearch`
