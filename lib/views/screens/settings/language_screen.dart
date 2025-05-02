import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/language_controller.dart";

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const List<Map<String, String>> _languages = [
    {"code": "es", "name": "Español"},
    {"code": "en", "name": "English"},
    {"code": "de", "name": "Deutsch"},
    {"code": "it", "name": "Italiano"},
    {"code": "fr", "name": "Français"},
    {"code": "pt", "name": "Português"},
    {"code": "zh", "name": "中文"},
    {"code": "ja", "name": "日本語"},
    {"code": "ko", "name": "한국어"},
  ];

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
                          title: Text(language["name"]!),
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
