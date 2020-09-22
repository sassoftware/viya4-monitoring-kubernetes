# Samples

Several samples are available that demonstrate how to customize the deployment
of the logging and monitoring stacks. Although each example is fairly specific
and targeted to its individual purpose, multiple samples can be combined by
merging the appropriate values in each file.

The samples include:

* [azure-deployment](azure-deployment) - Deployment to Microsoft AKS
* [azure-monitor](azure-monitor) - Enabling Azure Monitor to collect metrics
from SAS Viya components
* [external-alertmanager](external-alertmanager) - Configuring a central,
external Alert Manager instance
* [generic-base](generic-base) - Full set of cusomization files with comments
* [ingress](ingress) - How to configure host-based or path-based ingress
* [min-logging](min-logging) - Minimal logging configuration for dev or test
environments
* [namespace-monitoring](namespace-monitoring) - Separating cluster monitoring
from SAS Viya monitoring
* [tls](tls) - Enabling TLS encryption for both ingress and in-cluster
communication
