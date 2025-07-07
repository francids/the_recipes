import "dart:io";

import "package:flutter/material.dart";
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
    int preparationTime,
  ) async {
    try {
      var box = Hive.box<Recipe>(recipesBox);
      String id = const Uuid().v4();

      Recipe recipe = Recipe(
        id: id,
        title: title,
        description: description,
        image: imagePath,
        ingredients: ingredients,
        directions: directions,
        preparationTime: preparationTime,
        ownerId: authController.isLoggedIn ? authController.user!.$id : "",
        isPublic: false,
        cloudId: null,
      );

      await box.put(id, recipe);
      update();

      if (authController.isLoggedIn && authController.autoSyncEnabled) {
        try {
          await SyncService.syncRecipesToCloud();
          update();
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

  Future<void> updateLocalRecipe(
    String id, {
    String? title,
    String? description,
    String? imagePath,
    List<String>? ingredients,
    List<String>? directions,
    int? preparationTime,
    bool? isPublic,
  }) async {
    try {
      var box = Hive.box<Recipe>(recipesBox);

      if (box.containsKey(id)) {
        Recipe recipe = box.get(id)!;

        recipe.title = title ?? recipe.title;
        recipe.description = description ?? recipe.description;
        recipe.image = imagePath ?? recipe.image;
        recipe.ingredients = ingredients ?? recipe.ingredients;
        recipe.directions = directions ?? recipe.directions;
        recipe.preparationTime = preparationTime ?? recipe.preparationTime;
        recipe.isPublic = isPublic ?? recipe.isPublic;

        await box.put(id, recipe);
      } else {
        EasyLoading.showError("recipe_controller.recipe_not_found".tr);
        return;
      }

      update();
    } catch (e) {
      EasyLoading.showError("recipe_controller.update_error".trParams({
        "0": e.toString(),
      }));
    }
  }

  Future<void> deleteRecipe(String id, String image) async {
    try {
      var box = Hive.box<Recipe>(recipesBox);

      if (box.containsKey(id)) {
        final recipe = box.get(id)!;

        if (authController.isLoggedIn &&
            recipe.cloudId != null &&
            recipe.cloudId!.isNotEmpty) {
          try {
            await SyncService.deleteRecipeFromCloud(id);
          } catch (e) {
            debugPrint("Error deleting recipe from cloud: $e");
          }
        }

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

      update();
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
