export type Locale =
  | "de"
  | "en"
  | "es"
  | "fr"
  | "it"
  | "ja"
  | "ko"
  | "pt"
  | "zh";

export interface Translations {
  [key: string]: string | Translations;
}

const defaultLocale: Locale = "en";
const supportedLocales: Locale[] = [
  "de",
  "en",
  "es",
  "fr",
  "it",
  "ja",
  "ko",
  "pt",
  "zh",
];

const translationsCache = new Map<Locale, Translations>();

async function loadTranslations(locale: Locale): Promise<Translations> {
  if (translationsCache.has(locale)) {
    return translationsCache.get(locale)!;
  }

  try {
    const translations = await import(`../../messages/${locale}.json`);
    translationsCache.set(locale, translations.default);
    return translations.default;
  } catch (error) {
    console.warn(
      `Could not load locale ${locale}, falling back to ${defaultLocale}`
    );
    if (locale !== defaultLocale) {
      return await loadTranslations(defaultLocale);
    }
    return {};
  }
}

export function detectUserLocale(request: Request): Locale {
  const cookies = request.headers.get("cookie");
  if (cookies) {
    const localeCookie = cookies
      .split(";")
      .find((c) => c.trim().startsWith("locale="));

    if (localeCookie) {
      const locale = localeCookie.split("=")[1] as Locale;
      if (supportedLocales.includes(locale)) {
        return locale;
      }
    }
  }

  const acceptLanguage = request.headers.get("accept-language");
  if (acceptLanguage) {
    const languages = acceptLanguage
      .split(",")
      .map((lang) => lang.split(";")[0].trim().toLowerCase());

    for (const lang of languages) {
      if (supportedLocales.includes(lang as Locale)) {
        return lang as Locale;
      }

      const langCode = lang.split("-")[0] as Locale;
      if (supportedLocales.includes(langCode)) {
        return langCode;
      }
    }
  }

  return defaultLocale;
}

function getNestedTranslation(
  obj: Translations,
  path: string
): string | undefined {
  const result = path
    .split(".")
    .reduce((current: Translations | string | undefined, key: string) => {
      if (current && typeof current === "object" && key in current) {
        return current[key];
      }
      return undefined;
    }, obj);

  return typeof result === "string" ? result : undefined;
}

export async function t(
  key: string,
  locale: Locale = defaultLocale
): Promise<string> {
  const translations = await loadTranslations(locale);
  return getNestedTranslation(translations, key) || key;
}

export async function createTranslationHelper(
  locale: Locale
): Promise<(key: string, fallback?: string) => string> {
  const translations = await loadTranslations(locale);

  return function translate(key: string, fallback: string = key): string {
    return getNestedTranslation(translations, key) || fallback;
  };
}

export { supportedLocales, defaultLocale };
