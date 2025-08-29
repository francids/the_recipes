import { useEffect, useState } from "react";

import lightHexagonSvg from "../assets/light-hexagon.svg";
import darkHexagonSvg from "../assets/dark-hexagon.svg";

export default function HexagonBackground() {
  const [isDarkMode, setIsDarkMode] = useState<boolean>(false);

  useEffect(() => {
    const isDark = document.documentElement.classList.contains("dark");
    setIsDarkMode(isDark);

    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.attributeName === "class") {
          const isDarkNow = document.documentElement.classList.contains("dark");
          setIsDarkMode(isDarkNow);
        }
      });
    });

    observer.observe(document.documentElement, { attributes: true });

    return () => observer.disconnect();
  }, []);

  const hexagon = isDarkMode ? darkHexagonSvg : lightHexagonSvg;

  return (
    <div className="absolute inset-0 z-0 overflow-hidden bg-gradient-to-b from-main/5 to-white dark:from-main/10 dark:to-zinc-900">
      <style>{`
        @keyframes scroll-bg {
          0% {
            background-position: 0 0;
          }
          100% {
            background-position: -200px -200px;
          }
        }
        .animate-scroll-bg {
          animation: scroll-bg 20s linear infinite;
        }
      `}</style>
      <div
        className="absolute inset-0 opacity-10 dark:opacity-5 animate-scroll-bg transition-opacity duration-500"
        style={{
          backgroundImage: `url("${hexagon}")`,
          backgroundSize: "200px",
          backgroundRepeat: "repeat",
        }}
      />
      <div className="absolute inset-0 bg-gradient-to-b from-transparent to-white dark:to-zinc-900 dark:via-zinc-900/75" />
    </div>
  );
}
