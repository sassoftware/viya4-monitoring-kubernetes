# Deployment on Azure

This sample shows the customizations that are necessary if you deploy
on Microsoft Azure. The sample assumes that NGINX ingress is used, but you can
modify it for other solutions.

## Instructions

1. Copy this directory to a local directory (for example, `my-viya4mon-user-dir/`).

2. If necessary, edit the `azuredisk-v4m.yaml` file to customize the
storage class that will be used for the deployment.

3. Edit the host names in the sample yaml files in both the `monitoring`
and `logging` subdirectories to match your environment's actual host names.

4. Add additional customization as desired.

5. Run this command to set the `USER_DIR` environment variable to the local path 
   (change the command to use local path that you created in step 1):

```bash
export USER_DIR=my-viya4mon-user-dir/azure-deployment
```

1. Run this command:

```bash
`kubectl apply -f $USER_DIR/azuredisk-v4m.yaml`
```

7. Run the standard deployment scripts to deploy monitoring and logging 
components in Azure.

## Access the Applications

The monitoring and logging applications in this sample are configured for
path-based ingress and are available at the following URLs. Be sure to 
replace the host names in the URLs with the host names for your deployment.

* `https://host.mycluster.example.com/grafana`
* `https://host.mycluster.example.com/dashboards`

This sample does not make Prometheus and Alertmanager available since these
web applications do not provide any sort of user-authentication.  However,
if you want to make these applications available, you can do so by setting 
the `enabled` key available in the appropriate section of the `monitoring/user-values=prom-operator.yaml`
file (e.g. set the key `alertmanager.ingress.enabled` to 'true' to make 
Alertmanager accessible).

If you have chosen to make these applications available, the applications
are available at the following URLs.  As mentioned above, be sure to
replace the host names in the URLs with the host names for your deployment.

* `https://host.mycluster.example.com/prometheus`
* `https://host.mycluster.example.com/alertmanager`

For an example of using host-based ingress, see the [ingress sample](../ingress).
