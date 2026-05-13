#!/bin/bash
# Instrument SAS Java (Spring) services with OpenTelemetry Java Agent
#
# Usage: instrument_java_services.sh [--disable]
#
# Required environment variables (or edit defaults below):
#   VIYA_NS              - Namespace where SAS Viya is deployed
#   MON_NS               - Monitoring namespace (where Alloy receiver lives)
#   HELM_RELEASE_PREFIX  - Helm release prefix for monitoring stack
#   OTEL_PVC_CLAIM       - PVC name containing the opentelemetry-javaagent.jar
#   OTEL_AGENT_PATH      - Path to the java agent jar inside the PVC mount

set -e

VIYA_NS="${VIYA_NS:-al}"
MON_NS="${MON_NS:-v4m-test}"
HELM_RELEASE_PREFIX="${HELM_RELEASE_PREFIX:-v4m-test}"
OTEL_PVC_CLAIM="${OTEL_PVC_CLAIM:-opentel}"
OTEL_AGENT_PATH="${OTEL_AGENT_PATH:-/mnt/opentelemetry-javaagent.jar}"
OTEL_MOUNT_PATH="${OTEL_MOUNT_PATH:-/mnt}"

ALLOY_RECEIVER="${HELM_RELEASE_PREFIX}-k8s-monitoring-alloy-receiver"
OTLP_ENDPOINT="http://${ALLOY_RECEIVER}.${MON_NS}:4318"

DISABLE=false
if [[ "$1" == "--disable" ]]; then
  DISABLE=true
fi

echo "============================================"
if $DISABLE; then
  echo "  Disabling OTEL instrumentation (Java)"
else
  echo "  Enabling OTEL instrumentation (Java)"
fi
echo "  Viya namespace:       $VIYA_NS"
echo "  Monitoring namespace: $MON_NS"
echo "  OTLP endpoint:        $OTLP_ENDPOINT"
echo "  PVC claim:            $OTEL_PVC_CLAIM"
echo "  Agent jar path:       $OTEL_AGENT_PATH"
echo "============================================"

DEPLOYMENTS=$(kubectl -n "$VIYA_NS" get deployment -l "sas.com/deployment-base=spring" \
  -o custom-columns='NAME:.metadata.name' --no-headers 2>&1)

if [[ -z "$DEPLOYMENTS" ]]; then
  echo "No spring-based deployments found in namespace $VIYA_NS"
  exit 0
fi

TOTAL=$(echo "$DEPLOYMENTS" | wc -l | tr -d ' ')
COUNT=0

for deployment in $DEPLOYMENTS; do
  COUNT=$((COUNT + 1))
  echo ""
  echo "[$COUNT/$TOTAL] -> $deployment"

  if $DISABLE; then
    # Remove the volume mount patch by removing the volume
    PATCH=$(cat <<EOFPATCH
spec:
  template:
    spec:
      volumes:
      - \$patch: delete
        name: otel-agent
      containers:
      - name: $deployment
        volumeMounts:
        - \$patch: delete
          mountPath: $OTEL_MOUNT_PATH
EOFPATCH
)
    echo "  -> Removing volume mount..."
    kubectl patch deployment -n "$VIYA_NS" "$deployment" --type strategic --patch "$PATCH" 2>&1 || true

    echo "  -> Removing JAVA_TOOL_OPTIONS and OTEL env vars..."
    kubectl -n "$VIYA_NS" set env "deployment/$deployment" \
      JAVA_TOOL_OPTIONS- \
      OTEL_SERVICE_NAME- \
      OTEL_EXPORTER_OTLP_ENDPOINT- \
      OTEL_EXPORTER_OTLP_PROTOCOL- \
      OTEL_TRACES_EXPORTER- \
      OTEL_RESOURCE_ATTRIBUTES- 2>&1

  else
    # 1. Add PVC volume and mount the agent jar
    PATCH=$(cat <<EOFPATCH
spec:
  template:
    spec:
      volumes:
      - name: otel-agent
        persistentVolumeClaim:
          claimName: $OTEL_PVC_CLAIM
      containers:
      - name: $deployment
        volumeMounts:
        - name: otel-agent
          mountPath: $OTEL_MOUNT_PATH
          readOnly: true
EOFPATCH
)
    echo "  -> Adding volume mount..."
    kubectl patch deployment -n "$VIYA_NS" "$deployment" --type strategic --patch "$PATCH" 2>&1

    # 2. Set env vars — Java agent reads standard OTEL_* env vars natively
    echo "  -> Setting OTEL env vars..."
    kubectl -n "$VIYA_NS" set env "deployment/$deployment" \
      JAVA_TOOL_OPTIONS="-javaagent:${OTEL_AGENT_PATH}" \
      OTEL_SERVICE_NAME="$deployment" \
      OTEL_EXPORTER_OTLP_ENDPOINT="$OTLP_ENDPOINT" \
      OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf" \
      OTEL_TRACES_EXPORTER="otlp" \
      OTEL_RESOURCE_ATTRIBUTES="deployment.environment=sas-viya,k8s.namespace.name=${VIYA_NS},k8s.deployment.name=${deployment}" \
      2>&1
  fi

  echo "  $deployment done"
done

echo ""
echo "============================================"
if $DISABLE; then
  echo "All $TOTAL Java services un-instrumented."
else
  echo "All $TOTAL Java services instrumented!"
fi
echo "============================================"
