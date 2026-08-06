import React from 'react';
import { Route, Routes } from 'react-router-dom';
import { AppRootProps } from '@grafana/data';
import { ROUTES } from '../../constants';
import { AppMetaProvider } from './AppContext';
//const PageOne = React.lazy(() => import('../../pages/PageOne'));
//const PageTwo = React.lazy(() => import('../../pages/PageTwo'));
//const PageThree = React.lazy(() => import('../../pages/PageThree'));
//const PageFour = React.lazy(() => import('../../pages/PageFour'));
const PageFive = React.lazy(() => import('../../pages/PageFive'));

function App(props: AppRootProps) {
  return (
    <AppMetaProvider value={props.meta}>
      <Routes>
        {/*<Route path={ROUTES.Two} element={<PageTwo />} />*/}
        {/*<Route path={`${ROUTES.Three}/:id?`} element={<PageThree />} />*/}

        {/* Full-width page (this page will have no side navigation) */}
        {/*<Route path={ROUTES.Four} element={<PageFour />} />*/}
        <Route path={ROUTES.Five} element={<PageFive />} />

        {/* Default page */}
        {/*<Route path="*" element={<PageOne />} />*/}
      </Routes>
    </AppMetaProvider>
  );
}

export default App;
