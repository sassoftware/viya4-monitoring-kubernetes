# Deployment on Azure

This sample shows the customizations that are necessary if you deploy
on Microsoft Azure. The sample assumes that NGINX ingress is used, but you can
modify it for other solutions.

## Instructions

1. Copy this directory to a local directory
2. Edit `azuredisk-v4m.yaml` file if necessary to customize the
storage class that will be used for the deployment
3. Edit the hostnames in the sample yaml files in both the `monitoring`
and `logging` subdirectories to match your environment's actual hostname(s)
4. Add additional customization as desired
5. Run the command (adjust to local path created in step 1):
`export USER_DIR=path/to/my/copy/azure-deployment`
6. Run the command:
`kubectl apply -f $USER_DIR/azuredisk-v4m.yaml`
7. Run the scripts to deploy monitoring and logging components in Azure

## Access the Applications

The monitoring and logging applications in this sample are configured for
path-based ingress and will be available at (replace the hostnames):

* `http://host.mycluster.example.com/grafana`
* `http://host.mycluster.example.com/prometheus`
* `http://host.mycluster.example.com/alertmanager`
* `http://host.mycluster.example.com/kibana`

For an example of using host-based ingress, see the [ingress sample](../ingress).
