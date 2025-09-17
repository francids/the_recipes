import type { Theme, ThemeState, ThemeManagerType } from "../types/theme";

export class ThemeManager implements ThemeManagerType {
  theme: Theme = "system";
  isDarkMode: boolean = false;
  listeners: ((state: ThemeState) => void)[] = [];

  init(): void {
    try {
      function getCookie(name: string): string | null {
        const nameEQ = name + "=";
        const cookies = document.cookie.split(";");
        for (let i = 0; i < cookies.length; i++) {
          let cookie = cookies[i];
          while (cookie.charAt(0) === " ") {
            cookie = cookie.substring(1, cookie.length);
          }
          if (cookie.indexOf(nameEQ) === 0) {
            return cookie.substring(nameEQ.length, cookie.length);
          }
        }
        return null;
      }

      const storedTheme = getCookie("theme");
      this.theme =
        storedTheme && ["light", "dark", "system"].includes(storedTheme)
          ? (storedTheme as Theme)
          : "system";

      this.applyTheme(this.theme);
      this.setupMediaQueryListener();
    } catch (e) {
      console.error("Failed to initialize theme:", e);
    }
  }

  applyTheme(currentTheme: Theme): void {
    let isDark: boolean;
    if (currentTheme === "system") {
      isDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    } else {
      isDark = currentTheme === "dark";
    }

    this.isDarkMode = isDark;
    this.theme = currentTheme;

    if (isDark) {
      document.documentElement.classList.add("dark");
      document.documentElement.style.backgroundColor = "#18181b";
    } else {
      document.documentElement.classList.remove("dark");
      document.documentElement.style.backgroundColor = "#fafafa";
    }

    document.cookie = `theme=${currentTheme};path=/;max-age=${
      60 * 60 * 24 * 365
    };SameSite=Lax`;
    this.notifyListeners();
  }

  setTheme(newTheme: Theme): void {
    if (["light", "dark", "system"].includes(newTheme)) {
      this.applyTheme(newTheme);
    }
  }

  toggleTheme(): void {
    if (this.theme === "light") this.setTheme("dark");
    else if (this.theme === "dark") this.setTheme("system");
    else this.setTheme("light");
  }

  setupMediaQueryListener(): void {
    const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");

    const handleChange = () => {
      if (this.theme === "system") {
        const isDark = mediaQuery.matches;
        this.isDarkMode = isDark;

        if (isDark) {
          document.documentElement.classList.add("dark");
          document.documentElement.style.backgroundColor = "#18181b";
        } else {
          document.documentElement.classList.remove("dark");
          document.documentElement.style.backgroundColor = "#fafafa";
        }

        this.notifyListeners();
      }
    };

    mediaQuery.addEventListener("change", handleChange);
  }

  subscribe(callback: (state: ThemeState) => void): () => void {
    this.listeners.push(callback);
    return () => {
      this.listeners = this.listeners.filter(
        (listener) => listener !== callback
      );
    };
  }

  notifyListeners(): void {
    this.listeners.forEach((listener) => {
      try {
        listener({ theme: this.theme, isDarkMode: this.isDarkMode });
      } catch (e) {
        console.error("Error notifying theme listener:", e);
      }
    });
  }

  getState(): ThemeState {
    return {
      theme: this.theme,
      isDarkMode: this.isDarkMode,
    };
  }
}

if (typeof window !== "undefined") {
  window.themeManager = new ThemeManager();
  window.themeManager.init();
}
