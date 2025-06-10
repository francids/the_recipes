import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
import "package:the_recipes/hive_boxes.dart";

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  bool get autoSyncEnabled => _getAutoSyncSetting();

  bool _getAutoSyncSetting() {
    final box = Hive.box(settingsBox);
    return box.get("autoSync", defaultValue: false) as bool;
  }

  Future<void> setAutoSyncEnabled(bool value) async {
    final box = Hive.box(settingsBox);
    await box.put("autoSync", value);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      update();
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      EasyLoading.show(status: "auth_controller.signing_in".tr);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        EasyLoading.dismiss();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      update();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError("auth_controller.sign_in_error".tr);
    }
  }

  Future<void> signOut() async {
    try {
      final box = Hive.box(settingsBox);
      await box.delete("autoSync");
      await _auth.signOut();
      await _googleSignIn.signOut();
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
        await _user!.delete();
        await _googleSignIn.signOut();
        update();
        EasyLoading.dismiss();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        EasyLoading.dismiss();
        EasyLoading.showError("auth_controller.requires_recent_login".tr);
        await _reauthenticateAndDelete();
      } else {
        EasyLoading.showError(
          "auth_controller.delete_account_error".trParams({
            "0": e.message ?? e.toString(),
          }),
        );
      }
    } catch (e) {
      EasyLoading.showError(
        "auth_controller.delete_account_error".trParams({
          "0": e.toString(),
        }),
      );
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      EasyLoading.show(status: "auth_controller.reauthenticating".tr);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        EasyLoading.dismiss();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _user!.reauthenticateWithCredential(credential);

      await _user!.delete();
      await _googleSignIn.signOut();
      update();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(
        "auth_controller.reauthentication_failed".trParams({
          "0": e.toString(),
        }),
      );
    }
  }
}
