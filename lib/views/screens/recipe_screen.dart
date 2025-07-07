import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/controllers/favorites_controller.dart";
import "package:the_recipes/models/recipe.dart";
import "package:the_recipes/views/widgets/common_recipe_view.dart";
import "package:the_recipes/views/widgets/share_recipe_bottom_sheet.dart";
import "package:the_recipes/views/widgets/ui_helpers.dart";
import "package:the_recipes/controllers/share_recipe_controller.dart";

class RecipeScreen extends StatelessWidget {
  RecipeScreen({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;
  final RecipeController recipeController = Get.find();
  final FavoritesController favoritesController = Get.find();
  final ShareRecipeController shareRecipeController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("recipe_screen.title".tr),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () => favoritesController.toggleFavorite(recipe.id),
              icon: Icon(
                favoritesController.isFavorite(recipe.id)
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                color: favoritesController.isFavorite(recipe.id)
                    ? Colors.red
                    : null,
              ),
            ),
          ),
          if (authController.isLoggedIn && authController.autoSyncEnabled)
            Obx(
              () => IconButton(
                icon: Icon(
                  shareRecipeController.isPublic(recipe.id)
                      ? CupertinoIcons.globe
                      : CupertinoIcons.share,
                ),
                onPressed: () =>
                    ShareRecipeBottomSheet.show(context, recipe.id),
              ),
            ),
          IconButton(
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            tooltip: "inicial_screen.menu_tooltip".tr,
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(CupertinoIcons.delete),
                      title: Text("recipe_screen.menu_item_delete".tr),
                      horizontalTitleGap: 8,
                    ),
                    onTap: () {
                      UIHelpers.showConfirmationDialog(
                        context: context,
                        title: "recipe_screen.delete_confirmation_title".tr,
                        message: "recipe_screen.delete_confirmation_message".tr,
                        lottieAsset: "assets/lottie/delete.json",
                        confirmAction: () async {
                          Get.back();
                          UIHelpers.showLoadingDialog(
                            context,
                            "recipe_screen.deleting_recipe".tr,
                            "recipe_screen.deleting_recipe_message".tr,
                          );
                          await recipeController.deleteRecipe(
                            recipe.id,
                            recipe.image,
                          );
                          Get.back();
                          recipeController.refreshRecipes();
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CommonRecipeView(recipe: recipe),
        ],
      ),
    );
  }
}
