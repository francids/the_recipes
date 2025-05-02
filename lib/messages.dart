import "dart:convert";
import "package:flutter/services.dart";
import "package:get/get.dart";

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => _keys;

  static Map<String, Map<String, String>> _keys = {
    "en": {},
    "es": {},
  };

  static Future<void> init() async {
    final en = await rootBundle.loadString("assets/messages/en.json");
    final es = await rootBundle.loadString("assets/messages/es.json");

    final enMap = _flattenTranslations(json.decode(en));
    final esMap = _flattenTranslations(json.decode(es));

    _convertParamsFormat(enMap);
    _convertParamsFormat(esMap);

    _keys = {
      "en": enMap,
      "es": esMap,
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
