# Configure TLS for Logging

## Overview

TLS is required for communication between the Elasticsearch nodes and for accessing Elasticsearch from other components. It is also a best practice to use TLS (by using HTTPS) when accessing Kibana from a browser.

TLS requires the use of digital security certificates. These certificates allow the Elasticsearch nodes to verify their identity when establishing communication connections. For SAS Viya Monitoring, these certificates are persisted as Kubernetes secrets. Kubernetes mounts these secrets onto the various Elasticsearch and Kibana pods where they appear as files on disk. The name and location of these files is fixed by the Open Distro for Elasticsearch Helm chart and cannot be changed. 

## Configure TLS Using cert-manager

By default, the deployment process for the SAS Viya Monitoring solution uses cert-manager to obtain and manage the digital security certificates.

The deploy_logging_open.sh deployment script automatically obtains the certificates from cert-manager and creates the Kubernetes secrets with the required structure and expected names. The script ensures that the certificates are mounted on the Elasticsearch and Kibana pods in the correct locations.

## Configure TLS Without Using cert-manager

To enable TLS without using cert-manager, you must perform manual steps to obtain the digital certificates and create the corresponding Kubernetes secrets.

1. Use the method of your choice to create the files that are required to generate the Kubernetes secrets. Create these files:

   - TLS certificate (the "cert"): used to generate the tls.crt; must be an X.509 PEM certificate
   - TLS key (the "key"): used to generate the tls.key; must be an X.509 PEM key
   - key from the certificate authority (the "CA key"): used to generate the ca.crt; must be an X.509 PEM certificate

2. Create each of the Kubernetes secrets:

```bash
kubectl -n <namespace> create secret generic <secret-name> --from-file=tls.crt=<tls_cert_name>.pem --from-file=tls.key=<key_name>.key --from-file=ca.crt=<CA_key_name>.pem
```

By default, the value of `namespace` that is used during the deployment process is `logging`. The value of `secret-name` can be one of the following:

   - `es-transport-tls-secret`: used to establish communications between Elasticsearch nodes
   - `es-rest-tls-secret`: used to establish communications between Elasticsearch and incoming REST call traffic
   - `es-admin-tls-secret`: used to establish communications for internal administration actions that are performed locally on the Elasticsearch nodes

Use the appropriate values for `tls_cert_name`, `key_name`, and `CA_key_name` for each secret that that is being generated.

3. Repeat Step 2 to create all three of the required Kubernetes secrets.

4. Obtain the subject information from the certificates in order to modify the Helm chart. Run this command for the `es-transport-tls` certificate and the `es-admin-tls` certificates:

```bash
openssl x509 -subject -nameopt RFC2253 -noout -in <tls_cert_name>.pem
```

This command returns the subject information that is specified in the certificate in this form:

```bash
subject= CN=<common_name>,OU=<organization_unit>,O=<organization>,L=<location>,C=XX
```

5. Modify the file `$USER_DIR\logging\user-values-elasticsearch-open.yaml`.

   - For the value of the key `opendistro_security.nodes_dn`, specify the subject information that you obtained from the `es-transport-tls` certificate.

   - For the value of the key `opendistro_security.authcz.admin_dn`, specify the subject information that you obtained from the `es-admin-tls` certificate.

*Note:* You must specify the subject information exactly as it was returned from the certificate (without any spaces after the commas). 