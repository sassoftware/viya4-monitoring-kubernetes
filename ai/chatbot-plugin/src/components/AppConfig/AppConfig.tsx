import React, { ChangeEvent, useState } from 'react';
import { lastValueFrom } from 'rxjs';
import { css } from '@emotion/css';
import { AppPluginMeta, GrafanaTheme2, PluginConfigPageProps, PluginMeta } from '@grafana/data';
import { getBackendSrv } from '@grafana/runtime';
import { Button, Field, FieldSet, Input, SecretInput, useStyles2 } from '@grafana/ui';
import { testIds } from '../testIds';

type AppPluginSettings = {
  apiUrl?: string;
  mcpServerOneUrl?: string;
  mcpServerTwoUrl?: string;
};

type State = {
  // The URL to reach our custom API.
  apiUrl: string;
  // The first MCP server URL.
  mcpServerOneUrl: string;
  // The second MCP server URL.
  mcpServerTwoUrl: string;
  // Tells us if the API key secret is set.
  isApiKeySet: boolean;
  // A secret key for our custom API.
  apiKey: string;
};

export interface AppConfigProps extends PluginConfigPageProps<AppPluginMeta<AppPluginSettings>> {}

const AppConfig = ({ plugin }: AppConfigProps) => {
  const s = useStyles2(getStyles);
  const { enabled, pinned, jsonData, secureJsonFields } = plugin.meta;
  const [state, setState] = useState<State>({
    apiUrl: jsonData?.apiUrl || '',
    mcpServerOneUrl: jsonData?.mcpServerOneUrl || '',
    mcpServerTwoUrl: jsonData?.mcpServerTwoUrl || '',
    apiKey: '',
    isApiKeySet: Boolean(secureJsonFields?.apiKey),
  });

  const isSubmitDisabled = Boolean(
    !state.apiUrl || !state.mcpServerOneUrl || !state.mcpServerTwoUrl || (!state.isApiKeySet && !state.apiKey)
  );

  const onResetApiKey = () =>
    setState({
      ...state,
      apiKey: '',
      isApiKeySet: false,
    });

  const onChange = (event: ChangeEvent<HTMLInputElement>) => {
    setState({
      ...state,
      [event.target.name]: event.target.value.trim(),
    });
  };

  const onSubmit = () => {
    if (isSubmitDisabled) {
      return;
    }

    updatePluginAndReload(plugin.meta.id, {
      enabled,
      pinned,
      jsonData: {
        apiUrl: state.apiUrl,
        mcpServerOneUrl: state.mcpServerOneUrl,
        mcpServerTwoUrl: state.mcpServerTwoUrl,
      },
      // This cannot be queried later by the frontend.
      // We don't want to override it in case it was set previously and left untouched now.
      secureJsonData: state.isApiKeySet
        ? undefined
        : {
            apiKey: state.apiKey,
          },
    });
  };

  return (
    <form onSubmit={onSubmit}>
      <FieldSet label="API Settings">
        <Field label="API Key" description="A secret key for authenticating to our custom API">
          <SecretInput
            width={60}
            id="config-api-key"
            data-testid={testIds.appConfig.apiKey}
            name="apiKey"
            value={state.apiKey}
            isConfigured={state.isApiKeySet}
            placeholder={'Your secret API key'}
            onChange={onChange}
            onReset={onResetApiKey}
          />
        </Field>

        <Field label="API Url" description="" className={s.marginTop}>
          <Input
            width={60}
            name="apiUrl"
            id="config-api-url"
            data-testid={testIds.appConfig.apiUrl}
            value={state.apiUrl}
            placeholder={`E.g.: http://mywebsite.com/api/v1`}
            onChange={onChange}
          />
        </Field>

        <Field label="MCP Server One Url" description="First MCP server used by the chatbot" className={s.marginTop}>
          <Input
            width={60}
            name="mcpServerOneUrl"
            id="config-mcp-server-one-url"
            value={state.mcpServerOneUrl}
            placeholder={`E.g.: http://localhost:8000/mcp`}
            onChange={onChange}
          />
        </Field>

        <Field label="MCP Server Two Url" description="Second MCP server used by the chatbot" className={s.marginTop}>
          <Input
            width={60}
            name="mcpServerTwoUrl"
            id="config-mcp-server-two-url"
            value={state.mcpServerTwoUrl}
            placeholder={`E.g.: http://localhost:9000/sse`}
            onChange={onChange}
          />
        </Field>

        <div className={s.marginTop}>
          <Button type="submit" data-testid={testIds.appConfig.submit} disabled={isSubmitDisabled}>
            Save API settings
          </Button>
        </div>
      </FieldSet>
    </form>
  );
};

export default AppConfig;

const getStyles = (theme: GrafanaTheme2) => ({
  colorWeak: css`
    color: ${theme.colors.text.secondary};
  `,
  marginTop: css`
    margin-top: ${theme.spacing(3)};
  `,
});

const updatePluginAndReload = async (pluginId: string, data: Partial<PluginMeta<AppPluginSettings>>) => {
  try {
    await updatePlugin(pluginId, data);

    // Reloading the page as the changes made here wouldn't be propagated to the actual plugin otherwise.
    // This is not ideal, however unfortunately currently there is no supported way for updating the plugin state.
    window.location.reload();
  } catch (e) {
    console.error('Error while updating the plugin', e);
  }
};

const updatePlugin = async (pluginId: string, data: Partial<PluginMeta>) => {
  const response = await getBackendSrv().fetch({
    url: `/api/plugins/${pluginId}/settings`,
    method: 'POST',
    data,
  });

  return lastValueFrom(response);
};
