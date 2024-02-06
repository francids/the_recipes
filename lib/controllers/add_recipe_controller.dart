import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_recipes/controllers/recipe_controller.dart';

class AddRecipeController extends GetxController {
  final storage = FirebaseStorage.instance;
  RecipeController recipeController = RecipeController();

  Future<void> refreshRecipes() async {
    await recipeController.refreshRecipes();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController directionsController = TextEditingController();
  String? fileName;
  var fullPath = "".obs;
  File? image;

  void setImagePath(XFile file) {
    fileName = DateTime.now().toString().removeAllWhitespace + file.name;
    fullPath.value = file.path;
    image = File(file.path);
    update();
  }

  Future<void> uploadImage() async {
    EasyLoading.show(status: 'Subiendo imagen...');
    await storage.ref('recipe-images/$fileName').putFile(image!);
    EasyLoading.showSuccess('Imagen subida');
  }

  Future<String> getImageUrl() async {
    return await storage.ref('recipe-images/$fileName').getDownloadURL();
  }

  Future<void> addRecipe() async {
    EasyLoading.show(status: 'Agregando receta...');
    await uploadImage();
    String image = await getImageUrl();
    await recipeController.addRecipe(
      titleController.text,
      descriptionController.text,
      image,
      ingredientsController.text.split('\n'),
      directionsController.text.split('\n'),
    );
    EasyLoading.showSuccess('Receta agregada');
  }
}
