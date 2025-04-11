"use client";

import { useEffect, useState } from "react";
import Image from "next/image";

export default function HeroSection() {
  const [isDarkMode, setIsDarkMode] = useState(false);

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
    <section className="bg-gradient-to-b from-orange-600 to-amber-500 dark:from-orange-950 dark:to-zinc-900 text-white pt-32 pb-20 px-5 text-center relative overflow-hidden">
      <div className="max-w-4xl mx-auto mb-8">
        <h1 className="text-4xl md:text-5xl lg:text-5xl font-bold mb-4 drop-shadow-md">
          Tu libro de recetas digital
        </h1>
        <p className="text-lg md:text-xl opacity-90 mb-8">
          Almacena, organiza y encuentra fácilmente todas tus recetas favoritas
          en un solo lugar. ¡Ya disponible para Android!
        </p>
        <a
          href="https://the-recipe-app.uptodown.com/android"
          target="_blank"
          rel="noopener noreferrer"
          className="inline-flex items-center gap-2 px-8 py-4 rounded-full bg-white text-orange-600 dark:bg-orange-600 dark:text-white font-semibold text-lg transition-all duration-300 hover:bg-zinc-50 dark:hover:bg-orange-700 hover:-translate-y-1 hover:shadow-lg select-none"
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
          <span>Descargar ahora</span>
        </a>
      </div>

      <div className="max-w-6xl mx-auto py-10 flex justify-center items-center gap-3 md:gap-5 flex-wrap select-none">
        <div className="w-64 md:w-80 transition-all duration-500 hover:-translate-y-3 hover:scale-105 hover:rotate-0 -rotate-3">
          <Image
            src={
              isDarkMode
                ? "/DarkInicialScreen.webp"
                : "/LightInicialScreen.webp"
            }
            alt="App receta detallada - modo oscuro"
            width={360}
            height={720}
            className="w-full h-auto"
            priority
          />
        </div>
        <div className="w-64 md:w-80 transition-all duration-500 hover:-translate-y-3 hover:scale-105 hover:rotate-0 rotate-3">
          <Image
            src={
              isDarkMode ? "/DarkRecipeScreen.webp" : "/LightRecipeScreen.webp"
            }
            alt="App lista de recetas - modo oscuro"
            width={360}
            height={720}
            className="w-full h-auto"
            priority
          />
        </div>
      </div>
    </section>
  );
}
