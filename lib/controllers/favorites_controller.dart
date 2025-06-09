import "package:get/get.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
import "package:the_recipes/hive_boxes.dart";

class FavoritesController extends GetxController {
  final RxList<String> favoriteRecipeIds = <String>[].obs;
  final RxBool showFavoritesOnly = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void _loadFavorites() {
    final box = Hive.box<String>(favoritesBox);
    favoriteRecipeIds.assignAll(box.values.toList());
  }

  Future<void> toggleFavorite(String recipeId) async {
    final box = Hive.box<String>(favoritesBox);

    if (favoriteRecipeIds.contains(recipeId)) {
      await box.delete(recipeId);
      favoriteRecipeIds.remove(recipeId);
    } else {
      await box.put(recipeId, recipeId);
      favoriteRecipeIds.add(recipeId);
    }
  }

  bool isFavorite(String recipeId) {
    return favoriteRecipeIds.contains(recipeId);
  }

  void toggleFilter() {
    showFavoritesOnly.value = !showFavoritesOnly.value;
  }

  void setFilter(bool showFavoritesOnly) {
    this.showFavoritesOnly.value = showFavoritesOnly;
  }
}
