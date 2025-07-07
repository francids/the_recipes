import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:get/get.dart";
import "package:the_recipes/models/recipe.dart";

class CommonRecipeView extends StatelessWidget {
  const CommonRecipeView({super.key, required this.recipe});

  final Recipe recipe;

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

    return Expanded(
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
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.5),
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                  child: recipe.image.isNotEmpty
                      ? recipe.image.startsWith("http")
                          ? Image.network(
                              recipe.image,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(recipe.image),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          child: const Icon(
                            CupertinoIcons.photo,
                            size: 50,
                            color: Colors.grey,
                          ),
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
                ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(
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
              const Divider(height: 32),
              Text(
                "recipe_screen.ingredients_title".tr,
                style: Theme.of(context).textTheme.displayMedium,
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(
                  begin: 0.2, duration: 400.ms, curve: Curves.easeOutCubic),
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
              const Divider(height: 32),
              Text(
                "recipe_screen.instructions_title".tr,
                style: Theme.of(context).textTheme.displayMedium,
              ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideY(
                  begin: 0.2, duration: 400.ms, curve: Curves.easeOutCubic),
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
    );
  }
}
