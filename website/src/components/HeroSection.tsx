import { useTranslation } from "react-i18next";
import Logotype from "./Logotype";
import RecipeBackground from "./RecipeBackground";
import { useElementOnScreen, useTheme } from "@/hooks";

import LightInicialScreen from "../assets/light-inicial-screen.webp";
import DarkInicialScreen from "../assets/dark-inicial-screen.webp";
import LightRecipeScreen from "../assets/light-recipe-screen.webp";
import DarkRecipeScreen from "../assets/dark-recipe-screen.webp";

export default function HeroSection() {
  const { t } = useTranslation(undefined, {
    keyPrefix: "HeroSection",
  });
  const { isDarkMode } = useTheme();

  const [h1Ref, h1IsVisible] = useElementOnScreen<HTMLHeadingElement>({
    threshold: 0.1,
    triggerOnce: true,
  });
  const [pRef, pIsVisible] = useElementOnScreen<HTMLParagraphElement>({
    threshold: 0.1,
    triggerOnce: true,
  });
  const [buttonRef, buttonIsVisible] = useElementOnScreen<HTMLAnchorElement>({
    threshold: 0.1,
    triggerOnce: true,
  });
  const [logotypeRef, logotypeIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  return (
    <section className="text-zinc-900 dark:text-zinc-100 pt-20 md:pt-20 pb-16 px-8 text-center md:text-left relative overflow-hidden selection:bg-white/25">
      <RecipeBackground />
      <div className="max-w-7xl mx-auto flex xl:flex-row flex-col lg:items-center xl:justify-between gap-8 relative z-10">
        <div className="lg:w-2/5 mb-4 lg:mb-12 xl:mb-32 text-center xl:text-left">
          <div
            ref={logotypeRef}
            className={`flex items-center justify-center xl:justify-start mb-4 w-full animate-on-scroll ${
              logotypeIsVisible ? "visible" : ""
            }`}
          >
            <Logotype className="w-20 h-8 text-main dark:text-amber-500" />
          </div>
          <h1
            ref={h1Ref}
            className={`md:leading-12 text-4xl md:text-5xl lg:text-5xl font-bold mb-4 animate-on-scroll ${
              h1IsVisible ? "visible" : ""
            }`}
            style={{ animationDelay: "0.2s" }}
          >
            {t("title")}
          </h1>
          <p
            ref={pRef}
            className={`text-zinc-600 dark:text-zinc-400 md:leading-8 text-lg md:text-xl mb-8 animate-on-scroll ${
              pIsVisible ? "visible" : ""
            }`}
            style={{ animationDelay: "0.4s" }}
          >
            {t("description")}
          </p>
          <a
            ref={buttonRef}
            href="https://github.com/francids/the_recipes/releases/latest/download/app-release.apk"
            target="_blank"
            rel="noopener noreferrer"
            className={`inline-flex justify-center items-center gap-2 px-8 py-4 rounded-md bg-main text-white font-semibold text-lg transition-all duration-300 active:scale-95 hover:bg-orange-500 hover:text-white select-none animate-on-scroll ${
              buttonIsVisible ? "visible" : ""
            }`}
            style={{ animationDelay: "0.6s" }}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              height="24px"
              viewBox="0 -960 960 960"
              width="24px"
              fill="currentColor"
            >
              <path d="M40-240q9-107 65.5-197T256-580l-74-128q-6-9-3-19t13-15q8-5 18-2t16 12l74 128q86-36 180-36t180 36l74-128q6-9 16-12t18 2q10 5 13 15t-3 19l-74 128q94 53 150.5 143T920-240H40Zm240-110q21 0 35.5-14.5T330-400q0-21-14.5-35.5T280-450q-21 0-35.5 14.5T230-400q0 21 14.5 35.5T280-350Zm400 0q21 0 35.5-14.5T730-400q0-21-14.5-35.5T680-450q-21 0-35.5 14.5T630-400q0 21 14.5 35.5T680-350Z" />
            </svg>
            <span className="whitespace-nowrap">{t("download")}</span>
          </a>
        </div>

        <div className="flex flex-col items-center justify-center gap-8 lg:gap-0">
          <div className="flex justify-center md:justify-end items-center gap-6 md:gap-12 flex-wrap select-none">
            <div className="w-56 md:w-72 transition-all duration-500 hover:-translate-y-2 hover:-rotate-1 -rotate-3 relative">
              <img
                src={isDarkMode ? DarkInicialScreen : LightInicialScreen}
                alt="App initial screen"
                width={320}
                height={640}
                className="transition-opacity duration-300 rounded-lg"
              />
            </div>
            <div className="w-56 md:w-72 transition-all duration-500 hover:-translate-y-2 hover:rotate-1 rotate-3 relative">
              <img
                src={isDarkMode ? DarkRecipeScreen : LightRecipeScreen}
                alt="App recipe screen"
                width={320}
                height={640}
                className="transition-opacity duration-300 rounded-lg"
              />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
