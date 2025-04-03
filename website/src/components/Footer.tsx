import { useState, useEffect } from "react";
import { ReactSVG } from "react-svg";
import LogoSvg from "../assets/Logo.svg";
import styles from "./Footer.module.css";

export default function Footer() {
  const [darkMode, setDarkMode] = useState(() => {
    const savedTheme = localStorage.getItem("darkMode");

    if (savedTheme !== null) {
      return savedTheme === "true";
    }

    return window.matchMedia("(prefers-color-scheme: dark)").matches;
  });

  useEffect(() => {
    if (darkMode) {
      document.documentElement.classList.add("darkMode");
    } else {
      document.documentElement.classList.remove("darkMode");
    }
    localStorage.setItem("darkMode", darkMode.toString());
  }, [darkMode]);

  const toggleTheme = () => {
    setDarkMode(!darkMode);
  };

  return (
    <footer className={styles.footer}>
      <div className={styles.footerContent}>
        <div className={styles.footerLogo}>
          <ReactSVG
            src={LogoSvg}
            className={styles.footerLogoImg}
            aria-label="The Recipes App"
          />
          <p className={styles.footerTagline}>Tu asistente culinario digital</p>
        </div>
        <div className={styles.footerLinks}>
          <div className={styles.footerLinkColumn}>
            <h3 className={styles.footerLinkTitle}>The Recipes</h3>
            <a href="/#features" className={styles.footerLink}>
              Características
            </a>
            <a href="/#cta" className={styles.footerLink}>
              Desarrollo
            </a>
          </div>
          <div className={styles.footerLinkColumn}>
            <h3 className={styles.footerLinkTitle}>Contacto</h3>
            <a
              href="https://github.com/francids/the_recipes"
              className={styles.footerLink}
            >
              GitHub
            </a>
          </div>
          <div className={styles.footerLinkColumn}>
            <h3 className={styles.footerLinkTitle}>Preferencias</h3>
            <div className={styles.themeSelector}>
              <span className={styles.themeSelectorLabel}>Modo oscuro</span>
              <button
                onClick={toggleTheme}
                className={styles.themeToggle}
                aria-label={
                  darkMode ? "Cambiar a modo claro" : "Cambiar a modo oscuro"
                }
              >
                <div
                  className={`${styles.themeToggleSlider} ${
                    darkMode ? styles.themeToggleActive : ""
                  }`}
                >
                  <span className={styles.themeToggleIcon}>
                    {darkMode ? "🌙" : "☀️"}
                  </span>
                </div>
              </button>
            </div>
          </div>
        </div>
      </div>
      <div className={styles.footerBottom}>
        <p>
          &copy; {new Date().getFullYear()} The Recipes App. Todos los derechos
          reservados.
        </p>
      </div>
    </footer>
  );
}
