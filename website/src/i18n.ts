import i18n from "i18next";
import { initReactI18next } from "react-i18next";

import en from "../messages/en.json";
import es from "../messages/es.json";
import fr from "../messages/fr.json";
import de from "../messages/de.json";
import it from "../messages/it.json";
import ja from "../messages/ja.json";
import ko from "../messages/ko.json";
import pt from "../messages/pt.json";
import zh from "../messages/zh.json";

const resources = {
  en: { translation: en },
  es: { translation: es },
  fr: { translation: fr },
  de: { translation: de },
  it: { translation: it },
  ja: { translation: ja },
  ko: { translation: ko },
  pt: { translation: pt },
  zh: { translation: zh },
};

type ResourceKey = keyof typeof resources;

const savedLang = localStorage.getItem("i18nextLng");
const browserLang = navigator.language.split("-")[0];
const fallbackLng = "en";
const initialLang =
  savedLang &&
  (resources as Record<string, (typeof resources)[ResourceKey]>)[savedLang]
    ? savedLang
    : (resources as Record<string, (typeof resources)[ResourceKey]>)[
        browserLang
      ]
    ? browserLang
    : fallbackLng;

i18n.use(initReactI18next).init({
  resources,
  lng: initialLang,
  fallbackLng,
  interpolation: {
    escapeValue: false,
  },
});

i18n.on("languageChanged", (lng) => {
  localStorage.setItem("i18nextLng", lng);
});

export default i18n;
