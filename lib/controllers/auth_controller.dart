import "package:appwrite/appwrite.dart";
import "package:appwrite/models.dart" as models;
import "package:appwrite/enums.dart" as enums;
import "package:flutter/foundation.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/services/sync_service.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/appwrite_config.dart";
import "package:http/http.dart" as http;
import "dart:convert";

class AuthController extends GetxController {
  static const autoSyncKey = "autoSync";
  static AuthController instance = Get.find();
  final _account = AppwriteConfig.account;
  final _functions = AppwriteConfig.functions;

  models.User? _user;
  String? _userProfileImageUrl;

  models.User? get user => _user;
  bool get isLoggedIn => _user != null;
  String? get userProfileImageUrl => _userProfileImageUrl;

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
      await _loadUserProfileImage();
      update();
    } catch (e) {
      _user = null;
      _userProfileImageUrl = null;
      update();
    }
  }

  Future<void> _loadUserProfileImage() async {
    try {
      models.Preferences preferences = await _account.getPrefs();
      final Map<String, dynamic> currentPrefs = preferences.data;
      _userProfileImageUrl = currentPrefs["profileImageUrl"] as String?;
    } catch (e) {
      _userProfileImageUrl = null;
      debugPrint("Error loading user profile image: $e");
    }
  }

  Future<void> _storeUserProfileImage(String imageUrl) async {
    try {
      final preferences = await _account.getPrefs();
      final Map<String, dynamic> currentPrefs = preferences.data;
      currentPrefs["profileImageUrl"] = imageUrl;
      await _account.updatePrefs(
          prefs: Map<dynamic, dynamic>.from(currentPrefs));
      _userProfileImageUrl = imageUrl;
      update();
    } on AppwriteException catch (e) {
      debugPrint(
        "Error storing profile image URL in preferences: ${e.message}",
      );
    } catch (e) {
      debugPrint("Unexpected error storing profile image URL: $e");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      EasyLoading.show(status: "auth_controller.signing_in".tr);

      await _account.createOAuth2Session(
        provider: enums.OAuthProvider.google,
        success: AppwriteConfig.redirectUrlSuccess,
        failure: AppwriteConfig.redirectUrlFailure,
        scopes: ["profile", "email", "openid"],
      );

      await _checkCurrentUser();

      if (_user != null) {
        final session = await _account.getSession(sessionId: "current");
        final providerAccessToken = session.providerAccessToken;

        final response = await http.get(
          Uri.parse("https://www.googleapis.com/oauth2/v3/userinfo"),
          headers: {
            "Authorization": "Bearer $providerAccessToken",
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> userData = jsonDecode(response.body);
          final String? userImageUrl = userData["picture"];
          if (userImageUrl != null) {
            await _storeUserProfileImage(userImageUrl);
          }
        }
      }

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
      if (autoSyncEnabled) {
        await SyncService.clearLocalRecipesOnSignOut();
      }
      await setAutoSyncEnabled(false);

      await _account.deleteSession(sessionId: "current");
      _user = null;
      _userProfileImageUrl = null;

      Get.find<RecipeController>().refreshRecipes();
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

        await setAutoSyncEnabled(false);

        await _functions.createExecution(
          functionId: "the-recipes-accounts",
          path: "/delete",
        );

        _user = null;
        _userProfileImageUrl = null;
        update();
        EasyLoading.dismiss();
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
}
