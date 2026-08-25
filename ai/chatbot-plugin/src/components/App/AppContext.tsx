import React, { createContext, useContext } from 'react';
import { AppRootProps } from '@grafana/data';

const AppMetaContext = createContext<AppRootProps['meta'] | null>(null);

type AppMetaProviderProps = {
  value: AppRootProps['meta'];
  children: React.ReactNode;
};

export const AppMetaProvider = ({ value, children }: AppMetaProviderProps): JSX.Element => (
  <AppMetaContext.Provider value={value}>{children}</AppMetaContext.Provider>
);

export const useAppMeta = (): AppRootProps['meta'] => {
  const value = useContext(AppMetaContext);

  if (!value) {
    throw new Error('App metadata is not available.');
  }

  return value;
};

// Extension components (panel-menu modal, sidebar) render outside the app root,
// where the AppMetaProvider is not mounted.
export const useOptionalAppMeta = (): AppRootProps['meta'] | null => useContext(AppMetaContext);
