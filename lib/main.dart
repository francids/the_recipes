import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:the_recipes/screens/add_recipe_screen.dart';
import 'package:the_recipes/screens/inicial_screen.dart';
import 'package:the_recipes/the_recipe_app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    MaterialApp(
      title: 'The Recipes App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const InicialScreen(),
        '/add': (context) => const AddRecipeScreen(),
      },
      theme: ThemeData(
        textTheme: TheRecipeAppTheme.textTheme,
        colorScheme: TheRecipeAppTheme.colorScheme,
        useMaterial3: false,
      ),
    ),
  );
}
