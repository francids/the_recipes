import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/firebase_options.dart";
import "package:the_recipes/hive/hive_adapters.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/models/recipe.dart";
import "package:the_recipes/views/screens/inicial_screen.dart";
import "package:the_recipes/the_recipe_app_theme.dart";
import "package:the_recipes/views/screens/login_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive..registerAdapter(RecipeAdapter());
  await Hive.openBox<Recipe>(recipesBox);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );

  Get.put(AuthController());

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "The Recipes App",
      transitionDuration: const Duration(milliseconds: 350),
      defaultTransition: Transition.downToUp,
      debugShowCheckedModeBanner: false,
      home: _handleAuthState(),
      theme: TheRecipeAppTheme.theme,
      builder: EasyLoading.init(),
    );
  }

  Widget _handleAuthState() {
    return GetX<AuthController>(
      builder: (a) {
        if (a.user.value != null) {
          return const InicialScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
