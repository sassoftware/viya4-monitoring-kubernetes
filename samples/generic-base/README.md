# Generic Base

This sample contains all of the files that can be customized as part of the
monitoring and logging deployments. See the comments in each file for
reference links and variable listings.

## Using This Sample

You customize your deployment by specifying values in `user.env` and `*.yaml`
files. These files are stored in a local directory outside of your
repository that is identified by the `USER_DIR` environment variable.
For information about the customization process, see [Create the Deployment Directory](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=p15fe8611w9njkn1fucwbvlz8tyg.htm) in the SAS Viya Monitoring for Kubernetes Help Center.

The customization files in this sample provide a starting point for
customization if your environment does not match any of the specialized
samples.

In order to use the values in this sample in the customization files for your
deployment, copy the customization files from this sample to your local
customization directory and modify the files further as needed.

If you need to use values from another sample, manually copy the values to
your customization files after you add the values in this sample.

After you finish modifying the customization files, deploy the metric-monitoring and
log-monitoring components. See [Deploy](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=n1rhzwx0mcnnnun17q11v85bspyk.htm) in the SAS Viya Monitoring for Kubernetes Help Center.

## Grafana Dashboards and Alerting

In addition to customizing the deployment, this sample show how you can add
your own Grafana dashboards, alerts, contact points and notifications policies. See [Add More Grafana Dashboards](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=v_003&docsetId=obsrvdply&docsetTarget=n1sg9bc44ow616n1sw7l3dlsbmgz.htm) and
[Provision Contact Points, Notification Policies and Alert Rules](https://documentation.sas.com/doc/en/obsrvcdc/v_003/obsrvdply/n0auhd4hutsf7xn169hfvriysz4e.htm#n1o8xp9s4wiflun1bdm4zhlfoyip) for details.
