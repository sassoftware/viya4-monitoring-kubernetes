#!/bin/bash

source $V4M_REPO/bin/kube-include.sh

# Output the version env vars set by kube-include.sh
echo "KUBE_CLIENT_VER=$KUBE_CLIENT_VER"
echo "KUBE_SERVER_VER=$KUBE_SERVER_VER"
