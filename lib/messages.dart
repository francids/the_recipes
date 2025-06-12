import "dart:convert";
import "package:flutter/services.dart";
import "package:get/get.dart";

class Messages extends Translations {
  static String get appName =>
      {
        "es": "Recetas",
        "en": "Recipes",
        "de": "Rezepte",
        "it": "Ricette",
        "fr": "Recettes",
        "pt": "Receitas",
        "zh": "食谱",
        "ja": "レシピ",
        "ko": "레시피",
      }[Get.locale?.languageCode] ??
      "Recipes";

  @override
  Map<String, Map<String, String>> get keys => _keys;

  static Map<String, Map<String, String>> _keys = {
    "es": {},
    "en": {},
    "de": {},
    "it": {},
    "fr": {},
    "pt": {},
    "zh": {},
    "ja": {},
    "ko": {},
  };

  static Future<void> init() async {
    for (final lang in _keys.keys) {
      final content = await rootBundle.loadString("assets/messages/$lang.json");
      final translations = _flattenTranslations(json.decode(content));
      _convertParamsFormat(translations);
      _keys[lang] = translations;
    }
  }

  static void _convertParamsFormat(Map<String, String> translations) {
    translations.forEach((key, value) {
      if (value.contains("{") && value.contains("}")) {
        var newValue = value;
        final regex = RegExp(r"\{(\d+)\}");
        final matches = regex.allMatches(value);
        for (var match in matches) {
          final paramIndex = match.group(1);
          newValue = newValue.replaceAll("{$paramIndex}", "@$paramIndex");
        }
        translations[key] = newValue;
      }
    });
  }

  static Map<String, String> _flattenTranslations(Map<String, dynamic> json,
      [String prefix = ""]) {
    final Map<String, String> result = {};

    json.forEach((key, value) {
      final String newKey = prefix.isEmpty ? key : "$prefix.$key";

      if (value is Map) {
        result.addAll(
            _flattenTranslations(Map<String, dynamic>.from(value), newKey));
      } else if (value is String) {
        result[newKey] = value;
      }
    });

    return result;
  }
}
