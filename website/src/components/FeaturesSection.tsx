import { useTranslation } from "react-i18next";
import { useElementOnScreen, useTheme } from "@/hooks";
import FullFeatureCard from "./FullFeatureCard";
import FeatureCard from "./FeatureCard";
import type Feature from "@/interfaces/feature";

import LightAiComponent from "@/assets/light-ai-component.png";
import DarkAiComponent from "@/assets/dark-ai-component.png";
import LightShareComponent from "@/assets/light-share-component.png";
import DarkShareComponent from "@/assets/dark-share-component.png";

export default function FeaturesSection() {
  const { t } = useTranslation(undefined, {
    keyPrefix: "FeaturesSection",
  });
  const { isDarkMode } = useTheme();

  const [titleRef, titleIsVisible] = useElementOnScreen<HTMLHeadingElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const features: Feature[] = [
    {
      icon: "🤖",
      title: t("feature5_title"),
      description: t("feature5_description"),
      lightImage: LightAiComponent,
      darkImage: DarkAiComponent,
    },
    {
      icon: "🔄",
      title: t("feature4_title"),
      description: t("feature4_description"),
      lightImage: LightShareComponent,
      darkImage: DarkShareComponent,
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
      className="py-20 px-5 bg-white dark:bg-gradient-to-b dark:from-zinc-900 dark:to-zinc-950 text-center flex flex-col items-center justify-center"
    >
      <h2
        ref={titleRef}
        className={`text-4xl font-bold mb-16 text-main relative animate-on-scroll ${
          titleIsVisible ? "visible" : ""
        }`}
      >
        {t("title")}
        <span className="absolute bottom-[-1.5rem] left-1/2 transform -translate-x-1/2 w-16 sm:w-20 h-1 bg-main rounded-md shadow-sm"></span>
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
