# Ingress using HTTP rather than HTTPS

This scenario, like the others in this sample, describes how to configure Kubernetes
ingress for accessing the monitoring web applications deployed as part of
the SAS Viya Monitoring for Kubernetes solution.  However, in this scenario,
ingress is configured to permit access via HTTP rather than HTTPS.

**Requiring the use of HTTPS when accessing web applications is generally considered
to be more secure.**

## Overview

To configure ingress to use HTTP rather than HTTPS, follow the steps outlined in 
one of the other two scenarios (e.g. host-based ingress or path-based ingress) in 
this sample.  However, before running the deployment scripts, you will need to make
a small number of changes.

## Details

Make the following changes in all of the user-values-*.yaml files in your USER_DIR/logging 
and/or USER_DIR/monitoring directories (depending on which components you are 
deploying):

* Change the value of the `ingress.annotations.nginx.ingress.kubernetes.io/backend-protocol`
key from **'HTTPS'** to **'HTTP'**.
* Remove the entire `tls` stanza from the `ingress` section(s) of the yaml files.

