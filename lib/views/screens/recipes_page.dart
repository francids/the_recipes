import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/controllers/favorites_controller.dart";
import "package:the_recipes/views/widgets/recipe_card.dart";
import "package:the_recipes/views/screens/add_recipe_screen.dart";

enum SortOption { none, title, duration }

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeController = Get.find<RecipeController>();
    final favoritesController = Get.find<FavoritesController>();
    final currentSortOption = SortOption.none.obs;

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
          Obx(() {
            if (recipeController.recipes.isEmpty) {
              return const SizedBox.shrink();
            }
            return _buildFilterChip(favoritesController, currentSortOption)
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.2, curve: Curves.easeOutCubic);
          }),
          Expanded(
            child: Obx(() {
              var displayedRecipes = favoritesController.showFavoritesOnly.value
                  ? recipeController.recipes
                      .where(
                          (recipe) => favoritesController.isFavorite(recipe.id))
                      .toList()
                  : recipeController.recipes.toList();

              if (currentSortOption.value == SortOption.title) {
                displayedRecipes.sort((a, b) =>
                    a.title.toLowerCase().compareTo(b.title.toLowerCase()));
              } else if (currentSortOption.value == SortOption.duration) {
                displayedRecipes.sort(
                    (a, b) => a.preparationTime.compareTo(b.preparationTime));
              }

              return displayedRecipes.isEmpty
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
                        itemCount: displayedRecipes.length,
                        itemBuilder: (context, index) {
                          return RecipeCard(
                            recipe: displayedRecipes[index],
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

  Widget _buildFilterChip(
    FavoritesController favoritesController,
    Rx<SortOption> currentSortOption,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 60,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 16.0,
          right: 16.0,
        ),
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
          const SizedBox(width: 8),
          Obx(() {
            String sortLabel;
            IconData sortIcon;
            switch (currentSortOption.value) {
              case SortOption.title:
                sortLabel = "recipes_page.sort_title".tr;
                sortIcon = CupertinoIcons.sort_up;
                break;
              case SortOption.duration:
                sortLabel = "recipes_page.sort_duration".tr;
                sortIcon = CupertinoIcons.clock;
                break;
              case SortOption.none:
                sortLabel = "recipes_page.sort_by_label".tr;
                sortIcon = CupertinoIcons.sort_down;
                break;
            }
            return FilterChip(
              showCheckmark: false,
              selected: currentSortOption.value != SortOption.none,
              avatar: Icon(sortIcon, size: 18),
              label: Text(sortLabel),
              onSelected: (_) {
                if (currentSortOption.value == SortOption.none) {
                  currentSortOption.value = SortOption.title;
                } else if (currentSortOption.value == SortOption.title) {
                  currentSortOption.value = SortOption.duration;
                } else if (currentSortOption.value == SortOption.duration) {
                  currentSortOption.value = SortOption.none;
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
