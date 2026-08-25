import React, { Suspense, lazy } from 'react';
import {
  AppPlugin,
  PluginExtensionPoints,
  type AppRootProps,
  type PluginExtensionPanelContext,
} from '@grafana/data';
import { LoadingPlaceholder } from '@grafana/ui';
import type { AppConfigProps } from './components/AppConfig/AppConfig';
import type { ChatPanelProps } from './components/Chat/ChatPanel';

const LazyApp = lazy(() => import('./components/App/App'));
const LazyAppConfig = lazy(() => import('./components/AppConfig/AppConfig'));
const LazyChatPanel = lazy(() => import('./components/Chat/ChatPanel'));

const App = (props: AppRootProps) => (
  <Suspense fallback={<LoadingPlaceholder text="" />}>
    <LazyApp {...props} />
  </Suspense>
);

const AppConfig = (props: AppConfigProps) => (
  <Suspense fallback={<LoadingPlaceholder text="" />}>
    <LazyAppConfig {...props} />
  </Suspense>
);

const ChatModal = (props: ChatPanelProps) => (
  <Suspense fallback={<LoadingPlaceholder text="" />}>
    <LazyChatPanel {...props} />
  </Suspense>
);

export const plugin = new AppPlugin<{}>()
  .setRootPage(App)
  .addConfigPage({
    title: 'Configuration',
    icon: 'cog',
    body: AppConfig,
    id: 'configuration',
  })
  .addLink<PluginExtensionPanelContext>({
    targets: [PluginExtensionPoints.DashboardPanelMenu],
    title: 'Ask Observability Chatbot',
    description: 'Ask the observability agent about this panel',
    icon: 'comment-alt',
    onClick: (_event, helpers) => {
      const context = helpers?.context;
      helpers?.openModal?.({
        title: 'Observability Chatbot',
        width: '55%',
        height: '75%',
        body: () => (
          <ChatModal
            compact
            context={{
              dashboardTitle: context?.dashboard?.title,
              dashboardUid: context?.dashboard?.uid,
              panelTitle: context?.title,
              queries: context?.targets,
              timeRange: context?.timeRange,
            }}
          />
        ),
      });
    },
  });
