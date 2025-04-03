import { useState, useEffect } from "react";
import styles from "./Home.module.css";
import LogoSvg from "../assets/Logo.svg";
import InicialScreenPng from "../assets/InicialScreen.png";
import RecipeListScreenPng from "../assets/RecipeScreen.png";
import { ReactSVG } from "react-svg";

export default function Home() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

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

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  const toggleTheme = () => {
    setDarkMode(!darkMode);
  };

  const features = [
    {
      icon: "📋",
      title: "Visualiza tus recetas",
      description:
        "Accede fácilmente a todas tus recetas guardadas, con instrucciones paso a paso e ingredientes necesarios.",
    },
    {
      icon: "➕",
      title: "Almacena nuevas recetas",
      description:
        "Añade tus recetas favoritas de forma sencilla para tenerlas siempre a mano cuando las necesites.",
    },
    {
      icon: "🗑️",
      title: "Gestiona tu colección",
      description:
        "Elimina las recetas que ya no necesitas o actualiza las existentes con nuevas mejoras.",
    },
    {
      icon: "🔄",
      title: "Próximamente: Compartir",
      description:
        "En futuras actualizaciones, podrás compartir tus mejores creaciones culinarias con amigos y familiares.",
    },
  ];

  const renderFeatureCards = () => {
    return features.map((feature, index) => (
      <div key={index} className={styles.featureCard}>
        <div className={styles.featureIcon}>{feature.icon}</div>
        <h3 className={styles.featureTitle}>{feature.title}</h3>
        <p className={styles.featureText}>{feature.description}</p>
      </div>
    ));
  };

  return (
    <div className={styles.container}>
      <nav className={styles.navbar}>
        <a href="#" className={styles.navbarLogo}>
          <ReactSVG
            src={LogoSvg}
            className={styles.navLogo}
            aria-label="The Recipes App"
          />
        </a>
        <div className={styles.navLinks}>
          <a href="#features" className={styles.navLink}>
            Características
          </a>
          <a href="#cta" className={styles.navLink}>
            Desarrollo
          </a>
          <a
            href="https://github.com/francids/the_recipes"
            target="_blank"
            rel="noopener noreferrer"
            className={styles.navLinkHighlight}
          >
            GitHub
          </a>
        </div>
        <button
          className={styles.hamburgerButton}
          onClick={toggleMenu}
          aria-label="Menú"
        >
          <span className={styles.hamburgerLine}></span>
          <span className={styles.hamburgerLine}></span>
          <span className={styles.hamburgerLine}></span>
        </button>
        <div
          className={`${styles.mobileMenu} ${isMenuOpen ? styles.open : ""}`}
        >
          <a href="#features" className={styles.navLink} onClick={toggleMenu}>
            Características
          </a>
          <a href="#cta" className={styles.navLink} onClick={toggleMenu}>
            Desarrollo
          </a>
          <a
            href="https://github.com/francids/the_recipes"
            target="_blank"
            rel="noopener noreferrer"
            className={styles.navLinkHighlight}
            onClick={toggleMenu}
          >
            GitHub
          </a>
        </div>
      </nav>

      <section className={styles.hero}>
        <div className={styles.heroContent}>
          <h1 className={styles.heroTitle}>Tu libro de recetas digital</h1>
          <p className={styles.heroSubtitle}>
            Almacena, organiza y encuentra fácilmente todas tus recetas
            favoritas en un solo lugar
          </p>
        </div>
        <div className={styles.appShowcase}>
          <img
            src={InicialScreenPng}
            alt="App receta detallada"
            className={`${styles.mockup} ${styles.mockupLeft}`}
          />
          <img
            src={RecipeListScreenPng}
            alt="App lista de recetas"
            className={`${styles.mockup} ${styles.mockupRight}`}
          />
        </div>
      </section>

      <section id="features" className={styles.features}>
        <h2 className={styles.featuresTitle}>
          Una manera simple de gestionar tus recetas
        </h2>
        <div className={styles.featuresGrid}>{renderFeatureCards()}</div>
      </section>

      {/* <section className={styles.testimonial}>
        <div className={styles.testimonialContent}>
          <div className={styles.quoteMark}>"</div>
          <p className={styles.testimonialText}>
            The Recipes App ha cambiado completamente mi forma de organizar mis
            recetas. ¡Ya no pierdo tiempo buscando entre papeles o marcadores!
          </p>
          <div className={styles.testimonialAuthor}></div>
            <p className={styles.authorName}>María García</p>
            <p className={styles.authorTitle}>Chef aficionada</p>
          </div>
        </div>
      </section> */}

      <section id="cta" className={styles.cta}>
        <h2 className={styles.ctaTitle}>¡Proyecto en desarrollo!</h2>
        <p className={styles.ctaText}>
          The Recipes App está actualmente en desarrollo. Sigue el progreso o
          contribuye al proyecto.
        </p>
        <div className={styles.ctaButtons}>
          <a
            href="https://github.com/francids/the_recipes"
            target="_blank"
            rel="noopener noreferrer"
            className={styles.downloadBtn}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="currentColor"
              className={styles.githubIcon}
            >
              <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
            </svg>
            <span>Ver en GitHub</span>
          </a>
          <a href="#features" className={styles.secondaryBtn}>
            Descubrir funciones
          </a>
        </div>
      </section>

      <footer className={styles.footer}>
        <div className={styles.footerContent}>
          <div className={styles.footerLogo}>
            <ReactSVG
              src={LogoSvg}
              className={styles.footerLogoImg}
              aria-label="The Recipes App"
            />
            <p className={styles.footerTagline}>
              Tu asistente culinario digital
            </p>
          </div>
          <div className={styles.footerLinks}>
            <div className={styles.footerLinkColumn}>
              <h3 className={styles.footerLinkTitle}>The Recipes</h3>
              <a href="#features" className={styles.footerLink}>
                Características
              </a>
              <a href="#cta" className={styles.footerLink}>
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
            &copy; {new Date().getFullYear()} The Recipes App. Todos los
            derechos reservados.
          </p>
        </div>
      </footer>
    </div>
  );
}
