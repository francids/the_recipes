import "package:firebase_app_check/firebase_app_check.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/controllers/favorites_controller.dart";
import "package:the_recipes/controllers/language_controller.dart";
import "package:the_recipes/controllers/theme_controller.dart";
import "package:the_recipes/controllers/view_option_controller.dart";
import "package:the_recipes/firebase_options.dart";
import "package:the_recipes/hive/hive_adapters.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/messages.dart";
import "package:the_recipes/models/recipe.dart";
import "package:the_recipes/views/screens/inicial_screen.dart";
import "package:the_recipes/the_recipe_app_theme.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Messages.init();

  await Hive.initFlutter();
  Hive..registerAdapter(RecipeAdapter());
  await Hive.openBox<Recipe>(recipesBox);
  await Hive.openBox<String>(favoritesBox);
  await Hive.openBox(settingsBox);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );

  Get.put(AuthController());
  Get.put(ThemeController());
  Get.put(LanguageController());
  Get.put(FavoritesController());
  Get.put(ViewOptionController());

  configureEasyLoading();

  runApp(
    const MyApp(),
  );
}

void configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.deepOrange
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.deepOrange
    ..textColor = Colors.black87
    ..maskColor = Colors.black.withAlpha(128)
    ..userInteractions = true
    ..dismissOnTap = true
    ..boxShadow = [
      BoxShadow(
        color: Colors.black.withAlpha(25),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ]
    ..fontSize = 14.0
    ..textStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      color: Colors.black87,
    )
    ..contentPadding = const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 20.0,
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onGenerateTitle: (context) => Messages.appName,
      transitionDuration: const Duration(milliseconds: 350),
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
      color: Colors.deepOrange,
      theme: TheRecipeAppTheme.theme,
      darkTheme: TheRecipeAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const InicialScreen(),
      builder: EasyLoading.init(),
      translations: Messages(),
      locale: Locale(Get.find<LanguageController>().currentLanguage),
      fallbackLocale: Locale("en"),
    );
  }
}
