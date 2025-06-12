import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/controllers/favorites_controller.dart";
import "package:the_recipes/models/recipe.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:the_recipes/views/widgets/ui_helpers.dart";

class RecipeScreen extends StatelessWidget {
  RecipeScreen({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;
  final RecipeController recipeController = Get.find();
  final FavoritesController favoritesController = Get.find();

  String _formatPreparationTime(int seconds) {
    if (seconds == 0) return "";

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    Map<String, Map<String, String>> localizedStrings = {
      "de": {"h": "Std", "m": "Min", "s": "Sek"},
      "en": {"h": "h", "m": "m", "s": "s"},
      "es": {"h": "h", "m": "m", "s": "s"},
      "fr": {"h": "h", "m": "m", "s": "s"},
      "it": {"h": "h", "m": "m", "s": "s"},
      "ja": {"h": "時間", "m": "分", "s": "秒"},
      "ko": {"h": "시간", "m": "분", "s": "초"},
      "pt": {"h": "h", "m": "m", "s": "s"},
      "zh": {"h": "小时", "m": "分钟", "s": "秒"},
    };

    Map<String, String> currentStrings =
        localizedStrings[Get.locale] ?? localizedStrings["en"]!;

    List<String> parts = [];
    if (hours > 0) parts.add("$hours${currentStrings["h"]}");
    if (minutes > 0) parts.add("$minutes${currentStrings["m"]}");
    if (remainingSeconds > 0 && hours == 0)
      parts.add("$remainingSeconds${currentStrings["s"]}");

    return parts.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("recipe_screen.title".tr),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        actions: [
          Obx(() => IconButton(
                onPressed: () => favoritesController.toggleFavorite(recipe.id),
                icon: Icon(
                  favoritesController.isFavorite(recipe.id)
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: favoritesController.isFavorite(recipe.id)
                      ? Colors.red
                      : null,
                ),
              )),
          IconButton(
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            tooltip: "inicial_screen.menu_tooltip".tr,
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(CupertinoIcons.delete),
                      title: Text("recipe_screen.menu_item_delete".tr),
                      horizontalTitleGap: 8,
                    ),
                    onTap: () {
                      UIHelpers.showConfirmationDialog(
                        context: context,
                        title: "recipe_screen.delete_confirmation_title".tr,
                        message: "recipe_screen.delete_confirmation_message".tr,
                        lottieAsset: "assets/lottie/delete.json",
                        confirmAction: () {
                          recipeController.deleteRecipe(
                            recipe.id,
                            recipe.image,
                          );
                          Get.back();
                          Get.back();
                          recipeController.refreshRecipes();
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDarkMode ? Colors.white30 : Colors.black26,
                          width: 0.5,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        color:
                            isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.5),
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                        ),
                        child: Image.file(
                          File(recipe.image),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.displayLarge,
                    ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(
                          begin: 0.2,
                          duration: 400.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: 8),
                    if (recipe.preparationTime > 0)
                      Chip(
                        avatar: Icon(CupertinoIcons.time),
                        label: Text(
                          _formatPreparationTime(recipe.preparationTime),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 100.ms, duration: 500.ms)
                          .slideY(
                            begin: 0.2,
                            duration: 400.ms,
                            curve: Curves.easeOutCubic,
                          ),
                    const SizedBox(height: 8),
                    Text(
                      recipe.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(
                          begin: 0.2,
                          duration: 400.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    const Divider(
                      thickness: 0.3,
                      height: 32,
                      color: Colors.black12,
                    ),
                    Text(
                      "recipe_screen.ingredients_title".tr,
                      style: Theme.of(context).textTheme.displayMedium,
                    ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(
                        begin: 0.2,
                        duration: 400.ms,
                        curve: Curves.easeOutCubic),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 2);
                        },
                        itemBuilder: (context, index) {
                          return Text(
                            "\u2022   ${recipe.ingredients[index]}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        },
                        itemCount: recipe.ingredients.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 3),
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                    const Divider(
                      thickness: 0.3,
                      height: 32,
                      color: Colors.black12,
                    ),
                    Text(
                      "recipe_screen.instructions_title".tr,
                      style: Theme.of(context).textTheme.displayMedium,
                    ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideY(
                        begin: 0.2,
                        duration: 400.ms,
                        curve: Curves.easeOutCubic),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 8);
                        },
                        itemBuilder: (context, index) {
                          return Text(
                            "${index + 1}. ${recipe.directions[index]}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        },
                        itemCount: recipe.directions.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 3),
                      ),
                    ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
