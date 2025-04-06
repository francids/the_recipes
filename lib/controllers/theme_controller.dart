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

      update(); // Notify listeners
      applyTheme();
    } catch (e) {
      print("Error al cargar el tema: $e");
      _isDarkMode = Get.isPlatformDarkMode;
      update(); // Notify listeners
      applyTheme();
    }
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    update(); // Notify listeners

    try {
      if (!Hive.isBoxOpen(themeBox)) {
        await Hive.openBox(themeBox);
      }

      final box = Hive.box(themeBox);
      await box.put(themeKey, _isDarkMode);

      applyTheme();
    } catch (e) {
      print("Error al guardar el tema: $e");
    }
  }

  void applyTheme() {
    Get.changeThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
