# Generic Base

This sample contains all of the files that can be customized as part of the
monitoring and logging deployments. See the comments in each file for
reference links and variable listings.

## Using This Sample

You customize your deployment by specifying values in `user.env` and `*.yaml` files. These files are stored in a local directory outside of your repository that is identified by the `USER_DIR` environment variable. The customization files in this sample provide a starting point for customization if your environment does not matchany of the specialized samples. See the 
[main README](../../README.md#customization) to for information about the customization process.

If you need to use values from another sample, manually copy the values to your configuration files after you add the values in this sample. 

After you finish modifying the configuration files, deploy monitoring and logging using the standard deployment scripts.

