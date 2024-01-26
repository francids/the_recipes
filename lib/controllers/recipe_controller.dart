import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:the_recipes/models/recipe.dart';

class RecipeController extends GetxController {
  var db = FirebaseFirestore.instance;

  List<Recipe> recipes = [];

  Future<List<Recipe>> getRecipes() async {
    EasyLoading.show(status: 'Cargando recetas...');
    await Future.delayed(const Duration(milliseconds: 3500));
    await db.collection("recipes").get().then((value) {
      for (var element in value.docs) {
        recipes.add(
          Recipe.fromMap(
            element.data(),
          ),
        );
      }
      update();
    });
    return recipes;
  }
}
