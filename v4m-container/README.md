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

### Create a Local Copy of the Repository

There are two methods to create a local copy of the repository:

* download a compressed copy
* clone the repository

#### Download a Compressed Copy of the Repository

1. On the main page of the repository, click on Releases (on the right side of the repository contents area) to display the [Releases](https://github.com/sassoftware/viya4-monitoring-kubernetes/releases) page.
2. Locate the release that you want to deploy. Typically, you should download the latest release, which is the first one listed.
3. Expand **Assets** for the release, which is located below the release notes.
4. Select either **Source code (.zip)** or **Source code (.tar.gz)** to download the repository
as a compressed file.
5. Expand the downloaded file to create a local copy of the repository. The repository is created
in a directory named `viya4-monitoring-kubernetes-<release_number>`.

#### Clone the Repository

1. From the main page for the repository, select the **stable** branch, which is the most recent officially released version. The **master** branch is the branch under active development.
2. From the main page for the repository, click **Code**.
3. Copy the HTTPS URL for the repository.
4. From a directory where you want to create the local copy, enter the command `git clone --branch stable <https_url>`. You can replace `stable` with the tag associated with a specific release if you need a version other than the current stable version. For example, if you are developing a repeatable process and need to ensure the same release of the repo is used every time, specify the tag associated with that specific release rather than stable. Note that the tag and release names are typically the same, but you should check the Releases page to verify the tag name.
5. Change to the `viya4-monitoring-kubernetes` directory.
6. Enter the command `git checkout <release_number>`. If you used the command `git clone --branch <my_branch> <https_url>` in Step 4 to specify the branch, release, or tag, you do not have to perform this step

### Building the Docker Image

Run the following command to create the `v4m` Docker image using the provided Dockerfile

```bash
# Move to v4m-container directory
cd v4m-container

# Build the Docker container
docker build --no-cache -t v4m .
```

The Docker image `v4m` will contain Helm, kubectl, and other executables needed to run the Viya Monitoring for Kubernetes scripts.

### Kubeconfig File

To ensure that your kubeconfig files are available from within the Docker container, you can copy the kubeconfig files to the `./v4m-container/kubeconfig` directory or mount the file or directory during your `docker run` command.

### (Optional) Custom Deployment Configurations

You can customize the Viya 4 Monitoring for Kubernetes deployment by editing files in a USER_DIR directory. See the [monitoring README](../monitoring/README.md) and [logging README](../logging/README.md)
) for detailed information about the customization process and about determining valid customization values.

## Running the Docker Container

### Important Directory Locations in the Docker Container

The main files that you will be working with in the Docker container are in the following locations:

```bash
# Viya Monitoring for Kubernetes Repository:
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

From there, you will in a UNIX shell environment.  

By default, the Docker container is expecting the kubeconfig file to be called `config`.  If you want to use a different file name, you will need to set the `KUBECONFIG` environment variable to point to the appropriate one using the following command:

```bash
export KUBECONFIG=/opt/v4m/.kube/<name of kubeconfig file>.conf
```

Now you can run any script from the `/opt/v4m/viya4-monitoring-kubernetes` directory in the Docker container.

**NOTE**:  With this option, if you update any files in either the `./v4m-container/user_dir` or `./v4m-container/kubeconfig` directories, you will need to rebuild the Docker container in order for them to be updated in the Docker container.

### Option 2: Running Commands from Outside of the Docker Container

To run commands from outside of the Docker Container, you can run commands similar to the ones below:

```bash
docker run \
--mount type=bind,source=<path/to/kubeconfig/file>,target=/opt/v4m/.kube/config \
v4m \
<script/to/run>
```

For example, if you wanted to run `deploy_monitoring_cluster.sh`, your command would look like:

```bash
docker run \
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
docker run \
--mount type=bind,source=<path/to/kubeconfig/file>,target=/opt/v4m/.kube/config \
--mount type=bind,source=<path/to/userdir/directory>,target=/opt/v4m/user_dir \
v4m \
monitoring/bin/deploy_monitoring_cluster.sh
```

**NOTE**: With this option, you do not need to rebuild the Docker container after making changes in the mounted directories.
