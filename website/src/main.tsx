import { createRoot } from "react-dom/client";
import "./i18n.ts";
import App from "./app.tsx";
import "./styles.css";

createRoot(document.getElementById("root")!).render(<App />);
