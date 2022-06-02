# Limiting Access to Logs

## Overview

>**Important:** As of the 1.1.3 release (mid-January 2022), a new 
administrator user, `logadm`, is available. The deployment process automatically 
creates `logadm`. It is intended to be the
primary account used for log-monitoring activity. With this change, the 
original OpenSearch Dashboards administrator account (`admin`) should be used only for OpenSearch Dashboards 
administration tasks, such as reviewing security, adjusting index management 
policies, or when the `logadm` account cannot be used.

By default, the log-monitoring capability in SAS Viya Monitoring for 
Kubernetes enables an administrator to view log information about 
everything in your Kubernetes cluster. For details, see 
[The `logadm` User and Its Access Controls](Limiting_Access_to_Logs.md#logadm).

However, there might be instances where 
you want to restrict the information that certain administrators can access.

- If you have multiple SAS Viya deployments in your cluster (for example, 
to support Dev, Test, and Prod instances), you can limit an 
administrator's access so that they can access the log information 
only for a specified namespace.
- If you have a multi-tenant SAS Viya deployment, you can limit 
each tenant administrator's access so that they can access the 
log information only for their SAS Viya tenant.

This access is controlled by a combination of OpenSearch Dashboards-tenant spaces and 
OpenSearch roles, back-end roles, and role mappings. 
Scripts are provided to create everything that is needed for each 
scenario. For details, see 
[Manage Access Controls for a Tenant or Namespace](Limiting_Access_to_Logs.md#manage_access).

## <a name="logadm"></a>The `logadm` User and Its Access Controls

The `logadm` user is the day-to-day user for log monitoring for cluster 
administrators. The `logadm` user has access to all of the log messages 
collected by the log-monitoring components. This means that the `logadm` user 
has access to the following messages: 

- log messages from all SAS Viya namespaces and all tenants within those 
  namespaces
- log messages from all namespaces that are not SAS Viya including the Kubernetes 
  infrastructure namespaces
 
Although the `logadm` user can access all of the log messages, `logadm` can 
access only the "cluster_admins" OpenSearch Dashboards-tenant space.

The access controls are designed to provide `logadm` users with full cluster 
access to perform the log-monitoring activities needed for their job.
Limiting these users to the "cluster_admins" OpenSearch Dashboards-tenant space helps in the 
following ways:

- simplifies the OpenSearch Dashboards user experience
- eliminates the potential confusion that could otherwise occur if the user 
  could access OpenSearch Dashboards content in the other OpenSearch Dashboards-tenant spaces

You can disable the creation of the `logadm` user during the deployment process. 
In the `logging/user.env` file in USER_DIR, set the LOG_CREATE_LOGADM_USER 
environment variable to 'false'. The default is to create the `logadm` user.

To set the password for the `logadm` user, set the `LOG_LOGADM_PASSWD` 
environment variable in the same file. If no password has been set for the 
`logadm` user, but a password has been set for the `admin` user (by using 
the `ES_ADMIN_PASSWD` environment variable), that password is used for the 
`logadm` user also. If neither password has been set, random passwords are 
generated for these accounts. These random passwords are displayed in the 
log messages generated during the deployment process.

For more information about user accounts, including how to change passwords, 
see [Internal Users and Passwords](https://documentation.sas.com/doc/en/sasadmincdc/default/callogging/p0d3645shytio6n1v2swjjd8faac.htm#p1t6bbyvf29tm4n1l47ujibv6r3i). 

## <a name="manage_access"></a>Manage Access Controls for a Tenant or Namespace

### Introduction

You can implement or remove logging access controls for a specific namespace or 
individual SAS Viya tenants within a given namespace. 

### Implement Access Controls for a Tenant or Namespace

Use the `onboard.sh` script from the `logging/bin` subdirectory in the repository 
to implement logging access controls for a namespace or SAS Viya tenant. 
The script performs the following actions: 

1. Create an OpenSearch Dashboards-tenant space.
2. Load OpenSearch Dashboards content such as visualizations and dashboards into the OpenSearch Dashboards-tenant space.
3. Create the access controls to limit access to only the appropriate 
back-end data.
4. Link the access controls to the OpenSearch Dashboards-tenant space.
5. (Optional) Create a new user that can access only the information in this 
OpenSearch Dashboards-tenant space.

Here is the syntax for the script:

<pre>
logging/bin/onboard.sh --namespace <i>namespace</i>  [--tenant <i>tenant</i>] 
[--user][<i>user_name</i>] [--password <i>password</i>]
</pre>

- *namespace* is required. It specifies the Kubernetes namespace to which access 
  limitations are applied.
- *tenant* specifies the SAS Viya tenant to which access limitations are applied.
- *user* specifies to create an initial user with access to the 
OpenSearch Dashboards-tenant space. 

The OpenSearch Dashboards-tenant space name is a combination of the namespace name and the 
SAS Viya tenant name (if used). For example, if you ran the script and specified 
only `--namespace mynamespace`, the OpenSearch Dashboards-tenant space name would be `mynamespace`. 
If you ran the script and specified `--namespace mynamespace --tenant mytenant1`, 
the OpenSearch Dashboards-tenant space name would be `mynamespace_mytenant1`. 

If you do not specify a name for the user, a user is 
created with the default name of `<OpenSearch Dashboards tenant space name>_admin`. 
For example, if you ran the script and specified `--namespace mynamespace 
--tenant mytenant1 --user`, the initial user would 
be `mynamespace_mytenant1_admin`.

### Remove Access for a Tenant or Namespace

Use the `offboard.sh` script from the `logging/bin` subdirectory in the repository 
to remove logging access for a 
namespace or SAS Viya tenant. The script performs the following actions: 

1. Remove the OpenSearch Dashboards-tenant space.
2. Remove the access controls for the OpenSearch Dashboards-tenant space.

The `offboard.sh` script does not remove the initial user, if one was 
created by the `onboard.sh` script.

Here is the syntax for the script:

<pre>
logging/bin/offboard.sh --namespace <i>namespace</i>  [--tenant <i>tenant</i>]
</pre>

- *namespace* is required. It specifies the Kubernetes namespace for which the 
  corresponding OpenSearch Dashboards-tenant space and access controls are removed.
- *tenant* specifies the SAS Viya tenant for which the corresponding 
  OpenSearch Dashboards-tenant space and access controls are removed.

As with the `onboard.sh` script, the OpenSearch Dashboards-tenant space name is a 
combination of the namespace name and the SAS Viya tenant name (if used). For example, if you ran the script and specified only `--namespace mynamespace`, the script would remove the OpenSearch Dashboards-tenant space named `mynamespace`. If you ran the script and specified 
`--namespace mynamespace --tenant mytenant1`, the script would remove the OpenSearch Dashboards-tenant space named `mynamespace_mytenant1`. 

## Managing User Accounts for Restricted Access

### Introduction

You can create or delete OpenSearch accounts 
that have access to only the log messages and OpenSearch Dashboards-tenant spaces 
associated with a specified namespace or SAS Viya tenant. 

### Creating User Accounts
After you run the `onboard.sh` to implement access controls for 
the OpenSearch Dashboards-tenant space, you can run 
the  `logging/bin/user.sh` script to create user accounts that are bound by 
these access controls. 


Here is the syntax for the script to add a user:

<pre>
logging/bin/user.sh CREATE --namespace <i>namespace</i> [--tenant <i>tenant</i>] 
[--user][<i>user_name</i>] [--password <i>password</i>]
</pre>

- *namespace* is required. It specifies the Kubernetes namespace to which the 
  user can access.
- *tenant* specifies the SAS Viya tenant to which the user can access.
- *user* specifies a user name. If you do not specify a user name, a user is 
created with the default name of `<OpenSearch Dashboards tenant space name>_admin`. 
For example, if you ran the script and specified 
`--namespace mynamespace --tenant mytenant1 --user`, the user would be `mynamespace_mytenant1_admin`.

You can create new users and link them to these access controls by running the 
user.sh script.  For example, to create a user called "chen" and link the user to these 
access controls, submit the following command:

<pre>
logging/bin/user.sh CREATE --user chen --password chenspassword 
--namespace mynamespace --tenant mytenant1
</pre>

### Deleting a User Account

Here is the syntax for the script to delete a user:

<pre>
logging/bin/user.sh DELETE --user <i>user_name</i>
</pre>

## Concepts

### Overview

The OpenSearch security plug-in uses roles to 
control access to the logging information from 
a cluster, an index, or an OpenSearch Dashboards-tenant space. A role contains 
permissions for actions (such as cluster 
access and index access) that correspond to sources and type of log 
information. You can then assign users to roles in order to grant them 
the permissions that are defined in the role. 

A back-end role enables you to point to multiple roles. The security 
plug-in links roles and back-end roles through role mappings. 
Role mappings can also be used to define links between users 
and roles and between users and back-end roles.
By assigning a single back-end role to a user, the user can 
essentially be assigned to multiple roles at once.

### Roles and Role Mappings for a Tenant or Namespace

When you run the `onboard.sh` script to add OpenSearch Dashboards-tenant space, two new roles 
are created and role mappings are defined to link the new roles (and one 
pre-existing role) to a new back-end role.  The following table depicts the 
roles, back-end roles and role mappings that are created when the script is 
run to onboard the SAS Viya tenant `acme` from the `production` SAS Viya 
namespace:

| Back-end Role | Role | Purpose |
| --- | --- | --- |
|     | v4m_kibana_user | Grants access to OpenSearch Dashboards |
|     | tenant_production_acme | Grants access to the `production_acme` OpenSearch Dashboards-tenant space |
|     | search_index_production_acme | Grants access to log messages from the `acme` tenant within the `production` namespace  |
| production_acme_kibana_users |   | Grants access to all of the above roles |

The back-end role provides an easy way to link the set of RBACs with a user.
After these access controls have been defined, you can assign the back-end role 
of `production_acme_kibana_users` to a user. The back-end role 
enables the user to access only:
-  log messages collected from the pods associated with the SAS Viya tenant 
  `acme` in the `production` namespace
- OpenSearch Dashboards-tenant space `production_acme` 

In some cases, you might want to create users who cannot log in to OpenSearch Dashboards but 
can access the log messages collected from a specific namespace or 
namespace/tenant combination. These users might be needed to allow some 
automated process to extract log messages through API calls. To do this, 
assign the `search_index_production_acme` role to the user, rather than 
the `production_acme_kibana_users` back-end role. Because the user has not 
also been assigned the `v4m_kibana_user` or `tenant_production_acme` 
roles, the user cannot log in to OpenSearch Dashboards and cannot access the 
`production_acme` OpenSearch Dashboards-tenant space.

### Roles and Role Mappings for the `logadm` User

As of the 1.1.3 release, the following items are created during the deployment process:

- a set of role-based access controls (RBACs)
- the `logadm` user which is linked to the set of RBACs


The following table shows the RBAC roles that are linked to the `logadm` back-end role. The table also shows the access granted to the RBAC roles by the plug-in.

| Back-end Role | Role | Purpose |
| --- | --- | --- |
|     | v4m_kibana_user | Grants user access to the OpenSearch Dashboards functionality needed. (This role is not unique to the `logadm` user). |
|     | search_index | Grants access to all collected log messages. |
|     | tenant_cluster_admins | Grants access to the cluster_admins OpenSearch Dashboards-tenant space.|
|V4MCLUSTER_ADMIN_kibana_users |    | Provides an easy way to link the above roles with a user.

Linking users to the back-end role V4MCLUSTER_ADMIN_kibana_users via the 
OpenSearch security plug-in grants those users the access described in the table above.
You can also use the user.sh script to grant a user the same level of access as 
a `logadm` user. For example, to grant the user "chen" this level of  
access controls, submit the following command:

<pre>
logging/bin/user.sh CREATE --user chen --password chenspassword 
--namespace _all_ --tenant _all_
</pre>
