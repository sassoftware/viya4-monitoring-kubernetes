#!/bin/sh

set -e

# Namespace of the Prometheus custom resource
MON_NS=${MON_NS:-monitoring}
# Name of the Prometheus custom resource
PROM_NAME=${PROM_NAME:-v4m-prometheus}

# Set PROM_PATH if using path-based ingress (e.g. PROM_PATH=/prometheus/)
PROM_PATH=${PROM_PATH:-/}

# Stackdriver Prometheus sidecar version
# https://console.cloud.google.com/gcr/images/stackdriver-prometheus/GLOBAL/stackdriver-prometheus-sidecar
GKE_SIDECAR_VERSION=${SIDECAR_VERSION:-0.8.2}

# Required user inputs
if [ "$GCP_PROJECT" == "" ]; then
  echo "ERROR: GCP_PROJECT must be set"
  exit 1
fi
if [ "$GCP_REGION" == "" ]; then
  echo "ERROR: GCP_REGION must be set"
  exit 1
fi
if [ "$GKE_CLUSTER" == "" ]; then
  echo "ERROR: GKE_CLUSTER must be set"
  exit 1
fi

kubectl -n "$MON_NS" patch prometheus "$PROM_NAME" --type merge --patch "
spec:
  containers:
  - name: sidecar
    image: gcr.io/stackdriver-prometheus/stackdriver-prometheus-sidecar:$GKE_SIDECAR_VERSION
    imagePullPolicy: Always
    args:
    - \"--stackdriver.project-id=$GCP_PROJECT\"
    - \"--prometheus.wal-directory=/data/wal\"
    - \"--stackdriver.kubernetes.location=$GCP_REGION\"
    - \"--stackdriver.kubernetes.cluster-name=$GKE_CLUSTER\"
    - \"--prometheus.api-address=http://127.0.0.1:9090$PROM_PATH\"
    - \"--include={__name__!~'.*:.*',__name__!=''}\"
    ports:
    - name: sidecar
      containerPort: 9091
    volumeMounts:
    - mountPath: /data
      name: prometheus-$PROM_NAME-db
      subPath: prometheus-db
"
