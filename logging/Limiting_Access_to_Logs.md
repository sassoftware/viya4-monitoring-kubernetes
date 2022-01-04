# Limiting Access to Logs

## Overview 

By default, the log-monitoring capability in SAS Viya Monitoring for 
Kubernetes enables an administrator to view log information about 
everything in your Kubernetes cluster. For details, see [The Logadm User and Its Access Controls](Limiting_Access_to_Logs.md#logadm).

However, there might be instances where 
you want to restrict the information that certain administrators can access:

- If you have multiple SAS Viya deployments in your cluster (for example, 
to support Dev, Test, and Prod instances), you can limit an 
administrator's access so that they can access the log information 
only for a specified namespace.
- If you have a multi-tenant SAS Viya deployment, you can limit 
each tenant administrator's access so that they can access the 
log information only for their SAS Viya tenant.

This access is controlled by a combination of Kibana-tenant spaces and 
Open Distro for Elasticsearch roles, back-end roles, and role mappings. 
Scripts are provided to create everything that is needed for each 
scenario. For details, see [Implement Access Controls for a Tenant or Namespace](Limiting_Access_to_Logs.md#implement_access).

## <a name="logadm"></a>The Logadm User and Its Access Controls

### Overview

As of the 1.1.3 release, the following items are created during the deployment process:

- a set of role-based access controls (RBACs)
- the logadm user, which is linked to the new RBACs

You can disable the creation of the logadm user during the deployment process. Set the LOG_CREATE_LOGADM_USER environment variable to 'false'. The default is to create the logadm user.
  
### Logadm Access Controls

The logadm user is the day-to-day user for log monitoring for cluster administrators. The logadm user has access to all of the log messages collected by the log-monitoring components. This means that the logadm user has access to the following messages: 

- log messages from all SAS Viya namespaces and all tenants within those namespaces.
- log messages from all non-SAS Viya namespaces including the Kubernetes infrastructure namespaces.
 
Although the logadm user can access all of the log messages, logadm can access only the "cluster_admins" Kibana-tenant space.

The access controls are designed to provide logadm users with full cluster access to perform the log-monitoring activities needed for their job.  Limiting these users to the "cluster_admins" Kibana-tenant space helps in the following ways:

- simplifies the Kibana user experience.
- eliminates the potential confusion that could otherwise occur if the user could  access Kibana content in the other Kibana-tenant spaces.


| Back-end Role | Role | Purpose |
| --- | --- | --- |
|     | v4m_kibana_user | Grants user access to the Kibana functionality needed. (This role is not unique to the logadm user). |
|     | search_index | Grants access to all collected log messages. |
|     | tenant_cluster_admins | Grants access to the cluster_admins Kibana-tenant space.|
|V4MCLUSTER_ADMIN_kibana_users |    | Provides an easy way to link the above roles with a user.

Linking users to the back-end role of V4MCLUSTER_ADMIN_kibana_users via the Kibana security plug-in grants those users the access describe above.

You can create new users and link them to these access controls by running the user.sh script.  For example, to create a user called "Chen" and link her to these access controls, submit the following command:

<pre>
/logging/bin/user.sh CREATE --user <i>username</i> --password <i>password</i> --namespace _all_ --tenant _all_
</pre>

Where: 

- *username* is chen.
- *password* is the password to WHAT?.

## <a name="implement_access"></a>Implement Access Controls for a Tenant or Namespace

Use the `/logging/bin/onboard.sh` script to implement logging access 
controls for a namespace or SAS Viya tenant. The script performs these actions: 

- Creates a Kibana-tenant space.
- Loads Kibana content such as visualizations and dashboards into the Kibana 
tenant space.
- Creates the access controls to limit access to only the appropriate 
back-end data.
- Links the access controls to the Kibana-tenant space.
- (Optional) Creates a new user that can access only the information in this 
Kibana-tenant space.

This is the syntax for the script:

<pre>
/logging/bin/onboard.sh --namespace <i>namespace</i>  [--tenant <i>tenant</i>] [--user][<i>username</i>] [--password <i>password</i>]
</pre>

- *namespace* is required. It specifies the Kubernetes namespace to which access limitations are applied.
- *tenant* specifies the SAS Viya tenant to which access limitations are applied.
- *user* specifies to create an initial user with access to the 
Kibana-tenant space. 

The Kibana-tenant space name is a combination of the namespace name and the 
SAS Viya tenant name (if used). For example, if you ran the script and specified only `--namespace mynamespace`, the Kibana-tenant space name would be `mynamespace`. If you ran the script and specified `--namespace mynamespace --tenant mytenant1`, the Kibana-tenant space name would be `mynamespace_mytenant1`. 

If you do not specify a name for the user, a user is 
created with the default name of `<Kibana tenant space name>_admin`. 
For example, if you ran the script and specified `--namespace mynamespace --tenant mytenant1 --user`, the initial user would 
be `mynamespace_mytenant1_admin`.

## Remove Access for a Tenant or Namespace

Use the `/logging/bin/offboard.sh` script to remove logging access for a namespace or SAS Viya tenant. The script performs these actions: 

- Removes the Kibana-tenant space.
- Removes the access controls for the Kibana-tenant space.

The `offboard.sh` script does not remove the initial user, if one was 
created by the `onboard.sh` script.

This is the syntax for the script:

<pre>
/logging/bin/offboard.sh --namespace <i>namespace</i>  [--tenant <i>tenant</i>]
</pre>

- *namespace* is required. It specifies the Kubernetes namespace for which the corresponding Kibana-tenant space and access controls are removed.

- *tenant* specifies the SAS Viya tenant for which the corresponding Kibana-tenant space and access controls are removed.

As with the `onboard.sh` script, the Kibana-tenant space name is a 
combination of the namespace name and the SAS Viya tenant name (if used). For example, if you ran the script and specified only `--namespace mynamespace`, the script would remove the Kibana-tenant space named `mynamespace`. If you ran the script and specified `--namespace mynamespace --tenant mytenant1`, the script would remove the Kibana-tenant space named `mynamespace_mytenant1`. 

## Managing User Accounts for Restricted Access

Use the `/logging/bin/user.sh` script to create or delete Kibana accounts 
that have access to only the log messages and Kibana-tenant space 
associated with a specified namespace or SAS Viya tenant. You can use 
the script to create user accounts for a Kibana-tenant space anytime 
after you have run the `onboard.sh` to implement access limitations for 
the Kibana-tenant space.

This is the syntax for the script to add a user:

<pre>```
/logging/bin/user.sh CREATE --namespace <i>namespace</i>  [--tenant <i>tenant</i>]  [--user][<i>username</i>] [--password <i>password</i>]
</pre>

- *namespace* is required. It specifies the Kubernetes namespace to which the user can access.

- *tenant* specifies the SAS Viya tenant to which the user can access.

- *user* specifies a user name. If you do not specify a user name, a user is 
created with the default name of `<Kibana tenant space name>_admin`. 
For example, if you ran the script and specified `--namespace mynamespace --tenant mytenant1 --user`, the user would 
be `mynamespace_mytenant1_admin`.

This is the syntax for the script to remove a user:

<pre>
/logging/bin/user.sh DELETE --user <i>username</i>
</pre>

## Concepts

The Open Distro for Elasticsearch security plug-in uses roles to 
control access to the logging information from 
a cluster, an index, or a Kibana-tenant space. A role contains 
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

When you run the `onboard.sh` script to add Kibana-tenant space, two new roles are created and role mappings are defined to link the new roles (and one pre-existing role) to a new back-end role.  The following table depicts the roles, back-end roles and role mappings that are created when the script is run to onboard the SAS Viya tenant `acme` from the `production` SAS Viya namespace:

| Back-end Role | Role | Purpose |
| --- | --- | --- |
|     | v4m_kibana_user | allows access to Kibana |
| production_acme_kibana_users | search_index_production_acme | Allows access to log messages from the `production` namespace and `acme` tenant |
|     | tenant_production_acme | Allows access to Kibana-tenant space for `production_acme` |

After these access controls have been defined, you can assign the back-end role of `production_acme_kibana_users` to a user. The back-end role 
enables the user to access only:
-  log messages collected from the pods associated with the SAS Viya tenant `acme` in the `production` namespace
- Kibana `production_acme` Kibana-tenant space  

In some cases, you might want to create users who cannot log in to Kibana but can access the log messages collected from a specific namespace or namespace_tenant combination. These users might be needed to allow some automated process to extract log messages through API calls. To do this, assign the `search_index_ production_acme` role to the user, rather than the `production_acme_kibana_users` back-end role. Because the user has not 
also been assigned the `v4m_kibana_user` or `tenant_production_acme` 
roles, the user cannot sign in to Kibana and cannot access the 
`production_acme` Kibana-tenant space. 

You can also use these roles and back-end roles to create users that can access multiple tenants.  



