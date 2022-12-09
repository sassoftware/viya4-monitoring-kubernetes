# Implementing Access Limitations for Logging for Tenants

If you are the provider administrator in a SAS Viya multi-tenant 
environment, you 
can implement access controls so that the administrators of each 
SAS Viya tenant can view only the log messages associated with the 
tenant and 
access only the OpenSearch Dashboards resources for the tenant. Scripts are provided 
to manage the access controls for SAS Viya tenants.

Use the `/logging/bin/onboard.sh` script to implement logging access limitations 
for a SAS Viya tenant.

Use the `/logging/bin/offboard.sh` script to remove logging access 
for a SAS Viya tenant.

Use the `/logging/bin/user.sh` script to create or delete OpenSearch accounts 
that have access to only the log messages and OpenSearch Dashboards-tenant space 
associated with a specified SAS Viya tenant.

For information about using these scripts, see 
[Controlling User Access to Log Monitoring](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p1nee94eh0x1ymn1blz03g48jz2y.htm) in the SAS Viya Monitoring for Kubernetes Help Center.