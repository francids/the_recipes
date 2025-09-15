import type { ThemeManagerType, MenuManagerType } from "./theme";

declare global {
  interface Window {
    themeManager: ThemeManagerType;
    menuManager: MenuManagerType;
  }

  interface WindowEventMap {
    menuToggle: CustomEvent<{ isOpen: boolean }>;
  }
}

export {};
