import { useTranslation } from "react-i18next";
import Footer from "@/components/Footer";
import { useElementOnScreen } from "@/hooks";

export default function NotFoundPage() {
  const { t } = useTranslation(undefined, {
    keyPrefix: "NotFound",
  });

  const [contentRef, contentIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const [footerRef, footerIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  return (
    <div className="flex flex-col bg-white dark:bg-zinc-900 relative min-h-screen">
      <div className="flex-1 min-h-screen relative z-10">
        <div className="flex flex-col items-center justify-center min-h-screen pt-20 pb-16 px-4">
          <div
            ref={contentRef}
            className={`text-center max-w-2xl mb-32 mx-auto animate-on-scroll ${
              contentIsVisible ? "visible" : ""
            } transition-all duration-300 ease-out`}
          >
            <h1 className="text-6xl md:text-7xl font-bold text-zinc-900 dark:text-white mb-6 selection:bg-orange-500/25">
              {t("title")}
            </h1>
            <h2 className="text-2xl md:text-3xl font-semibold text-zinc-700 dark:text-zinc-300 mb-4 selection:bg-orange-500/25">
              {t("subtitle")}
            </h2>
            <p className="text-lg text-zinc-600 dark:text-zinc-400 mb-8 leading-relaxed selection:bg-orange-500/25">
              {t("description")}
            </p>
          </div>
        </div>
      </div>

      <div
        ref={footerRef}
        className={`animate-on-scroll relative z-10 ${
          footerIsVisible ? "visible" : ""
        }`}
        style={{ animationDelay: "0.2s" }}
      >
        <Footer />
      </div>
    </div>
  );
}
