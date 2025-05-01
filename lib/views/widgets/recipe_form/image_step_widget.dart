import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_recipes/controllers/add_recipe_controller.dart';
import 'package:the_recipes/controllers/ai_recipe_controller.dart';
import 'package:the_recipes/controllers/auth_controller.dart';
import 'package:the_recipes/views/widgets/ui_helpers.dart';

class ImageStepWidget extends StatelessWidget {
  final AddRecipeController controller;
  final ImagePicker _imagePicker = ImagePicker();

  ImageStepWidget({Key? key, required this.controller}) : super(key: key);

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.setImagePath(image);
    }
  }

  void _generateRecipeFromImage(BuildContext context) async {
    UIHelpers.showLoadingDialog(context, "Analizando imagen",
        "Por favor espera mientras procesamos la imagen");

    try {
      final aiController = Get.put(AIRecipeController());
      final recipe =
          await aiController.generateRecipeFromImage(controller.fullPath.value);

      controller.title.value = recipe.title;
      controller.description.value = recipe.description;
      controller.ingredientsList.value = recipe.ingredients;
      controller.directionsList.value = recipe.directions;

      Get.back();
      UIHelpers.showSuccessSnackbar("Se ha generado información de la receta");
    } catch (e) {
      Get.back();
      UIHelpers.showErrorSnackbar(
          "No se pudo generar la receta: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authController = Get.find<AuthController>();

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Obx(() => _buildImageContainer()),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Toca la imagen para seleccionar una foto de la receta",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Obx(() => _buildAISection(context, authController, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.circular(10),
          image: controller.fullPath.value.isNotEmpty
              ? DecorationImage(
                  image: FileImage(File(controller.fullPath.value)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: controller.fullPath.value.isEmpty
            ? const Icon(
                Icons.add_a_photo,
                color: Colors.deepOrange,
                size: 40,
              )
            : null,
      ),
    );
  }

  Widget _buildAISection(
      BuildContext context, AuthController authController, bool isDarkMode) {
    if (controller.fullPath.value.isEmpty) {
      return const SizedBox();
    }

    if (authController.isLoggedIn) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: FilledButton.icon(
          onPressed: () => _generateRecipeFromImage(context),
          icon: const Icon(Icons.auto_awesome, color: Colors.white),
          label: const Text(
            "Generar información de la receta",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        "La función de generar recetas automáticamente a partir de imágenes no está disponible actualmente. Esta característica estará disponible en futuras versiones.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }
}
