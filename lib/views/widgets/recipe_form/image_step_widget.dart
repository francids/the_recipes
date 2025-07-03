import "dart:io";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "package:the_recipes/controllers/add_recipe_controller.dart";
import "package:the_recipes/controllers/ai_recipe_controller.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/views/widgets/pressable_button.dart";
import "package:the_recipes/views/widgets/ui_helpers.dart";
import "package:flutter_animate/flutter_animate.dart";

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
    UIHelpers.showLoadingDialog(
      context,
      "image_step.analyzing_image_title".tr,
      "image_step.analyzing_image_message".tr,
    );

    try {
      final aiController = Get.put(AIRecipeController());
      final recipe =
          await aiController.generateRecipeFromImage(controller.fullPath.value);

      controller.title.value = recipe.title;
      controller.description.value = recipe.description;
      controller.ingredientsList.value = recipe.ingredients;
      controller.directionsList.value = recipe.directions;
      controller.preparationTime.value = recipe.preparationTime;

      Get.back();
      UIHelpers.showSuccessSnackbar(
        "image_step.recipe_generated_success".tr,
        context,
      );
    } on AIRecipeException catch (e) {
      Get.back();
      UIHelpers.showErrorSnackbar(
        e.message,
        context,
      );
    } catch (e) {
      Get.back();
      UIHelpers.showErrorSnackbar(
        "image_step.recipe_generated_error".trParams({
          "0": e.toString(),
        }),
        context,
      );
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
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .scaleXY(begin: 0.8, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "image_step.tap_to_select".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 24),
          Obx(() => _buildAISection(context, authController, isDarkMode))
              .animate()
              .fadeIn(delay: 400.ms, duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _pickImage,
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
                  CupertinoIcons.photo_on_rectangle,
                  color: Colors.deepOrange,
                  size: 40,
                )
              : null,
        ),
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
        child: PressableButton(
          child: FilledButton.icon(
            onPressed: () => _generateRecipeFromImage(context),
            icon: const Icon(Icons.auto_awesome, color: Colors.white),
            label: Text(
              "image_step.generate_recipe_info".tr,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        "image_step.feature_not_available".tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }
}
