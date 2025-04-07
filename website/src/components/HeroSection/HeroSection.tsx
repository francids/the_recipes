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
          en un solo lugar.
        </p>
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
