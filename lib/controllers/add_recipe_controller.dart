import "dart:io";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "package:path_provider/path_provider.dart";
import "package:path/path.dart" as path;
import "package:the_recipes/controllers/recipe_controller.dart";

class AddRecipeController extends GetxController {
  final RecipeController recipeController = RecipeController();

  final RxString title = "".obs;
  final RxString description = "".obs;
  final RxList<String> ingredientsList = <String>[].obs;
  final RxList<String> directionsList = <String>[].obs;
  final RxString fullPath = "".obs;
  final RxInt preparationTime = 0.obs; // in seconds

  final RxBool isRecipeGenerated = false.obs;
  final RxString generationError = ''.obs;

  String? fileName;
  File? image;

  void setImagePath(XFile file) {
    fileName = DateTime.now().toString().replaceAll(" ", "") + file.name;
    fullPath.value = file.path;
    image = File(file.path);
  }

  Future<void> saveImageLocally() async {
    if (image == null) return;
    EasyLoading.show(status: "add_recipe_controller.saving_image".tr);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String imagesPath = path.join(appDocDir.path, "recipe-images");
    Directory imagesDir = Directory(imagesPath);
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    String finalImagePath = path.join(imagesPath, fileName!);
    await image!.copy(finalImagePath);
    fullPath.value = finalImagePath;
    EasyLoading.showSuccess("add_recipe_controller.image_saved".tr);
  }

  Future<void> addRecipe() async {
    EasyLoading.show(status: "add_recipe_controller.adding_recipe".tr);
    await saveImageLocally();

    await recipeController.addRecipe(
      title.value,
      description.value,
      fullPath.value,
      List<String>.from(ingredientsList),
      List<String>.from(directionsList),
      preparationTime.value, // already in seconds
    );

    EasyLoading.showSuccess("add_recipe_controller.recipe_added".tr);
  }
}
