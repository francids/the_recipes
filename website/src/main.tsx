import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import { BrowserRouter, Route, Routes } from "react-router";

import Home from "./screens/Home.tsx";
import NotFound from "./screens/404.tsx";

const initializeTheme = () => {
  const savedTheme = localStorage.getItem("darkMode");

  if (savedTheme === "true") {
    document.documentElement.classList.add("darkMode");
  } else if (savedTheme === "false") {
    document.documentElement.classList.remove("darkMode");
  } else {
    const prefersDark = window.matchMedia(
      "(prefers-color-scheme: dark)"
    ).matches;

    if (prefersDark) {
      document.documentElement.classList.add("darkMode");
      localStorage.setItem("darkMode", "true");
    } else {
      localStorage.setItem("darkMode", "false");
    }
  }
};

initializeTheme();

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  </StrictMode>
);
