#!/bin/bash
# Instrument SAS Go and Java (Spring) services with OpenTelemetry
#
# Usage: instrument_services.sh [--disable]
#
# Required environment variables (or edit defaults below):
#   VIYA_NS              - Namespace where SAS Viya is deployed
#   MON_NS               - Monitoring namespace (where Alloy receiver lives)
#   HELM_RELEASE_PREFIX  - Helm release prefix for monitoring stack
#   OTEL_PVC_CLAIM       - PVC name containing the opentelemetry-javaagent.jar
#   OTEL_AGENT_PATH      - Path to the java agent jar inside the PVC mount

set -e

# Prevent Git Bash (MSYS) from mangling Unix paths like /mnt/... into
# C:/Program Files/Git/mnt/... when passing them to kubectl.
export MSYS_NO_PATHCONV=1

VIYA_NS="${VIYA_NS:-al}"
MON_NS="${MON_NS:-v4m-test}"
HELM_RELEASE_PREFIX="${HELM_RELEASE_PREFIX:-v4m-test}"
OTEL_PVC_CLAIM="${OTEL_PVC_CLAIM:-opentel}"
OTEL_AGENT_PATH="${OTEL_AGENT_PATH:-/mnt/opentelemetry-javaagent.jar}"
OTEL_MOUNT_PATH="${OTEL_MOUNT_PATH:-/mnt}"
OTEL_JAVA_AGENT_VERSION="${OTEL_JAVA_AGENT_VERSION:-2.15.0}"
OTEL_STORAGE_CLASS="${OTEL_STORAGE_CLASS:-nfs-client}"

ALLOY_RECEIVER="${HELM_RELEASE_PREFIX}-k8s-monitoring-alloy-receiver"
OTLP_GRPC_ENDPOINT="${ALLOY_RECEIVER}.${MON_NS}:4317"
OTLP_HTTP_ENDPOINT="http://${ALLOY_RECEIVER}.${MON_NS}:4318"

DISABLE=false
if [[ "$1" == "--disable" ]]; then
  DISABLE=true
fi

echo "============================================"
if $DISABLE; then
  echo "  Mode: DISABLE instrumentation"
else
  echo "  Mode: ENABLE instrumentation"
fi
echo "  Viya namespace:       $VIYA_NS"
echo "  Monitoring namespace: $MON_NS"
echo "  OTLP gRPC endpoint:  $OTLP_GRPC_ENDPOINT"
echo "  OTLP HTTP endpoint:  $OTLP_HTTP_ENDPOINT"
echo "  Java PVC claim:       $OTEL_PVC_CLAIM"
echo "  Java agent jar:       $OTEL_AGENT_PATH"
echo "============================================"

# -----------------------------------------------
# Go services — configure via Consul KV
# -----------------------------------------------
# SAS Go binaries read telemetry config from Consul, not env vars.
# Setting these keys under config/application/ applies to ALL Go services.
echo ""
echo "--- Go services (Consul KV configuration) ---"

CONSUL_POD=$(kubectl -n "$VIYA_NS" get pods -l app=sas-consul-server \
  -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [[ -z "$CONSUL_POD" ]]; then
  echo "ERROR: No sas-consul-server pod found in namespace $VIYA_NS"
else
  consul_kv() {
    kubectl -n "$VIYA_NS" exec "pod/$CONSUL_POD" -c sas-consul-server -- \
      sh -c "export CONSUL_HTTP_ADDR=https://localhost:8500; consul kv $1 -token=\$CONSUL_HTTP_TOKEN $2 $3" 2>/dev/null
  }

  if $DISABLE; then
    echo "  -> Disabling telemetry in Consul..."
    consul_kv put "config/application/sas.telemetry.enabled" "false"
    echo "  Consul: telemetry disabled for Go services."
  else
    echo "  -> Setting telemetry config in Consul..."
    consul_kv put "config/application/sas.telemetry.enabled" "true"
    consul_kv put "config/application/sas.telemetry.exporter" "otlp"
    consul_kv put "config/application/sas.telemetry.otlp.protocol" "grpc"
    consul_kv put "config/application/sas.telemetry.collector.addr" "$OTLP_GRPC_ENDPOINT"

    echo "  Consul keys set:"
    consul_kv get "-recurse" "config/application/sas.telemetry"
    echo ""
    echo "  Go services will pick up changes on next restart."
    echo "  To restart all Go services now, run:"
    echo "    kubectl -n $VIYA_NS rollout restart deployment -l sas.com/deployment-base=golang"
  fi
fi

# -----------------------------------------------
# Ensure PVC and Java agent jar exist (enable only)
# -----------------------------------------------
if ! $DISABLE; then
  echo ""
  echo "--- Checking OTEL Java agent PVC ---"

  if kubectl get pvc "$OTEL_PVC_CLAIM" -n "$VIYA_NS" &>/dev/null; then
    echo "PVC '$OTEL_PVC_CLAIM' already exists in namespace $VIYA_NS"
  else
    echo "PVC '$OTEL_PVC_CLAIM' not found â€” creating..."
    kubectl apply -f - <<EOFPVC
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $OTEL_PVC_CLAIM
  namespace: $VIYA_NS
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: $OTEL_STORAGE_CLASS
  resources:
    requests:
      storage: 1Gi
EOFPVC
    echo "PVC '$OTEL_PVC_CLAIM' created."
  fi

  # Check if the jar exists on the PVC by running a test pod
  AGENT_JAR_NAME=$(basename "$OTEL_AGENT_PATH")
  AGENT_URL="https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_JAVA_AGENT_VERSION}/opentelemetry-javaagent.jar"

  echo "Checking if $AGENT_JAR_NAME exists on PVC..."
  JAR_CHECK=$(kubectl run otel-jar-check -n "$VIYA_NS" --rm -i --restart=Never \
    --image=curlimages/curl:latest \
    --overrides="{
      \"spec\": {
        \"volumes\": [{\"name\": \"otel\", \"persistentVolumeClaim\": {\"claimName\": \"$OTEL_PVC_CLAIM\"}}],
        \"containers\": [{
          \"name\": \"otel-jar-check\",
          \"image\": \"curlimages/curl:latest\",
          \"command\": [\"sh\", \"-c\", \"test -s ${OTEL_MOUNT_PATH}/${AGENT_JAR_NAME} && echo EXISTS || echo MISSING\"],
          \"volumeMounts\": [{\"name\": \"otel\", \"mountPath\": \"${OTEL_MOUNT_PATH}\"}]
        }]
      }
    }" 2>/dev/null || echo "MISSING")

  if echo "$JAR_CHECK" | grep -q "EXISTS"; then
    echo "$AGENT_JAR_NAME already present on PVC."
  else
    echo "$AGENT_JAR_NAME not found â€” downloading v${OTEL_JAVA_AGENT_VERSION}..."
    kubectl run otel-agent-loader -n "$VIYA_NS" --rm -i --restart=Never \
      --image=curlimages/curl:latest \
      --overrides="{
        \"spec\": {
          \"volumes\": [{\"name\": \"otel\", \"persistentVolumeClaim\": {\"claimName\": \"$OTEL_PVC_CLAIM\"}}],
          \"containers\": [{
            \"name\": \"otel-agent-loader\",
            \"image\": \"curlimages/curl:latest\",
            \"command\": [\"sh\", \"-c\", \"curl -sL -o ${OTEL_MOUNT_PATH}/${AGENT_JAR_NAME} ${AGENT_URL} && ls -lh ${OTEL_MOUNT_PATH}/${AGENT_JAR_NAME} && echo DONE\"],
            \"volumeMounts\": [{\"name\": \"otel\", \"mountPath\": \"${OTEL_MOUNT_PATH}\"}]
          }]
        }
      }" 2>/dev/null
    echo "Java agent downloaded."
  fi
fi

# -----------------------------------------------
# Java (Spring) services
# -----------------------------------------------
echo ""
echo "--- Java services (sas.com/deployment-base=spring) ---"

JAVA_DEPLOYMENTS=$(kubectl -n "$VIYA_NS" get deployment -l "sas.com/deployment-base=spring" \
  -o custom-columns='NAME:.metadata.name' --no-headers 2>&1)

if [[ -z "$JAVA_DEPLOYMENTS" ]]; then
  echo "No spring-based deployments found in namespace $VIYA_NS"
else
  JAVA_TOTAL=$(echo "$JAVA_DEPLOYMENTS" | wc -l | tr -d ' ')
  JAVA_COUNT=0

  for deployment in $JAVA_DEPLOYMENTS; do
    JAVA_COUNT=$((JAVA_COUNT + 1))
    echo ""
    echo "[$JAVA_COUNT/$JAVA_TOTAL] -> $deployment"

    if $DISABLE; then
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

      echo "  -> Removing OTEL env vars from main container..."
      kubectl -n "$VIYA_NS" set env "deployment/$deployment" -c "$deployment" \
        JAVA_TOOL_OPTIONS- \
        OTEL_SERVICE_NAME- \
        OTEL_EXPORTER_OTLP_ENDPOINT- \
        OTEL_EXPORTER_OTLP_PROTOCOL- \
        OTEL_TRACES_EXPORTER- \
        OTEL_LOGS_EXPORTER- \
        OTEL_PROPAGATORS- \
        OTEL_JAVA_EXPERIMENTAL_SPAN_ATTRIBUTES- \
        OTEL_INSTRUMENTATION_HTTP_CAPTURE_HEADERS_SERVER_REQUEST- \
        OTEL_INSTRUMENTATION_HTTP_CAPTURE_HEADERS_SERVER_RESPONSE- \
        OTEL_RESOURCE_ATTRIBUTES- 2>&1

    else
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

      echo "  -> Setting OTEL env vars on main container only..."
      kubectl -n "$VIYA_NS" set env "deployment/$deployment" -c "$deployment" \
        JAVA_TOOL_OPTIONS="-javaagent:${OTEL_AGENT_PATH}" \
        OTEL_SERVICE_NAME="$deployment" \
        OTEL_EXPORTER_OTLP_ENDPOINT="$OTLP_HTTP_ENDPOINT" \
        OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf" \
        OTEL_TRACES_EXPORTER="otlp" \
        OTEL_LOGS_EXPORTER="otlp" \
        OTEL_PROPAGATORS="tracecontext,baggage" \
        OTEL_JAVA_EXPERIMENTAL_SPAN_ATTRIBUTES="baggage" \
        OTEL_INSTRUMENTATION_HTTP_CAPTURE_HEADERS_SERVER_REQUEST="baggage,X-Request-ID" \
        OTEL_INSTRUMENTATION_HTTP_CAPTURE_HEADERS_SERVER_RESPONSE="traceresponse" \
        OTEL_RESOURCE_ATTRIBUTES="deployment.environment=sas-viya,k8s.namespace.name=${VIYA_NS},k8s.deployment.name=${deployment}" \
        2>&1
    fi

    # --- Clean otel-agent artifacts from init containers ---
    # Strategic merge targets only the named main container, but admission
    # webhooks or previous script runs may have added otel-agent to init containers.
    if command -v jq &>/dev/null; then
      DEPLOY_JSON=$(kubectl -n "$VIYA_NS" get deployment "$deployment" -o json 2>/dev/null)
      CLEANUP_OPS=$(echo "$DEPLOY_JSON" | jq -c '
        [
          ((.spec.template.spec.initContainers // []) | to_entries[] |
           .key as $ci | (.value.volumeMounts // []) | to_entries[] |
           select(.value.name == "otel-agent") |
           {"op":"remove","path":"/spec/template/spec/initContainers/\($ci)/volumeMounts/\(.key)"}),
          ((.spec.template.spec.initContainers // []) | to_entries[] |
           .key as $ci | (.value.env // []) | to_entries[] |
           select(.value.name == "JAVA_TOOL_OPTIONS") |
           {"op":"remove","path":"/spec/template/spec/initContainers/\($ci)/env/\(.key)"})
        ] | sort_by(.path) | reverse
      ' 2>/dev/null)
      if [[ -n "$CLEANUP_OPS" && "$CLEANUP_OPS" != "[]" ]]; then
        echo "  -> Removing otel-agent from init containers..."
        kubectl -n "$VIYA_NS" patch deployment "$deployment" --type=json \
          -p "$CLEANUP_OPS" 2>&1 || true
      fi
    fi

    echo "  $deployment done"
  done

  echo "Java: $JAVA_TOTAL services done."
fi

echo ""
echo "============================================"
if $DISABLE; then
  echo "  Instrumentation disabled."
else
  echo "  Instrumentation complete!"
fi
echo "============================================"
