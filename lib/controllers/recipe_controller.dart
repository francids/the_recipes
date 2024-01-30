import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:the_recipes/models/recipe.dart';

class RecipeController extends GetxController {
  var db = FirebaseFirestore.instance;

  List<Recipe> recipes = <Recipe>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRecipes();
  }

  Future<void> refreshRecipes() async {
    recipes.clear();
    await getRecipes();
  }

  Future<void> getRecipes() async {
    EasyLoading.show(status: 'Cargando recetas...');

    await db.collection("recipes").get().then((value) {
      for (var element in value.docs) {
        String docId = element.id;
        Map<String, dynamic> recipe = element.data();
        recipe['id'] = docId;
        recipes.add(Recipe.fromMap(recipe));
      }
      update();
    });

    EasyLoading.showSuccess('Recetas cargadas');
  }

  Future<void> deleteRecipe(String id) async {
    EasyLoading.show(status: 'Eliminando receta...');
    await db.collection("recipes").doc(id).delete();
    update();
    EasyLoading.showSuccess('Receta eliminada');
  }
}
