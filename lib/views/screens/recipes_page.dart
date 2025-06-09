import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/controllers/favorites_controller.dart";
import "package:the_recipes/views/widgets/recipe_card.dart";
import "package:the_recipes/views/screens/add_recipe_screen.dart";

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeController = Get.find<RecipeController>();
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      floatingActionButton: Tooltip(
        message: "inicial_screen.fab_tooltip_add".tr,
        preferBelow: false,
        child: FloatingActionButton(
          onPressed: () async {
            await Get.to(const AddRecipeScreen());
          },
          child: const Icon(CupertinoIcons.add),
        ).animate().scale(
              delay: 150.ms,
              duration: 300.ms,
              curve: Curves.easeOutBack,
            ),
      ),
      body: Column(
        children: [
          if (recipeController.recipes.isNotEmpty)
            Obx(() => _buildFilterChip(favoritesController))
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.2, curve: Curves.easeOutCubic),
          Expanded(
            child: Obx(() {
              final filteredRecipes = favoritesController
                      .showFavoritesOnly.value
                  ? recipeController.recipes
                      .where(
                          (recipe) => favoritesController.isFavorite(recipe.id))
                      .toList()
                  : recipeController.recipes;

              return filteredRecipes.isEmpty
                  ? Center(
                      child: Text(
                        favoritesController.showFavoritesOnly.value
                            ? "recipes_page.no_favorites".tr
                            : "inicial_screen.empty_list".tr,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        recipeController.refreshRecipes();
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                          top: 8,
                          bottom: MediaQuery.of(context).padding.bottom + 16.0,
                          left: 16,
                          right: 16,
                        ),
                        itemCount: filteredRecipes.length,
                        itemBuilder: (context, index) {
                          return RecipeCard(
                            recipe: filteredRecipes[index],
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
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(FavoritesController favoritesController) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        children: [
          FilterChip(
            showCheckmark: false,
            label: Text("recipes_page.favorites_filter".tr),
            selected: favoritesController.showFavoritesOnly.value,
            onSelected: (selected) => favoritesController.setFilter(selected),
            avatar: Icon(
              favoritesController.showFavoritesOnly.value
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
