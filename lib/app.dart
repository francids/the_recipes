import "package:app_links/app_links.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/language_controller.dart";
import "package:the_recipes/controllers/share_recipe_controller.dart";
import "package:the_recipes/messages.dart";
import "package:the_recipes/the_recipe_app_theme.dart";
import "package:the_recipes/views/screens/inicial_screen.dart";
import "package:the_recipes/views/screens/recipe_screen.dart";
import "package:the_recipes/views/screens/shared_recipe_screen.dart";
import "package:the_recipes/views/widgets/ui_helpers.dart";

class TheRecipesApp extends StatefulWidget {
  const TheRecipesApp({super.key});

  @override
  State<TheRecipesApp> createState() => _TheRecipesAppState();
}

class _TheRecipesAppState extends State<TheRecipesApp>
    with WidgetsBindingObserver {
  final _appLinks = AppLinks();
  final ShareRecipeController shareRecipeController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDeepLinks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      final appLink = await _appLinks.getInitialLink();
      if (appLink != null) {
        await _handleDeepLink(appLink);
      }
    });
  }

  Future<void> _handleDeepLink(Uri uri) async {
    bool isSharingLink = (uri.host == "sharing" ||
            uri.pathSegments.contains("recipe") ||
            uri.pathSegments.contains("sharing")) &&
        uri.queryParameters.containsKey("id");

    if (isSharingLink) {
      final recipeCloudId = uri.queryParameters["id"];

      if (recipeCloudId != null) {
        final localRecipe =
            shareRecipeController.findLocalRecipeByCloudId(recipeCloudId);

        if (localRecipe != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.to(() => RecipeScreen(recipe: localRecipe));
          });
        } else {
          try {
            final recipeShared =
                await shareRecipeController.getSharedRecipe(recipeCloudId);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.to(() => SharedRecipeScreen(recipe: recipeShared));
            });
          } catch (e) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final currentContext = Get.context;
              if (currentContext != null) {
                UIHelpers.showErrorSnackbar(
                  "shared_recipe.not_found_error".tr,
                  currentContext,
                );
              }
            });
          }
        }
      }
    }
  }

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
      fallbackLocale: const Locale("en"),
    );
  }
}
