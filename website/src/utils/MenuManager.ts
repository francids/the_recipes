import type { MenuManagerType } from "../types/theme";

export class MenuManager implements MenuManagerType {
  isMenuOpen: boolean = false;

  toggleMenu(): void {
    this.isMenuOpen = !this.isMenuOpen;
    if (this.isMenuOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }

    window.dispatchEvent(
      new CustomEvent("menuToggle", {
        detail: { isOpen: this.isMenuOpen },
      })
    );
  }

  closeMenu(): void {
    if (this.isMenuOpen) {
      this.isMenuOpen = false;
      document.body.style.overflow = "";
      window.dispatchEvent(
        new CustomEvent("menuToggle", {
          detail: { isOpen: this.isMenuOpen },
        })
      );
    }
  }
}

if (typeof window !== "undefined") {
  window.menuManager = new MenuManager();

  window.addEventListener("resize", () => {
    if (window.innerWidth >= 768) {
      window.menuManager.closeMenu();
    }
  });

  window.addEventListener("beforeunload", () => {
    document.body.style.overflow = "";
  });
}
