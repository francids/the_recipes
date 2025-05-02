import "dart:io";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:lottie/lottie.dart";
import "package:material_dialogs/material_dialogs.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/models/recipe.dart";
import "package:easy_localization/easy_localization.dart";

class RecipeScreen extends StatelessWidget {
  RecipeScreen({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;
  final RecipeController recipeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "recipe_title_${recipe.id}",
          child: Text(
            recipe.title,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Dialogs.materialDialog(
                context: context,
                msg: tr("recipe_screen.delete_confirmation_message"),
                title: tr("recipe_screen.delete_confirmation_title"),
                lottieBuilder: LottieBuilder.asset(
                  "assets/lottie/delete.json",
                  fit: BoxFit.contain,
                ),
                msgAlign: TextAlign.center,
                titleStyle: Theme.of(context).textTheme.displayMedium!,
                msgStyle: Theme.of(context).textTheme.bodyMedium,
                color: Theme.of(context).colorScheme.surface,
                dialogWidth: MediaQuery.of(context).size.width * 0.8,
                useRootNavigator: true,
                useSafeArea: true,
                actionsBuilder: (context) {
                  return [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(tr("recipe_screen.cancel_button")),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FilledButton(
                        onPressed: () {
                          recipeController.deleteRecipe(
                            recipe.id,
                            recipe.image,
                          );
                          Get.back();
                          Get.back();
                          recipeController.refreshRecipes();
                        },
                        child: Text(tr("recipe_screen.delete_button")),
                      ),
                    ),
                  ];
                },
              );
            },
            icon: const Icon(Icons.delete_outline),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:
                            isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode ? Colors.black38 : Colors.black12,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: "recipe_image_${recipe.id}",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(recipe.image),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      recipe.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Divider(
                      thickness: 0.3,
                      height: 16,
                      color: Colors.black12,
                    ),
                    Text(
                      tr("recipe_screen.ingredients_title"),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
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
                    ),
                    const Divider(
                      thickness: 0.3,
                      height: 16,
                      color: Colors.black12,
                    ),
                    Text(
                      tr("recipe_screen.instructions_title"),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
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
                    ),
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
