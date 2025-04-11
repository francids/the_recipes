"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";

export default function Footer() {
  const [darkMode, setDarkMode] = useState(() => {
    const savedTheme = localStorage.getItem("darkMode");

    if (savedTheme !== null) {
      return savedTheme === "true";
    }

    return window.matchMedia("(prefers-color-scheme: dark)").matches;
  });

  useEffect(() => {
    if (darkMode) {
      document.documentElement.classList.add("dark");
    } else {
      document.documentElement.classList.remove("dark");
    }
    localStorage.setItem("darkMode", darkMode.toString());
  }, [darkMode]);

  const toggleTheme = () => {
    setDarkMode(!darkMode);
  };

  return (
    <footer className="bg-zinc-900 dark:bg-zinc-950 text-white py-16 px-5 text-center">
      <div className="flex justify-between flex-wrap gap-10 max-w-7xl mx-auto mb-10 text-left">
        <div className="flex-1 min-w-[250px] flex flex-col items-start">
          <div className="w-[150px] mb-5 text-white select-none pointer-events-none">
            <Image
              src="/Logo.svg"
              alt="The Recipes App Logo"
              className="invert dark:invert"
              width={100}
              height={24}
              priority
            />
          </div>
          <p className="text-neutral-400 dark:text-neutral-300 text-lg">
            Tu asistente culinario digital
          </p>
        </div>
        <div className="flex gap-10 flex-wrap">
          <div className="min-w-[150px]">
            <h3 className="text-orange-500 mb-5 text-lg">The Recipes</h3>
            <Link
              href="/#features"
              className="block text-neutral-400 dark:text-neutral-300 mb-2.5 no-underline hover:text-orange-500 transition-colors"
            >
              Características
            </Link>
            <Link
              href="/#cta"
              className="block text-neutral-400 dark:text-neutral-300 mb-2.5 no-underline hover:text-orange-500 transition-colors"
            >
              Desarrollo
            </Link>
          </div>
          <div className="min-w-[150px]">
            <h3 className="text-orange-500 mb-5 text-lg">Contacto</h3>
            <a
              href="https://github.com/francids/the_recipes"
              className="block text-neutral-400 dark:text-neutral-300 mb-2.5 no-underline hover:text-orange-500 transition-colors"
            >
              GitHub
            </a>
          </div>
          <div className="min-w-[150px]">
            <h3 className="text-orange-500 mb-5 text-lg">Preferencias</h3>
            <div className="flex items-center justify-start gap-2.5 mt-2.5">
              <span className="text-neutral-400 dark:text-neutral-300 text-base">
                Modo oscuro
              </span>
              <button
                onClick={toggleTheme}
                className="relative inline-block w-[60px] h-[30px] bg-zinc-700 dark:bg-zinc-800 rounded-full border-none cursor-pointer overflow-hidden transition-colors"
                aria-label={
                  darkMode ? "Cambiar a modo claro" : "Cambiar a modo oscuro"
                }
              >
                <div
                  className={`absolute top-0.5 left-0.5 w-[26px] h-[26px] flex items-center justify-center rounded-full transition-transform ease-in-out duration-300 ${
                    darkMode
                      ? "transform translate-x-[30px] bg-zinc-500"
                      : "bg-orange-500"
                  }`}
                >
                  <span className="text-sm flex items-center justify-center select-none pointer-events-none">
                    {darkMode ? "🌙" : "☀️"}
                  </span>
                </div>
              </button>
            </div>
          </div>
        </div>
      </div>
      <div className="pt-8 border-t border-zinc-800 dark:border-zinc-700 text-zinc-500 dark:text-zinc-400 text-sm">
        <p>
          &copy; {new Date().getFullYear()} The Recipes App. Todos los derechos
          reservados.
        </p>
      </div>
    </footer>
  );
}
