import styles from "./Home.module.css";
import LogoSvg from "../assets/Logo.svg";
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
            src={LogoSvg}
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
        <h2 className={styles.ctaTitle}>¡Proyecto en desarrollo!</h2>
        <p className={styles.ctaText}>
          The Recipes App está actualmente en desarrollo. Sigue el progreso.
        </p>
        <div className={styles.ctaButtons}>
          <a
            href="https://github.com/francids/the_recipes"
            target="_blank"
            rel="noopener noreferrer"
            className={styles.downloadBtn}
          >
            <span>Ver en GitHub</span>
          </a>
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
