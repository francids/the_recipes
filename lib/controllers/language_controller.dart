import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";

class LanguageController extends GetxController {
  static const languageBox = "language_box";
  static const languageKey = "language_key";

  String _currentLanguage = Get.deviceLocale?.languageCode ?? "en";
  String get currentLanguage => _currentLanguage;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  void loadLanguage() async {
    try {
      if (!Hive.isBoxOpen(languageBox)) {
        await Hive.openBox(languageBox);
      }

      final box = Hive.box(languageBox);
      final language = box.get(
        languageKey,
        defaultValue: Get.deviceLocale?.languageCode ?? "en",
      );

      _currentLanguage = language;

      update();
      applyLanguage();
    } catch (e) {
      print("Error loading language: $e");
      _currentLanguage = "en";
      update();
      applyLanguage();
    }
  }

  void changeLanguage(Locale language) async {
    _currentLanguage = language.languageCode;
    update();

    try {
      if (!Hive.isBoxOpen(languageBox)) {
        await Hive.openBox(languageBox);
      }

      final box = Hive.box(languageBox);
      await box.put(languageKey, _currentLanguage);

      applyLanguage();
    } catch (e) {
      print("Error saving language: $e");
    }
  }

  void applyLanguage() {
    Get.updateLocale(Locale(_currentLanguage));
  }
}
