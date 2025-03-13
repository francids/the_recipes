import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_recipes/controllers/recipe_controller.dart';
import 'package:path/path.dart' as path;

class AddRecipeController extends GetxController {
  RecipeController recipeController = RecipeController();

  void refreshRecipes() {
    recipeController.refreshRecipes();
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

  Future<void> saveImageLocally() async {
    if (image == null) return;
    EasyLoading.show(status: 'Guardando imagen...');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String imagesPath = path.join(appDocDir.path, 'recipe-images');
    Directory imagesDir = Directory(imagesPath);
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    String finalImagePath = path.join(imagesPath, fileName!);
    await image!.copy(finalImagePath);
    fullPath.value = finalImagePath;
    EasyLoading.showSuccess('Imagen guardada');
  }

  Future<String> getImagePath() async {
    return fullPath.value;
  }

  Future<void> addRecipe() async {
    EasyLoading.show(status: 'Agregando receta...');
    await saveImageLocally();
    String imagePath = await getImagePath();
    await recipeController.addRecipe(
      titleController.text,
      descriptionController.text,
      imagePath,
      ingredientsController.text.split('\n'),
      directionsController.text.split('\n'),
    );
    EasyLoading.showSuccess('Receta agregada');
  }
}
