import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/language_controller.dart";

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const List<Map<String, String>> _languages = [
    {"code": "es", "name": "Español", "flagCode": "ES"},
    {"code": "en", "name": "English", "flagCode": "GB"},
    {"code": "de", "name": "Deutsch", "flagCode": "DE"},
    {"code": "it", "name": "Italiano", "flagCode": "IT"},
    {"code": "fr", "name": "Français", "flagCode": "FR"},
    {"code": "pt", "name": "Português", "flagCode": "PT"},
    {"code": "zh", "name": "中文", "flagCode": "CN"},
    {"code": "ja", "name": "日本語", "flagCode": "JP"},
    {"code": "ko", "name": "한국어", "flagCode": "KR"},
  ];

  String _getFlagEmoji(String countryCode) {
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "settings_screen.language".tr,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _languages.length,
                  (index) {
                    final language = _languages[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<String>(
                          title: Row(
                            children: [
                              Text(_getFlagEmoji(language["flagCode"]!)),
                              const SizedBox(width: 8),
                              Text(language["name"]!),
                            ],
                          ),
                          value: language["code"]!,
                          groupValue: Get.locale?.languageCode,
                          onChanged: (value) {
                            if (value != null) {
                              Get.find<LanguageController>().changeLanguage(
                                Locale(value),
                              );
                              Get.back();
                            }
                          },
                        ),
                        if (index < _languages.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
