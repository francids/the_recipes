import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';

class UIHelpers {
  static void showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void showSuccessSnackbar(String message) {
    Get.snackbar(
      "Éxito",
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
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
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: confirmAction,
            child: const Text("Confirmar"),
          ),
        ];
      },
    );
  }

  static void showLoadingDialog(
      BuildContext context, String title, String message) {
    Dialogs.materialDialog(
      context: context,
      barrierDismissible: false,
      title: title,
      msg: message,
      lottieBuilder: LottieBuilder.asset(
        "assets/lottie/loading.json",
        fit: BoxFit.contain,
      ),
      msgAlign: TextAlign.center,
      titleStyle: Theme.of(context).textTheme.displayMedium!,
      msgStyle: Theme.of(context).textTheme.bodyMedium,
      color: Theme.of(context).colorScheme.surface,
      dialogWidth: MediaQuery.of(context).size.width * 0.8,
      useRootNavigator: true,
      useSafeArea: true,
    );
  }
}
