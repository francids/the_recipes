import "dart:io";
import "package:appwrite/appwrite.dart";
import "package:appwrite/models.dart" as models;
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";
import "package:path_provider/path_provider.dart";
import "package:path/path.dart" as path;
import "package:http/http.dart" as http;
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/models/recipe.dart";
import "package:the_recipes/appwrite_config.dart";

class SyncService {
  static final Databases _databases = AppwriteConfig.databases;
  static final Storage _storage = AppwriteConfig.storage;
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
              recipe.ownerId == _authController.user!.$id)
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
            ownerId: _authController.user!.$id,
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
      final documentList = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.recipesCollectionId,
        queries: [
          Query.equal('ownerId', _authController.user!.$id),
        ],
      );

      final localBox = Hive.box<Recipe>(recipesBox);

      for (var doc in documentList.documents) {
        final recipeData = doc.data;
        recipeData["id"] = doc.$id;

        if (recipeData["image"] != null &&
            recipeData["image"].toString().isNotEmpty) {
          String imageValue = recipeData["image"].toString();

          if (imageValue.startsWith("http") || !imageValue.contains("/")) {
            recipeData["image"] =
                await _downloadImage(imageValue, recipeData["id"]);
          }
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
      models.Document? existingDoc;

      try {
        existingDoc = await _databases.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.recipesCollectionId,
          documentId: recipe.id,
        );
      } on AppwriteException catch (e) {
        if (e.type == "user_unauthorized") {
          debugPrint("User is not authorized: $e");
        }
        if (e.type != "document_not_found") {
          debugPrint("Error getting existing document: $e");
        }
        existingDoc = null;
      } catch (e) {
        existingDoc = null;
      }

      if (recipe.image.isNotEmpty && !recipe.image.startsWith("http")) {
        if (existingDoc != null) {
          final existingImage = existingDoc.data["image"] as String?;
          if (existingImage != null && existingImage.isNotEmpty) {
            if (existingImage != recipe.image) {
              try {
                if (existingImage.startsWith("http")) {
                  final uri = Uri.parse(existingImage);
                  if (uri.pathSegments.length >= 3) {
                    final fileId = uri.pathSegments[3];
                    await _storage.deleteFile(
                      bucketId: AppwriteConfig.bucketId,
                      fileId: fileId,
                    );
                  }
                } else {
                  await _storage.deleteFile(
                    bucketId: AppwriteConfig.bucketId,
                    fileId: existingImage,
                  );
                }
              } catch (e) {
                debugPrint("Error deleting old image: $e");
              }

              cloudImageUrl = await _uploadImage(
                  recipe.image, recipe.id, recipe.isPublic ?? false);
            } else {
              cloudImageUrl = existingImage;
            }
          } else {
            cloudImageUrl = await _uploadImage(
                recipe.image, recipe.id, recipe.isPublic ?? false);
          }
        } else {
          cloudImageUrl = await _uploadImage(
              recipe.image, recipe.id, recipe.isPublic ?? false);
        }
      }

      final recipeData = recipe.toMap();
      if (cloudImageUrl != null) {
        recipeData["image"] = cloudImageUrl;
      }
      recipeData.remove("id");

      final bool isPublic = recipe.isPublic ?? false;

      if (existingDoc != null) {
        await _databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.recipesCollectionId,
          documentId: recipe.id,
          data: recipeData,
          permissions: [
            Permission.read(
              isPublic ? Role.any() : Role.user(_authController.user!.$id),
            ),
            Permission.update(Role.user(_authController.user!.$id)),
            Permission.delete(Role.user(_authController.user!.$id)),
          ],
        );
      } else {
        try {
          await _databases.createDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.recipesCollectionId,
            documentId: recipe.id,
            data: recipeData,
            permissions: [
              Permission.read(
                isPublic ? Role.any() : Role.user(_authController.user!.$id),
              ),
              Permission.update(Role.user(_authController.user!.$id)),
              Permission.delete(Role.user(_authController.user!.$id)),
            ],
          );
        } catch (e) {
          if (e.toString().contains('document_already_exists')) {
            await _databases.updateDocument(
              databaseId: AppwriteConfig.databaseId,
              collectionId: AppwriteConfig.recipesCollectionId,
              documentId: recipe.id,
              data: recipeData,
              permissions: [
                Permission.read(
                  isPublic ? Role.any() : Role.user(_authController.user!.$id),
                ),
                Permission.update(Role.user(_authController.user!.$id)),
                Permission.delete(Role.user(_authController.user!.$id)),
              ],
            );
          } else {
            rethrow;
          }
        }
      }
    } catch (e) {
      debugPrint("Error uploading recipe ${recipe.id}: $e");
      rethrow;
    }
  }

  static Future<String> _uploadImage(
    String localPath,
    String recipeId,
    bool isPublic,
  ) async {
    try {
      final File imageFile = File(localPath);
      if (!await imageFile.exists()) {
        throw Exception("sync_service.image_file_does_not_exist".trParams({
          "0": localPath,
        }));
      }

      final String fileName = path.basename(localPath);

      try {
        await _storage.deleteFile(
          bucketId: AppwriteConfig.bucketId,
          fileId: recipeId,
        );
        debugPrint("Deleted existing file with ID: $recipeId");
      } catch (e) {
        debugPrint("No existing file to delete with ID: $recipeId");
      }

      final result = await _storage.createFile(
        bucketId: AppwriteConfig.bucketId,
        fileId: recipeId,
        file: InputFile.fromPath(path: localPath, filename: fileName),
        permissions: [
          Permission.read(
            isPublic ? Role.any() : Role.user(_authController.user!.$id),
          ),
          Permission.update(Role.user(_authController.user!.$id)),
          Permission.delete(Role.user(_authController.user!.$id)),
        ],
      );

      return result.$id;
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

      if (cloudUrl.startsWith("http")) {
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
      } else {
        final bytes = await _storage.getFileDownload(
          bucketId: AppwriteConfig.bucketId,
          fileId: cloudUrl,
        );

        final File imageFile = File(localPath);
        await imageFile.writeAsBytes(bytes);
        return localPath;
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
      try {
        final doc = await _databases.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.recipesCollectionId,
          documentId: recipeId,
        );

        final imageUrl = doc.data["image"] as String?;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            if (imageUrl.startsWith("http")) {
              final uri = Uri.parse(imageUrl);
              if (uri.pathSegments.length >= 3) {
                final fileId = uri.pathSegments[3];
                await _storage.deleteFile(
                  bucketId: AppwriteConfig.bucketId,
                  fileId: fileId,
                );
                debugPrint("Image deleted from Appwrite Storage: $imageUrl");
              }
            } else {
              await _storage.deleteFile(
                bucketId: AppwriteConfig.bucketId,
                fileId: imageUrl,
              );
              debugPrint("Image deleted from Appwrite Storage: $imageUrl");
            }
          } catch (e) {
            debugPrint("Error deleting image from Appwrite Storage: $e");
          }
        }
      } catch (e) {
        debugPrint("Error getting document before deletion: $e");
      }

      await _databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.recipesCollectionId,
        documentId: recipeId,
      );
      debugPrint("Recipe document deleted from Appwrite: $recipeId");
    } catch (e) {
      debugPrint("Error deleting recipe from cloud: $e");
      rethrow;
    }
  }

  static Future<void> deleteAllUserRecipesFromCloud() async {
    if (!_authController.isLoggedIn) {
      throw Exception("sync_service.user_must_be_logged_in".tr);
    }

    try {
      final documentList = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.recipesCollectionId,
        queries: [
          Query.equal('ownerId', _authController.user!.$id),
        ],
      );

      for (var doc in documentList.documents) {
        final imageUrl = doc.data["image"] as String?;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            if (imageUrl.startsWith("http")) {
              final uri = Uri.parse(imageUrl);
              if (uri.pathSegments.length >= 3) {
                final fileId = uri.pathSegments[3];
                await _storage.deleteFile(
                  bucketId: AppwriteConfig.bucketId,
                  fileId: fileId,
                );
                debugPrint(
                  "Image deleted from Appwrite Storage during mass delete: $imageUrl",
                );
              }
            } else {
              await _storage.deleteFile(
                bucketId: AppwriteConfig.bucketId,
                fileId: imageUrl,
              );
              debugPrint(
                "Image deleted from Appwrite Storage during mass delete: $imageUrl",
              );
            }
          } catch (e) {
            debugPrint(
              "Error deleting image from Appwrite Storage during mass delete: $e",
            );
          }
        }

        await _databases.deleteDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.recipesCollectionId,
          documentId: doc.$id,
        );
        debugPrint(
          "Recipe document deleted from Appwrite during mass delete: ${doc.$id}",
        );
      }
    } catch (e) {
      debugPrint("Error deleting all user recipes from cloud: $e");
      rethrow;
    }
  }
}
