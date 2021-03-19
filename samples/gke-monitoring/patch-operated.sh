#!/bin/sh

set -e
set -u

# These usually don't need overrides
SIDECAR_IMAGE_TAG=${SIDECAR_IMAGE_TAG:-0.8.2}
MON_NAMESPACE=${MON_NS:-monitoring}
PROM_NAME=${PROM_NAME:-v4m-prometheus}

# Set PROM_PATH if using path-based ingress (e.g. PROM_PATH=/prometheus/)
PROM_PATH=${PROM_PATH:-/}

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

kubectl -n "${MON_NAMESPACE}" patch prometheus "$PROM_NAME" --type merge --patch "
spec:
  containers:
  - name: sidecar
    image: gcr.io/stackdriver-prometheus/stackdriver-prometheus-sidecar:${SIDECAR_IMAGE_TAG}
    imagePullPolicy: Always
    args:
    - \"--stackdriver.project-id=${GCP_PROJECT}\"
    - \"--prometheus.wal-directory=/data/wal\"
    - \"--stackdriver.kubernetes.location=${GCP_REGION}\"
    - \"--stackdriver.kubernetes.cluster-name=${GKE_CLUSTER}\"
    - \"--prometheus.api-address=http://127.0.0.1:9090${PROM_PATH}\"
    ports:
    - name: sidecar
      containerPort: 9091
    volumeMounts:
    - mountPath: /data
      name: prometheus-$PROM_NAME-db
      subPath: prometheus-db
"
