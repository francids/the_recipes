"use client";

import { useState, useEffect } from "react";
import { useTranslations } from "next-intl";
import Footer from "@/components/Footer";
import Navbar from "@/components/Navbar";
import { useElementOnScreen } from "@/hooks/useElementOnScreen";

export default function NotFound() {
  const t = useTranslations("NotFound");
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const [contentRef, contentIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const [footerRef, footerIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
    if (!isMenuOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
  };

  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth >= 768 && isMenuOpen) {
        setIsMenuOpen(false);
        document.body.style.overflow = "";
      }
    };

    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("resize", handleResize);
      document.body.style.overflow = "";
    };
  }, [isMenuOpen]);

  return (
    <div className="flex flex-col bg-white dark:bg-zinc-900 relative min-h-screen">
      <div className="flex-1 min-h-screen relative z-10">
        <Navbar isMenuOpen={isMenuOpen} toggleMenu={toggleMenu} />
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
