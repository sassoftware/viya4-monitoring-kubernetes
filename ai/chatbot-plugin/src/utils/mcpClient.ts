import { Client } from '@modelcontextprotocol/sdk/client';
import { SSEClientTransport } from '@modelcontextprotocol/sdk/client/sse';
import { StreamableHTTPClientTransport } from '@modelcontextprotocol/sdk/client/streamableHttp';

export type McpServerConfig = {
  name: string;
  url: string;
};

export type MCPTool = {
  server: string;
  name: string;
  description?: string;
  inputSchema?: unknown;
};

type ConnectedServer = {
  client: Client;
  transport: StreamableHTTPClientTransport | SSEClientTransport;
  config: McpServerConfig;
};

const connectedServers = new Map<string, ConnectedServer>();

export async function connectMcpServer(config: McpServerConfig): Promise<Client> {
  const existing = connectedServers.get(config.name);
  if (existing) {
    return existing.client;
  }

  const client = new Client({ name: 'joel-mcp-chat', version: '1.0.0' });
  const transport = await createTransport(config.url);

  await client.connect(transport);
  connectedServers.set(config.name, { client, transport, config });

  return client;
}

export async function listAllTools(configs: McpServerConfig[]): Promise<MCPTool[]> {
  const result = await listAllToolsSafe(configs);
  if (result.tools.length === 0 && result.errors.length > 0) {
    throw new Error(
      'Failed to list tools from all configured servers: ' +
        result.errors.map((e) => e.server + ': ' + e.message).join(' | ')
    );
  }
  return result.tools;
}

export async function callMcpTool(serverName: string, toolName: string, args: Record<string, unknown>): Promise<unknown> {
  const server = connectedServers.get(serverName);
  if (!server) {
    throw new Error(`MCP server not connected: ${serverName}`);
  }

  const result = await server.client.callTool({ name: toolName, arguments: args });
  if (result.isError) {
    const errorMessage =
      Array.isArray(result.content) && result.content.length > 0
        ? JSON.stringify(result.content)
        : 'Tool call failed';

    throw new Error(errorMessage);
  }

  return result.structuredContent ?? result.content;
}

export async function closeMcpServers(): Promise<void> {
  await Promise.all(
    Array.from(connectedServers.values()).map(async ({ client, transport }) => {
      await transport.close?.();
      await client.close();
    })
  );
  connectedServers.clear();
}

async function createTransport(urlString: string): Promise<StreamableHTTPClientTransport | SSEClientTransport> {
  const url = new URL(urlString);
  const path = url.pathname.toLowerCase();

  if (path.endsWith('/sse')) {
    return new SSEClientTransport(url);
  }

  return new StreamableHTTPClientTransport(url);
}

export const isConfiguredServer = (server: Partial<McpServerConfig> | undefined): server is McpServerConfig =>
  Boolean(server?.name && server?.url);

export async function buildMcpContext(message: string, configs: McpServerConfig[]): Promise<string> {
  const tools = await listAllTools(configs);
  if (tools.length === 0) {
    return '';
  }

  const ranked = rankTools(message, tools).slice(0, 2);
  if (ranked.length === 0) {
    return ['Available MCP tools:', ...tools.map((tool) => `- ${tool.server}.${tool.name}: ${tool.description ?? ''}`)].join(
      '\n'
    );
  }

  const details: string[] = [];
  for (const tool of ranked) {
    const args = buildToolArguments(tool.name, message);
    const result = await callMcpTool(tool.server, tool.name, args);
    details.push(`${tool.server}.${tool.name}: ${serializeResult(result)}`);
  }

  return ['MCP context from connected servers:', ...details].join('\n\n');
}

const rankTools = (message: string, tools: MCPTool[]): MCPTool[] => {
  const normalized = message.toLowerCase();

  return tools
    .map((tool) => ({
      tool,
      score: scoreTool(normalized, tool),
    }))
    .filter(({ score }) => score > 0)
    .sort((left, right) => right.score - left.score)
    .map(({ tool }) => tool);
};

const scoreTool = (message: string, tool: MCPTool): number => {
  const haystack = `${tool.server} ${tool.name} ${tool.description ?? ''}`.toLowerCase();
  let score = 0;

  for (const token of haystack.split(/[^a-z0-9]+/).filter(Boolean)) {
    if (token.length > 2 && message.includes(token)) {
      score += 2;
    }
  }

  return score;
};

const buildToolArguments = (toolName: string, message: string): Record<string, unknown> => {
  const namespace = extractNamespace(message);
  const serviceName = extractServiceName(message);
  const window = extractWindow(message);

  switch (toolName) {
    case 'namespace_health':
      return namespace ? { namespace } : {};
    case 'service_performance':
      return serviceName ? { service_name: serviceName, namespace: namespace ?? 'viya', window: window ?? '5m' } : {};
    case 'pending_pod_diagnostics':
    case 'failed_pod_diagnostics':
    case 'list_service_candidates':
    case 'resource_pressure':
    case 'rollout_health':
    case 'event_hotspots':
    case 'node_pressure_details':
      return namespace ? { namespace } : {};
    default:
      return {};
  }
};

const extractNamespace = (message: string): string | undefined => {
  const patterns = [/namespace\s+([a-z0-9-]+)/i, /ns\s+([a-z0-9-]+)/i, /in\s+([a-z0-9-]+)\s+namespace/i];

  for (const pattern of patterns) {
    const match = message.match(pattern);
    if (match?.[1]) {
      return match[1];
    }
  }

  return undefined;
};

const extractServiceName = (message: string): string | undefined => {
  const quoted = message.match(/service\s+["'`](.+?)["'`]/i);
  if (quoted?.[1]) {
    return quoted[1];
  }

  const named = message.match(/service\s+([a-z0-9.-]+)/i);
  if (named?.[1]) {
    return named[1];
  }

  return undefined;
};

const extractWindow = (message: string): string | undefined => {
  const match = message.match(/(\d+[smhd])/i);
  return match?.[1];
};

export const serializeResult = (result: unknown): string => {
  if (typeof result === 'string') {
    return result;
  }

  return JSON.stringify(result, null, 2);
};

type JsonSchema = {
  required?: string[];
  properties?: Record<string, unknown>;
};

type ToolCallCandidate = {
  server: string;
  name: string;
  args: Record<string, unknown>;
  required: string[];
  score: number;
};

const WRITE_TOOL_HINTS = ["update", "create", "delete", "patch", "manage", "save"];

const isMutatingTool = (name: string): boolean =>
  WRITE_TOOL_HINTS.some((hint) => name.toLowerCase().includes(hint));

const readRequiredFields = (inputSchema: unknown): string[] => {
  const schema = (inputSchema ?? {}) as JsonSchema;
  return Array.isArray(schema.required) ? schema.required.filter((x): x is string => typeof x === "string") : [];
};

const hasAllRequiredArgs = (args: Record<string, unknown>, required: string[]): boolean =>
  required.every((k) => {
    const v = args[k];
    return v !== undefined && v !== null && String(v).trim() !== "";
  });

export function buildKnownArgs(toolName: string, message: string): Record<string, unknown> {
  const namespace = extractNamespace(message);
  const serviceName = extractServiceName(message);
  const window = extractWindow(message);

  switch (toolName) {
    case "namespace_health":
      return namespace ? { namespace } : {};
    case "service_performance":
      return serviceName ? { service_name: serviceName, namespace: namespace ?? "viya", window: window ?? "5m" } : {};
    case "pending_pod_diagnostics":
    case "failed_pod_diagnostics":
    case "list_service_candidates":
    case "resource_pressure":
    case "rollout_health":
    case "event_hotspots":
    case "node_pressure_details":
      return namespace ? { namespace } : {};
    default:
      return {};
  }
}

export function getEligibleToolCandidates(message: string, tools: MCPTool[]): ToolCallCandidate[] {
  return tools
    .map((tool) => {
      const score = scoreTool(message.toLowerCase(), tool);
      const args = buildKnownArgs(tool.name, message);
      const required = readRequiredFields(tool.inputSchema);
      return { server: tool.server, name: tool.name, args, required, score };
    })
    .filter((c) => c.score > 0)
    .filter((c) => !isMutatingTool(c.name))
    .filter((c) => hasAllRequiredArgs(c.args, c.required))
    .sort((a, b) => b.score - a.score);
}

export type ToolDiscoveryError = {
  server: string;
  message: string;
};

export type ToolDiscoveryResult = {
  tools: MCPTool[];
  errors: ToolDiscoveryError[];
};

export async function listAllToolsSafe(configs: McpServerConfig[]): Promise<ToolDiscoveryResult> {
  const settled = await Promise.allSettled(
    configs.map(async (config) => {
      const client = await connectMcpServer(config);
      const result = await client.listTools();

      return result.tools.map((tool: { name: string; description?: string; inputSchema?: unknown }) => ({
        server: config.name,
        name: tool.name,
        description: tool.description,
        inputSchema: tool.inputSchema,
      }));
    })
  );

  const tools: MCPTool[] = [];
  const errors: ToolDiscoveryError[] = [];

  settled.forEach((entry, index) => {
    const serverName = configs[index]?.name ?? 'unknown';
    if (entry.status === 'fulfilled') {
      tools.push(...entry.value);
    } else {
      const message = entry.reason instanceof Error ? entry.reason.message : String(entry.reason);
      errors.push({ server: serverName, message });
    }
  });

  return { tools, errors };
}
