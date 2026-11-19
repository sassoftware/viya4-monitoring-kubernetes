# Grafana AI Agent

An optional AI assistant for SAS Viya Monitoring for Kubernetes. It adds an
**Observability Agent** page to Grafana that answers questions about your
cluster, metrics, logs, and the V4M documentation, using an Azure OpenAI model
and live data from your monitoring stack. **This preview is currently in an experimental internal-only phase, and will require a SAS username and password to setup. Currently, Nginx and Contour are supported for ingress.**

## Features

- **Chat inside Grafana**: a Grafana app plugin (`v4m-aiagent-app`) that
  uses the Grafana LLM app (`grafana-llm-app`) to call your Azure OpenAI
  deployment.
- **Live cluster tools** through the `v4m-mcp-server` MCP server:
  - Cluster health and firing alerts
  - PromQL queries, metric lookups, failing scrape targets, and help with
    queries that return no data
  - Recent changes (rollouts, restarts, events) in a namespace
  - Pod listing, pod descriptions, and container logs (read-only access)
  - Log search in OpenSearch, if the V4M logging stack is deployed
  - Search of the V4M documentation, plus any PDFs you add (see
    [Adding documentation](#adding-documentation))
- **Grafana tools** through the `grafana-mcp-server` MCP server, for example
  dashboards, data sources, and alert rules.
- **Approval for changes**: any tool call that could change data is shown to
  you first and only runs if you reply `approve`.
- **Automated deployment**: `deploy_monitoring_cluster.sh` deploys and
  configures the MCP servers, the Ollama embeddings server, the plugin, and the
  Azure OpenAI connection. `remove_monitoring_cluster.sh` removes them.

### Components

All components are deployed to the monitoring namespace (`monitoring` by
default).

| Component | Purpose |
|---|---|
| `v4m-mcp-server` | MCP server for Prometheus, Kubernetes, OpenSearch, and documentation search |
| `grafana-mcp-server` | MCP server for the Grafana API |
| `ollama` | Creates the embeddings used for documentation search (`nomic-embed-text`) |
| `v4m-aiagent-app` | The chatbot plugin, installed into the Grafana pod |
| `grafana-llm-app` | Grafana's LLM integration, which connects to Azure OpenAI |

## Prerequisites

- **An Azure OpenAI model deployment.** The endpoint must be in the Azure
  OpenAI format (`https://<resource>.openai.azure.com`). See
  [Set up the endpoint in Azure AI Foundry](#set-up-the-endpoint-in-azure-ai-foundry).
- **The registry password for the MCP server image** (`v4mai.azurecr.io`). You can find this here: https://sasoffice365.sharepoint.com/:fl:/g/contentstorage/CSP_1a0d8ecc-06c9-4470-ba04-6b64858d511f/IQBnnfyL0gybQLCPxkFBrKCSASqdqu-eB1kYkSAgBov9l5M
- **A User Directory with the following:**
  - **`BASE_DOMAIN` set, with host-based routing** Make sure this variable is set in your user.env file. The MCP servers are exposed at `v4m-mcp.<BASE_DOMAIN>` and `grafana-mcp.<BASE_DOMAIN>`.
  - **TLS certificates** - If you are running this deployment on Contour, ensure that your `INGRESS_CERT` and `INGRESS_KEY` values are set prior to deployment pointing to your TLS certificates. 
- **`npm` and `zip` on the machine you deploy from**, to build the plugin.

## Set up the endpoint in Azure AI Foundry

The agent connects to Azure through the Grafana LLM app, which uses the Azure
OpenAI Chat Completions API. You need an Azure OpenAI model deployment, plus
its endpoint and key. Labels in the Foundry portal change from time to time,
so the steps below may not match it exactly.

1. **Create or choose a resource.** In the
   [Azure AI Foundry portal](https://ai.azure.com), open an existing project or
   create one. A new project also creates an Azure AI Foundry resource. An
   existing Azure OpenAI resource works too.
2. **Deploy a model.** Go to **Models + endpoints > Deploy model > Deploy base
   model**.
   - Choose a GPT chat model from Azure OpenAI, for example `gpt-5.6-luna`. Models from other providers in the Foundry catalog use a different API and won't work.
   - The **deployment name** you enter here is your `AZURE_OPENAI_DEPLOYMENT`.
   - Set the **tokens-per-minute rate limit** as high as your quota allows.
     A low limit causes intermittent *Failed to generate a reply* errors.
3. **Copy the endpoint and key.** Open the deployment. Its details page shows a
   **Target URI** and a **Key**.
   - `AZURE_OPENAI_URL` is only the start of the target URI. For example, from
     `https://my-resource.openai.azure.com/openai/deployments/my-model/chat/completions?api-version=...`,
     use `https://my-resource.openai.azure.com`.
   - The key is your `AZURE_OPENAI_API_KEY`.
   - You can also find both in the Azure portal, under the resource's
     **Keys and Endpoint** page. Use the **Azure OpenAI** endpoint.

> **Note:** Don't use the project endpoint
> (`https://<resource>.services.ai.azure.com/api/projects/...`) or a Responses
> API URL (`.../openai/v1/responses`). The Grafana LLM app can't call them.

To check the endpoint, deployment, and key before you deploy, run this command
with your own values. A JSON reply that contains `"choices"` means they are
correct.

```bash
curl "https://<resource>.openai.azure.com/openai/deployments/<deployment>/chat/completions?api-version=2024-10-21" -H "api-key: <key>" -H "Content-Type: application/json" -d '{"messages":[{"role":"user","content":"ping"}]}'
```

## Setup

### 1. Add the environment variables

Add these to `$USER_DIR/monitoring/user.env`:

```bash
# AI ENABLEMENT
AI_CHATBOT_PROVISION=true
AZURE_OPENAI_URL=https://<your-resource>.openai.azure.com
AZURE_OPENAI_DEPLOYMENT=<your-deployment-name> (ex: gpt-5.6-luna)
AZURE_OPENAI_API_KEY=<your-azure-openai-key>
V4M_MCP_IMAGE_PULL_SECRET=<registry-password>
```

| Variable | Description |
|---|---|
| `AI_CHATBOT_PROVISION` | Set to `true` to deploy the agent. |
| `AZURE_OPENAI_URL` | Your Azure OpenAI resource endpoint. |
| `AZURE_OPENAI_DEPLOYMENT` | The name of your model deployment in that resource. |
| `AZURE_OPENAI_API_KEY` | The API key for that resource. It's stored in the `grafana-llm-openai-secret` Secret. |
| `V4M_MCP_IMAGE_PULL_SECRET` | The registry password. The deploy uses it to create the `v4mai-pull` image pull secret (username `V4M-SAS`). |

> **Important:** After you fill it in, `user.env` contains your Azure OpenAI
> key and the registry password in plain text. Don't commit it or share it.
> Values must not contain quotes, spaces, or backslashes.

### 2. Add the Grafana Helm values

Add these keys to `$USER_DIR/monitoring/user-values-prom-operator.yaml`. If the
file already has a `grafana:` or `prometheus-node-exporter` section, merge them into it. The same keys, with
comments, are in
[monitoring/samples/ai-chatbot/user-values-prom-operator.yaml](../monitoring/samples/ai-chatbot/user-values-prom-operator.yaml).

```yaml
grafana:
  # Installs the Grafana LLM app from the Grafana plugin catalog
  plugins:
    - grafana-llm-app

  # Lets the agent plugin load. 
  env:
    GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS: v4m-aiagent-app

  # Azure OpenAI key (Secret created by the deploy)
  envValueFrom:
    AZURE_OPENAI_API_KEY:
      secretKeyRef:
        name: grafana-llm-openai-secret
        key: apiKey

  # Azure OpenAI URL and deployment name (ConfigMap created by the deploy)
  envFromConfigMaps:
    - name: grafana-llm-config

  # Connects the Grafana LLM app to Azure OpenAI
  extraConfigmapMounts:
    - name: grafana-chatbot-provisioning
      configMap: grafana-chatbot-provisioning
      mountPath: /etc/grafana/provisioning/plugins/grafana-llm-app-provisioning.yaml
      subPath: grafana-llm-app-provisioning.yaml

prometheus-node-exporter:
  resources:
    requests:
      cpu: "10m"
      memory: "50Mi"
    limits:
      cpu: "250m"
      memory: "100Mi"
```

### 3. Deploy

```bash
monitoring/bin/deploy_monitoring_cluster.sh
```
With the proper environment variables set, the script will provision and deploy the AI Agent alongside the monitoring deployment. **IMPORTANT: The monitoring deployment script will output the MCP URLs after deploying. Be sure to visit them and clear out the cert warnings to prevent authentication errors.** Once finalized, you can visit the Grafana link provided at the bottom and sign in, and the agent should appear in the left sidebar. You can ask questions to the agent directly or click on the three dots on panels inside of dashboards, and click "ask observability agent" to interact with it.

## Adding resources to the Agent

The V4M repository documentation is built into the MCP server image (v4m-mcp-server). To add
other documents, such as SAS Viya documentation PDFs:

1. Copy the PDFs into the `v4m-mcp-pdfs` volume, which is mounted at
   `/app/docs/pdfs`.
2. Restart the `v4m-mcp-server` pod.

The search index is rebuilt only when the documents change.

## Removal

`monitoring/bin/remove_monitoring_cluster.sh` removes all chatbot components.
The volumes (the embeddings cache, added PDFs, and the Ollama model) are kept
unless you set `MON_DELETE_PVCS_ON_REMOVE=true`.

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| `v4m-mcp-server` is in `ImagePullBackOff` | `V4M_MCP_IMAGE_PULL_SECRET` is not set or is wrong. Set it and redeploy. |
| The deploy fails with *AZURE_OPENAI_... must all be set* | One of the three `AZURE_OPENAI_*` variables is empty. |
| The chatbot answers, but no tools are used | The browser can't reach the MCP servers. Open `https://v4m-mcp.<BASE_DOMAIN>/mcp` in a browser to check for certificate errors. |
| *No healthy upstream* from an MCP hostname | The MCP server pod isn't ready. Check `kubectl describe pod` and the pod logs. |
