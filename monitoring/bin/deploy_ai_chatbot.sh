#! /bin/bash

# Copyright © 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Deploys the Grafana AI chatbot integration in three steps, in the order
# they have to run:
#
#   1. MCP servers: applies ai/k8s/{pvcs,ollama,service,deployment}.yaml
#      (v4m-mcp + its embeddings dependency) and
#      ai/k8s/grafana-mcp-{service,deployment}.yaml (grafana-mcp) as
#      ClusterIP Services, then routes to both through this cluster's
#      existing ingress-nginx controller (same BASE_DOMAIN/ROUTING convention
#      deploy_monitoring_cluster.sh already uses for Grafana/Prometheus/
#      Alertmanager) rather than provisioning a LoadBalancer per service.
#      nginx only — no contour support. Only ROUTING=host is supported for
#      now.
#
#   2. Provisioning: creates the grafana-chatbot-provisioning ConfigMap
#      (grafana-llm-app's provider config ONLY — see
#      monitoring/grafana-llm-app-provisioning.yaml for why the chatbot
#      plugin's own config is deliberately NOT in here) and the
#      grafana-llm-openai-secret Secret. These must exist BEFORE
#      `helm upgrade --install` creates/updates the Grafana pod, since the pod
#      spec references them directly via envValueFrom/extraConfigmapMounts
#      (see monitoring/samples/ai-chatbot/user-values-prom-operator.yaml) —
#      with `--atomic` set on that helm call, a pod that can't start because
#      these are missing risks rolling back the ENTIRE monitoring release,
#      not just the chatbot piece. 
#
#   3. Plugin delivery + configuration: kubectl cp's the built chatbot plugin
#      into the running Grafana pod, restarts it, then — once Grafana and the
#      plugin are BOTH confirmed up — sets the plugin's MCP server URLs via
#      Grafana's `/api/plugins/:id/settings` API, using the hostnames
#      discovered in step 1. This needs a Grafana pod that's already up AND
#      already carrying the unsigned-plugin allowlist env var from step 2's
#      overlay — i.e. it needs to run AFTER a `helm upgrade --install` that
#      picked up that overlay.
#
# Due to the ordering, run this script manually once BEFORE your first
# deploy_monitoring_cluster.sh run with AI_CHATBOT_ENABLE=true (steps 1-2 will
# succeed; step 3 will no-op with a warning if Grafana isn't running the new
# overlay yet — that's expected on a first pass). deploy_monitoring_cluster.sh
# then calls this same script again automatically when AI_CHATBOT_ENABLE=true,
# at which point steps 1-2 are harmless no-ops and step 3 completes for real.

cd "$(dirname "$BASH_SOURCE")/../.." || exit 1
source monitoring/bin/common.sh

set -e

# --- Step 1: MCP servers -----------------------------------------------------

ROUTING="${ROUTING:-host}"

if [ -z "$BASE_DOMAIN" ]; then
    log_error "BASE_DOMAIN is not set. It's required to generate ingress hostnames for the MCP"
    log_error "servers — the same variable deploy_monitoring_cluster.sh uses for Grafana/"
    log_error "Prometheus/Alertmanager ingress. Set it in user.env or export it."
    exit 1
fi
if [ "$ROUTING" != "host" ]; then
    log_error "Only host-based routing (ROUTING=host) is currently supported for the MCP"
    log_error "server ingress — path-based support hasn't been built yet."
    exit 1
fi

log_info "Applying Ollama (v4m-mcp's embeddings dependency), v4m-mcp, and grafana-mcp k8s manifests..."
kubectl apply -f ai/k8s/pvcs.yaml

ollamaDefFile="$TMP_DIR/ollama_def_file.yaml"
cp ai/k8s/ollama.yaml "$ollamaDefFile"
imgSnippet="$OLLAMA_FULL_IMAGE" yq -i '(select(.kind=="Deployment") | .spec.template.spec.containers[0].image) = env(imgSnippet)' "$ollamaDefFile"
if [ -n "$OLLAMA_IMAGE_PULL_SECRET" ]; then
    secretSnippet="$OLLAMA_IMAGE_PULL_SECRET" yq -i '(select(.kind=="Deployment") | .spec.template.spec.imagePullSecrets[0].name) = env(secretSnippet)' "$ollamaDefFile"
else
    yq -i '(select(.kind=="Deployment") | .spec.template.spec) |= del(.imagePullSecrets)' "$ollamaDefFile"
fi
kubectl apply -f "$ollamaDefFile"

kubectl apply -f ai/k8s/service.yaml

mcpDefFile="$TMP_DIR/v4m_mcp_deployment_def_file.yaml"
cp ai/k8s/deployment.yaml "$mcpDefFile"
imgSnippet="$V4M_MCP_FULL_IMAGE" yq -i '.spec.template.spec.containers[0].image = env(imgSnippet)' "$mcpDefFile"
if [ -n "$V4M_MCP_IMAGE_PULL_SECRET" ]; then
    secretSnippet="$V4M_MCP_IMAGE_PULL_SECRET" yq -i '.spec.template.spec.imagePullSecrets[0].name = env(secretSnippet)' "$mcpDefFile"
else
    yq -i 'del(.spec.template.spec.imagePullSecrets)' "$mcpDefFile"
fi
originSnippet="https://grafana.$BASE_DOMAIN" yq -i '(.spec.template.spec.containers[0].env[] | select(.name=="ALLOWED_ORIGIN")).value = env(originSnippet)' "$mcpDefFile"
kubectl apply -f "$mcpDefFile"

grafanaMcpDefFile="$TMP_DIR/grafana_mcp_deployment_def_file.yaml"
cp ai/k8s/grafana-mcp-deployment.yaml "$grafanaMcpDefFile"
originSnippet="https://grafana.$BASE_DOMAIN" yq -i '(.spec.template.spec.containers[0].env[] | select(.name=="ALLOWED_ORIGIN")).value = env(originSnippet)' "$grafanaMcpDefFile"
grafanaScheme="${GRAFANA_INTERNAL_SCHEME:-$([ "$TLS_ENABLE" == "true" ] && echo https || echo http)}"
urlSnippet="$grafanaScheme://v4m-grafana.monitoring.svc:3000" yq -i '(.spec.template.spec.containers[0].env[] | select(.name=="GRAFANA_URL")).value = env(urlSnippet)' "$grafanaMcpDefFile"
adminSecretName="${GRAFANA_ADMIN_SECRET_NAME:-v4m-grafana}"
secretSnippet="$adminSecretName" yq -i '(.spec.template.spec.containers[0].env[] | select(.name=="GRAFANA_PASSWORD")).valueFrom.secretKeyRef.name = env(secretSnippet)' "$grafanaMcpDefFile"
kubectl apply -f "$grafanaMcpDefFile"

kubectl apply -f ai/k8s/grafana-mcp-service.yaml

# Unlike Grafana/Prometheus/Alertmanager (whose Ingress objects come from the
# kube-prometheus-stack chart's own ingress sub-values), v4m-mcp-server and
# grafana-mcp-server aren't part of any Helm chart, so their Ingress objects
# are built directly from the ai/k8s/ingress-templates/*_ingress.yaml templates.
v4mMcpSecret="v4m-mcp-ingress-tls-secret"
grafanaMcpSecret="grafana-mcp-ingress-tls-secret"

for entry in "v4m-mcp:$v4mMcpSecret" "grafana-mcp:$grafanaMcpSecret"; do
    app="${entry%%:*}"
    secretName="${entry##*:}"
    resourceDefFile="$TMP_DIR/${app}_ingress_def_file.yaml"
    yq eval-all '. as $item ireduce ({}; . * $item )' "ai/k8s/ingress-templates/${app}_ingress.yaml" > "$resourceDefFile"
    hostSnippet="$app.$BASE_DOMAIN" yq -i '.spec.rules[0].host=env(hostSnippet)' "$resourceDefFile"
    hostSnippet="$app.$BASE_DOMAIN" yq -i '.spec.tls[0].hosts[0]=env(hostSnippet)' "$resourceDefFile"
    secretSnippet="$secretName" yq -i '.spec.tls[0].secretName=env(secretSnippet)' "$resourceDefFile"
    kubectl apply -n "$MON_NS" -f "$resourceDefFile"
done

v4mMcpUrl="https://v4m-mcp.$BASE_DOMAIN/mcp"
grafanaMcpUrl="https://grafana-mcp.$BASE_DOMAIN/mcp"
log_info "v4m-mcp:      $v4mMcpUrl"
log_info "grafana-mcp:  $grafanaMcpUrl"

# --- Step 2: provisioning ----------------------------------------------------

if [ -z "$AZURE_OPENAI_API_KEY" ] || [ -z "$AZURE_OPENAI_URL" ] || [ -z "$AZURE_OPENAI_DEPLOYMENT" ]; then
    log_error "AZURE_OPENAI_API_KEY, AZURE_OPENAI_URL, and AZURE_OPENAI_DEPLOYMENT must all be set."
    log_error "Set them in user.env, or export them before running this script:"
    log_error "  export AZURE_OPENAI_API_KEY=yourAzureOpenAIKeyHere"
    log_error "  export AZURE_OPENAI_URL=https://your-resource.openai.azure.com"
    log_error "  export AZURE_OPENAI_DEPLOYMENT=yourDeploymentName"
    exit 1
fi

log_info "Creating grafana-chatbot-provisioning ConfigMap in the [$MON_NS] namespace..."
kubectl create configmap grafana-chatbot-provisioning \
    -n "$MON_NS" \
    --from-file=grafana-llm-app-provisioning.yaml=monitoring/grafana-llm-app-provisioning.yaml \
    --dry-run=client -o yaml | kubectl apply -f -

log_info "Creating grafana-llm-openai-secret Secret in the [$MON_NS] namespace..."
kubectl create secret generic grafana-llm-openai-secret \
    -n "$MON_NS" \
    --from-literal=apiKey="$AZURE_OPENAI_API_KEY" \
    --dry-run=client -o yaml | kubectl apply -f -

log_info "Creating grafana-llm-config ConfigMap in the [$MON_NS] namespace..."
kubectl create configmap grafana-llm-config \
    -n "$MON_NS" \
    --from-literal=AZURE_OPENAI_URL="$AZURE_OPENAI_URL" \
    --from-literal=AZURE_OPENAI_DEPLOYMENT="$AZURE_OPENAI_DEPLOYMENT" \
    --dry-run=client -o yaml | kubectl apply -f -

log_info "Provisioning objects ready. Make sure the grafana.* keys from"
log_info "monitoring/samples/ai-chatbot/user-values-prom-operator.yaml are in your"
log_info "user-values-prom-operator.yaml before running deploy_monitoring_cluster.sh."

# --- Step 3: plugin delivery + configuration --------------------------------

set +e
kubectl -n "$MON_NS" get pods -l app.kubernetes.io/name=grafana --no-headers 2> /dev/null | grep -q .
grafanaRunning=$?
set -e

if [ "$grafanaRunning" -ne 0 ]; then
    log_warn "No Grafana pod found in [$MON_NS] yet."
    log_warn "MCP servers are up and provisioning is done — the chatbot plugin itself"
    log_warn "will be delivered and configured automatically the next time"
    log_warn "deploy_monitoring_cluster.sh runs with AI_CHATBOT_ENABLE=true."
    exit 0
fi

pluginId="${CHATBOT_PLUGIN_ID:-mainorg-joelmcpchat-app}"
pluginFile="${pluginId}.zip"
pluginSrcDir="ai/chatbot-plugin"
builtZip="$pluginSrcDir/$pluginFile"

if [ ! -f "$builtZip" ]; then
    if ! command -v npm &> /dev/null; then
        log_error "npm is required to build the chatbot plugin but wasn't found on PATH."
        exit 1
    fi
    log_info "Building chatbot plugin from $pluginSrcDir..."
    ( cd "$pluginSrcDir" && npm ci && npm run build ) || { log_error "Chatbot plugin build failed."; exit 1; }
    ( cd "$pluginSrcDir/dist" && zip -qr "../${pluginFile}" . )
fi
userPluginFile="$builtZip"

grafanaPod=$(kubectl -n "$MON_NS" get pods -l app.kubernetes.io/name=grafana -o jsonpath='{.items[0].metadata.name}')
log_debug "Grafana Pod [$grafanaPod]"

log_info "Copying chatbot plugin into Grafana pod..."
# dist/ has plugin.json at its own root (not inside a named folder), so the
# zip built from it does too — extract into an explicit, dedicated
# subdirectory rather than straight into /var/lib/grafana/plugins/, or
# plugin.json ends up loose in the plugins root and Grafana won't find it.

kubectl exec -n "$MON_NS" "$grafanaPod" -- sh -c '
    cd /var/lib/grafana/plugins &&
    rm -rf plugin.json module.js module.js.map img CHANGELOG.md LICENSE README.md \
        [0-9]*.js [0-9]*.js.map
' || true

kubectl cp "$userPluginFile" "$MON_NS/$grafanaPod:/var/lib/grafana/plugins/$pluginFile"
kubectl exec -n "$MON_NS" "$grafanaPod" -- mkdir -p /var/lib/grafana/plugins/"$pluginId"
kubectl exec -n "$MON_NS" "$grafanaPod" -- unzip -o /var/lib/grafana/plugins/"$pluginFile" -d /var/lib/grafana/plugins/"$pluginId"/
kubectl exec -n "$MON_NS" "$grafanaPod" -- rm /var/lib/grafana/plugins/"$pluginFile"

log_info "Chatbot plugin installed. Restarting Grafana pod to load it..."
kubectl delete pods -n "$MON_NS" -l "app.kubernetes.io/name=grafana"
kubectl -n "$MON_NS" wait pods --selector "app.kubernetes.io/name=grafana" --for condition=Ready --timeout=5m

# Now that the plugin is actually installed and Grafana is back up, set the MCP server URLs via the settings API
grafanaPod=$(kubectl -n "$MON_NS" get pods -l app.kubernetes.io/name=grafana -o jsonpath='{.items[0].metadata.name}')

adminSecretName="${GRAFANA_ADMIN_SECRET_NAME:-v4m-grafana}"
adminPassword=$(kubectl get secret "$adminSecretName" -n "$MON_NS" -o jsonpath='{.data.admin-password}' | base64 -d)

grafanaScheme="${GRAFANA_INTERNAL_SCHEME:-$([ "$TLS_ENABLE" == "true" ] && echo https || echo http)}"

log_info "Setting chatbot plugin MCP server URLs via the Grafana API..."
settingsPayload=$(cat << EOF
{"enabled": true, "jsonData": {"apiUrl": "http://default-url.com", "mcpServerOneUrl": "$v4mMcpUrl", "mcpServerTwoUrl": "$grafanaMcpUrl"}, "secureJsonData": {"apiKey": "secret-key"}}
EOF
)
kubectl exec -n "$MON_NS" "$grafanaPod" -- curl -sk -u "admin:$adminPassword" -X POST \
    "$grafanaScheme://localhost:3000/api/plugins/$pluginId/settings" \
    -H "Content-Type: application/json" \
    -d "$settingsPayload"

log_info ""
log_info "Grafana AI chatbot deployment complete."
