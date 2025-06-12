import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
import "package:file_picker/file_picker.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/models/recipe.dart";
import "package:the_recipes/services/export_service.dart";
import "package:the_recipes/services/import_service.dart";
import "package:the_recipes/services/sync_service.dart";
import "package:the_recipes/views/widgets/ui_helpers.dart";

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final RecipeController _recipeController = Get.find<RecipeController>();

  Future<void> handleAutoSyncToggle(bool enabled, BuildContext context) async {
    if (enabled) {
      await _authController.setAutoSyncEnabled(enabled);
      if (context.mounted) {
        UIHelpers.showLoadingDialog(
          context,
          "profile_page.syncing_recipes".tr,
          "profile_page.syncing_recipes_description".tr,
          lottieAsset: "assets/lottie/sync.json",
        );
      }

      try {
        await _assignOwnerIdToLocalRecipes();
        await SyncService.fullSync();
        _recipeController.refreshRecipes();
        Get.back();

        if (context.mounted) {
          UIHelpers.showSuccessSnackbar(
            "profile_page.sync_success_message".tr,
            context,
          );
        }
      } catch (e) {
        Get.back();
        await _authController.setAutoSyncEnabled(false);
        if (context.mounted) {
          UIHelpers.showErrorSnackbar(
            "profile_page.sync_error_message".trParams({"0": e.toString()}),
            context,
          );
        }
      }
    } else {
      await _handleSyncDisable(enabled, context);
    }
  }

  Future<void> _handleSyncDisable(bool enabled, BuildContext context) async {
    UIHelpers.showConfirmationDialog(
      context: context,
      title: "profile_page.disable_sync_confirmation_title".tr,
      message: "profile_page.disable_sync_confirmation_message".tr,
      lottieAsset: "assets/lottie/alert.json",
      confirmAction: () async {
        Get.back();
        await _authController.setAutoSyncEnabled(enabled);

        try {
          UIHelpers.showLoadingDialog(
            context,
            "profile_page.deleting_cloud_recipes_title".tr,
            "profile_page.deleting_cloud_recipes_description".tr,
          );

          await SyncService.deleteAllUserRecipesFromCloud();
          Get.back();

          UIHelpers.showSuccessSnackbar(
            "profile_page.auto_sync_disabled".tr,
            context,
          );
        } catch (e) {
          Get.back();
          await _authController.setAutoSyncEnabled(true);
          UIHelpers.showErrorSnackbar(
            "profile_page.delete_cloud_recipes_error"
                .trParams({"0": e.toString()}),
            context,
          );
        }
      },
    );
  }

  Future<void> _assignOwnerIdToLocalRecipes() async {
    if (!_authController.isLoggedIn) return;

    try {
      final box = Hive.box<Recipe>(recipesBox);

      for (int i = 0; i < box.length; i++) {
        final recipe = box.getAt(i);
        if (recipe != null &&
            (recipe.ownerId!.isEmpty ||
                recipe.ownerId != _authController.user!.uid)) {
          final updatedRecipe = Recipe(
            id: recipe.id,
            title: recipe.title,
            description: recipe.description,
            image: recipe.image,
            ingredients: recipe.ingredients,
            directions: recipe.directions,
            preparationTime: recipe.preparationTime,
            ownerId: _authController.user!.uid,
          );
          await box.putAt(i, updatedRecipe);
        }
      }
    } catch (e) {
      debugPrint("Error assigning ownerId to local recipes: $e");
    }
  }

  void handleExportRecipes(BuildContext context, {bool fromSettings = false}) {
    UIHelpers.showConfirmationDialog(
      context: context,
      title: "profile_page.export_confirmation_title".tr,
      message: "profile_page.export_confirmation_message".tr,
      lottieAsset: "assets/lottie/save_file.json",
      confirmAction: () async {
        if (!fromSettings) {
          Get.back();
        }
        final recipes = _recipeController.getAllRecipesForExport();
        await ExportService.exportRecipes(recipes, context);
      },
    );
  }

  void handleImportRecipes(BuildContext context, {bool fromSettings = false}) {
    UIHelpers.showConfirmationDialog(
      context: context,
      title: "profile_page.import_confirmation_title".tr,
      message: "profile_page.import_confirmation_message".tr,
      lottieAsset: "assets/lottie/load_file.json",
      confirmAction: () async {
        if (!fromSettings) {
          Get.back();
        }
        await _performImport(context);
      },
    );
  }

  Future<void> _performImport(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["zip"],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final importResult =
            await ImportService.importRecipes(filePath, context);

        if (context.mounted) {
          UIHelpers.showSuccessSnackbar(
            "profile_page.import_success_message".trParams({
              "0": importResult.importedCount.toString(),
              "1": importResult.skippedCount.toString(),
            }),
            context,
          );
        }

        _recipeController.refreshRecipes();

        if (_authController.isLoggedIn &&
            _authController.autoSyncEnabled &&
            importResult.importedCount > 0) {
          await _syncImportedRecipes(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        UIHelpers.showErrorSnackbar(
          "profile_page.import_error_message".trParams({"0": e.toString()}),
          context,
        );
      }
    }
  }

  Future<void> _syncImportedRecipes(BuildContext context) async {
    try {
      if (context.mounted) {
        UIHelpers.showLoadingDialog(
          context,
          "profile_page.syncing_recipes".tr,
          "profile_page.syncing_recipes_description".tr,
        );
      }
      await _assignOwnerIdToImportedRecipes();
      await SyncService.syncRecipesToCloud();
      Get.back();
    } catch (e) {
      if (context.mounted) {
        UIHelpers.showErrorSnackbar(
          "profile_page.sync_error_message".trParams({"0": e.toString()}),
          context,
        );
      }
    }
  }

  Future<void> _assignOwnerIdToImportedRecipes() async {
    if (!_authController.isLoggedIn) return;

    try {
      final box = Hive.box<Recipe>(recipesBox);

      for (int i = 0; i < box.length; i++) {
        final recipe = box.getAt(i);
        if (recipe != null && recipe.ownerId!.isEmpty) {
          final updatedRecipe = Recipe(
            id: recipe.id,
            title: recipe.title,
            description: recipe.description,
            image: recipe.image,
            ingredients: recipe.ingredients,
            directions: recipe.directions,
            preparationTime: recipe.preparationTime,
            ownerId: _authController.user!.uid,
          );
          await box.putAt(i, updatedRecipe);
        }
      }
    } catch (e) {
      debugPrint("Error assigning ownerId to imported recipes: $e");
    }
  }
}
