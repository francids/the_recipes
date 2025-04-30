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
          <Image
            src="/Logo.svg"
            alt="The Recipes App"
            width={40}
            height={40}
            className="dark:invert"
          />
        </Link>
        <LanguageSelect />
      </div>

      <div className="hidden md:flex gap-8 items-center select-none">
        <Link
          href="#features"
          className="font-medium text-zinc-800 dark:text-zinc-100 hover:text-orange-600 dark:hover:text-orange-400"
        >
          {t("features")}
        </Link>
        <Link
          href="#cta"
          className="font-medium text-zinc-800 dark:text-zinc-100 hover:text-orange-600 dark:hover:text-orange-400"
        >
          {t("download")}
        </Link>
        <a
          href="https://github.com/francids/the_recipes"
          target="_blank"
          rel="noopener noreferrer"
          className="font-medium text-zinc-800 dark:text-zinc-100 hover:text-orange-600 dark:hover:text-orange-400"
        >
          GitHub
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
          fixed top-[72px] left-0 right-0 flex flex-col gap-4 p-6 shadow-lg rounded-b-lg md:hidden
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
