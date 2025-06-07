import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/views/widgets/recipe_card.dart";
import "package:the_recipes/views/screens/add_recipe_screen.dart";

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeController recipeController = Get.find<RecipeController>();

    return Scaffold(
      floatingActionButton: Tooltip(
        message: "inicial_screen.fab_tooltip_add".tr,
        preferBelow: false,
        child: FloatingActionButton(
          onPressed: () async {
            var upd = await Get.to(const AddRecipeScreen());
            if (upd == true) {
              recipeController.refreshRecipes();
            }
          },
          child: const Icon(CupertinoIcons.add),
        ).animate().scale(
              delay: 150.ms,
              duration: 300.ms,
              curve: Curves.easeOutBack,
            ),
      ),
      body: GetX<RecipeController>(
        builder: (controller) {
          return controller.recipes.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text("inicial_screen.empty_list".tr),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    controller.refreshRecipes();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16.0,
                      bottom: MediaQuery.of(context).padding.bottom + 16.0,
                      left: 16,
                      right: 16,
                    ),
                    itemCount: controller.recipes.length,
                    itemBuilder: (context, index) {
                      return RecipeCard(
                        recipe: controller.recipes[index],
                      )
                          .animate()
                          .fadeIn(
                            delay: (50 * index).ms,
                            duration: 300.ms,
                          )
                          .slideX(
                            begin: -0.1,
                            delay: (50 * index).ms,
                            duration: 300.ms,
                            curve: Curves.easeOutCubic,
                          );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                  ),
                );
        },
      ),
    );
  }
}
