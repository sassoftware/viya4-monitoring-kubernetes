# Sample - TLS Enablement for Monitoring

**Note:** Before using this sample, be sure to read 
 [Understanding How Transport Layer Security (TLS) Is Used by SAS Viya Monitoring for Kubernetes](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm) in the SAS Viya Monitoring for Kubernetes Help Center. 

## Overview

This sample demonstrates how to deploy metric-monitoring components with Transport 
Layer Security (TLS) enabled.

Using the `TLS_ENABLE=true` environment variable enables TLS for in-cluster
communications between monitoring components.

If you enable TLS by specifying `TLS_ENABLE=true` and you are using NodePorts,
connections between the user and the monitoring components also use TLS.

To use TLS (HTTPS) for ingress, you do not have to specify the
`TLS_ENABLE=true` environment variable. However, you must manually populate
Kubernetes ingress secrets as described below.

## About This Sample

There are two versions of this sample:

- host-based ingress
- path-based ingress

The difference between the two is in the URL that is used to access the 
applications:

- For host-based ingress, the
application name is part of the host name itself (for example,
`https://grafana.host.cluster.example.com/`).
- For path-based ingress, the host name is fixed and the application name is 
  appended as a path on the URL
(for example, `https://host.cluster.example.com/grafana`).

## Using This Sample

For information about the customization process, see 
[Pre-deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1ajbblsxpcgl5n11t13wgtd4d7c.htm).

The customization files in this sample provide a starting point for the
customization files required for a deployment that supports monitoring with TLS 
enabled.

In order to use the values in this sample in the customization files for your 
deployment, complete the following steps:

1. Copy the customization files from either the `host-based-ingress`
or `path-based-ingress` subdirectories to your local customization directory 
(that is, your `USER_DIR`).
2. In the configuration files, replace all instances of 
   `host.cluster.example.com` with the host name that is used in your 
   environment.
3. (Optional) Modify the files further as needed.

After you finish modifying the customization files, deploy metric monitoring. See 
[Deploy](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1rhzwx0mcnnnun17q11v85bspyk.htm).

## Notes on Customization Values

- Set `TLS_ENABLE=true` in the `$USER_DIR/monitoring/user.env` file to specify
that Prometheus, Grafana, and Alertmanager are deployed with TLS enabled for
connections to these components. 

- The Prometheus node exporter and kube-state-metrics exporters do not
currently support TLS. These components are not exposed over ingress, so
in-cluster access uses HTTP instead of HTTPS.

- Edit the `$USER_DIR/monitoring/user-values-prom-operator.yaml` file and 
replace any sample host names with the host names for your deployment. 
Specifically, you must replace `host.cluster.example.com` with the name 
of the ingress node. Typically, the ingress node is the cluster primary node.

## Specifying TLS for Ingress

See [Enable TLS for Ingress](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p0ssqw32dy9a44n1rokwojskla19.htm#p1itsqky7ypohbn1txujf7jmqajb).