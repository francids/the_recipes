import { useElementOnScreen } from "@/hooks";
import type Feature from "@/interfaces/feature";

interface FullFeatureCardProps {
  feature: Feature;
  index: number;
  isDarkMode: boolean;
}

export default function FullFeatureCard({
  feature,
  index,
  isDarkMode,
}: FullFeatureCardProps) {
  const [cardRef, cardIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const animationDelay = `${index * 0.15}s`;

  return (
    <div
      ref={cardRef}
      className={`flex flex-col lg:flex-row w-full bg-white dark:bg-zinc-800 rounded-md border-2 border-orange-200 dark:border-orange-700/30 transition-transform duration-300 md:hover:scale-[101%] hover:shadow-sm animate-on-scroll overflow-hidden min-h-[60vh] lg:min-h-[80vh] mb-8 ${
        cardIsVisible ? "visible" : ""
      }`}
      style={{ animationDelay }}
    >
      <div className="flex flex-col justify-center items-center lg:items-start w-full lg:w-1/2 p-12 lg:p-16">
        <div className="text-5xl sm:text-4xl mb-6 lg:mb-8 text-orange-600 select-none">
          {feature.icon}
        </div>
        <h3 className="text-2xl sm:text-3xl lg:text-4xl font-bold mb-3 lg:mb-2 text-zinc-800 dark:text-zinc-100 text-center lg:text-left">
          {feature.title}
        </h3>
        <p className="text-zinc-600 dark:text-zinc-400 text-base sm:text-lg leading-relaxed text-center lg:text-left max-w-md lg:max-w-none">
          {feature.description}
        </p>
      </div>
      <div className="w-full lg:w-1/2 bg-gradient-to-br from-orange-100 to-orange-200 dark:from-orange-900/20 dark:to-orange-800/20 flex items-center justify-center min-h-[300px] sm:min-h-[400px] lg:aspect-square">
        <img
          src={isDarkMode ? feature.darkImage || "" : feature.lightImage || ""}
          alt={feature.title}
          className="w-full h-full object-cover"
          loading="lazy"
          style={{ animationDelay }}
        />
      </div>
    </div>
  );
}
