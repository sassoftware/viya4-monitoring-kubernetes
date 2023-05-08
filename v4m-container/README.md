# SAS Viya Monitoring for Kubernetes Docker Container

**EXPERIMENTAL**:  Container of the [viya4-monitoring-kubernetes](https://github.com/sassoftware/viya4-monitoring-kubernetes)
project

_The SAS Viya Monitoring for Kubernetes Docker Container allows you to work with the SAS Viya Monitoring for Kubernetes project in a containerized environment. By using the container, you don't have to worry about:_

* _Configuring your own shell environment with all of the prerequisite modules and routines needed by the monitoring solution_
* _Which version of a given module you have installed_

 _All of those dependencies have been packaged into the container. The only prerequisites for running the container are listed below._

## Prerequisites

* Docker must be installed on your workstation.
* A local copy of the repository must be created. See 
[Copy the Repository](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n0b7mrzohgnb1ln1qq4tyaheq36r.htm) in the SAS Viya Monitoring for Kubernetes Help Center. 

## Preparing the Docker Container

### Kubeconfig Directory

To ensure that your kubeconfig files are available from within the Docker container, you can copy the kubeconfig files to the `./v4m-container/kubeconfig` directory or mount the file or directory during your `docker run` command.  By default, the `KUBECONFIG` environment variable is set to use a file called `config`; therefore, if multiple kubeconfig files are being provided, rename the one you would like to use to `config`.

### (Optional) user_dir Directory

You can customize the SAS Viya Monitoring for Kubernetes deployment by editing files in a USER_DIR directory. See [Pre-deployment](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n1ajbblsxpcgl5n11t13wgtd4d7c.htm).

If you would like to customize your deployment, you will need to copy the contents of your USER_DIR directory to the `./v4m-container/user_dir` directory or mount the file or directory during your `docker run` command.

## Building the Docker Image

Run the following command to create the `v4m` Docker image using the provided Dockerfile

```bash
# Move to v4m-container directory
cd v4m-container

# Build the Docker container
docker build --no-cache -t v4m .
```

The Docker image `v4m` will contain Helm, kubectl, and other executables needed to run the SAS Viya Monitoring for Kubernetes scripts.

## Running the Docker Container

### Important Directory Locations in the Docker Container

The main files that you will use in the Docker container are in the following locations:

```bash
# SAS Viya Monitoring for Kubernetes Repository:
/opt/v4m/viya4-monitoring-kubernetes/

# kubeconfig Files:
/opt/v4m/.kube/

# User Directory
/opt/v4m/user_dir/
```

### Option 1: Running Commands from Within the Docker Container

To connect to the Docker container, run the following command:

```bash
docker run -it v4m
```

From there, you are in a UNIX shell environment.  

By default, the Docker container is expecting the kubeconfig file to be called `config`.  If you want to use a different file name, you must set the `KUBECONFIG` environment variable to point to the appropriate file name using the following command:

```bash
export KUBECONFIG=/opt/v4m/.kube/<name of kubeconfig file>.conf
```

Now you can run any script from the `/opt/v4m/viya4-monitoring-kubernetes` directory in the Docker container.

### Option 2: Running Commands from Outside of the Docker Container

To run commands from outside of the Docker Container, you can run commands similar to the ones below:

```bash
docker run v4m <script/to/run>
```

For example, if you wanted to run `deploy_monitoring_cluster.sh`, your command would look like:

```bash
docker run v4m monitoring/bin/deploy_monitoring_cluster.sh
```

### Updating kubeconfig and user_dir Directories Used by Docker Container

If you change the files in the `./v4m-container/kubeconfig` or `./v4m-container/user_dir` directories, you must perform one of the following options in order for the change to reflect in your Docker container:

* Run the `docker build` command to rebuild the Docker container (see [**Building the Docker Image**](#building-the-docker-image))
* Add the `--mount` parameters to your `docker run` commands (see [**Mounting Files and Directories to Your Docker Container**](#mounting-files-and-directories-to-your-docker-container))

### Mounting Files and Directories to Your Docker Container

If you do not move your files to the provided `./v4m-container/kubeconfig` and `./v4m-container/user_dir` directories, add the following parameters to your `docker run` commands to include these files and directories:

```bash
# Add to your docker run commands to mount a kubeconfig file
--mount type=bind,source=<path/to/kubeconfig/file>,target=/opt/v4m/.kube/config

# Add to your docker run commands to mount a USER_DIR directory
--mount type=bind,source=<path/to/userdir/directory>,target=/opt/v4m/user_dir
```
