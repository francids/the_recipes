import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/controllers/favorites_controller.dart";
import "package:the_recipes/controllers/view_option_controller.dart";
import "package:the_recipes/views/widgets/recipe_card.dart";

enum SortOption { none, title, duration }

enum ViewOption { list, grid }

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeController = Get.find<RecipeController>();
    final favoritesController = Get.find<FavoritesController>();
    final viewOptionController = Get.find<ViewOptionController>();
    final _currentSortOption = SortOption.none.obs;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Obx(() {
                if (recipeController.recipes.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _buildFilterChip(favoritesController, _currentSortOption,
                        viewOptionController)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: -0.2, curve: Curves.easeOutCubic);
              }),
              Obx(() {
                var displayedRecipes =
                    favoritesController.showFavoritesOnly.value
                        ? recipeController.recipes
                            .where((recipe) =>
                                favoritesController.isFavorite(recipe.id))
                            .toList()
                        : recipeController.recipes.toList();

                if (_currentSortOption.value == SortOption.title) {
                  displayedRecipes.sort((a, b) =>
                      a.title.toLowerCase().compareTo(b.title.toLowerCase()));
                } else if (_currentSortOption.value == SortOption.duration) {
                  displayedRecipes.sort(
                      (a, b) => a.preparationTime.compareTo(b.preparationTime));
                }

                return displayedRecipes.isEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              favoritesController.showFavoritesOnly.value
                                  ? "recipes_page.no_favorites".tr
                                  : "inicial_screen.empty_list".tr,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          recipeController.refreshRecipes();
                        },
                        child: Obx(() {
                          if (viewOptionController.currentViewOption ==
                              ViewOption.list) {
                            return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: MediaQuery.of(context).padding.bottom +
                                    16.0 +
                                    80.0,
                                left: 16,
                                right: 16,
                              ),
                              itemCount: displayedRecipes.length,
                              itemBuilder: (context, index) {
                                return RecipeCard(
                                  recipe: displayedRecipes[index],
                                  viewOption:
                                      viewOptionController.currentViewOption,
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
                            );
                          } else {
                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: MediaQuery.of(context).padding.bottom +
                                    16.0 +
                                    80.0,
                                left: 16,
                                right: 16,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.0,
                              ),
                              itemCount: displayedRecipes.length,
                              itemBuilder: (context, index) {
                                return RecipeCard(
                                  recipe: displayedRecipes[index],
                                  viewOption:
                                      viewOptionController.currentViewOption,
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
                            );
                          }
                        }),
                      );
              }),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(0),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(18),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(36),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(54),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(72),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(108),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(144),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(180),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(196),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  stops: const [
                    0.0,
                    0.05,
                    0.1,
                    0.15,
                    0.2,
                    0.25,
                    0.3,
                    0.35,
                    0.4,
                    1.0
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(0),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(18),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(36),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(54),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(72),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(90),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(108),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(126),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(144),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(162),
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(180),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  stops: const [
                    0.0,
                    0.1,
                    0.2,
                    0.3,
                    0.4,
                    0.5,
                    0.6,
                    0.7,
                    0.8,
                    0.9,
                    0.95,
                    1.0
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    FavoritesController favoritesController,
    Rx<SortOption> currentSortOption,
    ViewOptionController viewOptionController,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
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
            Obx(() {
              return FilterChip(
                showCheckmark: false,
                label: Text(
                    viewOptionController.currentViewOption == ViewOption.list
                        ? "recipes_page.view_list".tr
                        : "recipes_page.view_grid".tr),
                selected: true,
                onSelected: (selected) {
                  viewOptionController.toggleViewOption();
                },
                avatar: Icon(
                  viewOptionController.currentViewOption == ViewOption.list
                      ? CupertinoIcons.list_bullet
                      : CupertinoIcons.square_grid_2x2_fill,
                  size: 18,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
