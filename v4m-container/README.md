# Viya Monitoring for Kubernetes Docker Container

**EXPERIMENTAL**:  Container of the [viya4-monitoring-kubernetes](https://github.com/sassoftware/viya4-monitoring-kubernetes)
project

_The Viya Monitoring for Kubernetes Docker Container allows you to work with the Viya 4 Monitoring for Kubernetes project in a containerized environment. By using the container, you don't have to worry about:_

* _Configuring your own shell environment with all of the prerequisite modules and routines needed by the monitoring solution_
* _Which version of a given module you have installed_

 _All of those dependencies have been packaged into the container. The only prerequisites for running the container are listed below._

## Pre-requisites

* Docker should be installed on your workstation

## Preparing the Docker Container

### Building the Docker Image

Run the following command to create the `v4m` Docker image using the provided Dockerfile

```bash
# Move to v4m-container directory
cd v4m-container

# Build the Docker container
docker build --no-cache -t v4m .
```

The Docker image `v4m` will contain Helm, kubectl, and other executables needed to run the Viya Monitoring for Kubernetes deployment.

### Kubeconfig File

To ensure that your kubeconfig files are available from within the Docker container, you can copy the kubeconfig files to the `./v4m-container/kubeconfig` directory or mount the file or directory during your `docker run` command.

### (Optional) Custom Deployment Configurations

You can customize the Viya 4 Monitoring for Kubernetes deployment by editing files in a USER_DIR directory. See the [monitoring README](../monitoring/README.md) and [logging README](../logging/README.md)
) for detailed information about the customization process and about determining valid customization values.

If you make any customization, you can place the files in the provided `./v4m-container/user_dir` directory to make them available within the container.  If you want to update your custom deployment configuration, you will need to update the contents of the `./v4m-container/user_dir` directory and rebuild the Docker container.

## Running the Docker Container

### Important Directory Locations in the Docker Container

The main files that you will be working with in the Docker container are in the following locations:

```bash
# Viya Monitoring for Kubernetes Deployment:
/opt/v4m/viya4-monitoring-kubernetes/

# kubeconfig Files:
/opt/v4m/.kube/

# User Directory
/opt/v4m/user_dir/
```

## Connecting to the Docker Container

### Option 1: Running Commands from Within the Docker Container

To connect to the Docker container, run the following command:

```bash
docker run -it v4m
```

From there, you will be in your UNIX environment.  Before you run any of the V4M scripts, you
will need to set the `KUBECONFIG` environment variable using the following command:

```bash
export $KUBECONFIG=/opt/v4m/.kube/<name of kubeconfig file>.conf
```

Now you can run any script from the `/opt/v4m/viya4-monitoring-kubernetes` directory in the Docker container.

### Option 2: Running Commands from Outside of the Docker Container

To run commands from outside of the Docker Container, you can run commands similar to the ones below:

```bash
docker run -it /
--mount type=bind,source=<path/to/kubeconfig/file>,target=/opt/v4m/.kube/config
v4m
<script/to/run>
```

For example, if you wanted to run `deploy_monitoring_cluster.sh`, your command would look like:

```bash
docker run -it \
--mount type=bind,source=<path/to/kubeconfig/file>,target=/opt/v4m/.kube/config \
v4m \
monitoring/bin/deploy_monitoring_cluster.sh
```

**NOTE**: If you want to include customizations to your deployment using a USER_DIR directory, you would need to add the following line to your command:

```bash
--mount type=bind,source=<path/to/userdir/directory>,target=/opt/v4m/user_dir
```

The final product would look similar to this:

```bash
docker run -it \
--mount type=bind,source=<path/to/kubeconfig/file>,target=/opt/v4m/.kube/config \
--mount type=bind,source=<path/to/userdir/directory>,target=/opt/v4m/user_dir \
v4m \
monitoring/bin/deploy_monitoring_cluster.sh
```
