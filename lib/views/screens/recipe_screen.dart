import "dart:io";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:lottie/lottie.dart";
import "package:material_dialogs/material_dialogs.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/models/recipe.dart";

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
            icon: const Icon(Icons.more_vert),
            tooltip: "inicial_screen.menu_tooltip".tr,
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text("recipe_screen.menu_item_delete".tr),
                    ),
                    onTap: () {
                      Dialogs.materialDialog(
                        context: context,
                        msg: "recipe_screen.delete_confirmation_message".tr,
                        title: "recipe_screen.delete_confirmation_title".tr,
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
                                child: Text("recipe_screen.cancel_button".tr),
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
                                child: Text("recipe_screen.delete_button".tr),
                              ),
                            ),
                          ];
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
                      child: Hero(
                        tag: "recipe_image_${recipe.id}",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9.5),
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
                      "recipe_screen.ingredients_title".tr,
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
                      "recipe_screen.instructions_title".tr,
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
