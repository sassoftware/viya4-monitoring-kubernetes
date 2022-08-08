# Sample - TLS Enablement for Logging

**Note:** Before using this sample, be sure to read 
[Understanding How Transport Layer Security (TLS) Is Used by SAS Viya Monitoring for Kubernetes](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=callogging&docsetTarget=p1lpu39g0ynczrn1jmcz4p49x1w6.htm) 
in the SAS Viya Administration Help Center. 

## Overview

This sample demonstrates how to enable TLS for communication into the
cluster. It does so by deploying log-monitoring with TLS enabled for connections between the
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
[Pre-deployment](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=callogging&docsetTarget=p1j31coiuoun6mn1om73shkcq4ut.htm) in the SAS Viya Administration Help Center.

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
[Deploy](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=callogging&docsetTarget=p0288u3wuftagyn1x1965tatn4zu.htm) in the SAS Viya Administration Help Center.

## Specifying TLS for Connections to OpenSearch Dashboards

See [Enable HTTPS Connections to OpenSearch Dashboards](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=callogging&docsetTarget=p1lpu39g0ynczrn1jmcz4p49x1w6.htm#p1u9i94g6fcmusn1n8284qegjtow) 
in the SAS Viya Administration Help Center.

If you specify `TLS_ENABLE=true`, the `kibana-tls-secret` Kubernetes secret
must be present. By default, the deployment script
automatically obtains the certificates from OpenSSL and creates the
`kibana-tls-secret` secret.
For more information, see
[Configure TLS Using Deployment-Generated Certificates](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=callogging&docsetTarget=p1lpu39g0ynczrn1jmcz4p49x1w6.htm#n0dung19iw8t9un17qsxhqkwclzp) 
in the SAS Viya Administration Help Center.

For information about creating this secret manually, see
[Create Kubernetes Secrets Using Your Own Certificates](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=callogging&docsetTarget=p1lpu39g0ynczrn1jmcz4p49x1w6.htm#p1dvch59jjskz8n0zvfpw4q81tq7) 
in the SAS Viya Administration Help Center.

## Specifying TLS for Ingress

See [Enable TLS for Ingress](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=callogging&docsetTarget=p1lpu39g0ynczrn1jmcz4p49x1w6.htm#n05lzm6u60rczwn14kzduswmcggl) 
in the SAS Viya Administration Help Center.