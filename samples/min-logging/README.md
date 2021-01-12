# Minimal Logging Sample

This sample demonstrates how you can customize a logging deployment
to minimize resource usage. The sample deployment configures single instances of each logging 
component. This configuration could save CPU and memory resources and could be useful in development and test environments.

## Using This Sample

You customize your logging deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. See the 
[main README](../../README.md#customization) for information about the customization process. 

The customization files in this sample provide a starting point for the customization files for a deployment that supports logging that minimizes resource usage. 

In order to use the values in this sample in the customization files for your deployment, copy the customization files from this sample to your local customization directory, then modify the files further as needed.

If you also need to use values from another sample, manually copy the values to your customization files after you add the values in this sample. 

After you finish modifying the customization files, deploy logging using the standard deployment script:

```bash
my_repository_path/logging/bin/deploy_logging_open.sh
```
