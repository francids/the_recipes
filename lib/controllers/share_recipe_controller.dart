import "package:appwrite/appwrite.dart";
import "package:flutter/foundation.dart";
import "package:get/get.dart";
import "package:the_recipes/appwrite_config.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/models/recipe.dart";

class ShareRecipeController extends GetxController {
  final databases = AppwriteConfig.databases;
  final storage = AppwriteConfig.storage;
  final authController = Get.find<AuthController>();
  final recipeController = Get.find<RecipeController>();

  final RxMap<String, bool> _isLoading = <String, bool>{}.obs;

  bool isPublic(String recipeId) {
    final recipe =
        recipeController.recipes.firstWhereOrNull((r) => r.id == recipeId);
    return recipe?.isPublic ?? false;
  }

  bool isLoading(String recipeId) {
    return _isLoading[recipeId] ?? false;
  }

  final String shareUrlTemplate = "https://recipes.francids.com/sharing?id=";

  Future<void> makeRecipePublic(String recipeId) async {
    _isLoading[recipeId] = true;
    try {
      final recipe =
          recipeController.recipes.firstWhereOrNull((r) => r.id == recipeId);
      if (recipe == null || recipe.cloudId == null) {
        debugPrint("Recipe not found or has no cloudId: $recipeId");
        return;
      }

      final cloudId = recipe.cloudId!;

      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.recipesCollectionId,
        documentId: cloudId,
        data: {
          "isPublic": true,
        },
        permissions: [
          Permission.read(Role.any()),
          Permission.update(Role.user(authController.user!.$id)),
          Permission.delete(Role.user(authController.user!.$id)),
        ],
      );
      await storage.updateFile(
        bucketId: AppwriteConfig.bucketId,
        fileId: cloudId,
        permissions: [
          Permission.read(Role.any()),
          Permission.update(Role.user(authController.user!.$id)),
          Permission.delete(Role.user(authController.user!.$id)),
        ],
      );
      recipeController.updateLocalRecipe(recipeId, isPublic: true);
    } catch (e) {
      debugPrint("Error making recipe public: $e");
    } finally {
      _isLoading[recipeId] = false;
    }
  }

  Future<void> makeRecipePrivate(String recipeId) async {
    _isLoading[recipeId] = true;
    try {
      final recipe =
          recipeController.recipes.firstWhereOrNull((r) => r.id == recipeId);
      if (recipe == null || recipe.cloudId == null) {
        debugPrint("Recipe not found or has no cloudId: $recipeId");
        return;
      }

      final cloudId = recipe.cloudId!;

      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.recipesCollectionId,
        documentId: cloudId,
        data: {
          "isPublic": false,
        },
        permissions: [
          Permission.read(Role.user(authController.user!.$id)),
          Permission.update(Role.user(authController.user!.$id)),
          Permission.delete(Role.user(authController.user!.$id)),
        ],
      );
      await storage.updateFile(
        bucketId: AppwriteConfig.bucketId,
        fileId: cloudId,
        permissions: [
          Permission.read(Role.user(authController.user!.$id)),
          Permission.update(Role.user(authController.user!.$id)),
          Permission.delete(Role.user(authController.user!.$id)),
        ],
      );
      recipeController.updateLocalRecipe(recipeId, isPublic: false);
    } catch (e) {
      debugPrint("Error making recipe private: $e");
    } finally {
      _isLoading[recipeId] = false;
    }
  }

  String generateShareUrl(String recipeId) {
    if (!authController.isLoggedIn) return "";

    final recipe =
        recipeController.recipes.firstWhereOrNull((r) => r.id == recipeId);
    if (recipe == null || recipe.cloudId == null) {
      debugPrint("Recipe not found or has no cloudId: $recipeId");
      return "";
    }

    return "$shareUrlTemplate${recipe.cloudId}";
  }

  Future<Recipe> getSharedRecipe(String cloudId) async {
    try {
      final document = await databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.recipesCollectionId,
        documentId: cloudId,
      );

      final recipeData = document.data;
      recipeData["image"] =
          "${AppwriteConfig.endpoint}/storage/buckets/${AppwriteConfig.bucketId}/files/$cloudId/view?project=${AppwriteConfig.projectId}";
      recipeData["cloudId"] = cloudId;

      return Recipe.fromMap(recipeData);
    } catch (e) {
      debugPrint("Error fetching shared recipe: $e");
      rethrow;
    }
  }

  String? getCloudId(String recipeId) {
    final recipe =
        recipeController.recipes.firstWhereOrNull((r) => r.id == recipeId);
    return recipe?.cloudId;
  }

  bool canShare(String recipeId) {
    return getCloudId(recipeId) != null;
  }

  Recipe? findLocalRecipeByCloudId(String cloudId) {
    return recipeController.recipes.firstWhereOrNull(
      (recipe) => recipe.cloudId == cloudId,
    );
  }

  Recipe? findLocalRecipeByTitle(String title) {
    var exactMatch = recipeController.recipes.firstWhereOrNull(
      (recipe) => recipe.title.toLowerCase() == title.toLowerCase(),
    );

    if (exactMatch != null) return exactMatch;

    return recipeController.recipes.firstWhereOrNull(
      (recipe) =>
          recipe.title.toLowerCase().contains(title.toLowerCase()) ||
          title.toLowerCase().contains(recipe.title.toLowerCase()),
    );
  }

  bool isRecipeAlreadySaved(Recipe sharedRecipe) {
    if (sharedRecipe.cloudId != null) {
      final byCloudId = findLocalRecipeByCloudId(sharedRecipe.cloudId!);
      if (byCloudId != null) return true;
    }

    final byTitle = findLocalRecipeByTitle(sharedRecipe.title);
    if (byTitle != null) {
      final sameIngredients = byTitle.ingredients.length ==
              sharedRecipe.ingredients.length &&
          byTitle.ingredients.every(
            (ingredient) => sharedRecipe.ingredients.any(
              (sharedIngredient) =>
                  ingredient.toLowerCase() == sharedIngredient.toLowerCase(),
            ),
          );

      if (sameIngredients) return true;
    }

    return false;
  }
}
