import styles from "./Home.module.css";
import LogoPng from "../assets/Logo.png";
import InicialScreenPng from "../assets/InicialScreen.png";
import RecipeListScreenPng from "../assets/RecipeScreen.png";

export default function Home() {
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
    <div>
      <section className={styles.hero}>
        <div>
          <img
            src={LogoPng}
            alt="The Recipes App"
            className={styles.heroLogo}
          />
        </div>
        <div className={styles.appShowcase}>
          <img
            src={InicialScreenPng}
            alt="App receta detallada"
            className={styles.mockup}
          />
          <img
            src={RecipeListScreenPng}
            alt="App lista de recetas"
            className={styles.mockup}
          />
        </div>
      </section>

      <section className={styles.features}>
        <h2 className={styles.featuresTitle}>
          Una manera simple de gestionar tus recetas
        </h2>
        <div className={styles.featuresGrid}>{renderFeatureCards()}</div>
      </section>

      <section className={styles.cta}>
        <h2 className={styles.ctaTitle}>¡Organiza tus recetas hoy mismo!</h2>
        <p className={styles.ctaText}>
          Descarga The Recipes App y comienza a gestionar tus recetas favoritas
          de forma sencilla.
        </p>
        <div className={styles.ctaButtons}>
          <button className={styles.downloadBtn} disabled>
            <span>Google Play</span>
          </button>
          <button className={styles.downloadBtn} disabled>
            <span>App Store</span>
          </button>
        </div>
      </section>

      <footer className={styles.footer}>
        <p>
          &copy; {new Date().getFullYear()} The Recipes App. Todos los derechos
          reservados.
        </p>
      </footer>
    </div>
  );
}
