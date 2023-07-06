# Ingress

This sample demonstrates how to configure Kubernetes ingress for accessing the monitoring
web applications deployed as part of the SAS Viya Monitoring for Kubernetes solution.

This sample provides information for two different scenarios:
* host-based ingress
* path-based ingress


The difference between the two is in the URL that is used to access the applications:

* For host-based ingress, the application name is part of the host name itself (for example, https://grafana.host.cluster.example.com/).
* For path-based ingress, the host name is fixed and the application name is appended as a path on the URL (for example, https://host.cluster.example.com/grafana).


## Using This Sample

For information about the customization process, see 
[Pre-deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1ajbblsxpcgl5n11t13wgtd4d7c.htm).

The customization files in this sample provide a starting point for the
customization files required for a deployment that uses Kubernetes ingress
for accessing the web applications.

In order to use the values in this sample in the customization files for your 
deployment, complete the following steps:

1. Copy the customization files from either the `host-based-ingress`
or `path-based-ingress` subdirectories to your local customization directory 
(that is, your `USER_DIR`).
2. In the configuration files, replace all instances of 
   `host.cluster.example.com` with the appropriate host name for your 
   environment.
3. (Optional) Modify the files further as needed.

After you finish modifying the customization files, you may deploy
SAS Viya Monitoring for Kubernetes.  See
[Deploy](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1rhzwx0mcnnnun17q11v85bspyk.htm)


## Notes on Customization Values

- Edit the .yaml files within your `$USER_DIR/monitoring` and `$USER_DIR/monitoring`
sub-directories and replace any sample host names with the appropriate host name 
for your deployment. Specifically, you must replace `host.cluster.example.com` with 
the ingress controller's endpoint.

## Specifying TLS Certificates for use with Ingress

Starting with the 1.2.15 (19JUL23) release, SAS Viya Monitoring for Kubernetes is deployed with TLS enabled for
intra-cluster communications.  As discussed in  [Understanding How Transport Layer Security (TLS) Is Used by SAS Viya Monitoring for Kubernetes](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm) 
in the SAS Viya Monitoring for Kubernetes Help Center, the deployment scripts will automatically generate a set of
self-signed TLS certificates for this purpose if you do not specify your own.

This sample assumes that access to the web applications should also be secured using
TLS (i.e. the web-applications should be accessed via HTTPS rather than HTTP). This requires a second set of TLS 
certificates (different than those used for intra-cluster communication).  However, these certificates are **not** 
created automatically for you.  You will need to obtain these certificates and create Kubernetes secrets with specific
names to make them available to SAS Viya Monitoring for Kubernetes.
See [Enable TLS for Ingress](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm#p1itsqky7ypohbn1txujf7jmqajb).

