import { useTranslations } from "next-intl";
import { useElementOnScreen } from "@/hooks/useElementOnScreen";
import { useEffect, useState } from "react";
import FullFeatureCard from "./FullFeatureCard";
import FeatureCard from "./FeatureCard";
import Feature from "@/interfaces/feature";

export default function FeaturesSection() {
  const t = useTranslations("FeaturesSection");
  const [isDarkMode, setIsDarkMode] = useState<boolean>(false);

  useEffect(() => {
    const isDark = document.documentElement.classList.contains("dark");
    setIsDarkMode(isDark);

    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.attributeName === "class") {
          const isDark = document.documentElement.classList.contains("dark");
          setIsDarkMode(isDark);
        }
      });
    });

    observer.observe(document.documentElement, { attributes: true });

    return () => observer.disconnect();
  }, []);

  const [titleRef, titleIsVisible] = useElementOnScreen<HTMLHeadingElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const features: Feature[] = [
    {
      icon: "🤖",
      title: t("feature5_title"),
      description: t("feature5_description"),
      lightImage: "/LightAiComponent.png",
      darkImage: "/DarkAiComponent.png",
    },
    {
      icon: "🔄",
      title: t("feature4_title"),
      description: t("feature4_description"),
      lightImage: "/LightShareComponent.png",
      darkImage: "/DarkShareComponent.png",
    },
    {
      icon: "📱",
      title: t("feature1_title"),
      description: t("feature1_description"),
    },
    {
      icon: "🌙",
      title: t("feature3_title"),
      description: t("feature3_description"),
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
      className="py-20 px-5 bg-zinc-50 dark:bg-gradient-to-b dark:from-zinc-900 dark:to-zinc-950 text-center flex flex-col items-center justify-center"
    >
      <h2
        ref={titleRef}
        className={`text-4xl font-bold mb-16 text-orange-600 relative animate-on-scroll ${
          titleIsVisible ? "visible" : ""
        }`}
      >
        {t("title")}
        <span className="absolute bottom-[-1.5rem] left-1/2 transform -translate-x-1/2 w-16 sm:w-20 h-1 bg-gradient-to-r from-orange-400 to-orange-600 rounded-full shadow-sm"></span>
      </h2>

      <div className="w-full xl:w-4/5 md:mb-8">
        {features.map((feature, index) => {
          if (feature.darkImage && feature.lightImage) {
            return (
              <FullFeatureCard
                key={index}
                index={index}
                feature={feature}
                isDarkMode={isDarkMode}
              />
            );
          }
        })}
      </div>

      <div className="flex flex-wrap justify-center items-stretch gap-8 max-w-6xl mx-auto">
        {features.map((feature, index) => {
          if (!feature.darkImage && !feature.lightImage) {
            return <FeatureCard key={index} feature={feature} index={index} />;
          }
        })}
      </div>
    </section>
  );
}
