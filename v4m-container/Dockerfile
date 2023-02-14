ARG ALPINE_TAG=latest

# Need glibc to support the OpenShift 'oc' CLI
# https://hub.docker.com/r/frolvlad/alpine-glibc/
FROM frolvlad/alpine-glibc:$ALPINE_TAG

# Version of the Viya Monitoring for Kubernetes deployment to download to the container
ARG V4M_TAG="stable"

ARG OS=linux
ARG ARCH=amd64

ARG HELM_VER=v3.8.0
ARG KUBECTL_VER=v1.23.4
# oc versions: https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/
ARG OC_VER=4.8

# Setting environment variables
ENV V4M_PATH=/opt/v4m
ENV KUBECONFIG=$V4M_PATH/.kube/config
ENV PATH=$V4M_PATH/bin:$PATH
ENV KEEP_TMP_DIR=true

RUN mkdir -p $V4M_PATH/bin $V4M_PATH/.kube $V4M_PATH/user_dir
WORKDIR $V4M_PATH

# Create $V4M_PATH/.kube/config if it doesn't exist
RUN touch ${KUBECONFIG}

# Copy contents from kubeconfig and user_dir to the container
COPY kubeconfig/ /opt/v4m/.kube/
COPY user_dir/ /opt/v4m/user_dir/

RUN chmod 600 ${KUBECONFIG}
ENV USER_DIR=/opt/v4m/user_dir
ENV TERM=xterm-256color

# Dependencies needed for python script
RUN apk add --no-cache python3 py3-pip
RUN pip3 install opensearch-py

# Download necessary executables
RUN set -eux; \
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
	;

# kubectl
RUN wget https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VER/bin/$OS/$ARCH/kubectl; \
    chmod +x ./kubectl; \
    mv ./kubectl $V4M_PATH/bin/; \
	mkdir -p $V4M_PATH/.kube;  \
	touch /opt/v4m/.kube/config

# helm
RUN	wget https://get.helm.sh/helm-$HELM_VER-$OS-$ARCH.tar.gz; \
	tar -xvf helm-$HELM_VER-$OS-$ARCH.tar.gz; \
	mv $OS-$ARCH/helm $V4M_PATH/bin/; \
	rm -rf $OS-$ARCH; \
	rm helm-$HELM_VER-$OS-$ARCH.tar.gz

# oc
RUN mkdir oc; \
    cd oc; \
    wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-${OC_VER}/openshift-client-${OS}.tar.gz; \
	tar -xvf openshift-client-${OS}.tar.gz; \
	mv oc $V4M_PATH/bin/; \
	cd ..; \
	rm -rf oc/

# viya4-monitoring-kubernetes
RUN V4M_BRANCH="$V4M_TAG"; \
  if [ "$V4M_BRANCH" == "latest" ]; then V4M_BRANCH="stable"; fi; \
  git clone --depth 1 -b ${V4M_BRANCH} https://github.com/sassoftware/viya4-monitoring-kubernetes

WORKDIR $V4M_PATH/viya4-monitoring-kubernetes
