import lightHexagonSvg from "../assets/light-hexagon.svg";
import darkHexagonSvg from "../assets/dark-hexagon.svg";
import { useTheme } from "@/contexts/ThemeContext";

export default function HexagonBackground() {
  const { isDarkMode } = useTheme();

  const hexagon = isDarkMode ? darkHexagonSvg : lightHexagonSvg;

  return (
    <div className="absolute inset-0 z-0 overflow-hidden bg-gradient-to-b from-main/5 to-white dark:from-main/10 dark:to-zinc-900">
      <style>{`
        @keyframes scroll-bg {
          0% {
            background-position: 0px 0px;
          }
          25% {
            background-position: 62.5px 62.5px;
          }
          50% {
            background-position: 125px 125px;
          }
          75% {
            background-position: 187.5px 187.5px;
          }
          100% {
            background-position: 250px 250px;
          }
        }
        .animate-scroll-bg {
          animation: scroll-bg 40s linear infinite;
        }
      `}</style>
      <div
        className="absolute inset-0 opacity-10 dark:opacity-5 animate-scroll-bg transition-opacity duration-500"
        style={{
          backgroundImage: `url("${hexagon}")`,
          backgroundSize: "125px",
          backgroundRepeat: "repeat",
        }}
      />
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-white lg:via-white/80 to-white dark:via-zinc-900 lg:dark:via-zinc-900/80 dark:to-zinc-900" />
    </div>
  );
}
