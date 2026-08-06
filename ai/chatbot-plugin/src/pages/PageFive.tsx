import React, { useEffect, useRef, useState } from 'react';
import { css } from '@emotion/css';
import { GrafanaTheme2 } from '@grafana/data';
import { openai } from '@grafana/llm';
import { PluginPage } from '@grafana/runtime';
import { Button, Input, Spinner, useStyles2 } from '@grafana/ui';
import { Subscription } from 'rxjs';
//import { scan } from 'rxjs/operators';
import { useAppMeta } from '../components/App/AppContext';
import {
  callMcpTool,
  isConfiguredServer,
  listAllToolsSafe,
  serializeResult,
  type MCPTool,
  type McpServerConfig,
  type ToolDiscoveryError,
} from '../utils/mcpClient';

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

const AGENT_MAX_STEPS = 2;

const MAX_HISTORY_MESSAGES = 8;
const MAX_TOOLS_FOR_PROMPT = 20;
const MAX_MESSAGE_CHARS = 1200;
const MAX_EVENT_CHARS = 1200;
const MAX_TOOL_SUMMARY_CHARS = 4000;

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

const makeAgentPrompt = (
  userMessage: string,
  catalog: ToolDescriptor[],
  history: ChatMessage[],
  events: AgentEvent[]
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
    '- Choose tools only when they add needed facts.',
    '- Prefer tool domains that match intent (dashboard questions should prefer Grafana dashboard tools).',
    '- If a tool failed (429/network), try one alternate tool/server when available.',
    '- Never invent tools; use only the listed catalog.',
    '- Avoid mutating tools unless user explicitly requested state changes.',
    '- Keep args minimal and valid for required fields.',
    '',
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

const SYSTEM_PROMPT =
  'You are a helpful assistant with deep knowledge of the Grafana, Prometheus and general observability ecosystem.';

const PageFive = (): JSX.Element => {
  const s = useStyles2(getStyles);
  const pluginMeta = useAppMeta();
  const [input, setInput] = useState('');
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [draftReply, setDraftReply] = useState('');
  const [isSending, setIsSending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const subscriptionRef = useRef<Subscription | null>(null);
  const latestReplyRef = useRef('');
  const requestSeqRef = useRef(0);
  const cancelRequestedRef = useRef(false);

  const [pendingApproval, setPendingApproval] = useState<PendingApproval | null>(null);

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
      subscriptionRef.current?.unsubscribe();
    };
  }, []);

  const sendMessage = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    const trimmedInput = input.trim();
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

    try {
      const enabled = await openai.enabled();
      assertActiveRequest();
      if (!enabled) {
        setError('The OpenAI integration is not enabled for this plugin.');
        return;
      }

      const servers: McpServerConfig[] = [
        { name: 'local-fastmcp', url: pluginMeta.jsonData?.mcpServerOneUrl ?? '' },
        { name: 'grafana', url: pluginMeta.jsonData?.mcpServerTwoUrl ?? '' },
      ].filter(isConfiguredServer);

      subscriptionRef.current?.unsubscribe();
      latestReplyRef.current = '';
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
          messages: [{ role: 'system', content: SYSTEM_PROMPT }, ...messagesForModel],
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
              content: makeAgentPrompt(trimmedInput, catalog, nextMessages, events),
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

  return (
    <PluginPage>
      <div className={s.page}>
        <div className={s.chatShell}>
          <div className={s.header}>
            <div className={s.title}>Observability Chatbot</div>
            <div className={s.subtitle}>Powered by the Grafana LLM integration</div>
          </div>

          <div className={s.conversation} aria-live="polite">
            {messages.length === 0 ? (
              <div className={s.emptyState}>
                Ask a question about Grafana, Prometheus, observability, or anything else you want to explore.
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
      </div>
    </PluginPage>
  );
};

export default PageFive;

const getStyles = (theme: GrafanaTheme2) => ({
  page: css`
    min-height: 100%;
    padding: ${theme.spacing(3)};
    background: linear-gradient(180deg, ${theme.colors.background.secondary}, ${theme.colors.background.primary});
  `,
  chatShell: css`
    max-width: 920px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: ${theme.spacing(2)};
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
  emptyState: css`
    color: ${theme.colors.text.secondary};
    padding: ${theme.spacing(2)};
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