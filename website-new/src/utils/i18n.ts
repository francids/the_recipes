// Import all language files
import en from '../../messages/en.json';
import es from '../../messages/es.json';
import fr from '../../messages/fr.json';
import de from '../../messages/de.json';
import it from '../../messages/it.json';
import ja from '../../messages/ja.json';
import ko from '../../messages/ko.json';
import pt from '../../messages/pt.json';
import zh from '../../messages/zh.json';

const translations = {
  en,
  es,
  fr,
  de,
  it,
  ja,
  ko,
  pt,
  zh,
};

export type Language = keyof typeof translations;
export const languages: Language[] = ['en', 'es', 'fr', 'de', 'it', 'ja', 'ko', 'pt', 'zh'];
export const defaultLanguage: Language = 'es';

export function getTranslations(lang: Language) {
  return translations[lang] || translations[defaultLanguage];
}

export function t(key: string, lang: Language, prefix?: string): string {
  const translation = getTranslations(lang);
  const keys = prefix ? `${prefix}.${key}` : key;
  const keyPath = keys.split('.');
  
  let result: any = translation;
  for (const k of keyPath) {
    if (result && typeof result === 'object' && k in result) {
      result = result[k];
    } else {
      return key; // Return key if translation not found
    }
  }
  
  return typeof result === 'string' ? result : key;
}