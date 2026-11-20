# Deployment on Azure

This sample shows the customizations that are necessary if you deploy
on Microsoft Azure. The sample uses Contour as the ingress controller and
auto-generates the HTTPProxy resources for the web applications
(`AUTOGENERATE_INGRESS=true`, `INGRESS_TYPE=contour`). Contour must be installed
in the cluster. For manual HTTPProxy configuration, see the [Contour sample](../contour).

## Instructions

1. Copy this directory to a local directory (for example, `my-viya4mon-user-dir/`).

2. Set `STORAGECLASS` in `user.env` to the StorageClass to use for all PVCs.
By default, the sample uses the AKS built-in `managed-csi-premium` StorageClass
(Premium SSD; requires VM sizes that support premium storage). Any existing
StorageClass works. To use the custom `Standard_LRS` StorageClass defined in
`azuredisk-v4m.yaml` instead, set `STORAGECLASS=azuredisk-v4m` and apply that file
(step 6). To use
different StorageClasses per component, set `PROMETHEUS_STORAGECLASS`,
`ALERTMANAGER_STORAGECLASS`, `GRAFANA_STORAGECLASS`, `PUSHGATEWAY_STORAGECLASS`
or `OPENSEARCH_STORAGECLASS`. See [Customize StorageClass](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=n0auhd4hutsf7xn169hfvriysz4e.htm#p1lvxtk81r8jgun1d789fqaz3lq1).

3. Set `BASE_DOMAIN` in `user.env` to the host name used to access the web
applications. `ROUTING` selects path-based (default) or host-based routing (see
[Access the Applications](#access-the-applications)). To use TLS certificates for the
generated HTTPProxy resources, set `INGRESS_CERT` and `INGRESS_KEY`. See
[Configure Access to Web Applications](https://documentation.sas.com/?softwareId=obsrv&softwareVersion=prod&docsetId=obsrvdply&docsetTarget=n0auhd4hutsf7xn169hfvriysz4e.htm#n0jiph3lcb5rmsn1g71be3cesmo8).

4. Add additional customization as desired.

5. Run this command to set the `USER_DIR` environment variable to the local path 
   (change the command to use local path that you created in step 1):

```bash
export USER_DIR=my-viya4mon-user-dir/azure-deployment
```

6. If you use the `azuredisk-v4m` StorageClass, run this command:

```bash
kubectl apply -f $USER_DIR/azuredisk-v4m.yaml
```

7. Run the standard deployment scripts to deploy monitoring and logging 
components in Azure.

## Access the Applications

With path-based routing (`ROUTING=path`), the web applications are available at
the following URLs, where `host.cluster.example.com` is the value of `BASE_DOMAIN`:

* `https://monitoring.host.cluster.example.com/grafana`
* `https://logging.host.cluster.example.com/dashboards`

With host-based routing (`ROUTING=host`), they are available at:

* `https://grafana.host.cluster.example.com`
* `https://dashboards.host.cluster.example.com`

The URLs are also shown at the end of the deployment.

This sample does not make Prometheus, Alertmanager and OpenSearch available since these
web applications do not provide any sort of user-authentication. However,
if you want to make these applications available, set `PROMETHEUS_INGRESS_ENABLE`,
`ALERTMANAGER_INGRESS_ENABLE` or `OPENSEARCH_INGRESS_ENABLE` to `true` in `user.env`.
