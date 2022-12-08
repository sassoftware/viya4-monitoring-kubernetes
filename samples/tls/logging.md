# Sample - TLS Enablement for Logging

**Note:** Before using this sample, be sure to read 
 [Understanding How Transport Layer Security (TLS) Is Used by SAS Viya Monitoring for Kubernetes](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm) in the SAS Viya Monitoring for Kubernetes Help Center. 

## Overview

This sample demonstrates how to enable TLS for communication into the
cluster. It does so by deploying log monitoring with TLS enabled for connections between the
user and OpenSearch Dashboards. The `TLS_ENABLE` environment variable controls whether
connections to OpenSearch Dashboards use TLS.

## About This Sample

There are two versions of this sample:

- host-based ingress
- path-based ingress

The difference between the two is in the URL that is used to access the 
applications:

- For host-based ingress, the
application name is part of the host name itself (for example,
`https://kibana.host.cluster.example.com/`).
- For path-based ingress, the host name is fixed and the application name is 
- appended as a path on the URL
(for example, `https://host.cluster.example.com/kibana`).

## Using This Sample

For information about the customization process, see 
[Pre-deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1ajbblsxpcgl5n11t13wgtd4d7c.htm).

The customization files in this sample provide a starting point for the
customization files required for a deployment that supports logging with TLS 
enabled.

In order to use the values in this sample in the customization files for your 
deployment, complete the following steps:

1. Copy the customization files from either the `host-based-ingress`
or `path-based-ingress` subdirectories to your local customization directory 
(that is, your `USER_DIR`).
2. In the configuration files, replace all instances of `host.cluster.example.com` 
with the host name that is used in your environment.
3. (Optional) Modify the files further as needed.

After you finish modifying the customization files, deploy log monitoring. See 
[Deploy](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1rhzwx0mcnnnun17q11v85bspyk.htm).

## Specifying TLS for Connections to OpenSearch Dashboards

See [Enable HTTPS Connections](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm#n1626a0u0s7fdkn1vxohz7fw3ybo).

If you specify `TLS_ENABLE=true`, the `kibana-tls-secret` Kubernetes secret
must be present. By default, the deployment script
automatically obtains the certificates from OpenSSL and creates the
`kibana-tls-secret` secret.
For more information, see
[Configure TLS Using Deployment-Generated Certificates](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm#p0dcjvqsw8pws6n1x69kqoej2n3l).

For information about creating this secret manually, see
[Create Kubernetes Secrets Using Your Own Certificates](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm#n0et53unurnaxrn11hwbwzssdi78).

## Specifying TLS for Ingress

See [Enable TLS for Ingress](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm#p1itsqky7ypohbn1txujf7jmqajb).