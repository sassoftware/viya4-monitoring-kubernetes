# Using an External Alertmanager

**Note:** Before using this sample, be sure to read [Configuring Alertmanager](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=p1hedx6j957ztfn1vs4likzvjv6o.htm) in the SAS Viya Monitoring for Kubernetes Help Center.

You customize your monitoring deployment by specifying values in `user.env` and
`*.yaml` files. These files are stored in a local directory outside of your
repository that is identified by the `USER_DIR` environment variable. See 
[Pre-deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1ajbblsxpcgl5n11t13wgtd4d7c.htm) for information
about the customization process.

The customization files in this sample provide a starting point for the
customization files for a deployment that supports an external instance of
Alertmanager.

In order to use the values in this sample in the customization files for your
deployment, copy the customization files from this sample to your local
customization directory and modify the files further as needed.

If you also need to use values from another sample, manually copy the values
to your customization files after you add the values in this sample.

1. The sample uses the value of `my-external-alertmanager` for the external
Alertmanager instance. If you use a name other than `my-external-alertmanager`,
change `alertmanager-endpoint.yaml` and
`$USER_DIR/monitoring/user-values-prom-operator.yaml` to specify the name of
your Alertmanager instance.

2. Define a service that points to the Alertmanager instance that you want to
use.

3. Deploy monitoring using the standard deployment script. See [Deploy](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1rhzwx0mcnnnun17q11v85bspyk.htm).

4. Deploy the `alertmanager-endpoint.yaml` file to the monitoring namespace:

```bash
kubectl apply -n monitoring -f $USER_DIR/alertmanager-endpoint.yaml
```
