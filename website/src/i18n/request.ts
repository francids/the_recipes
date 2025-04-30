import { getRequestConfig } from "next-intl/server";
import { cookies, headers } from "next/headers";
import { match } from "@formatjs/intl-localematcher";
import Negotiator from "negotiator";

const supportedLocales = ["en", "es", "de", "fr", "pt", "zh"];
const defaultLocale = "en";

async function getBrowserLocale(): Promise<string | null> {
  const requestHeaders = headers();
  const acceptLanguage = requestHeaders.get("accept-language");

  if (!acceptLanguage) {
    return null;
  }

  let languages = new Negotiator({ headers: { "accept-language": acceptLanguage } }).languages();

  try {
    return match(languages, supportedLocales, defaultLocale);
  } catch (e) {
    console.warn("Could not determine locale from browser, falling back to default.", e);
    return defaultLocale;
  }
}

async function getUserLocale(): Promise<string> {
  const cookieStore = cookies();
  const localeCookie = cookieStore.get("NEXT_LOCALE");

  if (localeCookie?.value && supportedLocales.includes(localeCookie.value)) {
    return localeCookie.value;
  }

  const browserLocale = await getBrowserLocale();
  if (browserLocale) {
    return browserLocale;
  }

  return defaultLocale;
}

export default getRequestConfig(async () => {
  const locale = await getUserLocale();

  return {
    locale,
    messages: (await import(`../../messages/${locale}.json`)).default
  };
});
