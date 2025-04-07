import styles from "./FeaturesSection.module.css";

interface Feature {
  icon: string;
  title: string;
  description: string;
}

interface FeaturesSectionProps {
  features: Feature[];
}

export default function FeaturesSection({ features }: FeaturesSectionProps) {
  return (
    <section id="features" className={styles.features}>
      <h2 className={styles.featuresTitle}>
        Una manera simple de gestionar tus recetas
      </h2>
      <div className={styles.featuresGrid}>
        {features.map((feature, index) => (
          <div key={index} className={styles.featureCard}>
            <div className={styles.featureIcon}>{feature.icon}</div>
            <h3 className={styles.featureTitle}>{feature.title}</h3>
            <p className={styles.featureText}>{feature.description}</p>
          </div>
        ))}
      </div>
    </section>
  );
}
