import "dart:io";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";
import "package:path_provider/path_provider.dart";
import "package:path/path.dart" as path;
import "package:http/http.dart" as http;
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/models/recipe.dart";

class SyncService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final AuthController _authController = Get.find<AuthController>();

  static Future<void> syncRecipesToCloud() async {
    if (!_authController.isLoggedIn) {
      throw Exception("sync_service.user_must_be_logged_in".tr);
    }

    try {
      final localBox = Hive.box<Recipe>(recipesBox);
      final userRecipes = localBox.values
          .where((recipe) =>
              recipe.ownerId!.isEmpty ||
              recipe.ownerId == _authController.user!.uid)
          .toList();

      for (Recipe recipe in userRecipes) {
        if (recipe.ownerId!.isEmpty) {
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
          await localBox.put(recipe.id, updatedRecipe);
          await _uploadRecipeToCloud(updatedRecipe);
        } else {
          await _uploadRecipeToCloud(recipe);
        }
      }
    } catch (e) {
      debugPrint("Error syncing recipes to cloud: $e");
      rethrow;
    }
  }

  static Future<void> syncRecipesFromCloud() async {
    if (!_authController.isLoggedIn) {
      throw Exception("sync_service.user_must_be_logged_in".tr);
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection("recipes")
          .where("ownerId", isEqualTo: _authController.user!.uid)
          .get();

      final localBox = Hive.box<Recipe>(recipesBox);

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        final recipeData = doc.data() as Map<String, dynamic>;
        recipeData["id"] = doc.id;

        if (recipeData["image"] != null &&
            (recipeData["image"]
                    .toString()
                    .startsWith("https://firebasestorage.googleapis.com") ||
                recipeData["image"].toString().startsWith("gs://"))) {
          recipeData["image"] =
              await _downloadImage(recipeData["image"], recipeData["id"]);
        }

        final recipe = Recipe.fromMap(recipeData);
        await localBox.put(recipe.id, recipe);
      }
    } catch (e) {
      debugPrint("Error syncing recipes from cloud: $e");
      rethrow;
    }
  }

  static Future<void> _uploadRecipeToCloud(Recipe recipe) async {
    try {
      String? cloudImageUrl;
      if (recipe.image.isNotEmpty &&
          !recipe.image.startsWith("https://firebasestorage.googleapis.com") &&
          !recipe.image.startsWith("gs://")) {
        try {
          final docSnapshot =
              await _firestore.collection("recipes").doc(recipe.id).get();

          if (docSnapshot.exists) {
            final existingData = docSnapshot.data() as Map<String, dynamic>;
            final existingImage = existingData["image"] as String?;

            if (existingImage != null &&
                (existingImage
                        .startsWith("https://firebasestorage.googleapis.com") ||
                    existingImage.startsWith("gs://"))) {
              cloudImageUrl = existingImage;
            } else {
              cloudImageUrl = await _uploadImage(recipe.image, recipe.id);
            }
          } else {
            cloudImageUrl = await _uploadImage(recipe.image, recipe.id);
          }
        } catch (e) {
          cloudImageUrl = await _uploadImage(recipe.image, recipe.id);
        }
      }

      final recipeData = recipe.toMap();
      if (cloudImageUrl != null) {
        recipeData["image"] = cloudImageUrl;
      }

      await _firestore
          .collection("recipes")
          .doc(recipe.id)
          .set(recipeData, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error uploading recipe ${recipe.id}: $e");
      rethrow;
    }
  }

  static Future<String> _uploadImage(String localPath, String recipeId) async {
    try {
      final File imageFile = File(localPath);
      if (!await imageFile.exists()) {
        throw Exception("sync_service.image_file_does_not_exist".trParams({
          "0": localPath,
        }));
      }

      final String fileName =
          "${recipeId}_${DateTime.now().millisecondsSinceEpoch}";
      final Reference ref = _storage.ref().child("recipes/$recipeId/$fileName");

      final SettableMetadata metadata = SettableMetadata(
        customMetadata: {
          "ownerId": _authController.user!.uid,
          "isPublic": "false",
        },
      );

      final UploadTask uploadTask = ref.putFile(imageFile, metadata);
      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading image: $e");
      rethrow;
    }
  }

  static Future<String> _downloadImage(String cloudUrl, String recipeId) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String imagesPath = path.join(appDocDir.path, "recipe-images");
      Directory imagesDir = Directory(imagesPath);

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      String fileName =
          "${recipeId}_${DateTime.now().millisecondsSinceEpoch}.jpg";
      String localPath = path.join(imagesPath, fileName);

      final response = await http.get(Uri.parse(cloudUrl));
      if (response.statusCode == 200) {
        final File imageFile = File(localPath);
        await imageFile.writeAsBytes(response.bodyBytes);
        return localPath;
      } else {
        throw Exception("sync_service.failed_to_download_image".trParams({
          "0": cloudUrl,
          "1": response.statusCode.toString(),
        }));
      }
    } catch (e) {
      debugPrint("Error downloading image: $e");
      return cloudUrl;
    }
  }

  static Future<void> fullSync() async {
    try {
      await syncRecipesToCloud();
      await syncRecipesFromCloud();
    } catch (e) {
      debugPrint("Error in full sync: $e");
      rethrow;
    }
  }

  static Future<void> deleteRecipeFromCloud(String recipeId) async {
    if (!_authController.isLoggedIn) {
      throw Exception("sync_service.user_must_be_logged_in".tr);
    }

    try {
      final docSnapshot =
          await _firestore.collection("recipes").doc(recipeId).get();

      if (docSnapshot.exists) {
        final recipeData = docSnapshot.data() as Map<String, dynamic>;
        final imageUrl = recipeData["image"] as String?;

        if (imageUrl != null &&
            (imageUrl.startsWith("https://firebasestorage.googleapis.com") ||
                imageUrl.startsWith("gs://"))) {
          try {
            final Reference imageRef = _storage.refFromURL(imageUrl);
            await imageRef.delete();
            debugPrint("Image deleted from Firebase Storage: $imageUrl");
          } catch (e) {
            debugPrint("Error deleting image from Firebase Storage: $e");
          }
        }
      }

      await _firestore.collection("recipes").doc(recipeId).delete();
      debugPrint("Recipe document deleted from Firestore: $recipeId");
    } catch (e) {
      debugPrint("Error deleting recipe from cloud: $e");
      rethrow;
    }
  }
}
