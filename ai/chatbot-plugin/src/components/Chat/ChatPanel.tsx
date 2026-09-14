import React, { useEffect, useRef, useState } from 'react';
import { css, cx } from '@emotion/css';
import { GrafanaTheme2, usePluginContext } from '@grafana/data';
import { openai } from '@grafana/llm';
import { getBackendSrv } from '@grafana/runtime';
import { Button, Input, Spinner, useStyles2 } from '@grafana/ui';
import { useOptionalAppMeta } from '../App/AppContext';
import {
  callMcpTool,
  isConfiguredServer,
  listAllToolsSafe,
  serializeResult,
  type MCPTool,
  type McpServerConfig,
  type ToolDiscoveryError,
} from '../../utils/mcpClient';

type ChatMessage = {
  role: 'user' | 'assistant';
  content: string;
};

type PlannedToolCall = { server: string; name: string; args: Record<string, unknown> };

type PendingApproval = {
  call: PlannedToolCall;
  reason?: string;
};

type ToolSchema = {
  required?: string[];
};

type ToolDescriptor = {
  server: string;
  name: string;
  description?: string;
  required: string[];
  mutating: boolean;
};

type AgentAction =
  | { type: 'tool_call'; call: PlannedToolCall; reasoning?: string }
  | { type: 'final_answer'; answer: string }
  | { type: 'ask_user'; question: string };

type AgentEvent =
  | { type: 'discovery_error'; server: string; message: string }
  | { type: 'tool_success'; server: string; name: string; args: Record<string, unknown>; result: unknown }
  | { type: 'tool_error'; server: string; name: string; args: Record<string, unknown>; message: string };

type AppPluginSettings = {
  apiUrl?: string;
  mcpServerOneUrl?: string;
  mcpServerTwoUrl?: string;
};

export type DashboardChatContext = {
  dashboardTitle?: string;
  dashboardUid?: string;
  panelTitle?: string;
  queries?: unknown[];
  timeRange?: unknown;
};

export type ChatPanelProps = {
  // Dashboard/panel details injected when the chat is opened from a dashboard extension.
  context?: DashboardChatContext;
  // Fills the parent container (modal/sidebar) instead of rendering the full-page shell.
  compact?: boolean;
};

const AGENT_MAX_STEPS = 5;

const MAX_HISTORY_MESSAGES = 8;
const MAX_TOOLS_FOR_PROMPT = 20;
const MAX_MESSAGE_CHARS = 1200;
const MAX_EVENT_CHARS = 2500;
const MAX_TOOL_SUMMARY_CHARS = 6000;
const MAX_CONTEXT_QUERY_CHARS = 1500;

const clamp = (value: string, limit: number): string =>
  value.length <= limit ? value : value.slice(0, limit) + '... [truncated]';

const compactHistory = (history: ChatMessage[]): ChatMessage[] =>
  history.slice(-MAX_HISTORY_MESSAGES).map((m) => ({
    role: m.role,
    content: clamp(m.content, MAX_MESSAGE_CHARS),
  }));

const tokenize = (text: string): string[] =>
  Array.from(new Set(text.toLowerCase().split(/[^a-z0-9]+/).filter((token) => token.length > 2)));

const scoreToolForPrompt = (tool: ToolDescriptor, userMessage: string): number => {
  const message = userMessage.toLowerCase();
  const haystack = `${tool.server} ${tool.name} ${tool.description ?? ''}`.toLowerCase();
  const tokens = tokenize(userMessage);

  let score = 0;

  for (const token of tokens) {
    if (haystack.includes(token)) {
      score += 3;
    }
  }

  if (message.includes('grafana') && tool.server === 'grafana') {
    score += 8;
  }

  if ((message.includes('dashboard') || message.includes('dashboards')) && haystack.includes('dashboard')) {
    score += 10;
  }

  if ((message.includes('alert') || message.includes('alerts')) && haystack.includes('alert')) {
    score += 10;
  }

  if ((message.includes('folder') || message.includes('folders')) && haystack.includes('folder')) {
    score += 10;
  }

  if ((message.includes('datasource') || message.includes('data source')) && haystack.includes('datasource')) {
    score += 10;
  }

  if (!tool.mutating) {
    score += 1;
  }

  return score;
};

const compactCatalog = (catalog: ToolDescriptor[], userMessage: string): ToolDescriptor[] =>
  catalog
    .map((tool) => ({
      tool: {
        ...tool,
        description: tool.description ? clamp(tool.description, MAX_MESSAGE_CHARS) : undefined,
      },
      score: scoreToolForPrompt(tool, userMessage),
    }))
    .sort((left, right) => right.score - left.score)
    .slice(0, MAX_TOOLS_FOR_PROMPT)
    .map((entry) => entry.tool);

const compactEvents = (events: AgentEvent[]): AgentEvent[] =>
  events.slice(-10).map((e) => {
    if (e.type === 'tool_success') {
      return { ...e, result: clamp(serializeResult(e.result), MAX_EVENT_CHARS) };
    }
    return { ...e, message: clamp(e.message, MAX_MESSAGE_CHARS) };
  });

const MUTATING_HINTS = ['update', 'create', 'delete', 'patch', 'manage', 'save', 'write', 'set'];

const isMutatingTool = (name: string, description?: string): boolean => {
  const hay = name + ' ' + (description ?? '');
  return MUTATING_HINTS.some((hint) => hay.toLowerCase().includes(hint));
};

const getToolCatalog = (tools: MCPTool[]): ToolDescriptor[] =>
  tools.map((tool) => {
    const schema = (tool.inputSchema ?? {}) as ToolSchema;
    return {
      server: tool.server,
      name: tool.name,
      description: tool.description,
      required: Array.isArray(schema.required) ? schema.required : [],
      mutating: isMutatingTool(tool.name, tool.description),
    };
  });

const validatePlannedCall = (call: PlannedToolCall, catalog: ToolDescriptor[]): string | null => {
  const tool = catalog.find((t) => t.server === call.server && t.name === call.name);
  if (!tool) {
    return 'Unknown tool: ' + call.server + '.' + call.name;
  }

  const args = call.args ?? {};
  for (const req of tool.required) {
    const v = args[req];
    if (v === undefined || v === null || String(v).trim() === '') {
      return "Missing required argument '" + req + "' for " + call.server + '.' + call.name;
    }
  }

  return null;
};

const isApproval = (text: string): boolean => /^(approve|yes|y|ok|run|allow)\b/i.test(text.trim());
const isDenial = (text: string): boolean => /^(deny|no|n|cancel|block|reject)\b/i.test(text.trim());

const makeDashboardContextPrompt = (context?: DashboardChatContext, liveData?: string): string => {
  if (!context) {
    return '';
  }

  const parts = ['The user opened this chat from a Grafana dashboard.'];

  if (context.dashboardTitle || context.dashboardUid) {
    parts.push('Dashboard: "' + (context.dashboardTitle ?? 'unknown') + '" (uid: ' + (context.dashboardUid ?? 'unknown') + ')');
  }

  if (context.panelTitle) {
    parts.push('Panel: "' + context.panelTitle + '"');
  }

  if (Array.isArray(context.queries) && context.queries.length > 0) {
    parts.push('Panel queries: ' + clamp(JSON.stringify(context.queries), MAX_CONTEXT_QUERY_CHARS));
  }

  if (context.timeRange) {
    parts.push('Current time range: ' + clamp(JSON.stringify(context.timeRange), 200));
  }

  if (liveData) {
    parts.push('Live panel data (fetched when this chat opened):');
    parts.push(liveData);
    parts.push('Use the query_prometheus tool for other metrics or time ranges.');
  }

  parts.push('When the user says "this dashboard" or "this panel", they mean the above.');

  return parts.join('\n');
};

// ---- Panel data snapshot ----------------------------------------------------
// Runs the panel's own queries through Grafana's datasource-query API when the
// chat opens, so the model sees the data the user is looking at without
// needing a tool call, plus the panel datasource's health.

const MAX_SNAPSHOT_CHARS = 2000;

type DataSourceRef = { uid?: string; type?: string };

type DsQueryFrame = {
  schema?: { name?: string; fields?: Array<{ name?: string; labels?: Record<string, string> }> };
  data?: { values?: unknown[][] };
};

const describeFieldSeries = (frame: DsQueryFrame, fieldIndex: number): string | null => {
  const field = frame.schema?.fields?.[fieldIndex];
  const values = (frame.data?.values?.[fieldIndex] ?? []).filter(
    (v): v is number => typeof v === 'number' && Number.isFinite(v)
  );
  if (values.length === 0) {
    return null;
  }

  const min = Math.min(...values);
  const max = Math.max(...values);
  const avg = values.reduce((a, b) => a + b, 0) / values.length;
  const last = values[values.length - 1];
  const name =
    field?.labels && Object.keys(field.labels).length > 0
      ? JSON.stringify(field.labels)
      : field?.name ?? frame.schema?.name ?? 'value';

  const round = (n: number) => Number(n.toFixed(4));
  return `${name}: ${values.length} points, min=${round(min)}, max=${round(max)}, avg=${round(avg)}, last=${round(last)}`;
};

const summarizeDsQueryResponse = (response: unknown): string => {
  const results = (response as { results?: Record<string, { frames?: DsQueryFrame[]; error?: string }> })?.results;
  if (!results) {
    return 'Panel query returned no result payload.';
  }

  const lines: string[] = [];
  for (const [refId, result] of Object.entries(results)) {
    if (result?.error) {
      lines.push(`Query ${refId}: ERROR: ${result.error}`);
      continue;
    }

    const frames = result?.frames ?? [];
    let seriesLines: string[] = [];
    for (const frame of frames) {
      const fieldCount = frame.schema?.fields?.length ?? 0;
      // Field 0 is conventionally time; describe the value fields.
      for (let i = 1; i < fieldCount; i += 1) {
        const described = describeFieldSeries(frame, i);
        if (described) {
          seriesLines.push(described);
        }
      }
    }

    if (seriesLines.length === 0) {
      lines.push(`Query ${refId}: NO DATA over the panel's time range.`);
    } else {
      const totalSeries = seriesLines.length;
      if (totalSeries > 8) {
        seriesLines = seriesLines.slice(0, 8);
        seriesLines.push(`... plus ${totalSeries - 8} more series`);
      }
      lines.push(`Query ${refId}: ${totalSeries} series:\n  ` + seriesLines.join('\n  '));
    }
  }

  return clamp(lines.join('\n'), MAX_SNAPSHOT_CHARS);
};

// Dashboard template variables arrive UN-interpolated in the extension
// context: a panel's datasource uid can be the literal string "${datasource}"
// and queries can contain "$cluster". Treating those as real values produces
// false "datasource unreachable" / "no data" conclusions.
const TEMPLATE_VAR_RE = /\$\{[^}]+\}|\$[a-zA-Z_][a-zA-Z0-9_]*/g;

const findTemplateVars = (text: string): string[] => Array.from(new Set(text.match(TEMPLATE_VAR_RE) ?? []));

const resolveDefaultPrometheus = async (): Promise<{ uid: string; name: string } | null> => {
  try {
    const sources = (await getBackendSrv().get('/api/datasources')) as Array<{
      uid: string;
      name: string;
      type: string;
      isDefault?: boolean;
    }>;
    const prometheusSources = sources.filter((d) => d.type === 'prometheus');
    const chosen = prometheusSources.find((d) => d.isDefault) ?? prometheusSources[0];
    return chosen ? { uid: chosen.uid, name: chosen.name } : null;
  } catch {
    return null;
  }
};

const fetchPanelSnapshot = async (context: DashboardChatContext): Promise<string> => {
  const targets = Array.isArray(context.queries) ? (context.queries as Array<Record<string, unknown>>) : [];
  const withDatasource = targets.filter((t) => Boolean((t.datasource as DataSourceRef | undefined)?.uid));
  if (withDatasource.length === 0) {
    return '';
  }

  const range = (context.timeRange ?? {}) as { from?: string; to?: string };
  const from = typeof range.from === 'string' ? range.from : 'now-1h';
  const to = typeof range.to === 'string' ? range.to : 'now';

  const parts: string[] = [];

  // Resolve the datasource, handling a "${datasource}" template variable.
  const dsRef = withDatasource[0].datasource as DataSourceRef;
  let effectiveDs: DataSourceRef = dsRef;
  if (dsRef.uid && findTemplateVars(dsRef.uid).length > 0) {
    const fallback = await resolveDefaultPrometheus();
    if (fallback) {
      effectiveDs = { uid: fallback.uid, type: dsRef.type ?? 'prometheus' };
      parts.push(
        `Panel datasource is the dashboard variable ${dsRef.uid} (not resolvable from this chat); ` +
          `using the Prometheus datasource "${fallback.name}" for this snapshot. ` +
          'Do NOT conclude the datasource is broken from the variable reference.'
      );
    } else {
      parts.push(
        `Panel datasource is the dashboard variable ${dsRef.uid} and no Prometheus datasource could be ` +
          'resolved to run the snapshot; panel data is unavailable in this context.'
      );
      return parts.join('\n');
    }
  }

  // Datasource health: an unhealthy datasource explains everything else.
  try {
    const health = (await getBackendSrv().get(`/api/datasources/uid/${effectiveDs.uid}/health`)) as {
      status?: string;
      message?: string;
    };
    parts.push(
      `Datasource ${effectiveDs.uid} (${effectiveDs.type ?? 'unknown type'}) health: ` +
        `${health?.status ?? 'unknown'}${health?.message ? ' — ' + health.message : ''}`
    );
  } catch (err) {
    parts.push(
      `Datasource ${effectiveDs.uid} (${effectiveDs.type ?? 'unknown type'}) health check FAILED: ` +
        (err instanceof Error ? err.message : 'not reachable or not found')
    );
  }

  // Split targets into runnable queries and ones blocked by template variables.
  const runnable: Array<Record<string, unknown>> = [];
  for (const target of withDatasource.slice(0, 4)) {
    const exprText = typeof target.expr === 'string' ? target.expr : '';
    const vars = findTemplateVars(exprText);
    if (vars.length > 0) {
      parts.push(
        `Query ${typeof target.refId === 'string' ? target.refId : '?'} contains unresolved dashboard ` +
          `variables (${vars.join(', ')}) and cannot run verbatim from this chat. When re-querying with ` +
          'tools, drop or substitute those matchers — "$var" is never a literal label value.'
      );
      continue;
    }
    runnable.push({ ...target, datasource: effectiveDs });
  }

  if (runnable.length > 0) {
    try {
      const queries = runnable.map((t, i) => ({
        ...t,
        refId: typeof t.refId === 'string' ? t.refId : String.fromCharCode(65 + i),
        intervalMs: 30000,
        maxDataPoints: 100,
      }));
      const response = await getBackendSrv().post('/api/ds/query', { queries, from, to });
      parts.push(summarizeDsQueryResponse(response));
    } catch (err) {
      parts.push('Running the panel queries failed: ' + (err instanceof Error ? err.message : 'unknown error'));
    }
  }

  return parts.join('\n');
};

// Worked examples for the planner: without these the model has to invent
// PromQL and investigation patterns from scratch, which is where wrong
// queries and guessed answers come from.
const QUERY_GUIDANCE = [
  'Query recipes (adapt namespace/labels as needed):',
  '- Namespace CPU: sum(rate(container_cpu_usage_seconds_total{namespace="X",container!=""}[5m]))',
  '- Namespace memory: sum(container_memory_working_set_bytes{namespace="X",container!=""})',
  '- Pod count: count(kube_pod_info{namespace="X"})',
  '- Pod restarts: increase(kube_pod_container_status_restarts_total{namespace="X"}[1h])',
  '- Disk fill forecast: predict_linear(kubelet_volume_stats_available_bytes[6h], 86400)',
  'Investigation patterns:',
  '- "Is this normal?" -> run the same expr twice with query_prometheus: current window, then wrapped in (expr offset 1d) or offset 7d, and compare.',
  '- Panel shows no data -> explain_empty_query with the panel expr; if the metric is absent -> check_metric_exists; if stale -> list_failing_targets.',
  '- Spike/anomaly -> query_prometheus around when it started, then recent_changes with the same window to correlate restarts/rollouts/OOM kills.',
  '- "the Viya namespace" -> Viya namespaces are customer-named (e.g. d122472); call list_viya_namespaces to resolve, never assume namespace="viya" or "Viya".',
  '- Pod inventory / "what does each pod do" -> list_pods for the workloads, then search_docs to explain each component.',
  '- Panel queries may contain unresolved dashboard variables like $cluster or ${datasource}. "$var" is never a literal value: drop or substitute those matchers before querying, and never diagnose the datasource as broken merely because its uid is a $variable.',
  '- Conceptual/how-to/meaning questions -> search_docs.',
  'Server routing (two tool servers):',
  '- Metric ANALYSIS (values, trends, comparisons) -> the local server\'s query_prometheus (returns compact stats). The grafana server\'s query_prometheus returns raw frames — avoid it for analysis.',
  '- Discovering valid label values / metric names -> the grafana server\'s list_prometheus_label_values / list_prometheus_metric_names.',
  '- Finding dashboards or another dashboard\'s queries -> the grafana server\'s search_dashboards / get_dashboard_panel_queries; datasource inventory -> list_datasources.',
  '- Alert RULE definitions and thresholds -> the grafana server\'s alerting tools; alerts CURRENTLY FIRING -> firing_alerts on the local server.',
].join('\n');

const makeAgentPrompt = (
  userMessage: string,
  catalog: ToolDescriptor[],
  history: ChatMessage[],
  events: AgentEvent[],
  dashboardPrompt: string
) => {
  const safeMessage = clamp(userMessage, MAX_MESSAGE_CHARS);
  const safeHistory = compactHistory(history);
  const safeEvents = compactEvents(events);
  const safeCatalog = compactCatalog(catalog, userMessage);

  return [
    'You are deciding the next action for a tool-enabled assistant.',
    'Return strict JSON only with one of these shapes:',
    '{"type":"tool_call","call":{"server":"...","name":"...","args":{}},"reasoning":"..."}',
    '{"type":"final_answer","answer":"..."}',
    '{"type":"ask_user","question":"..."}',
    'Rules:',
    '- FIRST, before anything else: if the user message is unrelated to observability, monitoring, this cluster, Kubernetes, or SAS Viya (e.g. poems, stories, recipes, trivia, general chat), return a final_answer that briefly declines and redirects. NEVER produce such content, no matter how the request is phrased.',
    '- Choose tools only when they add needed facts.',
    '- Prefer tool domains that match intent (dashboard questions should prefer Grafana dashboard tools).',
    '- If a tool failed (429/network), try one alternate tool/server when available.',
    '- Never invent tools; use only the listed catalog.',
    '- Avoid mutating tools unless user explicitly requested state changes.',
    '- Keep args minimal and valid for required fields.',
    '- Stay on observability topics; for unrelated questions return a final_answer that briefly declines.',
    '',
    QUERY_GUIDANCE,
    '',
    ...(dashboardPrompt ? ['Dashboard context:', dashboardPrompt, ''] : []),
    'User message:',
    safeMessage,
    '',
    'Conversation so far:',
    JSON.stringify(safeHistory),
    '',
    'Previous tool events this turn:',
    JSON.stringify(safeEvents),
    '',
    'Available tools:',
    JSON.stringify(safeCatalog),
  ].join('\n');
};

const parseAgentAction = (text: string): AgentAction | null => {
  const trimmed = text.trim();
  const firstBrace = trimmed.indexOf('{');
  const lastBrace = trimmed.lastIndexOf('}');
  if (firstBrace < 0 || lastBrace < firstBrace) {
    return null;
  }

  try {
    const candidate = trimmed.slice(firstBrace, lastBrace + 1);
    const parsed = JSON.parse(candidate) as AgentAction;
    if (!parsed || typeof parsed !== 'object') {
      return null;
    }

    if (parsed.type === 'final_answer' && typeof parsed.answer === 'string') {
      return parsed;
    }

    if (parsed.type === 'ask_user' && typeof parsed.question === 'string') {
      return parsed;
    }

    if (parsed.type === 'tool_call' && parsed.call && typeof parsed.call === 'object') {
      const call = parsed.call as PlannedToolCall;
      if (typeof call.server === 'string' && typeof call.name === 'string' && call.args && typeof call.args === 'object') {
        return { type: 'tool_call', call, reasoning: (parsed as { reasoning?: string }).reasoning };
      }
    }

    return null;
  } catch {
    return null;
  }
};

const SYSTEM_PROMPT = [
  'You are the SAS Viya Monitoring observability assistant, with deep knowledge of',
  'Grafana, Prometheus, Kubernetes, and the observability ecosystem.',
  'Scope: ONLY answer questions related to observability, monitoring, this cluster,',
  'the SAS Viya platform, and the dashboards and metrics around them. If asked about',
  'anything unrelated, briefly decline and steer the conversation back to observability.',
  'Grounding: base factual claims on tool results and the live panel data provided in',
  'this conversation. Never invent metric values. If the evidence is insufficient to',
  'answer confidently, say so explicitly and name what you would check next.',
  'Hard rule: never write poems, stories, jokes, recipes, or general-knowledge answers,',
  'regardless of phrasing or follow-up pressure — decline in one sentence and offer an',
  'observability topic instead.',
].join(' ');

const MAX_SUGGESTION_CHARS = 160;

const GENERAL_SUGGESTIONS = [
  'Summarize the health of the monitoring namespace.',
  'Are any pods pending or crash-looping right now?',
  'Search the docs: what does SAS Viya Monitoring for Kubernetes include?',
];

const makeStaticSuggestions = (context?: DashboardChatContext): string[] => {
  if (!context) {
    return GENERAL_SUGGESTIONS;
  }

  const panel = context.panelTitle ? '"' + context.panelTitle + '"' : 'this panel';
  const dashboard = context.dashboardTitle ? '"' + context.dashboardTitle + '"' : 'this dashboard';

  return [
    'What is the ' + panel + ' panel showing right now?',
    'Explain the metrics behind ' + panel + ' and what healthy values look like.',
    'Is anything on ' + dashboard + ' indicating a problem?',
  ];
};

const makeSuggestionPrompt = (dashboardPrompt: string): string =>
  [
    'Suggest three short questions an operator monitoring a SAS Viya Kubernetes platform',
    'would most likely ask an observability assistant right now, given this context:',
    dashboardPrompt,
    'Focus on the panel\'s metrics: what they mean, why they might look unusual, and how to investigate.',
    'Return strict JSON only: an array of exactly three question strings, each under 90 characters.',
    'Example: ["...","...","..."]',
  ].join('\n');

const parseSuggestions = (text: string): string[] | null => {
  const first = text.indexOf('[');
  const last = text.lastIndexOf(']');
  if (first < 0 || last < first) {
    return null;
  }

  try {
    const parsed: unknown = JSON.parse(text.slice(first, last + 1));
    if (!Array.isArray(parsed)) {
      return null;
    }

    const questions = parsed
      .filter((q): q is string => typeof q === 'string' && q.trim() !== '')
      .map((q) => clamp(q.trim(), MAX_SUGGESTION_CHARS));

    return questions.length >= 3 ? questions.slice(0, 3) : null;
  } catch {
    return null;
  }
};

export const ChatPanel = ({ context, compact }: ChatPanelProps): JSX.Element => {
  const s = useStyles2(getStyles);
  const appMeta = useOptionalAppMeta();
  const pluginContext = usePluginContext();
  // On the plugin page the meta comes from AppMetaProvider; in extension
  // components (modal/sidebar) it comes from Grafana's plugin context.
  const jsonData = (appMeta?.jsonData ?? pluginContext?.meta?.jsonData) as AppPluginSettings | undefined;

  const [input, setInput] = useState('');
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [draftReply, setDraftReply] = useState('');
  const [isSending, setIsSending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const requestSeqRef = useRef(0);
  const cancelRequestedRef = useRef(false);

  const [pendingApproval, setPendingApproval] = useState<PendingApproval | null>(null);

  const [suggestions, setSuggestions] = useState<string[]>(() => makeStaticSuggestions(context));
  const suggestionKeyRef = useRef<string | null>(null);

  const [panelSnapshot, setPanelSnapshot] = useState('');
  const snapshotKeyRef = useRef<string | null>(null);

  // Fetch the panel's live data (and datasource health) once per panel, at
  // chat open, so the model sees what the user sees without a tool call.
  useEffect(() => {
    const key = context ? JSON.stringify([context.dashboardUid, context.panelTitle]) : '';
    if (snapshotKeyRef.current === key) {
      return;
    }
    snapshotKeyRef.current = key;
    setPanelSnapshot('');

    if (!context) {
      return;
    }

    let cancelled = false;
    (async () => {
      try {
        const snapshot = await fetchPanelSnapshot(context);
        if (snapshot && !cancelled) {
          setPanelSnapshot(snapshot);
        }
      } catch {
        // The snapshot is best-effort context; the agent can still use tools.
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [context]);

  // Static suggestions render immediately; when dashboard context is present,
  // ask the model for three questions tailored to the panel's queries and
  // swap them in. The key ref keeps re-renders with an identical context from
  // re-triggering the LLM call.
  useEffect(() => {
    const key = context ? JSON.stringify([context.dashboardUid, context.panelTitle]) : '';
    if (suggestionKeyRef.current === key) {
      return;
    }
    suggestionKeyRef.current = key;

    setSuggestions(makeStaticSuggestions(context));

    const dashboardPrompt = makeDashboardContextPrompt(context);
    if (!dashboardPrompt) {
      return;
    }

    let cancelled = false;
    (async () => {
      try {
        const enabled = await openai.enabled();
        if (!enabled || cancelled) {
          return;
        }

        const response = await openai.chatCompletions({
          messages: [{ role: 'system', content: makeSuggestionPrompt(dashboardPrompt) }],
        });

        const tailored = parseSuggestions(response?.choices?.[0]?.message?.content ?? '');
        if (tailored && !cancelled) {
          setSuggestions(tailored);
        }
      } catch {
        // Keep the static fallbacks; suggestions must never surface an error.
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [context]);

  const stopProcessing = () => {
    cancelRequestedRef.current = true;
    requestSeqRef.current += 1;
    setIsSending(false);
    setDraftReply('');
    setError(null);
  };

  useEffect(() => {
    return () => {
      cancelRequestedRef.current = true;
      requestSeqRef.current += 1;
    };
  }, []);

  const sendMessage = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    await submitMessage(input);
  };

  // Shared send path for the input form and the suggestion chips.
  const submitMessage = async (raw: string) => {
    const trimmedInput = raw.trim();
    if (!trimmedInput || isSending) {
      return;
    }

    setError(null);

    const requestId = requestSeqRef.current + 1;
    requestSeqRef.current = requestId;
    cancelRequestedRef.current = false;

    const isActiveRequest = () => requestSeqRef.current === requestId && !cancelRequestedRef.current;
    const STOP_SENTINEL = '__REQUEST_STOPPED__';
    const assertActiveRequest = () => {
      if (!isActiveRequest()) {
        throw new Error(STOP_SENTINEL);
      }
    };

    const errText = (err: unknown): string => (err instanceof Error ? err.message : 'unknown');

    const dashboardPrompt = makeDashboardContextPrompt(context, panelSnapshot);
    const dashboardSystemMessages = dashboardPrompt
      ? [{ role: 'system' as const, content: dashboardPrompt }]
      : [];

    try {
      const enabled = await openai.enabled();
      assertActiveRequest();
      if (!enabled) {
        setError('The OpenAI integration is not enabled for this plugin.');
        return;
      }

      const servers: McpServerConfig[] = [
        { name: 'local-fastmcp', url: jsonData?.mcpServerOneUrl ?? '' },
        { name: 'grafana', url: jsonData?.mcpServerTwoUrl ?? '' },
      ].filter(isConfiguredServer);

      setDraftReply('');
      setIsSending(true);

      const nextMessages = [...messages, { role: 'user' as const, content: trimmedInput }];
      const messagesForModel = compactHistory(nextMessages);
      setMessages(nextMessages);
      setInput('');
      setHistoryIndex(null);
      setHistoryDraft('');

      if (servers.length === 0) {
        const response = await openai.chatCompletions({
          messages: [{ role: 'system', content: SYSTEM_PROMPT }, ...dashboardSystemMessages, ...messagesForModel],
        });
        assertActiveRequest();

        const finalReply = response?.choices?.[0]?.message?.content?.trim() ?? '';
        if (finalReply) {
          setMessages((current) => [...current, { role: 'assistant', content: finalReply }]);
        } else {
          setError('The model returned an empty response.');
        }

        setDraftReply('');
        setIsSending(false);
        return;
      }

      const discovery = await listAllToolsSafe(servers);
      assertActiveRequest();
      const catalog = getToolCatalog(discovery.tools);
      const events: AgentEvent[] = discovery.errors.map((e: ToolDiscoveryError) => ({
        type: 'discovery_error',
        server: e.server,
        message: e.message,
      }));

      if (catalog.length === 0) {
        const discoverySummary =
          discovery.errors.length > 0
            ? 'No MCP tools available. Discovery errors: ' + discovery.errors.map((e) => e.server + ': ' + e.message).join(' | ')
            : '';

        const response = await openai.chatCompletions({
          messages: [
            { role: 'system', content: SYSTEM_PROMPT },
            ...dashboardSystemMessages,
            ...(discoverySummary ? [{ role: 'system' as const, content: discoverySummary }] : []),
            ...messagesForModel,
          ],
        });
        assertActiveRequest();

        const finalReply = response?.choices?.[0]?.message?.content?.trim() ?? '';
        if (finalReply) {
          setMessages((current) => [...current, { role: 'assistant', content: finalReply }]);
        } else {
          setError('The model returned an empty response.');
        }

        setDraftReply('');
        setIsSending(false);
        return;
      }

      if (pendingApproval) {
        if (isDenial(trimmedInput)) {
          setPendingApproval(null);
          setMessages((current) => [...current, { role: 'assistant', content: 'Tool call blocked. No changes were made.' }]);
          setIsSending(false);
          return;
        }

        if (isApproval(trimmedInput)) {
          const approved = pendingApproval.call;
          setPendingApproval(null);

          try {
            const result = await callMcpTool(approved.server, approved.name, approved.args);
            assertActiveRequest();
            events.push({
              type: 'tool_success',
              server: approved.server,
              name: approved.name,
              args: approved.args,
              result,
            });
          } catch (err) {
            events.push({
              type: 'tool_error',
              server: approved.server,
              name: approved.name,
              args: approved.args,
              message: errText(err),
            });
          }
        } else {
          setMessages((current) => [
            ...current,
            { role: 'assistant', content: 'A change-capable tool call is pending approval. Reply "approve" or "deny".' },
          ]);
          setIsSending(false);
          return;
        }
      }

      let finalAnswer = '';
      let askedQuestion = '';

      for (let step = 0; step < AGENT_MAX_STEPS; step += 1) {
        const actionResp = await openai.chatCompletions({
          messages: [
            {
              role: 'system',
              content: makeAgentPrompt(trimmedInput, catalog, nextMessages, events, dashboardPrompt),
            },
          ],
        });
        assertActiveRequest();

        const actionText = actionResp?.choices?.[0]?.message?.content ?? '';
        const action = parseAgentAction(actionText);

        if (!action) {
          events.push({
            type: 'tool_error',
            server: 'agent',
            name: 'planner',
            args: {},
            message: 'Planner returned invalid action JSON.',
          });
          continue;
        }

        if (action.type === 'final_answer') {
          finalAnswer = action.answer.trim();
          break;
        }

        if (action.type === 'ask_user') {
          askedQuestion = action.question.trim();
          break;
        }

        const call = action.call;
        const validationError = validatePlannedCall(call, catalog);
        if (validationError) {
          events.push({
            type: 'tool_error',
            server: call.server,
            name: call.name,
            args: call.args,
            message: validationError,
          });
          continue;
        }

        const isMutating = catalog.some((t) => t.server === call.server && t.name === call.name && t.mutating);
        if (isMutating) {
          setPendingApproval({ call, reason: 'Tool appears to modify state.' });
          setMessages((current) => [
            ...current,
            {
              role: 'assistant',
              content:
                'This action may change data:\n' +
                call.server +
                '.' +
                call.name +
                '(' +
                JSON.stringify(call.args) +
                ')\n\n' +
                'Reply "approve" to run this one call, or "deny" to block it.',
            },
          ]);
          setIsSending(false);
          return;
        }

        try {
          const result = await callMcpTool(call.server, call.name, call.args);
          assertActiveRequest();
          events.push({
            type: 'tool_success',
            server: call.server,
            name: call.name,
            args: call.args,
            result,
          });
        } catch (err) {
          events.push({
            type: 'tool_error',
            server: call.server,
            name: call.name,
            args: call.args,
            message: errText(err),
          });
        }
      }

      if (askedQuestion) {
        setMessages((current) => [...current, { role: 'assistant', content: askedQuestion }]);
        setIsSending(false);
        return;
      }

      if (!finalAnswer) {
        const toolSummary = clamp(
          events
            .map((e) => {
              if (e.type === 'tool_success') {
                return e.server + '.' + e.name + ': ' + serializeResult(e.result);
              }
              if (e.type === 'tool_error') {
                return e.server + '.' + e.name + ' failed: ' + e.message;
              }
              return e.server + ' discovery failed: ' + e.message;
            })
            .join('\n\n'),
          MAX_TOOL_SUMMARY_CHARS
        );

        const response = await openai.chatCompletions({
          messages: [
            { role: 'system', content: SYSTEM_PROMPT },
            ...dashboardSystemMessages,
            ...(toolSummary ? [{ role: 'system' as const, content: 'Tool execution summary:\n' + toolSummary }] : []),
            ...messagesForModel,
          ],
        });
        assertActiveRequest();

        finalAnswer = response?.choices?.[0]?.message?.content?.trim() ?? '';
      }

      if (finalAnswer) {
        setMessages((current) => [...current, { role: 'assistant', content: finalAnswer }]);
      } else {
        setError('The model returned an empty response.');
      }

      setDraftReply('');
      setIsSending(false);
    } catch (err) {
      if (err instanceof Error && err.message === STOP_SENTINEL) {
        return;
      }

      setIsSending(false);
      setError(err instanceof Error ? err.message : 'Failed to generate a reply.');
    }
  };

  const [historyIndex, setHistoryIndex] = useState<number | null>(null);
  const [historyDraft, setHistoryDraft] = useState('');

  const userPromptHistory = messages
    .filter((m) => m.role === 'user')
    .map((m) => m.content);

  const handleInputKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (isSending) {
      return;
    }

    if (e.key !== 'ArrowUp' && e.key !== 'ArrowDown') {
      return;
    }

    if (userPromptHistory.length === 0) {
      return;
    }

    e.preventDefault();

    const getPromptAt = (idx: number): string => {
      const reverseIndex = userPromptHistory.length - 1 - idx;
      return userPromptHistory[reverseIndex] ?? '';
    };

    if (e.key === 'ArrowUp') {
      if (historyIndex === null) {
        setHistoryDraft(input);
        setHistoryIndex(0);
        setInput(getPromptAt(0));
        return;
      }

      const next = Math.min(historyIndex + 1, userPromptHistory.length - 1);
      setHistoryIndex(next);
      setInput(getPromptAt(next));
      return;
    }

    if (historyIndex === null) {
      return;
    }

    if (historyIndex === 0) {
      setHistoryIndex(null);
      setInput(historyDraft);
      return;
    }

    const next = historyIndex - 1;
    setHistoryIndex(next);
    setInput(getPromptAt(next));
  };

  const contextLabel = context
    ? [context.panelTitle, context.dashboardTitle].filter(Boolean).join(' — ')
    : '';

  return (
    <div className={compact ? s.chatShellCompact : s.chatShell}>
      {compact ? (
        contextLabel ? (
          <div className={s.contextChip}>Context: {contextLabel}</div>
        ) : null
      ) : (
        <div className={s.header}>
          <div className={s.title}>Observability Chatbot</div>
          <div className={s.subtitle}>Powered by the Grafana LLM integration</div>
        </div>
      )}

      <div className={cx(s.conversation, compact && s.conversationCompact)} aria-live="polite">
        {messages.length === 0 ? (
          <div className={s.emptyState}>
            <div>
              {context
                ? 'Ask a question about this panel or dashboard, or anything else you want to explore.'
                : 'Ask a question about Grafana, Prometheus, observability, or anything else you want to explore.'}
            </div>
            <div className={s.suggestionRow}>
              {suggestions.map((question) => (
                <button
                  key={question}
                  type="button"
                  className={s.suggestionChip}
                  onClick={() => submitMessage(question)}
                  disabled={isSending}
                >
                  {question}
                </button>
              ))}
            </div>
          </div>
        ) : (
          messages.map((message, index) => (
            <div
              key={`${message.role}-${index}-${message.content.slice(0, 20)}`}
              className={message.role === 'user' ? s.userRow : s.assistantRow}
            >
              <div className={message.role === 'user' ? s.userBubble : s.assistantBubble}>
                {message.content}
              </div>
            </div>
          ))
        )}

        {isSending ? (
          <div className={s.assistantRow}>
            <div className={s.assistantBubble}>
              <div className={s.streamingHeader}>
                <Spinner size="sm" />
                <span>Thinking...</span>
              </div>
              {draftReply ? <div className={s.streamingText}>{draftReply}</div> : null}
            </div>
          </div>
        ) : null}
      </div>

      {error ? <div className={s.error}>{error}</div> : null}

      <form className={s.form} onSubmit={sendMessage}>
        <Input
          value={input}
          onChange={(e) => {
            const value = e.currentTarget.value;
            setInput(value);
            setHistoryDraft(value);
            if (historyIndex !== null) {
              setHistoryIndex(null);
            }
          }}
          onKeyDown={handleInputKeyDown}
          placeholder="Type your message and press Enter"
          disabled={isSending}
        />
        {isSending ? (
          <Button type="button" onClick={stopProcessing}>
            Stop
          </Button>
        ) : (
          <Button type="submit" disabled={input.trim() === ''}>
            Send
          </Button>
        )}
      </form>
    </div>
  );
};

export default ChatPanel;

const getStyles = (theme: GrafanaTheme2) => ({
  chatShell: css`
    max-width: 920px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: ${theme.spacing(2)};
  `,
  chatShellCompact: css`
    height: 100%;
    display: flex;
    flex-direction: column;
    gap: ${theme.spacing(1)};
  `,
  header: css`
    display: flex;
    flex-direction: column;
    gap: ${theme.spacing(0.5)};
  `,
  title: css`
    font-size: ${theme.typography.h2.fontSize};
    font-weight: ${theme.typography.fontWeightBold};
    color: ${theme.colors.text.primary};
  `,
  subtitle: css`
    color: ${theme.colors.text.secondary};
  `,
  contextChip: css`
    align-self: flex-start;
    padding: ${theme.spacing(0.5)} ${theme.spacing(1)};
    border-radius: ${theme.shape.radius.default};
    background: ${theme.colors.background.secondary};
    border: 1px solid ${theme.colors.border.weak};
    color: ${theme.colors.text.secondary};
    font-size: ${theme.typography.bodySmall.fontSize};
  `,
  conversation: css`
    min-height: 420px;
    padding: ${theme.spacing(2)};
    border: 1px solid ${theme.colors.border.medium};
    border-radius: ${theme.shape.radius.default};
    background: ${theme.colors.background.primary};
    display: flex;
    flex-direction: column;
    gap: ${theme.spacing(1.5)};
    overflow-y: auto;
  `,
  conversationCompact: css`
    flex: 1;
    min-height: 0;
  `,
  emptyState: css`
    color: ${theme.colors.text.secondary};
    padding: ${theme.spacing(2)};
    display: flex;
    flex-direction: column;
    gap: ${theme.spacing(2)};
  `,
  suggestionRow: css`
    display: flex;
    flex-wrap: wrap;
    gap: ${theme.spacing(1)};
  `,
  suggestionChip: css`
    max-width: 100%;
    padding: ${theme.spacing(1)} ${theme.spacing(1.5)};
    border: 1px solid ${theme.colors.border.medium};
    border-radius: ${theme.shape.radius.pill};
    background: ${theme.colors.background.secondary};
    color: ${theme.colors.text.primary};
    font-size: ${theme.typography.bodySmall.fontSize};
    font-family: inherit;
    text-align: left;
    cursor: pointer;

    &:hover:not(:disabled) {
      border-color: ${theme.colors.primary.border};
      background: ${theme.colors.action.hover};
    }

    &:focus-visible {
      outline: 2px solid ${theme.colors.primary.border};
      outline-offset: 2px;
    }

    &:disabled {
      cursor: default;
      opacity: 0.6;
    }
  `,
  userRow: css`
    display: flex;
    justify-content: flex-end;
  `,
  assistantRow: css`
    display: flex;
    justify-content: flex-start;
  `,
  userBubble: css`
    max-width: min(720px, 85%);
    padding: ${theme.spacing(1.5)};
    border-radius: ${theme.shape.radius.default};
    background: ${theme.colors.primary.main};
    color: ${theme.colors.primary.contrastText};
    white-space: pre-wrap;
    word-break: break-word;
  `,
  assistantBubble: css`
    max-width: min(720px, 85%);
    padding: ${theme.spacing(1.5)};
    border-radius: ${theme.shape.radius.default};
    background: ${theme.colors.background.secondary};
    color: ${theme.colors.text.primary};
    white-space: pre-wrap;
    word-break: break-word;
    border: 1px solid ${theme.colors.border.weak};
  `,
  streamingHeader: css`
    display: inline-flex;
    align-items: center;
    gap: ${theme.spacing(1)};
    color: ${theme.colors.text.secondary};
    margin-bottom: ${theme.spacing(1)};
  `,
  streamingText: css`
    white-space: pre-wrap;
    word-break: break-word;
  `,
  error: css`
    padding: ${theme.spacing(1.5)};
    border-radius: ${theme.shape.radius.default};
    background: ${theme.colors.error.transparent};
    color: ${theme.colors.error.text};
    border: 1px solid ${theme.colors.error.border};
  `,
  form: css`
    display: flex;
    gap: ${theme.spacing(1)};
    align-items: center;
  `,
});
