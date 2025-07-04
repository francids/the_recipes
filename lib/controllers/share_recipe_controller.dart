import "package:appwrite/appwrite.dart";
import "package:flutter/foundation.dart";
import "package:get/get.dart";
import "package:the_recipes/appwrite_config.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/controllers/recipe_controller.dart";

class ShareRecipeController extends GetxController {
  final databases = AppwriteConfig.databases;
  final authController = Get.find<AuthController>();
  final recipeController = Get.find<RecipeController>();

  bool isPublic(String recipeId) {
    final recipe =
        recipeController.recipes.firstWhereOrNull((r) => r.id == recipeId);
    return recipe?.isPublic ?? false;
  }

  final String shareUrlTemplate = "https://recipes.francids.com/sharing?id=";

  String generateShareUrl(String recipeId) {
    return "$shareUrlTemplate$recipeId";
  }

  Future<void> makeRecipePublic(String recipeId) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.recipesCollectionId,
        documentId: recipeId,
        data: {
          "isPublic": true,
        },
        permissions: [
          Permission.read(Role.any()),
          Permission.update(Role.user(authController.user!.$id)),
          Permission.delete(Role.user(authController.user!.$id)),
        ],
      );
      recipeController.updateLocalRecipe(recipeId, isPublic: true);
      recipeController.refreshRecipes();
    } catch (e) {
      debugPrint("Error making recipe public: $e");
    }
  }

  Future<void> makeRecipePrivate(String recipeId) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.recipesCollectionId,
        documentId: recipeId,
        data: {
          "isPublic": false,
        },
        permissions: [
          Permission.read(Role.user(authController.user!.$id)),
          Permission.update(Role.user(authController.user!.$id)),
          Permission.delete(Role.user(authController.user!.$id)),
        ],
      );
      recipeController.updateLocalRecipe(recipeId, isPublic: false);
      recipeController.refreshRecipes();
    } catch (e) {
      debugPrint("Error making recipe private: $e");
    }
  }
}
