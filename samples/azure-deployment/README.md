# Deployment on Azure

This sample contains demonstrates what customizations are necessary when deploying
on Microsoft Azure. The sample assumes that NGINX ingress is used, but it can be
modified for other solutions.

## Instructions

* Copy this directory to a local directory
* Edit the sample yaml files to match your environment
* Add additional customization as desired
* `export USER_DIR=path/to/my/copy/azure-deployment`
* Run the monitoring and/or logging deploy scripts

## Notes

This sample uses path-based ingress, but this can be configured for host-based
ingress by following the [ingress sample](../ingress).

* http://host.cluster.example.com/grafana
* http://host.cluster.example.com/prometheus
* http://host.cluster.example.com/alertmanager
* http://host.cluster.example.com/kibana
