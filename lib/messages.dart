import "dart:convert";
import "package:flutter/services.dart";
import "package:get/get.dart";

class Messages extends Translations {
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
    final es = await rootBundle.loadString("assets/messages/es.json");
    final en = await rootBundle.loadString("assets/messages/en.json");
    final de = await rootBundle.loadString("assets/messages/de.json");
    final it = await rootBundle.loadString("assets/messages/it.json");
    final fr = await rootBundle.loadString("assets/messages/fr.json");
    final pt = await rootBundle.loadString("assets/messages/pt.json");
    final zh = await rootBundle.loadString("assets/messages/zh.json");
    final ja = await rootBundle.loadString("assets/messages/ja.json");
    final ko = await rootBundle.loadString("assets/messages/ko.json");

    final esMap = _flattenTranslations(json.decode(es));
    final enMap = _flattenTranslations(json.decode(en));
    final deMap = _flattenTranslations(json.decode(de));
    final itMap = _flattenTranslations(json.decode(it));
    final frMap = _flattenTranslations(json.decode(fr));
    final ptMap = _flattenTranslations(json.decode(pt));
    final zhMap = _flattenTranslations(json.decode(zh));
    final jaMap = _flattenTranslations(json.decode(ja));
    final koMap = _flattenTranslations(json.decode(ko));

    _convertParamsFormat(esMap);
    _convertParamsFormat(enMap);
    _convertParamsFormat(deMap);
    _convertParamsFormat(itMap);
    _convertParamsFormat(frMap);
    _convertParamsFormat(ptMap);
    _convertParamsFormat(zhMap);
    _convertParamsFormat(jaMap);
    _convertParamsFormat(koMap);

    _keys = {
      "es": esMap,
      "en": enMap,
      "de": deMap,
      "it": itMap,
      "fr": frMap,
      "pt": ptMap,
      "zh": zhMap,
      "ja": jaMap,
      "ko": koMap,
    };
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
