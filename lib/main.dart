import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";
import "package:the_recipes/app.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/controllers/favorites_controller.dart";
import "package:the_recipes/controllers/language_controller.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/controllers/share_recipe_controller.dart";
import "package:the_recipes/controllers/theme_controller.dart";
import "package:the_recipes/controllers/view_option_controller.dart";
import "package:the_recipes/appwrite_config.dart";
import "package:the_recipes/easy_loading_config.dart";
import "package:the_recipes/hive/hive_adapters.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/messages.dart";
import "package:the_recipes/models/recipe.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Messages.init();

  await Hive.initFlutter();
  Hive..registerAdapter(RecipeAdapter());
  await Hive.openBox<Recipe>(recipesBox);
  await Hive.openBox<String>(favoritesBox);
  await Hive.openBox(settingsBox);

  AppwriteConfig.client;

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );

  Get.lazyPut(() => RecipeController());
  Get.put(AuthController());
  Get.put(ThemeController());
  Get.put(LanguageController());
  Get.put(FavoritesController());
  Get.put(ViewOptionController());
  Get.put(ShareRecipeController());

  configureEasyLoading();

  runApp(
    const TheRecipesApp(),
  );
}
