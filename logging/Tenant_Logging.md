# Implementing Access Limitations for Logging for Tenants

If you are the provider administrator in a SAS Viya multi-tenant 
environment, you 
can implement access controls so that the administrators of each 
SAS Viya tenant can view only the log messages associated with the 
tenant and 
access only the Kibana resources for the tenant. Scripts are provided 
to manage the access controls for SAS Viya tenants.

Use the `/logging/bin/onboard.sh` script to implement logging access limitations 
for a SAS Viya tenant.

Use the `/logging/bin/offboard.sh` script to remove logging access 
for a SAS Viya tenant.

Use the `/logging/bin/user.sh` script to create or delete Kibana accounts 
that have access to only the log messages and Kibana tenant space 
associated with a specified SAS Viya tenant.

See [Limiting Access to Logs](Limiting_Access_to_Logs.md) for information 
about using these scripts.

