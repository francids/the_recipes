import { Outlet } from "react-router";
import { ThemeProvider } from "./contexts/ThemeContext";

export default function Layout() {
  return (
    <>
      <ThemeProvider>
        <Outlet />
      </ThemeProvider>
    </>
  );
}
