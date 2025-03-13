import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:the_recipes/hive_boxes.dart';
import 'package:the_recipes/models/recipe.dart';
import 'package:uuid/uuid.dart';

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
    EasyLoading.show(status: "Cargando recetas...");
    recipes.clear();
    recipes.addAll(Hive.box<Recipe>(recipesBox).values);
    EasyLoading.dismiss();
    await Future.delayed(const Duration(milliseconds: 300));
    EasyLoading.showSuccess("Recetas cargadas");
  }

  Future<void> addRecipe(
    String title,
    String description,
    String image,
    List<String> ingredients,
    List<String> directions,
  ) async {
    EasyLoading.show(status: 'Agregando receta...');

    String id = uuid.v4();

    Recipe recipe = Recipe(
      id: id,
      title: title,
      description: description,
      image: image,
      ingredients: ingredients,
      directions: directions,
    );

    await Hive.box<Recipe>(recipesBox).put(id, recipe);

    update();
    EasyLoading.showSuccess('Receta agregada');
  }

  Future<void> deleteRecipe(String id, String image) async {
    EasyLoading.show(status: 'Eliminando receta...');

    try {
      var box = Hive.box<Recipe>(recipesBox);

      if (box.containsKey(id)) {
        await box.delete(id);
        print("Receta con ID $id eliminada correctamente");
      } else {
        print("Error: No se encontró la receta con ID $id");
        EasyLoading.showError('La receta no existe');
        return;
      }

      if (image.isNotEmpty) {
        try {
          File imageFile = File(image);
          if (await imageFile.exists()) {
            await imageFile.delete();
            print("Imagen eliminada correctamente: $image");
          }
        } catch (e) {
          print("Error eliminando imagen: $e");
        }
      }

      update();
      EasyLoading.showSuccess('Receta eliminada');
    } catch (e) {
      print("Error eliminando receta: $e");
      EasyLoading.showError('Error al eliminar la receta');
    }
  }
}
