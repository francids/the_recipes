import "package:appwrite/appwrite.dart";
import "package:appwrite/models.dart" as models;
import "package:appwrite/enums.dart" as enums;
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/services/sync_service.dart";
import "package:the_recipes/appwrite_config.dart";

class AuthController extends GetxController {
  static const autoSyncKey = "autoSync";
  static AuthController instance = Get.find();
  final Account _account = AppwriteConfig.account;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  models.User? _user;

  models.User? get user => _user;
  bool get isLoggedIn => _user != null;

  bool get autoSyncEnabled => _getAutoSyncSetting();

  bool _getAutoSyncSetting() {
    final box = Hive.box(settingsBox);
    return box.get(autoSyncKey, defaultValue: false) as bool;
  }

  Future<void> setAutoSyncEnabled(bool value) async {
    final box = Hive.box(settingsBox);
    await box.put(autoSyncKey, value);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final user = await _account.get();
      _user = user;
      update();
    } catch (e) {
      _user = null;
      update();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      EasyLoading.show(status: "auth_controller.signing_in".tr);

      await _account.createOAuth2Session(
        provider: enums.OAuthProvider.google,
        success: AppwriteConfig.redirectUrlSuccess,
        failure: AppwriteConfig.redirectUrlFailure,
      );

      await _checkCurrentUser();

      EasyLoading.dismiss();
    } on AppwriteException catch (e) {
      EasyLoading.dismiss();
      print("Appwrite error: ${e.code} - ${e.message}");
      EasyLoading.showError("auth_controller.sign_in_error".tr);
    } catch (e) {
      EasyLoading.dismiss();
      print("General error: $e");
      EasyLoading.showError("auth_controller.sign_in_error".tr);
    }
  }

  Future<void> signOut() async {
    try {
      final box = Hive.box(settingsBox);
      await box.delete(autoSyncKey);
      await _account.deleteSession(sessionId: 'current');
      await _googleSignIn.signOut();
      _user = null;
      update();
    } catch (e) {
      EasyLoading.showError(
        "auth_controller.sign_out_error".trParams(
          {
            "0": e.toString(),
          },
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      EasyLoading.show(status: "auth_controller.deleting_account".tr);

      if (_user != null) {
        await SyncService.deleteAllUserRecipesFromCloud();

        final sessions = await _account.listSessions();
        for (final session in sessions.sessions) {
          await _account.deleteSession(sessionId: session.$id);
        }

        await _googleSignIn.signOut();
        _user = null;
        update();
        EasyLoading.dismiss();
      }
    } on AppwriteException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 401) {
        EasyLoading.showError("auth_controller.requires_recent_login".tr);
        await _reauthenticateAndDelete();
      } else {
        EasyLoading.showError(
          "auth_controller.delete_account_error".trParams(
            {
              "0": e.message ?? e.toString(),
            },
          ),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(
        "auth_controller.delete_account_error".trParams(
          {
            "0": e.toString(),
          },
        ),
      );
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      EasyLoading.show(status: "auth_controller.reauthenticating".tr);

      await _account.createOAuth2Session(
        provider: enums.OAuthProvider.google,
        success: AppwriteConfig.redirectUrlSuccess,
        failure: AppwriteConfig.redirectUrlFailure,
      );

      await SyncService.deleteAllUserRecipesFromCloud();

      final sessions = await _account.listSessions();
      for (final session in sessions.sessions) {
        await _account.deleteSession(sessionId: session.$id);
      }

      await _googleSignIn.signOut();
      _user = null;
      update();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(
        "auth_controller.reauthentication_failed".trParams({
          "0": e.toString(),
        }),
      );
    }
  }
}
