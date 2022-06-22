# Configure TLS for Logging

## Overview

TLS enablement for SAS Viya logging is divided into two parts:

- **TLS for in-cluster communications**, which is between logging components within
the cluster (between the OpenSearch nodes and between OpenSearch and other logging components). TLS must be enabled on these connections.

The information in this document explains how to configure TLS 
for in-cluster communications, either automatically (using 
cert-manager to generate certificates) or by manually generating certificates.

- **TLS for communications into the cluster**, which is between Ingress or a 
user's browser (if NodePorts are used) and OpenSearch Dashboards. TLS is optional on these connections, although enabling TLS is a best practice.

For information about configuring TLS for communications into the cluster, see 
the [TLS logging sample](../samples/tls/logging/README.md).

TLS requires the use of digital security certificates. These certificates allow the OpenSearch nodes to verify their identity when establishing communication connections. For SAS Viya Monitoring, these certificates are persisted as Kubernetes secrets. Kubernetes mounts these secrets onto the various OpenSearch and OpenSearch Dashboards pods where they appear as files on disk. The name and location of these files is fixed by the OpenSearch Helm chart and cannot be changed. 

## Configure TLS Using Generated Certificates

**Note:** This topic applies to release 1.2.0 and later.

When you deploy the SAS Viya Monitoring for Kubernetes solution, the deployment process detects whether pre-existing certificates are present. If none are detected, by default the deployment process uses OpenSSL to generate the TLS certificates that it requires. After generating the certificates, they are stored as Kubernetes secrets for subsequent use.  

**Note:** Earlier releases used cert-manager to generate certificates.  You can still use cert-manager to generate the TLS certificates.  Before you run the deployment script, set the environment variable `CERT_GENERATOR` to `cert-manager`.

## Configure TLS to Use Your Own TLS Certificates

**Note:** This topic applies to release 1.2.0 and later.

Your organization might have TLS certificates already. You must have certificates for the following Kubernetes secrets:

* `es-transport-tls-secret`
    used to establish communications between OpenSearch nodes.

* `es-rest-tls-secret`
    used to establish communications between OpenSearch and incoming REST-call traffic.

* `es-admin-tls-secret`
    used to establish communications for internal administration actions that are performed locally on the OpenSearch nodes.

* `kibana-tls-secret`
    used for TLS connections between Ingress or a user's browser (if NodePorts are used) and OpenSearch Dashboards.

**Note:** To maintain compatibility, the secrets have not been renamed to indicate their support of OpenSearch and OpenSearch Dashboards.

You must pre-populate the Kubernetes secrets with your certificates before running the deployment script. Use the following steps:

1.  For each of the required certificates, you must have the following three files:

* **TLS certificate (the "cert"):** 
    used to generate the tls.crt file. It must be an X.509 PEM certificate.
* **TLS key (the "key"):** 
    used to generate the tls.key file. It must be an X.509 PEM key.
* **key from the certificate authority (the "CA key"):** 
    used to generate the ca.crt file. It must be an X.509 PEM certificate.

**Note:** The certificate that you use for the `es-admin-tls-secret` secret cannot be reused for any of the other TLS certificates. 

2. Create a Kubernetes secret by entering the following command: 

```bash
kubectl -n <namespace> create secret generic <secret-name> --from-file=tls.crt=<tls_cert_name>.pem --from-file=tls.key=<key_name>.key --from-file=ca.crt=<CA_key_name>.pem
```
Where: 
- *namespace* is the namespace used during the deployment process. By default, this value is `logging`. If you changed the default, be sure to specify the name of your namespace instead of the default.

- *secret_name* is one of the following values: 

   - `es-transport-tls-secret` 
    used to establish communications between OpenSearch nodes.
   - `es-rest-tls-secret`
    used to establish communications between OpenSearch and incoming REST-call traffic.
   - `es-admin-tls-secret`
    used to establish communications for internal administration actions that are performed locally on the OpenSearch nodes.
  - `kibana-tls-secret`
    used for TLS connections between Ingress or a user's browser (if NodePorts are used) and OpenSearch Dashboards.

- *tls_cert_name*, *key_name*, and *CA_key_name* is a set of files that you created in the step 1. You created a set for each secret that you want to generate.
  
Use the appropriate values for `tls_cert_name`, `key_name`, and `CA_key_name` for each secret that that is being generated.

3. Repeat Step 2 until you have created all four of the required Kubernetes secrets.