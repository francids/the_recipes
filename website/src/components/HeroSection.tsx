"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import { useTranslations } from "next-intl";
import Logotype from "./Logotype";
import { useElementOnScreen } from "@/hooks/useElementOnScreen";

export default function HeroSection() {
  const t = useTranslations("HeroSection");
  const [isDarkMode, setIsDarkMode] = useState<boolean>(false);
  const [image1Loaded, setImage1Loaded] = useState(false);
  const [image2Loaded, setImage2Loaded] = useState(false);

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

  return (
    <section className="bg-gradient-to-b from-orange-600 to-amber-500 dark:from-yellow-950 dark:to-zinc-900 text-white pt-20 md:pt-20 pb-16 px-8 text-center md:text-left relative overflow-hidden selection:bg-white/25">
      <div
        className={`absolute bottom-0 left-0 right-0 top-0 ${
          isDarkMode
            ? "bg-[linear-gradient(to_right,#4f4f4f2e_1px,transparent_1px),linear-gradient(to_bottom,#4f4f4f2e_1px,transparent_1px)]"
            : "bg-[linear-gradient(to_right,#fed7aa40_1px,transparent_1px),linear-gradient(to_bottom,#fed7aa40_1px,transparent_1px)]"
        } bg-[size:28px_28px] [mask-image:radial-gradient(ellipse_60%_50%_at_50%_0%,#000_70%,transparent_100%)]`}
      ></div>
      <div
        className={`opacity-0 absolute inset-0 -z-10 h-full w-full ${
          isDarkMode
            ? "bg-zinc-900 [background:radial-gradient(125%_125%_at_50%_10%,#18181b_40%,#713f12_100%)]"
            : "bg-white [background:radial-gradient(125%_125%_at_50%_10%,#fff_40%,#fed7aa_100%)]"
        }`}
      ></div>
      <div className="max-w-7xl mx-auto flex xl:flex-row flex-col lg:items-center xl:justify-between gap-8 relative z-10">
        <div className="lg:w-2/5 mb-4 lg:mb-12 xl:mb-32 text-center xl:text-left">
          <div
            ref={logotypeRef}
            className={`flex items-center justify-center xl:justify-start mb-4 w-full animate-on-scroll ${
              logotypeIsVisible ? "visible" : ""
            }`}
          >
            <Logotype className="w-20 h-8 dark:text-amber-500" />
          </div>
          <h1
            ref={h1Ref}
            className={`text-4xl md:text-5xl lg:text-5xl font-bold mb-4 drop-shadow-md animate-on-scroll ${
              h1IsVisible ? "visible" : ""
            }`}
            style={{ animationDelay: "0.2s" }}
          >
            {t("title")}
          </h1>
          <p
            ref={pRef}
            className={`text-lg md:text-xl mb-8 animate-on-scroll ${
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
            className={`inline-flex justify-center items-center gap-2 px-8 py-4 rounded-md bg-white text-orange-600 dark:bg-orange-600 dark:text-white font-semibold text-lg transition-all duration-300 active:scale-95 hover:shadow-orange-500/50 dark:hover:shadow-orange-400/50 hover:bg-orange-50 dark:hover:bg-orange-700 hover:text-orange-600 dark:hover:text-white select-none animate-on-scroll ${
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
            <span>{t("download")}</span>
          </a>
        </div>

        <div className="flex flex-col items-center justify-center gap-8 lg:gap-0">
          <div className="flex justify-center md:justify-end items-center gap-6 md:gap-12 flex-wrap select-none">
            <div className="w-56 md:w-72 transition-all duration-500 hover:-translate-y-3 hover:scale-105 hover:rotate-0 -rotate-3 relative">
              {!image1Loaded && (
                <div className="absolute inset-0 flex items-center justify-center bg-orange-800/20 rounded-lg">
                  <div className="w-10 h-10 border-4 border-white border-t-transparent rounded-full animate-spin"></div>
                </div>
              )}
              <Image
                src={
                  isDarkMode
                    ? "/DarkInicialScreen.webp"
                    : "/LightInicialScreen.webp"
                }
                alt="App pantalla inicial"
                width={320}
                height={640}
                className={`transition-opacity duration-300 ${
                  image1Loaded ? "opacity-100" : "opacity-0"
                } rounded-lg`}
                priority
                unoptimized={true}
                onLoadingComplete={() => setImage1Loaded(true)}
              />
            </div>
            <div className="w-56 md:w-72 transition-all duration-500 hover:-translate-y-3 hover:scale-105 hover:rotate-0 rotate-3 relative">
              {!image2Loaded && (
                <div className="absolute inset-0 flex items-center justify-center bg-orange-800/20 rounded-lg">
                  <div className="w-10 h-10 border-4 border-white border-t-transparent rounded-full animate-spin"></div>
                </div>
              )}
              <Image
                src={
                  isDarkMode
                    ? "/DarkRecipeScreen.webp"
                    : "/LightRecipeScreen.webp"
                }
                alt="App pantalla de receta"
                width={320}
                height={640}
                className={`transition-opacity duration-300 ${
                  image2Loaded ? "opacity-100" : "opacity-0"
                } rounded-lg`}
                priority
                unoptimized={true}
                onLoadingComplete={() => setImage2Loaded(true)}
              />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
