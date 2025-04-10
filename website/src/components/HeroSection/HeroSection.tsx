import LightInicialScreen from "../../assets/LightInicialScreen.webp";
import LightRecipeListScreen from "../../assets/LightRecipeScreen.webp";
import DarkInicialScreen from "../../assets/DarkInicialScreen.webp";
import DarkRecipeListScreen from "../../assets/DarkRecipeScreen.webp";
import styles from "./HeroSection.module.css";

export default function HeroSection() {
  return (
    <section className={styles.hero}>
      <div className={styles.heroContent}>
        <h1 className={styles.heroTitle}>Tu libro de recetas digital</h1>
        <p className={styles.heroSubtitle}>
          Almacena, organiza y encuentra fácilmente todas tus recetas favoritas
          en un solo lugar. ¡Ya disponible para Android!
        </p>
        <a
          href="https://the-recipe-app.uptodown.com/android"
          target="_blank"
          rel="noopener noreferrer"
          className={styles.heroButton}
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            height="24px"
            viewBox="0 -960 960 960"
            width="24px"
            fill="currentColor"
          >
            <path d="M40-240q9-107 65.5-197T256-580l-74-128q-6-9-3-19t13-15q8-5 18-2t16 12l74 128q86-36 180-36t180 36l74-128q6-9 16-12t18 2q10 5 13 15t-3 19l-74 128q94 53 150.5 143T920-240H40Zm240-110q21 0 35.5-14.5T330-400q0-21-14.5-35.5T280-450q-21 0-35.5 14.5T230-400q0 21 14.5 35.5T280-350Zm400 0q21 0 35.5-14.5T730-400q0-21-14.5-35.5T680-450q-21 0-35.5 14.5T630-400q0 21 14.5 35.5T680-350Z" />
          </svg>
          <span>Descargar ahora</span>
        </a>
      </div>
      <div className={styles.appShowcase}>
        {document.documentElement.classList.contains("darkMode") ? (
          <>
            <img
              src={DarkInicialScreen}
              alt="App receta detallada - modo oscuro"
              className={`${styles.mockup} ${styles.mockupLeft}`}
            />
            <img
              src={DarkRecipeListScreen}
              alt="App lista de recetas - modo oscuro"
              className={`${styles.mockup} ${styles.mockupRight}`}
            />
          </>
        ) : (
          <>
            <img
              src={LightInicialScreen}
              alt="App receta detallada - modo claro"
              className={`${styles.mockup} ${styles.mockupLeft}`}
            />
            <img
              src={LightRecipeListScreen}
              alt="App lista de recetas - modo claro"
              className={`${styles.mockup} ${styles.mockupRight}`}
            />
          </>
        )}
      </div>
    </section>
  );
}
