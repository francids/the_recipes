import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/adapters.dart';

class ThemeController extends GetxController {
  static const themeBox = 'theme_box';
  static const themeKey = 'dark_theme';

  final RxBool _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

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

      _isDarkMode.value = isDark;

      applyTheme();
    } catch (e) {
      print("Error al cargar el tema: $e");
      _isDarkMode.value = Get.isPlatformDarkMode;
      applyTheme();
    }
  }

  void toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;

    try {
      if (!Hive.isBoxOpen(themeBox)) {
        await Hive.openBox(themeBox);
      }

      final box = Hive.box(themeBox);
      await box.put(themeKey, _isDarkMode.value);

      applyTheme();
    } catch (e) {
      print("Error al guardar el tema: $e");
    }
  }

  void applyTheme() {
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
