# Security Considerations for Logging

## Overview 

Elasticsearch uses roles to control access to the logging information from 
a cluster. A role contains permissions for actions (such as cluster 
access and index access) that correspond to sources and type of log 
information. You can then assign users to roles in order to grant them 
the permissions that are defined in the role. A back-end role enables 
you to point to multiple roles, You can then create a single role to 
access the back-end role, so that a user can essentially be assigned 
to multiple roles at once.

The SAS Viya Monitoring for Kubernetes solution uses the Open Distro for Elasticsearch security plug-in. See the [Open Distro for Elasticsearch security documentation](https://opendistro.github.io/for-elasticsearch-docs/docs/security/) for more information.

You can restrict the administrators’ access in Kibana to only the 
logging information from the namespace on which SAS Viya is installed. 
This level of access ensures that SAS Viya administrators can focus 
only on the messages that are relevant to their SAS Viya deployment.

To enable this access, scripts are provided to create the roles for 
SAS Viya namespace access and to create Kibana users that are assigned 
to the roles. The roles restrict access to the index and resources that 
apply only to the specified SAS Viya namespace. The user definitions 
create IDs that SAS administrators can use to log in to Kibana and 
see log information only about their SAS Viya namespace.

If your deployment contains multiple SAS Viya namespaces, after you 
create the roles for SAS Viya namespace access, you can use the 
security functions in Kibana to assign multiple namespace access 
roles to a single user. For example, you might use this strategy in 
order to enable a single administrator to administer SAS Viya namespaces 
for Dev, Test, and Prod.

## Set Up Role-Based Access Controls

To set up the role-based access control for a SAS Viya namespace, run 
this script:

```
/logging/bin/security_create_rbac.sh namespace
```

This script creates the `search_index_namespace` role and the `namespace_kibana_users` back-end role. The `search_index_namespace` role grants access to log messages from only the specified namespace.

The `namespace_kibana_users` back-end role is mapped to the 
`search_index_namespace` role and the `kibana_user` role, which is 
provided with Kibana. The `kibana_user` role grants access to Kibana.

To delete the roles and mappings for a namespace, run this script:

```
/logging/bin/security_delete_rbac.sh namespace
```

The scripts do not validate the namespace value.

## Create Kibana Users for Role-Based Access

After you have set up the role-based access control for a namespace, you can create Kibana users that are assigned to the role for the namespace. Rather than create a Kibana user for every possible SAS administrator, you can create a limited number of Kibana users for shared use by SAS administrators.

To create Kibana users, run this script:

```
/logging/bin/user.sh create --namespace <namespace>  [--user <username>] [--password <password>]
```

The `namespace` parameter is required. It specifies the Kubernetes namespace to which the user should have access. You must have already run the `security_create_rbac.sh` script for the namespace.

A user that is created with the `user.sh create --namespace script` is assigned the `namespace_kibana_users` back-end role that was created by the `security_create_rbac.sh` script.

The default value for `--user username` is the namespace name.

The default value for `--password password` is the username.

To delete a Kibana user that was created by this script, run this script:

```
/logging/bin/user.sh delete --user username
```

You can also use Kibana to create users and assign the users to one or more of the `namespace_kibana_users` back-end roles. See the [Kibana documentation](https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/users-roles/#map-users-to-roles) for information about mapping users to roles. Users and role mappings that are created in Kibana must be managed through Kibana rather than by using the scripts that are documented here.