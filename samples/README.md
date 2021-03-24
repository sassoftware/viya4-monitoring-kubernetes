# Samples

Samples are provided to demonstrate how to customize the deployment
of the logging and monitoring components for specific situations. The samples provide instructions, files, and scripts, as appropriate. 

Some samples use the deployment customization process, while others deploy specialized components to support specific scenarios.

## Customization-Based Samples

Samples are provided to demonstrate how to customize the deployment
of the logging and monitoring components for specific situations. The samples provide instructions, example yaml files that you can modify to fit your environment, and scripts, as appropriate. Although each example focuses on a specific scenario, you can combine multiple samples by merging the appropriate values in each deployment file.

You customize your logging deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. See the 
[main README](../README.md#customization) to for information about the customization process.

The customization files in each sample provide a starting point for the customization files for a deployment that supports a specific situation. 

In order to minimize the potential for errors, you should not manually create the customization files, but use one of these sample files as the starting point for your own customizations. 

If your situation matches one of the specialized samples, you can copy the customization files for the sample that most closely matches your environment from the repository to your customization file directory. This enables you to start your customization with a set of values that are valid for your situation. You can then make further modifications to the files.

If your situation does not match any of the specialized samples, copy the `generic-base` sample as a base for your customization files, and then change the values or copy values from other samples to match your environment. 

If more than one sample applies to your environment, you can manually copy the values from the other sample files to the files in your customization directory.

After you finish modifying the configuration files, deploy monitoring and logging using the standard deployment scripts.

These samples are provided:

* [azure-deployment](azure-deployment) - Deploys on Microsoft Azure Kubernetes Service (AKS)
* [azure-monitor](azure-monitor) - Enables Azure Monitor to collect metrics
from SAS Viya components
* [external-alertmanager](external-alertmanager) - Configures a central external Alertmanager instance
* [generic-base](generic-base) - Does not support a specific scenario, but provides a full set of customization files with comments
* [ingress](ingress) - Deploys using host-based or path-based ingress
* [min-logging](min-logging) - Provides a minimal logging configuration for dev or test environments
* [namespace-monitoring](namespace-monitoring) - Separates cluster monitoring
from SAS Viya monitoring
* [tls](tls) - Enables TLS encryption for both ingress and in-cluster
communication

## Other Samples

* [Cloudwatch](cloudwatch) - Configures Amazon Cloudwatch to collect SAS Viya metrics
* [Google Cloud Operations](gke-monitoring) - Enables Google Cloud Operations to view SAS Viya metric data from Prometheus