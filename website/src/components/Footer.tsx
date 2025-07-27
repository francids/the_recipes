import { useTranslation } from "react-i18next";
import { useElementOnScreen } from "@/hooks/useElementOnScreen";
import { useTheme } from "@/contexts/ThemeContext";
import { Link } from "react-router";

export default function Footer() {
  const { t } = useTranslation(undefined, {
    keyPrefix: "Footer",
  });
  const { theme, toggleTheme, isDarkMode } = useTheme();

  const [footerContentRef, footerContentIsVisible] =
    useElementOnScreen<HTMLDivElement>({ threshold: 0.05, triggerOnce: true });
  const [copyrightRef, copyrightIsVisible] = useElementOnScreen<HTMLDivElement>(
    { threshold: 0.05, triggerOnce: true }
  );

  const getButtonState = () => {
    return {
      icon: theme === "light" ? "☀️" : theme === "dark" ? "🌙" : "💻",
      label:
        theme === "light"
          ? t("theme_toggle_to_dark")
          : theme === "dark"
          ? t("theme_toggle_to_system")
          : t("theme_toggle_to_light"),
      positionClass: isDarkMode
        ? "transform translate-x-[30px] bg-zinc-500"
        : "bg-orange-500",
      isDarkEffective: isDarkMode,
    };
  };

  const buttonState = getButtonState();

  const themeLabel = () => {
    if (theme === "light") return t("theme_light");
    if (theme === "dark") return t("theme_dark");
    return t("theme_system");
  };

  return (
    <footer className="bg-zinc-900 dark:bg-zinc-950 text-white py-16 px-8">
      <div
        ref={footerContentRef}
        className={`flex justify-between flex-wrap gap-10 max-w-7xl mx-auto mb-10 text-left animate-on-scroll ${
          footerContentIsVisible ? "visible" : ""
        }`}
      >
        <div className="flex-1 min-w-[250px] flex flex-col items-start">
          <div className="w-[150px] mb-5 text-white select-none pointer-events-none">
            <img
              src="/Logo.svg"
              alt="The Recipes App Logo"
              width={100}
              height={24}
            />
          </div>
          <p className="text-neutral-400 dark:text-neutral-300 text-lg">
            {t("tagline")}
          </p>
        </div>
        <div className="flex gap-10 flex-wrap">
          <div className="min-w-[150px]">
            <h3 className="text-orange-500 mb-5 text-lg font-semibold">
              {t("section_recipes")}
            </h3>
            <Link
              to="/#features"
              className="block text-neutral-400 dark:text-neutral-300 mb-2.5 no-underline hover:text-orange-500 transition-colors"
            >
              {t("link_features")}
            </Link>
            <Link
              to="/#cta"
              className="block text-neutral-400 dark:text-neutral-300 mb-2.5 no-underline hover:text-orange-500 transition-colors"
            >
              {t("link_development")}
            </Link>
          </div>
          <div className="min-w-[150px]">
            <h3 className="text-orange-500 mb-5 text-lg font-semibold">
              {t("section_contact")}
            </h3>
            <a
              href="https://github.com/francids/the_recipes"
              className="block text-neutral-400 dark:text-neutral-300 mb-2.5 no-underline hover:text-orange-500 transition-colors"
            >
              Github
            </a>
          </div>
          <div className="min-w-[150px]">
            <h3 className="text-orange-500 mb-5 text-lg font-semibold">
              {t("section_preferences")}
            </h3>
            <div className="flex items-center justify-start gap-2.5 mt-2.5">
              <span className="text-neutral-400 dark:text-neutral-300 text-base">
                {t("theme_label")} {themeLabel()}
              </span>
              <button
                onClick={toggleTheme}
                className="relative inline-block w-[60px] h-[30px] bg-zinc-700 dark:bg-zinc-800 rounded-full border-none cursor-pointer overflow-hidden transition-colors"
                aria-label={buttonState.label}
              >
                <div
                  className={`absolute top-0.5 left-0.5 w-[26px] h-[26px] flex items-center justify-center rounded-full transition-transform ease-in-out duration-300 ${buttonState.positionClass}`}
                >
                  <span className="text-sm flex items-center justify-center select-none pointer-events-none">
                    {buttonState.icon}
                  </span>
                </div>
              </button>
            </div>
          </div>
        </div>
      </div>
      <div
        ref={copyrightRef}
        className={`pt-8 border-t border-zinc-800 dark:border-zinc-700 text-zinc-500 dark:text-zinc-400 text-sm w-4/5 sm:w-full sm:text-center animate-on-scroll ${
          copyrightIsVisible ? "visible" : ""
        }`}
        style={{ animationDelay: "0.3s" }}
      >
        <p>{t("copyright", { year: new Date().getFullYear() })}</p>
      </div>
    </footer>
  );
}
