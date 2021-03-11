# Monitoring and Logging on Cloud Provider Platforms

This document contains information about using the SAS Viya logging and monitoring components in cloud provider platforms (Azure, Amazon, and Google) that are supported by SAS Viya.

The logging and monitoring applications provided in this repository for SAS Viya can be deployed and can run in any of the cloud provider's environments. Minimal customization is needed to deploy these applications. Because the applications provided for SAS Viya work the same way across cloud platforms, administrators can have a consistent experience when moving between cloud platforms. 

The configurations for the monitoring and logging applications provided for SAS Viya are focused on detailed metrics and messages from the applications and services that make up SAS Viya. In some cases, the monitoring application provided by a cloud provider does not support the same level of detail. For administrators who are interested in metrics and log messages from SAS Viya services and components, the applications included in this repository provide the most comprehensive view of this detailed information. For administrators who are primarily interested in information from cluster resources, native applications might provide the level of logging and monitoring support that is needed.

Although each supported cloud provider provides one or more native applications to display metrics and log messages, configuration and customization steps are required in order to integrate collected SAS Viya metric data and log messages with these applications. Samples are included in this repository to provide the steps required to display SAS Viya metrics and log messages on these applications. However, not all scenarios are currently supported.   

## Microsoft Azure

### Deploying SAS Viya Logging and Monitoring on Azure

In order to deploy SAS Viya logging and monitoring on Azure, you must create a custom Storage Class. 
Follow the procedures in the [Azure sample](/samples/azure-deployment/README.md) for information on customizing your deployment for Azure.

You must also deploy logging and monitoring using ingress.

### Using Azure's Logging and Monitoring Applications With SAS Viya

If you deploy SAS Viya in an Azure environment, you can monitor and view log information by using either Azure Monitor or the SAS Viya logging and monitoring components. In order to determine which 
solution is right for your environment, you must consider the monitoring needs of both the cluster administrator and the SAS Viya administrator and compare the capabilities of the monitoring solutions. See [Choose a Monitoring Strategy for an Azure Environment](https://go.documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=v_001LTS&docsetId=calmonitoring&docsetTarget=n0okndfnjiwcxmn1ci29kjroaamp.htm&locale=en#n006zgl0bnp8txn15azzj13z8ww8) in the SAS Viya documentation for complete information. 

## Amazon Elastic Kubernetes Service (EKS)

### Deploying SAS Viya Logging and Monitoring on Amazon EKS

In order to use the SAS Viya monitoring and logging components in an Amazon EKS environment, you must deploy monitoring and logging using ingress. See the [Ingress sample](/samples/ingress/README.md) for deployment information.

No other customization is needed to deploy and run the SAS Viya logging and monitoring components on Amazon EKS.

### Using Amazon EKS Logging and Monitoring Applications With SAS Viya

If you deploy SAS Viya in an Amazon EKS environment, you can view metric information by using either the SAS Viya monitoring components or Amazon's monitoring application, CloudWatch. In order to use CloudWatch to monitor SAS Viya metrics, you must deploy the CloudWatch agent for Prometheus, make configuration changes to convert the Prometheus metrics collected from SAS Viya into performance log events, and map the log events to CloudWatch metrics. Follow the steps in the [Amazon CloudWatch Integration sample](/samples/cloudwatch/README.md) to use CloudWatch to monitor a selected group of SAS Viya metrics. Not all SAS Viya metrics are supported by this sample, because supporting all SAS Viya metrics would require every possible combination of labels from every SAS Viya source and every metric to be mapped to CloudWatch metric types. This sample might be updated in later releases to include additional combinations of dimensions for key metrics.

Amazon CloudWatch can also display log messages collected from Fluent Bit, which is the application used by the SAS Viya logging solution. However, current samples do not provide the configuration needed to integrate SAS Viya log processing with CloudWatch.  

## Google Kubernetes Engine (GKE)

### Deploying SAS Viya Logging and Monitoring on GKE

In order to use the SAS Viya monitoring and logging components in an GKE environment, you must deploy monitoring and logging using ingress. See the [Ingress sample](/samples/ingress/README.md) for deployment information.

Depending on the size of your cluster, you might need to increase the default size of the virtual machines in your nodepool and to split the workload among multiple nodes in order for the logging and monitoring components to deploy and run successfully. 

### Using GKE Logging and Monitoring Applications With SAS Viya

Google provides support for logging and monitoring through the Google Operation Suite application. Currently, no samples are available to integrate SAS Viya metrics and log messages with Google Operations Suite. 

