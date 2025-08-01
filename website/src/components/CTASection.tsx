import { useTranslation } from "react-i18next";
import { useElementOnScreen } from "@/hooks/useElementOnScreen";

export default function CTASection() {
  const { t } = useTranslation(undefined, {
    keyPrefix: "CTASection",
  });

  const [h2Ref, h2IsVisible] = useElementOnScreen<HTMLHeadingElement>({
    threshold: 0.1,
    triggerOnce: true,
  });
  const [pRef, pIsVisible] = useElementOnScreen<HTMLParagraphElement>({
    threshold: 0.1,
    triggerOnce: true,
  });
  const [button1Ref, button1IsVisible] = useElementOnScreen<HTMLAnchorElement>({
    threshold: 0.1,
    triggerOnce: true,
  });
  const [button2Ref, button2IsVisible] = useElementOnScreen<HTMLAnchorElement>({
    threshold: 0.1,
    triggerOnce: true,
  });
  const [button3Ref, button3IsVisible] = useElementOnScreen<HTMLAnchorElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  return (
    <section
      id="cta"
      className="py-20 px-5 bg-white dark:bg-zinc-900 text-center"
    >
      <h2
        ref={h2Ref}
        className={`text-4xl font-bold mb-5 text-zinc-800 dark:text-zinc-100 animate-on-scroll ${
          h2IsVisible ? "visible" : ""
        }`}
      >
        {t("title")}
      </h2>
      <p
        ref={pRef}
        className={`max-w-2xl mx-auto mb-10 text-lg text-zinc-600 dark:text-zinc-400 animate-on-scroll ${
          pIsVisible ? "visible" : ""
        }`}
        style={{ animationDelay: "0.2s" }}
      >
        {t("description")}
      </p>

      <div className="flex flex-wrap justify-center gap-5 select-none">
        <a
          ref={button1Ref}
          href="https://github.com/francids/the_recipes/releases/latest/download/app-release.apk"
          target="_blank"
          rel="noopener noreferrer"
          className={`inline-flex justify-center items-center gap-2 px-8 py-4 rounded-md bg-orange-600 text-white font-semibold text-lg transition-all duration-300 active:scale-95 hover:shadow-orange-500/50 dark:hover:shadow-orange-400/50 hover:bg-orange-700 dark:hover:bg-orange-700 select-none animate-on-scroll ${
            button1IsVisible ? "visible" : ""
          }`}
          style={{ animationDelay: "0.4s" }}
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
          <span>{t("download_now")}</span>
        </a>

        <a
          ref={button2Ref}
          href="https://github.com/francids/the_recipes"
          target="_blank"
          rel="noopener noreferrer"
          className={`inline-flex justify-center items-center gap-2 px-8 py-4 rounded-md bg-zinc-100 dark:bg-zinc-800 text-zinc-900 dark:text-zinc-200 font-semibold text-lg transition-all duration-300 active:scale-95 hover:bg-zinc-200 dark:hover:bg-zinc-700/20 hover:shadow-sm select-none animate-on-scroll ${
            button2IsVisible ? "visible" : ""
          }`}
          style={{ animationDelay: "0.5s" }}
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="currentColor"
          >
            <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
          </svg>
          <span>{t("view_github")}</span>
        </a>

        <a
          ref={button3Ref}
          href="#features"
          className={`inline-flex justify-center items-center gap-2 px-8 py-4 rounded-md bg-zinc-100 dark:bg-zinc-800 text-zinc-900 dark:text-zinc-200 font-semibold text-lg transition-all duration-300 active:scale-95 hover:bg-zinc-200 dark:hover:bg-zinc-700/20 hover:shadow-sm select-none animate-on-scroll ${
            button3IsVisible ? "visible" : ""
          }`}
          style={{ animationDelay: "0.6s" }}
        >
          {t("discover_features")}
        </a>
      </div>
    </section>
  );
}
