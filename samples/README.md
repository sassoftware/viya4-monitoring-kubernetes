# Samples

Samples are provided to demonstrate how to customize the deployment
of the logging and monitoring components for specific situations. The samples provide instructions and example yaml files that you can modify to fit your environment. Although each example focuses on a specific scenario, you can combine multiple samples by merging the appropriate values in each deployment file.

You customize your logging deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. The configuration files in each sample provide a starting point for the configuration files for a deployment that supports a specific situation. See the 
[main README](../README.md#customization) to for information about the customization process.

In order to use the values in a sample in the customization files for your deployment, you can use one of these approaches:

- Copy the configuration files from the sample to your local configuration directory, then modify the files further as needed.
- Copy the configuration files from the `generic-base` sample to your local configuration directory to provide a known basic configuration, then manually copy the contents from the files in this sample to your local configuration files.

If you also need to use values from another sample, manually copy the values to your configuration files after you add the values in this sample. 

After you finish modifying the configuration files, deploy monitoring and logging using the standard deployment scripts.

These samples are provided:

* [azure-deployment](azure-deployment) - Deploys on Microsoft Azure Kubernetes Service (AKS)
* [azure-monitor](azure-monitor) - Enables Azure Monitor to collect metrics
from SAS Viya components
* [external-alertmanager](external-alertmanager) - Configures a central external Alert Manager instance
* [generic-base](generic-base) - Does not support a specific scenario, but provides a full set of customization files with comments
* [ingress](ingress) - Deploys using host-based or path-based ingress
* [min-logging](min-logging) - Provides a minimal logging configuration for dev or test environments
* [namespace-monitoring](namespace-monitoring) - Separates cluster monitoring
from SAS Viya monitoring
* [tls](tls) - Enables TLS encryption for both ingress and in-cluster
communication
