import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/adapters.dart';

class ThemeController extends GetxController {
  static const themeBox = 'theme_box';
  static const themeKey = 'dark_theme';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void loadTheme() async {
    try {
      if (!Hive.isBoxOpen(themeBox)) {
        await Hive.openBox(themeBox);
      }

      final box = Hive.box(themeBox);
      final isDark = box.get(themeKey, defaultValue: false);

      _isDarkMode = isDark;

      update();
      applyTheme();
    } catch (e) {
      print("Error loading theme: $e");
      _isDarkMode = Get.isPlatformDarkMode;
      update();
      applyTheme();
    }
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    update();

    try {
      if (!Hive.isBoxOpen(themeBox)) {
        await Hive.openBox(themeBox);
      }

      final box = Hive.box(themeBox);
      await box.put(themeKey, _isDarkMode);

      applyTheme();
    } catch (e) {
      print("Error saving theme: $e");
    }
  }

  void applyTheme() {
    Get.changeThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
