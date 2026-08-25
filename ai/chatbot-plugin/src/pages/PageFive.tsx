import React from 'react';
import { css } from '@emotion/css';
import { GrafanaTheme2 } from '@grafana/data';
import { PluginPage } from '@grafana/runtime';
import { useStyles2 } from '@grafana/ui';
import { ChatPanel } from '../components/Chat/ChatPanel';

const PageFive = (): JSX.Element => {
  const s = useStyles2(getStyles);

  return (
    <PluginPage>
      <div className={s.page}>
        <ChatPanel />
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
});
