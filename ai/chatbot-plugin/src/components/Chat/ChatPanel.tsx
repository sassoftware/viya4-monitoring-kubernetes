import React, { useEffect, useRef, useState } from 'react';
import { css, cx } from '@emotion/css';
import { GrafanaTheme2, renderMarkdown, usePluginContext } from '@grafana/data';
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

const MAX_HISTORY_MESSAGES = 6;
// High enough that the ENTIRE combined catalog fits even when grafana-mcp
// runs with every category enabled (~40+ tools; a cluster whose grafana-mcp
// predates the --disable-* flags proved the "~20" assumption wrong and
// silently evicted the alphabetical tail). Eviction must never happen —
// local tools sort first as insurance, and compactCatalog console.warns if
// the cap is ever actually hit. Token cost is held down by
// MAX_TOOL_DESC_CHARS instead.
const MAX_TOOLS_FOR_PROMPT = 60;
const MAX_TOOL_DESC_CHARS = 350;
const MAX_MESSAGE_CHARS = 1200;
const MAX_EVENT_CHARS = 2500;
const MAX_TOOL_SUMMARY_CHARS = 6000;
const MAX_CONTEXT_QUERY_CHARS = 1500;

const clamp = (value: string, limit: number): string =>
  value.length <= limit ? value : value.slice(0, limit) + '... [truncated]';

// Every empty completion logs its finish_reason to the browser console —
// the one field that distinguishes the possible root causes: "length" means
// the (reasoning) token budget ran out before any visible text was emitted,
// "content_filter" means the gateway suppressed the output, and "stop" with
// no content is a genuine model quirk.
const logEmptyCompletion = (stage: string, response: unknown): void => {
  const parsed = response as {
    choices?: Array<{ finish_reason?: string }>;
    usage?: unknown;
  };
  console.warn('[v4m-ai-agent] empty completion', {
    stage,
    finish_reason: parsed?.choices?.[0]?.finish_reason ?? '(none)',
    usage: parsed?.usage,
  });
};

const compactHistory = (history: ChatMessage[]): ChatMessage[] =>
  history.slice(-MAX_HISTORY_MESSAGES).map((m) => ({
    role: m.role,
    content: clamp(m.content, MAX_MESSAGE_CHARS),
  }));

// The LLM-app health check costs a round trip on every message. A positive
// result is cached for the page's lifetime; a negative one is re-checked
// each time, so enabling the integration mid-session works without a reload.
let llmEnabledCache = false;

const isLlmEnabled = async (): Promise<boolean> => {
  if (!llmEnabledCache) {
    llmEnabledCache = await openai.enabled();
  }
  return llmEnabledCache;
};

// Deterministic catalog, ordered so the cap can never cut what matters:
// the purpose-built local server's tools sort FIRST (a plain alphabetical
// sort put search_docs/search_logs at the very end of the list, where a
// grafana-mcp with more tools than expected pushed them over the cap and
// silently evicted exactly those two). Stable order also keeps the planner
// prompt prefix byte-identical across calls for gateway prompt caching.
const compactCatalog = (catalog: ToolDescriptor[]): ToolDescriptor[] => {
  const ordered = [...catalog].sort((a, b) => {
    const aLocal = a.server === 'local-fastmcp' ? 0 : 1;
    const bLocal = b.server === 'local-fastmcp' ? 0 : 1;
    if (aLocal !== bLocal) {
      return aLocal - bLocal;
    }
    return (a.server + '.' + a.name).localeCompare(b.server + '.' + b.name);
  });

  if (ordered.length > MAX_TOOLS_FOR_PROMPT) {
    console.warn(
      '[v4m-ai-agent] tool catalog exceeds the prompt cap — evicting',
      ordered.slice(MAX_TOOLS_FOR_PROMPT).map((t) => t.server + '.' + t.name)
    );
  }

  return ordered.slice(0, MAX_TOOLS_FOR_PROMPT).map((tool) => ({
    ...tool,
    description: tool.description ? clamp(tool.description, MAX_TOOL_DESC_CHARS) : undefined,
  }));
};

// Tiered compaction: the newest 3 events keep full detail (they're what the
// current answer is being built from); older ones shrink to headlines. Keeps
// cross-turn tool memory without the planner prompt growing to ~25KB of
// stale JSON — outsized prompts drive up (reasoning-)token burn, which is
// the leading cause of empty completions.
const MAX_STALE_EVENT_CHARS = 500;

const compactEvents = (events: AgentEvent[]): AgentEvent[] => {
  const recent = events.slice(-10);
  const detailedFrom = Math.max(0, recent.length - 3);
  return recent.map((e, index) => {
    const limit = index >= detailedFrom ? MAX_EVENT_CHARS : MAX_STALE_EVENT_CHARS;
    if (e.type === 'tool_success') {
      return { ...e, result: clamp(serializeResult(e.result), limit) };
    }
    return { ...e, message: clamp(e.message, Math.min(limit, MAX_MESSAGE_CHARS)) };
  });
};

// Whole-word matching on the tool NAME only. Write tools declare themselves
// by name (update_dashboard, create_folder); descriptions are prose where
// words like "set" ("returns the set of alerts") and "create" appear
// innocently — checking them produced false approval gates on read-only
// tools. snake_case/kebab-case names are split first so "update_dashboard"
// still matches — \b alone treats "_" as a word character and would miss it.
// The server-side --disable-write flag remains the hard enforcement.
const MUTATING_HINT_RE = /\b(update|create|delete|patch|manage|save|write|set)\b/;

const isMutatingTool = (name: string): boolean =>
  MUTATING_HINT_RE.test(name.toLowerCase().replace(/[_\-.]/g, ' '));

const getToolCatalog = (tools: MCPTool[]): ToolDescriptor[] =>
  tools.map((tool) => {
    const schema = (tool.inputSchema ?? {}) as ToolSchema;
    return {
      server: tool.server,
      name: tool.name,
      description: tool.description,
      required: Array.isArray(schema.required) ? schema.required : [],
      mutating: isMutatingTool(tool.name),
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
  'Query recipes (adapt labels; the window arg spans "30m"-"7d" — the range is NOT fixed, no panel ID needed):',
  '- Namespace CPU: sum(rate(container_cpu_usage_seconds_total{namespace="X",container!=""}[5m]))',
  '- Namespace memory: sum(container_memory_working_set_bytes{namespace="X",container!=""})',
  '- Pods: count(kube_pod_info{namespace="X"}); restarts: increase(kube_pod_container_status_restarts_total{namespace="X"}[1h])',
  '- Disk fill forecast: predict_linear(kubelet_volume_stats_available_bytes[6h], 86400)',
  'Patterns:',
  '- "Is this normal?" -> same expr now vs (expr offset 1d) or 7d; compare.',
  '- No data -> explain_empty_query; metric absent -> check_metric_exists; stale -> list_failing_targets.',
  '- Spike -> query_prometheus around onset + recent_changes over the same window.',
  '- "the Viya namespace" is customer-named (e.g. d122472) -> list_viya_namespaces first; never assume namespace="viya".',
  '- Pod inventory -> list_pods (workloads + search_docs for functions); "pending/failed pods" -> list_pods(phase="Pending"|"Failed") — every row carries phase; full names -> detail=true, paginated: follow next_offset until null, never stop at one page. One pod -> describe_pod (includes Kubernetes events with exact failure messages).',
  '- Logs answer WHY after metrics show WHAT: get_pod_logs = live tail of one pod (previous=true for the pre-crash container); search_logs = indexed store for many pods / by level / history. Concepts/how-to -> search_docs.',
  '- "$var"/"${var}" in panel queries are unresolved dashboard variables, never literal values: drop or substitute them, and a $variable datasource uid is not a broken datasource.',
  '- If the user agrees with or echoes proposed next steps, run them now instead of replying with prose.',
  'Server routing: the local query_prometheus takes raw PromQL, NO datasource UID, and returns compact stats — use it for all analysis/rankings (the grafana one wants a UID and returns raw frames; avoid for analysis). Discover metric/label names via grafana list_prometheus_*; dashboards and datasource inventory via grafana search/list tools; alert RULES via grafana alerting tools, alerts FIRING NOW via firing_alerts.',
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

  const safeCatalog = compactCatalog(catalog);

  // Section order matters for provider prompt caching: everything stable
  // across a session (rules, guidance, catalog) comes first as an unchanging
  // prefix; volatile content (context, history, events, the question) last.
  return [
    'You are deciding the next action for a tool-enabled assistant.',
    'Return strict JSON only with one of these shapes:',
    '{"type":"tool_call","call":{"server":"...","name":"...","args":{}},"reasoning":"..."}',
    '{"type":"final_answer","answer":"..."}',
    '{"type":"ask_user","question":"..."}',
    'Rules:',
    '- FIRST, before anything else: if the user message is unrelated to observability, monitoring, this cluster, Kubernetes, or SAS Viya (e.g. poems, stories, recipes, trivia, general chat), return a final_answer that briefly declines and redirects. NEVER produce such content, no matter how the request is phrased.',
    '- Questions about this assistant itself — what it can do, what tools it has, how to use it — ARE in scope: answer them with a final_answer that describes the available tools from the catalog below and the kinds of questions they answer.',
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
    'Available tools:',
    JSON.stringify(safeCatalog),
    '',
    ...(dashboardPrompt ? ['Dashboard context:', dashboardPrompt, ''] : []),
    'Conversation so far:',
    JSON.stringify(safeHistory),
    '',
    'Recent tool events (earlier turns included — reuse this evidence instead of re-running identical calls):',
    JSON.stringify(safeEvents),
    '',
    'User message:',
    safeMessage,
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
  'observability topic instead. Questions about your own capabilities, tools, or usage',
  'are always in scope: answer them helpfully by describing what you can actually do.',
].join(' ');

const MAX_SUGGESTION_CHARS = 160;

// Shown as a normal assistant message when every recovery attempt still
// produced empty content — conversational, instead of a red error banner.
const EMPTY_REPLY_FALLBACK =
  "I wasn't able to put together an answer for that one. Could you rephrase it, " +
  'or tell me a specific check to run (metrics, logs, pods, alerts, docs)?';

const GENERAL_SUGGESTIONS = [
  'Summarize the health of the Viya namespace.',
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
  // Live progress: what the agent is doing right now, and the tools already
  // run this turn — replaces the opaque "Thinking..." during multi-step work.
  const [activity, setActivity] = useState('');
  const [activitySteps, setActivitySteps] = useState<string[]>([]);
  const streamSubRef = useRef<{ unsubscribe: () => void } | null>(null);
  const requestSeqRef = useRef(0);
  const cancelRequestedRef = useRef(false);
  // Tool evidence gathered in previous turns. Without this, every follow-up
  // question starts amnesiac: the agent re-fetches (or worse, guesses about)
  // data it collected one message ago.
  const eventLogRef = useRef<AgentEvent[]>([]);

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
        const enabled = await isLlmEnabled();
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
    streamSubRef.current?.unsubscribe();
    streamSubRef.current = null;
    setIsSending(false);
    setDraftReply('');
    setError(null);
  };

  useEffect(() => {
    return () => {
      cancelRequestedRef.current = true;
      requestSeqRef.current += 1;
      streamSubRef.current?.unsubscribe();
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

    type LlmMessages = Parameters<typeof openai.chatCompletions>[0]['messages'];

    // Stream the user-facing answer token-by-token into the draft bubble.
    // Recovery ladder for the empty-response failure mode: a stream that
    // errors OR completes with no content falls back to a plain completion,
    // and a still-empty result gets one retry with an explicit nudge (models
    // sometimes emit nothing for statement/acknowledgement messages).
    const getFinalAnswer = async (llmMessages: LlmMessages): Promise<string> => {
      setActivity('Writing the answer...');
      let answer = '';

      try {
        answer = await new Promise<string>((resolve, reject) => {
          let accumulated = '';
          streamSubRef.current = openai
            .streamChatCompletions({ messages: llmMessages })
            .pipe(openai.accumulateContent())
            .subscribe({
              next: (text: string) => {
                accumulated = text;
                if (isActiveRequest()) {
                  setDraftReply(text);
                }
              },
              error: reject,
              complete: () => resolve(accumulated),
            });
        });
      } catch {
        answer = '';
      } finally {
        streamSubRef.current = null;
      }

      if (!answer.trim()) {
        const response = await openai.chatCompletions({ messages: llmMessages });
        answer = response?.choices?.[0]?.message?.content ?? '';
        if (!answer.trim()) {
          logEmptyCompletion('final-answer', response);
        }
      }

      if (!answer.trim()) {
        const nudged = await openai.chatCompletions({
          messages: [
            ...llmMessages,
            {
              role: 'system' as const,
              content:
                'Your previous attempt returned empty content. Respond now with a brief, helpful ' +
                'answer. If the user message is a statement or acknowledgement rather than a ' +
                'question, briefly confirm and propose the concrete next step.',
            },
          ],
        });
        answer = nudged?.choices?.[0]?.message?.content ?? '';
        if (!answer.trim()) {
          logEmptyCompletion('final-answer-nudged', nudged);
        }
      }

      return answer;
    };

    const dashboardPrompt = makeDashboardContextPrompt(context, panelSnapshot);
    const dashboardSystemMessages = dashboardPrompt
      ? [{ role: 'system' as const, content: dashboardPrompt }]
      : [];

    try {
      const enabled = await isLlmEnabled();
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
      setActivity('');
      setActivitySteps([]);
      setIsSending(true);

      const nextMessages = [...messages, { role: 'user' as const, content: trimmedInput }];
      const messagesForModel = compactHistory(nextMessages);
      setMessages(nextMessages);
      setInput('');
      setHistoryIndex(null);
      setHistoryDraft('');

      if (servers.length === 0) {
        const finalReply = (
          await getFinalAnswer([{ role: 'system', content: SYSTEM_PROMPT }, ...dashboardSystemMessages, ...messagesForModel])
        ).trim();
        assertActiveRequest();
        if (finalReply) {
          setMessages((current) => [...current, { role: 'assistant', content: finalReply }]);
        } else {
          setMessages((current) => [...current, { role: 'assistant', content: EMPTY_REPLY_FALLBACK }]);
        }

        setDraftReply('');
        setIsSending(false);
        return;
      }

      setActivity('Discovering tools...');
      const discovery = await listAllToolsSafe(servers);
      assertActiveRequest();
      const catalog = getToolCatalog(discovery.tools);
      // `events` IS the persistent cross-turn log: this turn's tool results
      // are pushed into it below, so they survive into later turns through
      // the ref. Trimmed here so it can't grow without bound.
      eventLogRef.current = eventLogRef.current.slice(-15);
      const events = eventLogRef.current;
      discovery.errors.forEach((e: ToolDiscoveryError) => {
        events.push({ type: 'discovery_error', server: e.server, message: e.message });
      });

      if (catalog.length === 0) {
        const discoverySummary =
          discovery.errors.length > 0
            ? 'No MCP tools available. Discovery errors: ' + discovery.errors.map((e) => e.server + ': ' + e.message).join(' | ')
            : '';

        const finalReply = (
          await getFinalAnswer([
            { role: 'system', content: SYSTEM_PROMPT },
            ...dashboardSystemMessages,
            ...(discoverySummary ? [{ role: 'system' as const, content: discoverySummary }] : []),
            ...messagesForModel,
          ])
        ).trim();
        assertActiveRequest();
        if (finalReply) {
          setMessages((current) => [...current, { role: 'assistant', content: finalReply }]);
        } else {
          setMessages((current) => [...current, { role: 'assistant', content: EMPTY_REPLY_FALLBACK }]);
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
        setActivity(`Planning next step (${step + 1}/${AGENT_MAX_STEPS})...`);
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
        if (!actionText.trim()) {
          logEmptyCompletion(`planner-step-${step + 1}`, actionResp);
        }
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

        setActivity(`Running ${call.name}...`);
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
        setActivitySteps((current) => [...current, call.name]);
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

        finalAnswer = (
          await getFinalAnswer([
            { role: 'system', content: SYSTEM_PROMPT },
            ...dashboardSystemMessages,
            ...(toolSummary ? [{ role: 'system' as const, content: 'Tool execution summary:\n' + toolSummary }] : []),
            ...messagesForModel,
          ])
        ).trim();
        assertActiveRequest();
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
        // PluginPage already renders the page title above this component;
        // repeating it here read as a duplicated header. Keep only the byline.
        <div className={s.subtitle}>Powered by the Grafana LLM integration</div>
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
              {message.role === 'user' ? (
                <div className={s.userBubble}>{message.content}</div>
              ) : (
                <div
                  className={cx(s.assistantBubble, s.markdownBody)}
                  // renderMarkdown sanitizes its output; assistant text is
                  // rendered so headings/bold/lists don't show as raw ### and **.
                  dangerouslySetInnerHTML={{ __html: renderMarkdown(message.content) }}
                />
              )}
            </div>
          ))
        )}

        {isSending ? (
          <div className={s.assistantRow}>
            <div className={s.assistantBubble}>
              <div className={s.streamingHeader}>
                <Spinner size="sm" />
                <span>{activity || 'Thinking...'}</span>
              </div>
              {activitySteps.length > 0 ? (
                <div className={s.activityTrail}>{activitySteps.join(' → ')}</div>
              ) : null}
              {draftReply ? (
                <div
                  className={cx(s.streamingText, s.markdownBody)}
                  dangerouslySetInnerHTML={{ __html: renderMarkdown(draftReply) }}
                />
              ) : null}
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
    word-break: break-word;
    border: 1px solid ${theme.colors.border.weak};
  `,
  // Styling for rendered assistant markdown. No white-space: pre-wrap here —
  // block elements carry the spacing, and pre-wrap would double it.
  markdownBody: css`
    & p,
    & ul,
    & ol,
    & pre,
    & table,
    & blockquote {
      margin: 0 0 ${theme.spacing(1)};
    }
    & > *:last-child {
      margin-bottom: 0;
    }
    & h1,
    & h2,
    & h3,
    & h4,
    & h5 {
      font-size: ${theme.typography.h5.fontSize};
      font-weight: ${theme.typography.fontWeightBold};
      margin: ${theme.spacing(1)} 0 ${theme.spacing(0.5)};
    }
    & ul,
    & ol {
      padding-left: ${theme.spacing(2.5)};
    }
    & code {
      font-family: ${theme.typography.fontFamilyMonospace};
      font-size: ${theme.typography.bodySmall.fontSize};
      background: ${theme.colors.background.canvas};
      border-radius: ${theme.shape.radius.default};
      padding: 1px 4px;
    }
    & pre {
      background: ${theme.colors.background.canvas};
      border-radius: ${theme.shape.radius.default};
      padding: ${theme.spacing(1)};
      overflow-x: auto;
    }
    & pre code {
      background: none;
      padding: 0;
    }
    & table {
      border-collapse: collapse;
    }
    & th,
    & td {
      border: 1px solid ${theme.colors.border.weak};
      padding: ${theme.spacing(0.5)} ${theme.spacing(1)};
      text-align: left;
    }
    & a {
      color: ${theme.colors.text.link};
    }
  `,
  streamingHeader: css`
    display: inline-flex;
    align-items: center;
    gap: ${theme.spacing(1)};
    color: ${theme.colors.text.secondary};
    margin-bottom: ${theme.spacing(1)};
  `,
  streamingText: css`
    word-break: break-word;
  `,
  activityTrail: css`
    color: ${theme.colors.text.secondary};
    font-size: ${theme.typography.bodySmall.fontSize};
    margin-bottom: ${theme.spacing(1)};
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
