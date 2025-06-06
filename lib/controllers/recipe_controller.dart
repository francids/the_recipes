import "dart:io";

import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/models/recipe.dart";
import "package:uuid/uuid.dart";

class RecipeController extends GetxController {
  final uuid = Uuid();

  List<Recipe> recipes = <Recipe>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRecipes();
  }

  void refreshRecipes() async {
    recipes.clear();
    getRecipes();
  }

  void getRecipes() async {
    EasyLoading.show(status: "recipe_controller.loading_recipes".tr);
    recipes.clear();
    recipes.addAll(Hive.box<Recipe>(recipesBox).values);
    EasyLoading.dismiss();
  }

  Future<void> addRecipe(
    String title,
    String description,
    String imagePath,
    List<String> ingredients,
    List<String> directions,
    int preparationTime,
  ) async {
    String id = uuid.v4();

    Recipe recipe = Recipe(
      id: id,
      title: title,
      description: description,
      image: imagePath,
      ingredients: ingredients,
      directions: directions,
      preparationTime: preparationTime,
    );

    await Hive.box<Recipe>(recipesBox).put(id, recipe);
    update();
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
          print("Error deleting image: $e");
        }
      }

      update();
      EasyLoading.showSuccess("recipe_controller.recipe_deleted".tr);
    } catch (e) {
      print("Error eliminando receta: $e");
      EasyLoading.showError("recipe_controller.delete_error".tr);
    }
  }

  List<Recipe> getAllRecipesForExport() {
    return Hive.box<Recipe>(recipesBox).values.toList();
  }
}
