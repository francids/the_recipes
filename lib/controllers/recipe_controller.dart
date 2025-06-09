import "dart:io";

import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/models/recipe.dart";
import "package:the_recipes/services/sync_service.dart";
import "package:uuid/uuid.dart";

class RecipeController extends GetxController {
  final uuid = Uuid();
  final AuthController authController = Get.find<AuthController>();

  final RxList<Recipe> recipes = <Recipe>[].obs;
  bool _isLoading = false;

  @override
  void onInit() {
    super.onInit();
    getRecipes();
  }

  void refreshRecipes() async {
    if (!_isLoading) {
      getRecipes();
    }
  }

  void getRecipes() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      EasyLoading.show(status: "recipe_controller.loading_recipes".tr);

      final box = Hive.box<Recipe>(recipesBox);

      recipes.assignAll(box.values.toList());
    } catch (e) {
      EasyLoading.showError("recipe_controller.load_error".trParams({
        "0": e.toString(),
      }));
    } finally {
      _isLoading = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> addRecipe(
    String title,
    String description,
    String imagePath,
    List<String> ingredients,
    List<String> directions,
    int preparationTime, {
    String? ownerId,
    bool? isPublic,
  }) async {
    try {
      String id = uuid.v4();

      Recipe recipe = Recipe(
        id: id,
        title: title,
        description: description,
        image: imagePath,
        ingredients: ingredients,
        directions: directions,
        preparationTime: preparationTime,
        ownerId: ownerId ??
            (authController.isLoggedIn ? authController.user!.uid : null),
        isPublic: isPublic ?? false,
      );

      await Hive.box<Recipe>(recipesBox).put(id, recipe);

      recipes.add(recipe);

      if (authController.isLoggedIn && authController.autoSyncEnabled) {
        try {
          await SyncService.syncRecipesToCloud();
        } catch (e) {
          EasyLoading.showError("recipe_controller.sync_error".trParams({
            "0": e.toString(),
          }));
        }
      }
    } catch (e) {
      EasyLoading.showError("recipe_controller.add_error".trParams({
        "0": e.toString(),
      }));
    }
  }

  Future<void> deleteRecipe(String id, String image) async {
    EasyLoading.show(status: "recipe_controller.deleting_recipe".tr);

    try {
      var box = Hive.box<Recipe>(recipesBox);

      if (box.containsKey(id)) {
        await box.delete(id);
      } else {
        EasyLoading.showError("recipe_controller.recipe_not_found".tr);
        return;
      }

      if (image.isNotEmpty) {
        try {
          File imageFile = File(image);
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        } catch (e) {
          EasyLoading.showError(
              "recipe_controller.image_delete_error".trParams({
            "0": e.toString(),
          }));
        }
      }

      if (authController.isLoggedIn && authController.autoSyncEnabled) {
        try {
          await SyncService.deleteRecipeFromCloud(id);
        } catch (e) {
          EasyLoading.showError("recipe_controller.sync_error".trParams({
            "0": e.toString(),
          }));
        }
      }

      update();
      EasyLoading.showSuccess("recipe_controller.recipe_deleted".tr);
    } catch (e) {
      EasyLoading.showError("recipe_controller.delete_error".trParams({
        "0": e.toString(),
      }));
    }
  }

  List<Recipe> getAllRecipesForExport() {
    return Hive.box<Recipe>(recipesBox).values.toList();
  }
}
