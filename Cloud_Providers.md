# Monitoring and Logging on Cloud Provider Platforms

This document contains information about using the SAS Viya logging and monitoring components in cloud provider platforms (Azure, Amazon, and Google) that are supported by SAS Viya.

The SAS Viya logging and monitoring applications provided in this repository can be deployed and can run in any of the cloud provider's environments. The applications must be deployed using ingress, but minimal additional customization is needed. Because the applications provided for SAS Viya work the same way across cloud platforms, administrators can have a consistent experience when moving between cloud platforms. 

As an alternative to using the SAS Viya logging and monitoring applications, you might choose to use the cloud provider's native application for viewing metric data and log messages. However, there are considerations with coverage and configuration if you choose to use a native monitoring application with SAS Viya.  

The configurations for the monitoring and logging applications provided for SAS Viya are focused on detailed metrics and messages from the applications and services that make up SAS Viya. In some cases, the cloud provider's native monitoring application does not support the same level of detail. For administrators who are interested in metrics and log messages from SAS Viya services and components, the SAS Viya monitoring and logging applications included in this repository provide the most comprehensive view of this detailed information. For administrators who are primarily interested in information from cluster resources, the cloud provider's native monitoring application might provide the level of logging and monitoring support that is needed.

Configuration and customization steps are required in order to integrate the collected SAS Viya metric data and log messages with native monitoring applications. Samples are included in this repository to provide the steps required to display SAS Viya metrics and log messages on some native monitoring applications, although samples are not currently provided for all possible scenarios.   

## Microsoft Azure

### Deploying SAS Viya Logging and Monitoring on Azure

The default Azure StorageClass is not large enough for use with SAS Viya logging and monitoring. You can use a StorageClass other than the default, or you can create a custom StorageClass. The procedures in the [Azure sample](/samples/azure-deployment/README.md) provide information about creating a custom StorageClass. 

In order to use the SAS Viya monitoring and logging components in an Azure environment, you must deploy monitoring and logging using ingress. The [Azure sample](/samples/azure-deployment/README.md) includes deployment using ingress. The procedure in the [Ingress sample](/samples/ingress/README.md) also provides information about deployment using ingress.

### Alternative Monitoring Approach: Using Azure's Logging and Monitoring Applications With SAS Viya

As an alternative to using the SAS Viya monitoring and logging applications, you can use Azure Monitor, which is Azure's monitoring application. In order to determine which 
solution is right for your environment, you must consider the monitoring needs of both the cluster administrator and the SAS Viya administrator and compare the capabilities of the monitoring solutions. See [Choose a Monitoring Strategy for an Azure Environment](https://go.documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=v_001LTS&docsetId=calmonitoring&docsetTarget=n0okndfnjiwcxmn1ci29kjroaamp.htm&locale=en#n006zgl0bnp8txn15azzj13z8ww8) in the SAS Viya documentation for complete information. 

## Amazon Elastic Kubernetes Service (EKS)

### Deploying SAS Viya Logging and Monitoring on Amazon EKS

In order to use the SAS Viya monitoring and logging components in an Amazon EKS environment, you must deploy monitoring and logging using ingress. See the [Ingress sample](/samples/ingress/README.md) for deployment information.

No other customization is needed to deploy and run the SAS Viya logging and monitoring components on Amazon EKS.

### Alternative Monitoring Approach: Using Amazon EKS Logging and Monitoring Applications With SAS Viya

As an alternative to using the SAS Viya monitoring and logging applications, you can use CloudWatch, which is Amazon EKS's monitoring application. 

If you choose to use CloudWatch to monitor SAS Viya metrics, you must deploy the CloudWatch agent for Prometheus, make configuration changes to convert the Prometheus metrics collected from SAS Viya into performance log events, and map the log events to CloudWatch metrics. Follow the steps in the [Amazon CloudWatch Integration sample](/samples/cloudwatch/README.md) to use CloudWatch to monitor a selected group of SAS Viya metrics. Not all SAS Viya metrics are supported by this sample, because supporting all SAS Viya metrics would require every possible combination of labels from every SAS Viya source and every metric to be mapped to CloudWatch metric types. This sample might be updated in later releases to include additional combinations of dimensions for key metrics.

Amazon CloudWatch can also display log messages collected from Fluent Bit, which is the application used by the SAS Viya logging solution. However, there are differences in the formatting of log messages produced by SAS Viya applications and services. Although these messages are processed by the SAS Viya logging applications so that Kibana displays them using a consistent format, these messages are displayed in different formats on CloudWatch. 

## Google Kubernetes Engine (GKE)

### Deploying SAS Viya Logging and Monitoring on GKE

In order to use the SAS Viya monitoring and logging components in an GKE environment, you must deploy monitoring and logging using ingress. See the [Ingress sample](/samples/ingress/README.md) for deployment information.

### Alternative Monitoring Approach: Using GKE Logging and Monitoring Applications With SAS Viya

As an alternative to using the SAS Viya monitoring and logging applications, you can use Google Cloud's operations suite, which is Google's set of monitoring applications.

In future releases, samples might be developed to provide procedures for integrating SAS Viya metrics and log monitoring with the applications in Google Cloud's operations suite.
