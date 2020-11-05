# Monitoring using Fluent-bit and Azure Log Analytics Workspaces

## Introduction
As an alternative to monitoring SAS Viya using the Elasticsearch-centered
monitoring stack that is the current primary focus of this project, it is
possible monitor your SAS Viya deployments using a combination of Fluent
Bit and Log Analytics Workspaces, a feature of the Microsoft Azure cloud.
Our work on this approach has been limited, to date, primarily focused on
proving out the concept.

## Technical Overview
In this approach log collection continues to be performed by Fluent Bit
pods deployed cluster-wide via a Kubernetes DaemonSet.  This allows users to
benefit from the extensive work done to date on parsing and processing log
messages from all of the components of SAS Viya including the third-party
products.  This results in all log messages being handled consistently
regardless of which component emitted the log message originally.  However,
rather than sending the processed log messages to Elasticsearch, in this
approach the messages are loaded into a Log Analytics Workspace as a "custom
log" source.  This allows users to leverage the Azure Monitor capabilities for
exploring, filtering and reporting on the collected log messages.

**It should be noted that Azure Monitor and Log Analytics Workspaces are
optional features of Microsoft Azure requiring users to agree to additional
licensing terms and incurring additional charges. Users should make sure
they understand the terms and charges before deploying this stack.**

## Deploying the Fluent Bit + Azure Log Analytics Workspace Stack
To deploy this alternate technology stack run the **deploy_logging_azmonitor.sh**
script located in the **logging/bin** directory.  This script supports the
many of the same features as our primary deployment scripts, including
the user of a USER_DIR for customization.  In addition to deploying
Fluent Bit, by default, this script also deploys the Event Router, a component
that surfaces Kubernetes events as pseudo-log messages alongside the log
messages collected by Fluent Bit.
Removing this alternate technology stack by running the **remove_logging_azmonitor.sh**
script located in the **logging/bin** directory.  By default, this
script does NOT delete the namespace.
## Required Connection Information
The deployment script assumes a Log Analytics Workspace has *already* been
created.  Consult the Azure documentation for how the specifics of how this
can be done.  Once the Log Analytics Workspace has been created, you will need
pass connection information (via environment varibles) about it to the deployment
script.  The connection information needed is summarized below:
|Environment Variable|Log Analytics Workspace Information|
|--------------------|-----------------------------------|
|AZMONITOR_CUSTOMER_ID| Customer ID |
|AZMONITOR_SHARED_KEY| Primary Shared Key|

This information is available via the Azure Portal or from the Azure CLI.
The following commands show how this information can be obtained. 
Remember to use replace the sample resource group name and workspace
names shown below with the names of the resource group and workspace
you have created. The Azure CLI may be acccessed via a different name or
alias in your environment.
### Obtaining the Customer ID via the Azure CLI
```
az monitor log-analytics workspace show --resource-group myresourcegroup-rg --workspace-name myworkspace --query customerId
```
### Obtaining the Shared Keys via the Azure CLI
```
 az monitor log-analytics workspace get-shared-keys --resource-group myresourcegroup-rg --workspace-name myworkspace
```
Note: Two shared keys, labeled ***"primarySharedKey"*** and ***"secondarySharedKey"*** will be returned;
use the value of the ***primarySharedKey*** to set the approprite environment variable.
## Table and Variable Naming
After deploying this technology stack, collected log messages will appear as
a new table, **viya_logs_CL**, in the ***Custom Logs*** grouping within the
specified Log Analytics Workspace.  The structure of this table is very similar
to the structure of the log messages surfaced in Kibana when deploying the
projects Elasticsearch-centered stack.  However, due to features of the Azure
API, the names of some fields will be slightly different.  The tables feature
a flattened data-model, so multi-level JSON fields will appear as multiple
fields with the JSON hiearchy embedded in the fields name.  In addition, most
fields will have a suffix added to to their name indicating its data type,
such as ***_s*** for string fields and ***_d*** for a numeric (double) field.
As an example, Fluent Bit adds Kubernetes metadata to each message, including
the namespace and name of the pod  from which the message was collected.  This
information is nested in two fields, namespace and pod, under a top-level field
called kube creating the fields kube.namespace and kube.pod.  These fields
appear in the **viya_logs_CL** table as **kube_namespace_s** and **kube_pod_s**.

## Using the Data
While a full discussion of how the collected log messages can be used within 
Azure Monitor and Log Analytics Workspaces is out-of-scope for this document, 
we can provide a couple of tips to help you get started.
###  Kusto Queries
The Kusto is the powerful query language used within Log Analytics Workspaces
and Azure Monitor.  After selecting your Log Analytics Workspace in the Azure
Portal, an interactive query window is available by selecting the **Logs** item
(under the ***General*** heading) in the left-hand menu (as shown in the screen
capture below).  The query window also allows you to display query results as
charts or graphs.  It also allows you to export the results or add them to your
Azure dashboard.  Your Kusto queries can also be used as part of Workbooks.
### Sample Query #1: Show Log Messages collected in the last 5 minutes
The following Kusto query returns all of the log messages collected in the last
5 minutes.
```
viya_logs_CL 
| where TimeGenerated > ago(5m)
```
Note that if a query returns a very large number of results, only the first
10,000 results are shown and a message indicating that is displayed.
### Sample Query #2: Selecting specific fields to display
The following Kustom query is very similar to the previous one but only returns
specific fields.  This may make it easier to interpret the results.
```
viya_logs_CL
| where TimeGenerated > ago(5m)
| project TimeGenerated, Level, logsource_s, Message
```
### Sample Query #3: Message Counts by Message Severity and Source
The following query returns the number of log messages generated over the last
5 minutes summarized by message severity (**Level**) and source (**logsource_s**).
Notice that you can see these results displayed in chart form (in addition to
tabular results) by clicking on the **Chart** item in the menu directly above
the results output.
```
viya_logs_CL
| where TimeGenerated > ago(5m)
| project TimeGenerated, Level, logsource_s
| summarize msgcount=count() by Level, logsource_s
```
![Azure Log Analytics Workspace - Kusto Query](../img/screenshot-kustoquery-chart.png)
