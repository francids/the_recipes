import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:google_sign_in/google_sign_in.dart";

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

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
      EasyLoading.show(status: "Iniciando sesión...");

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
      EasyLoading.showSuccess("Sesión iniciada correctamente");
    } catch (e) {
      EasyLoading.showError("Error al iniciar sesión");
    }
  }

  Future<void> signOut() async {
    try {
      EasyLoading.show(status: "Cerrando sesión...");
      await _auth.signOut();
      await _googleSignIn.signOut();
      update();
      EasyLoading.showSuccess("Sesión cerrada correctamente");
    } catch (e) {
      EasyLoading.showError("Error al cerrar sesión: ${e.toString()}");
    }
  }
}
