# Contour

## Overview

This sample demonstrates how to configure Contour Envoy HTTPProxy resources for accessing the
web applications that are deployed as part of the SAS Viya Monitoring for Kubernetes solution.

This sample provides information about two scenarios:

* host-based
* path-based

These scenarios differ because of the URL that is used to access the applications:

* For host-based, the application name is part of the host name itself (for example, `https://grafana.host.cluster.example.com/`).
* For path-based, the host name is fixed and the application name is appended as a path on the URL (for example, `https://host.cluster.example.com/grafana`).

**Note:**  The ability to automatically generate Contour HTTPProxy resource
definitions to permit access to the web applications was added with version
`1.2.?? (released ????26)`.  Depending on your requirements, this may
eliminate the need to manually configure things as demonstrated in this
sample.  See the [Configure Contour HTTPProxy to Access to Web Applications](LINK TBD)
topic within the Help Center documentation for further information.

## Using This Sample

**Note:** For information about the customization process, see
[Create the Deployment Directory](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=p15fe8611w9njkn1fucwbvlz8tyg.htm) in the SAS Viya Monitoring for Kubernetes Help Center.

The customization files in this sample provide a starting point for the
customization files required by a deployment that uses Contour HTTPProxy
for accessing the web applications.

To use the sample customization files in your
deployment, complete these steps:

1. Copy the customization files from either the `host-based`
or `path-based` subdirectories to your local customization directory
(that is, your `USER_DIR`).
2. In the configuration files, replace all instances of
   `host.cluster.example.com` with the applicable host name for your
   environment.
3. (Optional) Modify the files further, as needed.

After you finish modifying the customization files, you can deploy
SAS Viya Monitoring for Kubernetes.  For more information, see
[Deploy](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=n1rhzwx0mcnnnun17q11v85bspyk.htm).

Once the deployment process completes, you can create the required HTTPProxy resources
by using the `kubectl apply` command pointing to appropriate YAML file(s).

## Update the YAML Files

Edit the .yaml files within your `$USER_DIR/monitoring` and `$USER_DIR/monitoring`
subdirectories. Replace any sample host names with the applicable host name
for your deployment. Specifically, you must replace `host.cluster.example.com` with
the appropriate host name.

## Create the HTTPProxy Resources
After running the deployment script, you will need to create the required HTTPProxy resource(s)
by running the `'kubectl apply` command and pointing to the appropriate YAML file(s).  The
HTTPProxy resource definitions are contained in files with names ending in `_httpproxy.yaml`.

For example, the following command would create the HTTPProxy resource needed to access
Grafana via the host-based configuration:
` kubectl -n monitoring apply -f $USER_DIR/grafana_host_httpproxy.yaml`

In the host-based configuration, a separate HTTPProxy resource is created for each web application
you make available.  In the path-based configuration, only a single HTTPProxy resource (per namespace) is needed.

## Specify TLS Certificates to Use

As of release 1.2.15 (19JUL23), SAS Viya Monitoring for Kubernetes is deployed with TLS enabled by default for
intra-cluster communications. The deployment scripts now automatically generate a set of
self-signed TLS certificates for this purpose if you do not specify your own. For details, see [Transport Layer Security (TLS): Digital Certificates and Kubernetes Secrets](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=p1tedn8lzgvhlyn1bzwgvqvv3p4j.htm#n1pnll5qjcigjvn15shfdhdhr0lz).

This sample assumes that access to the web applications also should be secured using
TLS (that is, the web applications should be accessed via HTTPS instead of HTTP). This requires a second set of TLS
certificates that differ from those used for intra-cluster communication.  However, these certificates are **not**
created automatically for you.  You must obtain these certificates, create Kubernetes secrets with specific
names, and make them available to SAS Viya Monitoring for Kubernetes.
For details, see [Enable TLS for Ingress](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=n0auhd4hutsf7xn169hfvriysz4e.htm#n13g4ybmjfxr2an1tuy6a20zpvw7).

## Access the Applications

### When Using the Host-Based Configuration

**Note:** Be sure to replace the placeholder host names with the host names that you specified in your environment.

When you deploy using the host-based configuration, the following applications are available at these locations:

* Grafana - `https://grafana.host.mycluster.example.com`
* OpenSearch Dashboards - `https://dashboards.host.mycluster.example.com`

If you have chosen to make the following applications available and you have used the host-based
configuratin, the applications are available at these locations:

* Prometheus - `https://prometheus.host.mycluster.example.com`
* Alertmanager - `https://alertmanager.host.mycluster.example.com`
* OpenSearch - `https://search.host.mycluster.example.com`

### When Using the Path-Based Configuration

**Note:** Be sure to replace the placeholder host names with the host names that you specified in your environment.

When you deploy using the path-based configuragtion, the following applications are available at these locations.

* Grafana - `https://host.mycluster.example.com/grafana`
* OpenSearch Dashboards - `https://host.mycluster.example.com/dashboards`

If you have chosen to make the following applications available and you have used the path-based configuration, the applications are available at these locations:

* Prometheus - `https://host.mycluster.example.com/prometheus`
* Alertmanager - `https://host.mycluster.example.com/alertmanager`
* OpenSearch - `https://host.mycluster.example.com/opensearch`
