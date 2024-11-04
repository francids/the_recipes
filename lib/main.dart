import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:the_recipes/firebase_options.dart';

import 'package:the_recipes/views/screens/inicial_screen.dart';
import 'package:the_recipes/the_recipe_app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    GetMaterialApp(
      title: 'The Recipes App',
      transitionDuration: const Duration(milliseconds: 350),
      defaultTransition: Transition.downToUp,
      debugShowCheckedModeBanner: false,
      home: const InicialScreen(),
      theme: ThemeData(
        textTheme: TheRecipeAppTheme.textTheme,
        colorScheme: TheRecipeAppTheme.colorScheme,
        useMaterial3: false,
      ),
      builder: EasyLoading.init(),
    ),
  );
}
