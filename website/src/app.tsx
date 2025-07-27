import { BrowserRouter, Route, Routes } from "react-router";

import Layout from "./layout";

import HomePage from "./pages/home-page";
import PrivacyPage from "./pages/privacy-page";
import SharingPage from "./pages/sharing-page";
import NotFoundPage from "./pages/not-found-page";

const App = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<HomePage />} />
          <Route path="/privacy" element={<PrivacyPage />} />
          <Route path="/sharing" element={<SharingPage />} />
          <Route path="*" element={<NotFoundPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
};

export default App;
