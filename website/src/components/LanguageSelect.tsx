import { useState, useEffect, useRef } from "react";
import { useTranslation } from "react-i18next";

const languageOptions = [
  { code: "es", name: "Español", flagCode: "ES" },
  { code: "en", name: "English", flagCode: "GB" },
  { code: "de", name: "Deutsch", flagCode: "DE" },
  { code: "it", name: "Italiano", flagCode: "IT" },
  { code: "fr", name: "Français", flagCode: "FR" },
  { code: "pt", name: "Português", flagCode: "PT" },
  { code: "zh", name: "中文", flagCode: "CN" },
  { code: "ja", name: "日本語", flagCode: "JP" },
  { code: "ko", name: "한국어", flagCode: "KR" },
];

export default function LanguageSelect() {
  const { i18n } = useTranslation();
  const [isOpen, setIsOpen] = useState(false);
  const [selectedLanguage, setSelectedLanguage] = useState<string>(
    i18n.language
  );
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setSelectedLanguage(i18n.language);
  }, [i18n.language]);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(event.target as Node)
      ) {
        setIsOpen(false);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  const changeLanguage = (code: string) => {
    if (code !== selectedLanguage) {
      i18n.changeLanguage(code);
    }
    setIsOpen(false);
  };

  const getCurrentLanguageName = () => {
    const language = languageOptions.find(
      (lang) => lang.code === selectedLanguage
    );
    return language ? language.name : "English";
  };

  const getCurrentLanguageFlag = () => {
    const language = languageOptions.find(
      (lang) => lang.code === selectedLanguage
    );
    return language ? language.flagCode : "GB";
  };

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="inline-flex items-center gap-1 py-2 px-3 rounded-md text-zinc-700 dark:text-zinc-300 bg-orange-100 dark:bg-orange-900/20 hover:bg-orange-200 dark:hover:bg-orange-900/30 transition-colors border border-orange-200 dark:border-orange-700/30"
        aria-label="Select language"
        aria-expanded={isOpen}
      >
        <img
          src={`flags/${getCurrentLanguageFlag()}.svg`}
          alt={getCurrentLanguageName()}
          width={16}
          height={16}
          className="inline-block ml-2"
          loading="lazy"
        />
        <span className="text-sm font-medium text-orange-700 dark:text-orange-400">
          {getCurrentLanguageName()}
        </span>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16px"
          height="16px"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
          className={`ml-1.5 transition-transform duration-200 text-orange-500 dark:text-orange-400 ${
            isOpen ? "rotate-180" : ""
          }`}
        >
          <path d="M12 5v14m-7-7l7 7 7-7" />
        </svg>
      </button>

      {isOpen && (
        <div className="absolute mt-1 left-0 bg-white dark:bg-zinc-800 border border-orange-200 dark:border-orange-800/30 rounded-md shadow-lg z-50 min-w-[150px] overflow-hidden">
          <ul className="py-1">
            {languageOptions.map((language) => (
              <li key={language.code}>
                <button
                  onClick={() => changeLanguage(language.code)}
                  className={`flex justify-start items-center w-full gap-0 text-left px-4 py-2 text-sm ${
                    language.code === selectedLanguage
                      ? "bg-orange-100 dark:bg-orange-900/40 text-orange-600 dark:text-orange-400 font-medium"
                      : "text-zinc-700 dark:text-zinc-300 hover:bg-orange-50 dark:hover:bg-orange-900/20 hover:text-orange-600 dark:hover:text-orange-400"
                  }`}
                >
                  <img
                    src={`flags/${language.flagCode}.svg`}
                    alt={language.name}
                    width={16}
                    height={16}
                    className="inline-block mr-2"
                    loading="lazy"
                  />
                  <span>{language.name}</span>
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
