import { useTranslations } from "next-intl";
import { useElementOnScreen } from "@/hooks/useElementOnScreen";

interface Feature {
  icon: string;
  title: string;
  description: string;
}

interface FeatureCardProps {
  feature: Feature;
  index: number;
}

const FeatureCard: React.FC<FeatureCardProps> = ({ feature, index }) => {
  const [cardRef, cardIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const animationDelay = `${index * 0.15}s`;

  return (
    <div
      ref={cardRef}
      className={`flex flex-col items-center w-full sm:w-80 bg-white dark:bg-zinc-800 px-8 py-12 rounded-md border-2 border-orange-200 dark:border-orange-700/30 transition-transform duration-300 md:hover:scale-105 hover:shadow-sm animate-on-scroll ${
        cardIsVisible ? "visible" : ""
      }`}
      style={{ animationDelay }}
    >
      <div className="text-5xl mb-5 text-orange-600 select-none">
        {feature.icon}
      </div>
      <h3 className="text-xl font-bold mb-4 text-zinc-800 dark:text-zinc-100">
        {feature.title}
      </h3>
      <p className="text-zinc-600 dark:text-zinc-400 text-lg leading-relaxed">
        {feature.description}
      </p>
    </div>
  );
};

export default function FeaturesSection() {
  const t = useTranslations("FeaturesSection");

  const [titleRef, titleIsVisible] = useElementOnScreen<HTMLHeadingElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const features: Feature[] = [
    {
      icon: "📱",
      title: t("feature1_title"),
      description: t("feature1_description"),
    },
    {
      icon: "📋",
      title: t("feature2_title"),
      description: t("feature2_description"),
    },
    {
      icon: "🌙",
      title: t("feature3_title"),
      description: t("feature3_description"),
    },
    {
      icon: "🔄",
      title: t("feature4_title"),
      description: t("feature4_description"),
    },
    {
      icon: "🤖",
      title: t("feature5_title"),
      description: t("feature5_description"),
    },
    {
      icon: "🌐",
      title: t("feature6_title"),
      description: t("feature6_description"),
    },
  ];

  return (
    <section
      id="features"
      className="py-20 px-5 bg-gradient-to-b from-zinc-50 to-white dark:from-zinc-900 dark:to-zinc-950 text-center"
    >
      <h2
        ref={titleRef}
        className={`text-4xl font-bold mb-16 text-orange-600 relative animate-on-scroll ${
          titleIsVisible ? "visible" : ""
        }`}
      >
        {t("title")}
        <span className="absolute bottom-[-1.5rem] left-1/2 transform -translate-x-1/2 w-20 h-0.5 bg-orange-600 rounded"></span>
      </h2>

      <div className="flex flex-wrap justify-center items-stretch gap-8 max-w-6xl mx-auto">
        {features.map((feature, index) => (
          <FeatureCard key={index} feature={feature} index={index} />
        ))}
      </div>
    </section>
  );
}
