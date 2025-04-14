FROM frolvlad/alpine-glibc:latest

# Version of the Viya Monitoring for Kubernetes deployment to download to the container
ARG V4M_TAG="stable"
ARG OS=linux
ARG ARCH=amd64
ARG HELM_VER=v3.8.0
ARG KUBECTL_VER=v1.23.4
# oc versions: https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/
ARG OC_VER=4.8

# Set environment variables in a single layer
ENV V4M_PATH=/opt/v4m \
    KUBECONFIG=/opt/v4m/.kube/config \
    PATH=/opt/v4m/bin:$PATH \
    KEEP_TMP_DIR=true \
    USER_DIR=/opt/v4m/user_dir \
    TERM=xterm-256color

# Create directory structure in a single layer
RUN mkdir -p $V4M_PATH/bin $V4M_PATH/.kube $V4M_PATH/user_dir && \
    touch ${KUBECONFIG} && \
    chmod 600 ${KUBECONFIG}

WORKDIR $V4M_PATH

# Copy configuration files
COPY kubeconfig/ /opt/v4m/.kube/
COPY user_dir/ /opt/v4m/user_dir/

# Install system dependencies - make sure to complete this step properly
RUN apk update && \
    apk add --no-cache \
    bash \
    coreutils \
    ncurses \
    curl \
    git \
    jq \
    wget \
    yq \
    openssh \
    procps \
    openssl \
    python3 \
    py3-pip

# Install opensearch-py using apk and create a symlink if needed
RUN pip3 install --break-system-packages opensearch-py

# Install binaries
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VER/bin/$OS/$ARCH/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl $V4M_PATH/bin/ && \
    # Install helm
    wget -q https://get.helm.sh/helm-$HELM_VER-$OS-$ARCH.tar.gz && \
    tar -xf helm-$HELM_VER-$OS-$ARCH.tar.gz && \
    mv $OS-$ARCH/helm $V4M_PATH/bin/ && \
    # Install oc
    wget -q https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-${OC_VER}/openshift-client-${OS}.tar.gz && \
    tar -xf openshift-client-${OS}.tar.gz && \
    mv oc $V4M_PATH/bin/ && \
    # Clone repository
    V4M_BRANCH="${V4M_TAG}" && \
    if [ "$V4M_BRANCH" == "latest" ]; then V4M_BRANCH="stable"; fi && \
    git clone --depth 1 -b ${V4M_BRANCH} https://github.com/sassoftware/viya4-monitoring-kubernetes && \
    # Cleanup
    rm -rf helm-$HELM_VER-$OS-$ARCH.tar.gz $OS-$ARCH openshift-client-${OS}.tar.gz

WORKDIR $V4M_PATH/viya4-monitoring-kubernetes

# Add a health check or default CMD if appropriate
CMD ["bash"]
