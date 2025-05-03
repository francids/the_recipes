"use client";

import { useEffect, useRef } from "react";
import Image from "next/image";
import Link from "next/link";
import { useTranslations } from "next-intl";
import LanguageSelect from "./LanguageSelect";

interface NavbarProps {
  isMenuOpen: boolean;
  toggleMenu: () => void;
}

export default function Navbar({ isMenuOpen, toggleMenu }: NavbarProps) {
  const t = useTranslations("Navbar");
  const menuRef = useRef<HTMLDivElement>(null);
  const buttonRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (
        isMenuOpen &&
        menuRef.current &&
        buttonRef.current &&
        !menuRef.current.contains(event.target as Node) &&
        !buttonRef.current.contains(event.target as Node)
      ) {
        toggleMenu();
      }
    }

    document.addEventListener("mousedown", handleClickOutside);
    return function () {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [isMenuOpen, toggleMenu]);

  return (
    <nav className="flex justify-between items-center px-8 py-4 static z-50 transition-all duration-300 bg-white dark:bg-zinc-900 shadow-md">
      <div className="flex items-center gap-4 select-none">
        <Link href="/" className="flex items-center select-none">
          <Image src="/Logo.svg" alt="The Recipes App" width={40} height={40} />
        </Link>
        <LanguageSelect />
      </div>

      <div className="hidden md:flex gap-4 items-center select-none">
        <Link
          href="#features"
          className="px-4 py-2 rounded-md bg-zinc-100 dark:bg-zinc-800 text-zinc-900 dark:text-zinc-200 font-semibold text-sm transition-all duration-300 active:scale-95 hover:bg-zinc-200 dark:hover:bg-zinc-700/20 hover:shadow-sm select-none"
        >
          {t("features")}
        </Link>
        <Link
          href="#cta"
          className="px-4 py-2 rounded-md bg-zinc-100 dark:bg-zinc-800 text-zinc-900 dark:text-zinc-200 font-semibold text-sm transition-all duration-300 active:scale-95 hover:bg-zinc-200 dark:hover:bg-zinc-700/20 hover:shadow-sm select-none"
        >
          {t("download")}
        </Link>
        <a
          href="https://github.com/francids/the_recipes"
          target="_blank"
          rel="noopener noreferrer"
          className="px-4 py-2 rounded-md bg-zinc-100 dark:bg-zinc-800 text-zinc-900 dark:text-zinc-200 font-semibold text-sm transition-all duration-300 active:scale-95 hover:bg-zinc-200 dark:hover:bg-zinc-700/20 hover:shadow-sm select-none"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="20"
            height="20"
            viewBox="0 0 24 24"
            fill="currentColor"
          >
            <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
          </svg>
        </a>
      </div>

      <button
        ref={buttonRef}
        className="md:hidden flex flex-col justify-between h-5 w-7 bg-transparent border-none cursor-pointer z-10"
        onClick={toggleMenu}
        aria-label="Menú"
      >
        <span className="w-full h-0.5 rounded-full bg-zinc-900 dark:bg-white transition-all"></span>
        <span className="w-full h-0.5 rounded-full bg-zinc-900 dark:bg-white transition-all"></span>
        <span className="w-full h-0.5 rounded-full bg-zinc-900 dark:bg-white transition-all"></span>
      </button>

      <div
        ref={menuRef}
        className={`
          fixed top-[70px] left-0 right-0 flex flex-col gap-4 m-0 p-6 shadow-lg rounded-b-lg md:hidden
          transition-opacity duration-300 ease-in-out
          ${
            isMenuOpen
              ? "opacity-100 pointer-events-auto"
              : "opacity-0 pointer-events-none"
          }
          bg-white dark:bg-zinc-800 border-t border-gray-200 dark:border-zinc-700 z-40
        `}
      >
        <Link
          href="#features"
          onClick={toggleMenu}
          className="font-medium py-2 text-zinc-800 dark:text-zinc-100 hover:text-orange-600 dark:hover:text-orange-400"
        >
          {t("features")}
        </Link>
        <Link
          href="#cta"
          onClick={toggleMenu}
          className="font-medium py-2 text-zinc-800 dark:text-zinc-100 hover:text-orange-600 dark:hover:text-orange-400"
        >
          {t("download")}
        </Link>
        <a
          href="https://github.com/francids/the_recipes"
          target="_blank"
          rel="noopener noreferrer"
          onClick={toggleMenu}
          className="font-medium py-2 text-zinc-800 dark:text-zinc-100 hover:text-orange-600 dark:hover:text-orange-400"
        >
          GitHub
        </a>
      </div>
    </nav>
  );
}
