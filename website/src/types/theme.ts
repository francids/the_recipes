export type Theme = "light" | "dark" | "system";

export interface ThemeState {
  theme: Theme;
  isDarkMode: boolean;
}

export interface MenuState {
  isOpen: boolean;
}

export interface ThemeManagerType {
  theme: Theme;
  isDarkMode: boolean;
  listeners: ((state: ThemeState) => void)[];
  init(): void;
  applyTheme(currentTheme: Theme): void;
  setTheme(newTheme: Theme): void;
  toggleTheme(): void;
  setupMediaQueryListener(): void;
  subscribe(callback: (state: ThemeState) => void): () => void;
  notifyListeners(): void;
  getState(): ThemeState;
}

export interface MenuManagerType {
  isMenuOpen: boolean;
  toggleMenu(): void;
  closeMenu(): void;
}
