import { useElementOnScreen } from "@/hooks/useElementOnScreen";
import type Feature from "@/interfaces/feature";

interface FeatureCardProps {
  feature: Feature;
  index: number;
}

export default function FeatureCard({ feature, index }: FeatureCardProps) {
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
}
