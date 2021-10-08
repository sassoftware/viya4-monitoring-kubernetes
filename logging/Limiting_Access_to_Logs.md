# Limiting Access to Logs

## Overview 

By default, the log monitoring capability in SAS Viya Monitoring for 
Kubernetes enables an administrator to view log information about 
everything in your deployment. However, there might be instances where 
you want to restrict the information that certain administrators can access:

- If you have log monitoring deployed in multiple namespaces (such as for Dev, Test, and Prod), you can enable a cluster administrator to access log 
information only for a specified namespace.
- If you have a multi-tenant deployment, you can enable each tenant 
administrator to access log information only for their SAS Viya tenant.

This access is controlled by a combination of Kibana tenant spaces and 
Open Distro for Elasticsearch roles, back-end roles, and role mappings. 
Scripts are provided to create everything that is needed for each 
environment.

## Implement Access Limitations for a Tenant or Namespace

Use the `/logging/bin/onboard.sh` script to implement logging access limitations for a namespace or SAS Viya tenant. The script performs these actions: 

- Creates a Kibana tenant space
- Loads Kibana content such as visualizations and dashboards into the Kibana 
tenant space
- Creates the access controls to limit access to only the appropriate 
back-end data
- Links the access controls to the Kibana tenant space
- Creates a new user that can access only the information in this 
Kibana tenant space (optional)

This is the syntax for the script:

```
/logging/bin/onboard.sh --namespace <namespace>  [--tenant <tenant>] [--user][<username>] [--password <password>]
```
The `namespace` parameter is required. It specifies the Kubernetes namespace to which access limitations are applied.

The `tenant` parameter specifies the SAS Viya tenant to which access limitations are applied.

The Kibana tenant space name is a combination of the namespace name and the 
SAS Viya tenant name (if used). For example, if you ran the script and specified only `--namespace mynamespace`, the Kibana tenant space name would be `mynamespace`. If you ran the script and specified `--namespace mynamespace --tenant mytenant1`, the Kibana tenant space name would be `mynamespace_mytenant1`. 

Specify the `--user` parameter to create an initial user with access to the 
Kibana tenant space. If you do not specify a name for the user, a user is 
created with the default name of `<Kibana tenant space name>_admin`. 
For example, if you ran the script and specified `--namespace mynamespace --tenant mytenant1 --user`, the initial user would 
be `mynamespace_mytenant1_admin`.

## Remove Access for a Tenant or Namespace

Use the `/logging/bin/offboard.sh` script to remove logging access for a namespace or SAS Viya tenant. The script performs these actions: 

- Removes the Kibana tenant space
- Removes the access controls for the Kibana tenant space

The `offboard.sh` script does not remove the initial user, if one was 
created by the `onboard.sh` script.

This is the syntax for the script:

```
/logging/bin/offboard.sh --namespace <namespace>  [--tenant <tenant>]
```
The `namespace` parameter is required. It specifies the Kubernetes namespace that identifies the Kibana tenant space to be removed.

The `tenant` parameter specifies the SAS Viya tenant that identifies the 
Kibana tenant space to be removed.

As with the `onboard.sh` script, the Kibana tenant space name is a 
combination of the namespace name and the SAS Viya tenant name (if used). For example, if you ran the script and specified only `--namespace mynamespace`, the script would remove the Kibana tenant space named `mynamespace`. If you ran the script and specified `--namespace mynamespace --tenant mytenant1`, the script would remove the Kibana tenant space named `mynamespace_mytenant1`. 

## Managing User Accounts for Restricted Access

Use the `/logging/bin/user.sh` script to create or delete Kibana accounts 
that have access to only the log messages and Kibana tenant space 
associated with a specified namespace or SAS Viya tenant. You can use 
the script to create user accounts for a Kibana tenant space anytime 
after you have run the `onboard.sh` to implement access limitations for 
the Kibana tenant space.

This is the syntax for the script to add a user:

```
/logging/bin/user.sh CREATE --namespace <namespace>  [--tenant <tenant>]  [--user][<username>] [--password <password>]
```
The `namespace` parameter is required. It specifies the Kubernetes namespace to which the user should have access

The `tenant` parameter specifies the SAS Viya tenant to which the user should have access.

If you do not specify a name for the `user` parameter, a user is 
created with the default name of `<Kibana tenant space name>_admin`. 
For example, if you ran the script and specified `--namespace mynamespace --tenant mytenant1 --user`, the user would 
be `mynamespace_mytenant1_admin`.

This is the syntax for the script to remove a user:

```
/logging/bin/user.sh DELETE --user <username>
```

## Concepts

The Open Distro for Elasticsearch security plug-in uses roles to 
control access to the logging information from 
a cluster, and index, or a Kibana tenant space. A role contains 
permissions for actions (such as cluster 
access and index access) that correspond to sources and type of log 
information. You can then assign users to roles in order to grant them 
the permissions that are defined in the role. 

A back-end role enables 
you to point to multiple roles. You can then create a single role to 
access the back-end role, so that a user can essentially be assigned 
to multiple roles at once.

The security plug-in links roles and back-end roles through role mappings.  Role mappings can also be used to define links between users and roles 
and between users and back-end roles.

When you run the `onboard.sh` script to add Kibana tenant space, two new roles are created and role mappings are defined to link the new roles (and one pre-existing role) to a new back-end role.  The following diagram depicts the roles, back-end roles and role mappings that are created when the script is run to add the SAS Viya tenant `acme` from the `production` Viya namespace:

| Back-end Role | Role | Purpose |
| --- | --- | --- |
|     | v4m_kibana_user | allows access to Kibana |
<tr/tr>
| production_acme_kibana_users | search_index_production_acme | Allows access to log messages from the `production` namespace and `acme` tenant |
<tr/tr>
|     | tenant_production_acme | Allows access to Kibana tenant space for `production_acme` |

After these access controls have been defined, you can assign the back-end role of `production_acme_kibana_users` to a user. The back-end role 
enables the user to access only:
-  log messages collected from the pods associated with the SAS Viya tenant `acme` in the `production` namespace
- Kibana `production_acme` Kibana tenant space  

In some cases, you might want to create users who cannot log into Kibana but can access the log messages collected from a specific namespace or namespace_tenant combination. These users might be needed to allow some automated process to extract log messages through API calls. To do this, assign the `search_index_ production_acme` role to the user, rather than the `production_acme_kibana_users` back-end role. Because the user has not 
also been assigned the `v4m_kibana_user` or `tenant_production_acme` 
roles, the user cannot sign into Kibana and cannot access the 
`production_acme` Kibana tenant space. 

You can also use these roles and back-end roles to create users that can access multiple tenants.  

