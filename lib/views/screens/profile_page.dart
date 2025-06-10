import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
import "package:lottie/lottie.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/models/recipe.dart";
import "package:the_recipes/services/export_service.dart";
import "package:the_recipes/services/import_service.dart";
import "package:the_recipes/services/sync_service.dart";
import "package:the_recipes/views/screens/profile_info_screen.dart";
import "package:the_recipes/views/widgets/ui_helpers.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:file_picker/file_picker.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(
        builder: (controller) {
          if (!controller.isLoggedIn) {
            return _buildSignInPrompt(context);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                _buildProfileHeader(context, controller)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: -0.2, curve: Curves.easeOutCubic),
                const SizedBox(height: 32),
                Text(
                  "profile_page.data_section".tr,
                  style: Theme.of(context).textTheme.displayMedium,
                )
                    .animate()
                    .fadeIn(delay: 150.ms, duration: 250.ms)
                    .slideX(begin: -0.15, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
                _buildDataCard(context)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 250.ms)
                    .slideX(begin: -0.15, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
                const Divider(
                  indent: 16,
                  endIndent: 16,
                )
                    .animate()
                    .fadeIn(delay: 250.ms, duration: 200.ms)
                    .slideX(begin: -0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
                _buildSignOutCard(context, controller)
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 250.ms)
                    .slideX(begin: -0.15, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final authController = Get.find<AuthController>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/lottie/profile.json",
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              "profile_page.sign_in_required".tr,
              style: textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "profile_page.sign_in_description".tr,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => authController.signInWithGoogle(),
              icon: const Icon(CupertinoIcons.person_add),
              label: Text("profile_page.sign_in_with_google".tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthController controller) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final user = controller.user;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.to(() => ProfileInfoScreen()),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: theme.colorScheme.primary.withAlpha(25),
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? Icon(
                        CupertinoIcons.person,
                        size: 32,
                        color: theme.colorScheme.primary,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? "profile_page.unknown_user".tr,
                      style: textTheme.displayMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? "",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCard(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          GetBuilder<AuthController>(
            builder: (authController) => SwitchListTile(
              title: Text(
                "profile_page.backup_recipes".tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                "profile_page.backup_recipes_description".tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              value: authController.autoSyncEnabled,
              onChanged: (value) => _handleAutoSyncToggle(value, context),
              secondary: Icon(
                CupertinoIcons.cloud_upload,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: Text(
              "profile_page.export_recipes".tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              "profile_page.export_recipes_description".tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            leading: Icon(
              CupertinoIcons.share,
              color: Theme.of(context).colorScheme.primary,
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: Theme.of(context).colorScheme.outline,
            ),
            onTap: () => _handleExportRecipes(context),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: Text(
              "profile_page.import_recipes".tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              "profile_page.import_recipes_description".tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            leading: Icon(
              CupertinoIcons.tray_arrow_down,
              color: Theme.of(context).colorScheme.primary,
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: Theme.of(context).colorScheme.outline,
            ),
            onTap: () => _handleImportRecipes(context),
          ),
        ],
      ),
    );
  }

  void _handleAutoSyncToggle(bool enabled, BuildContext context) async {
    final authController = Get.find<AuthController>();

    if (enabled) {
      await authController.setAutoSyncEnabled(enabled);
      UIHelpers.showLoadingDialog(
        context,
        "profile_page.syncing_recipes".tr,
        "profile_page.syncing_recipes_description".tr,
        lottieAsset: "assets/lottie/sync.json",
      );

      try {
        await _assignOwnerIdToLocalRecipes();
        await SyncService.fullSync();

        final recipeController = Get.find<RecipeController>();
        recipeController.refreshRecipes();

        Get.back();

        UIHelpers.showSuccessSnackbar(
          "profile_page.sync_success_message".tr,
          context,
        );
      } catch (e) {
        Get.back();

        await authController.setAutoSyncEnabled(false);

        UIHelpers.showErrorSnackbar(
          "profile_page.sync_error_message".trParams({
            "0": e.toString(),
          }),
          context,
        );
      }
    } else {
      UIHelpers.showConfirmationDialog(
        context: context,
        title: "profile_page.disable_sync_confirmation_title".tr,
        message: "profile_page.disable_sync_confirmation_message".tr,
        lottieAsset: "assets/lottie/alert.json",
        confirmAction: () async {
          Get.back();
          await authController.setAutoSyncEnabled(enabled);

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

            await authController.setAutoSyncEnabled(true);

            UIHelpers.showErrorSnackbar(
              "profile_page.delete_cloud_recipes_error".trParams({
                "0": e.toString(),
              }),
              context,
            );
          }
        },
      );
    }
  }

  Future<void> _assignOwnerIdToLocalRecipes() async {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn) return;

    try {
      final box = Hive.box<Recipe>(recipesBox);

      for (int i = 0; i < box.length; i++) {
        final recipe = box.getAt(i);
        if (recipe != null &&
            (recipe.ownerId!.isEmpty ||
                recipe.ownerId != authController.user!.uid)) {
          final updatedRecipe = Recipe(
            id: recipe.id,
            title: recipe.title,
            description: recipe.description,
            image: recipe.image,
            ingredients: recipe.ingredients,
            directions: recipe.directions,
            preparationTime: recipe.preparationTime,
            ownerId: authController.user!.uid,
          );
          await box.putAt(i, updatedRecipe);
        }
      }
    } catch (e) {
      debugPrint("Error assigning ownerId to local recipes: $e");
    }
  }

  void _handleExportRecipes(BuildContext context) {
    UIHelpers.showConfirmationDialog(
      context: context,
      title: "profile_page.export_confirmation_title".tr,
      message: "profile_page.export_confirmation_message".tr,
      lottieAsset: "assets/lottie/save_file.json",
      confirmAction: () async {
        Get.back();
        final recipeController = Get.find<RecipeController>();
        final recipes = recipeController.getAllRecipesForExport();
        await ExportService.exportRecipes(recipes, context);
      },
    );
  }

  void _handleImportRecipes(BuildContext context) {
    UIHelpers.showConfirmationDialog(
      context: context,
      title: "profile_page.import_confirmation_title".tr,
      message: "profile_page.import_confirmation_message".tr,
      lottieAsset: "assets/lottie/load_file.json",
      confirmAction: () async {
        Get.back();
        await _performImport(context);
      },
    );
  }

  Future<void> _performImport(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final importResult =
            await ImportService.importRecipes(filePath, context);

        UIHelpers.showSuccessSnackbar(
          "profile_page.import_success_message".trParams({
            "0": importResult.importedCount.toString(),
            "1": importResult.skippedCount.toString(),
          }),
          context,
        );

        final recipeController = Get.find<RecipeController>();
        recipeController.refreshRecipes();
      }
    } catch (e) {
      UIHelpers.showErrorSnackbar(
        "profile_page.import_error_message".trParams({
          "0": e.toString(),
        }),
        context,
      );
    }
  }

  Widget _buildSignOutCard(BuildContext context, AuthController controller) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          UIHelpers.showConfirmationDialog(
            context: context,
            title: "profile_page.sign_out_confirmation_title".tr,
            message: "profile_page.sign_out_confirmation_message".tr,
            lottieAsset: "assets/lottie/exit.json",
            confirmAction: () {
              Get.back();
              controller.signOut();
            },
          );
        },
        child: ListTile(
          title: Text(
            "profile_page.sign_out".tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          subtitle: Text(
            "profile_page.sign_out_description".tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          leading: Icon(
            CupertinoIcons.square_arrow_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          trailing: Icon(
            CupertinoIcons.chevron_forward,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
