import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:lottie/lottie.dart";
import "package:material_dialogs/material_dialogs.dart";

class UIHelpers {
  static void showErrorSnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccessSnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              CupertinoIcons.check_mark_circled,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String lottieAsset,
    required VoidCallback confirmAction,
  }) {
    Dialogs.materialDialog(
      context: context,
      title: title,
      msg: message,
      lottieBuilder: LottieBuilder.asset(
        lottieAsset,
        fit: BoxFit.contain,
      ),
      titleAlign: TextAlign.center,
      msgAlign: TextAlign.center,
      titleStyle: Theme.of(context).textTheme.displayMedium!,
      msgStyle: Theme.of(context).textTheme.bodyMedium,
      color: Theme.of(context).colorScheme.surface,
      dialogWidth: MediaQuery.of(context).size.width * 0.8,
      useRootNavigator: true,
      useSafeArea: true,
      actionsBuilder: (context) {
        return [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("ui_helpers.cancel".tr),
          ),
          FilledButton(
            onPressed: confirmAction,
            child: Text("ui_helpers.confirm".tr),
          ),
        ];
      },
    );
  }

  static void showLoadingDialog(
    BuildContext context,
    String title,
    String message, {
    String? lottieAsset,
  }) {
    Dialogs.materialDialog(
      context: context,
      barrierDismissible: false,
      title: title,
      msg: message,
      lottieBuilder: LottieBuilder.asset(
        lottieAsset ?? "assets/lottie/loading.json",
        fit: BoxFit.contain,
      ),
      titleAlign: TextAlign.center,
      msgAlign: TextAlign.center,
      titleStyle: Theme.of(context).textTheme.displayMedium!.copyWith(),
      msgStyle: Theme.of(context).textTheme.bodyMedium,
      color: Theme.of(context).colorScheme.surface,
      dialogWidth: MediaQuery.of(context).size.width * 0.8,
      useRootNavigator: true,
      useSafeArea: true,
    );
  }
}
