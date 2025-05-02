import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/language_controller.dart";

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const List<Map<String, String>> _languages = [
    {
      "code": "es",
      "name": "Español",
    },
    {
      "code": "en",
      "name": "English",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings_screen.language".tr,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: List.generate(
                  _languages.length,
                  (index) {
                    final language = _languages[index];
                    return Column(
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
          ],
        ),
      ),
    );
  }
}
