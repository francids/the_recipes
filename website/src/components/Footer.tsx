"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import { useTranslations } from "next-intl";
import { useElementOnScreen } from "@/hooks/useElementOnScreen";

type Theme = "light" | "dark" | "system";

export default function Footer() {
  const t = useTranslations("Footer");
  const [theme, setTheme] = useState<Theme>("system");

  const [footerContentRef, footerContentIsVisible] =
    useElementOnScreen<HTMLDivElement>({ threshold: 0.05, triggerOnce: true });
  const [copyrightRef, copyrightIsVisible] = useElementOnScreen<HTMLDivElement>(
    { threshold: 0.05, triggerOnce: true }
  );

  useEffect(() => {
    const storedTheme = localStorage.getItem("theme") as Theme | null;
    if (storedTheme && ["light", "dark", "system"].includes(storedTheme)) {
      setTheme(storedTheme);
    } else {
      setTheme("system");
    }
  }, []);

  useEffect(() => {
    const applyTheme = (currentTheme: Theme) => {
      let isDarkMode: boolean;
      if (currentTheme === "system") {
        isDarkMode = window.matchMedia("(prefers-color-scheme: dark)").matches;
      } else {
        isDarkMode = currentTheme === "dark";
      }

      if (isDarkMode) {
        document.documentElement.classList.add("dark");
      } else {
        document.documentElement.classList.remove("dark");
      }

      if (
        localStorage.getItem("theme") ||
        currentTheme !== "system" ||
        theme !== "system"
      ) {
        localStorage.setItem("theme", currentTheme);
      }
    };

    applyTheme(theme);
  }, [theme]);

  useEffect(() => {
    const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");

    const handleChange = () => {
      if (theme === "system") {
        if (mediaQuery.matches) {
          document.documentElement.classList.add("dark");
        } else {
          document.documentElement.classList.remove("dark");
        }
      }
    };

    handleChange();

    mediaQuery.addEventListener("change", handleChange);
    return () => mediaQuery.removeEventListener("change", handleChange);
  }, [theme]);

  const toggleTheme = () => {
    setTheme((prevTheme) => {
      if (prevTheme === "light") return "dark";
      if (prevTheme === "dark") return "system";
      return "light";
    });
  };

  const getButtonState = () => {
    let isCurrentlyDark: boolean;
    if (theme === "system") {
      if (typeof window !== "undefined") {
        isCurrentlyDark = window.matchMedia(
          "(prefers-color-scheme: dark)"
        ).matches;
      } else {
        isCurrentlyDark = false;
      }
    } else {
      isCurrentlyDark = theme === "dark";
    }

    return {
      icon: theme === "light" ? "☀️" : theme === "dark" ? "🌙" : "💻",
      label:
        theme === "light"
          ? t("theme_toggle_to_dark")
          : theme === "dark"
          ? t("theme_toggle_to_system")
          : t("theme_toggle_to_light"),
      positionClass: isCurrentlyDark
        ? "transform translate-x-[30px] bg-zinc-500"
        : "bg-orange-500",
      isDarkEffective: isCurrentlyDark,
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
        className={`flex justify-between flex-wrap gap-10 max-w-7xl mx-auto mb-10 text-left ${
          footerContentIsVisible ? "animate-fadeInUp" : "opacity-0"
        }`}
      >
        <div className="flex-1 min-w-[250px] flex flex-col items-start">
          <div className="w-[150px] mb-5 text-white select-none pointer-events-none">
            <Image
              src="/Logo.svg"
              alt="The Recipes App Logo"
              width={100}
              height={24}
              priority
            />
          </div>
          <p className="text-neutral-400 dark:text-neutral-300 text-lg">
            {t("tagline")}
          </p>
        </div>
        <div className="flex gap-10 flex-wrap">
          <div className="min-w-[150px]">
            <h3 className="text-orange-500 mb-5 text-lg">
              {t("section_recipes")}
            </h3>{" "}
            <Link
              href="/#features"
              className="block text-neutral-400 dark:text-neutral-300 mb-2.5 no-underline hover:text-orange-500 transition-colors"
            >
              {t("link_features")}
            </Link>
            <Link
              href="/#cta"
              className="block text-neutral-400 dark:text-neutral-300 mb-2.5 no-underline hover:text-orange-500 transition-colors"
            >
              {t("link_development")}
            </Link>
          </div>
          <div className="min-w-[150px]">
            <h3 className="text-orange-500 mb-5 text-lg">
              {t("section_contact")}
            </h3>{" "}
            <a
              href="https://github.com/francids/the_recipes"
              className="block text-neutral-400 dark:text-neutral-300 mb-2.5 no-underline hover:text-orange-500 transition-colors"
            >
              Github
            </a>
          </div>
          <div className="min-w-[150px]">
            <h3 className="text-orange-500 mb-5 text-lg">
              {t("section_preferences")}
            </h3>{" "}
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
        className={`pt-8 border-t border-zinc-800 dark:border-zinc-700 text-zinc-500 dark:text-zinc-400 text-sm w-4/5 sm:w-full sm:text-center ${
          copyrightIsVisible ? "animate-fadeInUp" : "opacity-0"
        } style="animation-delay: 0.3s"`}
      >
        <p>{t("copyright", { year: new Date().getFullYear() })}</p>
      </div>
    </footer>
  );
}
