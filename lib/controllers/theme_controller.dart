import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";
import "package:the_recipes/hive_boxes.dart";

class ThemeController extends GetxController {
  static const themeKey = "dark_theme";
  static const followSystemThemeKey = "follow_system_theme";

  bool _isDarkMode = false;
  bool _followSystemTheme = true;

  bool get isDarkMode => _isDarkMode;
  bool get followSystemTheme => _followSystemTheme;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void loadTheme() async {
    try {
      if (!Hive.isBoxOpen(settingsBox)) {
        await Hive.openBox(settingsBox);
      }

      final box = Hive.box(settingsBox);

      _followSystemTheme = box.get(followSystemThemeKey, defaultValue: true);
      _isDarkMode = box.get(themeKey, defaultValue: false);

      if (_followSystemTheme) {
        _isDarkMode = Get.isPlatformDarkMode;
      }

      update();
      applyTheme();
    } catch (e) {
      print("Error loading theme: $e");
      _followSystemTheme = true;
      _isDarkMode = Get.isPlatformDarkMode;
      update();
      applyTheme();
    }
  }

  void toggleTheme() async {
    if (_followSystemTheme) return;

    _isDarkMode = !_isDarkMode;
    update();

    try {
      if (!Hive.isBoxOpen(settingsBox)) {
        await Hive.openBox(settingsBox);
      }

      final box = Hive.box(settingsBox);
      await box.put(themeKey, _isDarkMode);

      applyTheme();
    } catch (e) {
      print("Error saving theme: $e");
    }
  }

  void setFollowSystemTheme(bool value) async {
    _followSystemTheme = value;

    if (_followSystemTheme) {
      _isDarkMode = Get.isPlatformDarkMode;
    }
    update();

    try {
      if (!Hive.isBoxOpen(settingsBox)) {
        await Hive.openBox(settingsBox);
      }
      final box = Hive.box(settingsBox);
      await box.put(followSystemThemeKey, _followSystemTheme);

      applyTheme();
    } catch (e) {
      print("Error saving follow system theme setting: $e");
    }
  }

  void applyTheme() {
    if (_followSystemTheme) {
      Get.changeThemeMode(ThemeMode.system);
    } else {
      Get.changeThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
    }
  }
}
