import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/controllers/share_recipe_controller.dart";
import "package:the_recipes/models/recipe.dart";
import "package:the_recipes/views/widgets/common_recipe_view.dart";
import "package:the_recipes/views/widgets/ui_helpers.dart";

class SharedRecipeScreen extends StatelessWidget {
  const SharedRecipeScreen({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final RecipeController recipeController = Get.find<RecipeController>();
    final ShareRecipeController shareRecipeController =
        Get.find<ShareRecipeController>();

    final bool recipeExistsLocally =
        shareRecipeController.isRecipeAlreadySaved(recipe);

    return Scaffold(
      appBar: AppBar(
        title: Text("shared_recipe.title".tr),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        actions: [
          if (!recipeExistsLocally)
            IconButton(
              onPressed: () => _saveRecipeLocally(context, recipeController),
              icon: const Icon(CupertinoIcons.download_circle),
              tooltip: "shared_recipe.save_locally".tr,
            ),
          if (recipeExistsLocally)
            IconButton(
              onPressed: null,
              icon: const Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: Colors.green,
              ),
              tooltip: "shared_recipe.already_saved".tr,
            ),
        ],
      ),
      body: Column(
        children: [
          CommonRecipeView(
            recipe: recipe,
          ),
        ],
      ),
    );
  }

  Future<void> _saveRecipeLocally(
    BuildContext context,
    RecipeController recipeController,
  ) async {
    try {
      UIHelpers.showLoadingDialog(
        context,
        "shared_recipe.saving_title".tr,
        "shared_recipe.saving_message".tr,
        lottieAsset: "assets/lottie/save_file.json",
      );

      await recipeController.addSharedRecipe(recipe);

      Get.back();

      UIHelpers.showSuccessSnackbar(
        "shared_recipe.save_success".tr,
        context,
      );

      Get.back();
    } catch (e) {
      Get.back();
      UIHelpers.showErrorSnackbar(
        "shared_recipe.save_error".trParams({"0": e.toString()}),
        context,
      );
    }
  }
}
