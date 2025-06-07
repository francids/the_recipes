import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:get/get.dart";
import "package:the_recipes/env/env.dart";
import "package:the_recipes/models/recipe.dart";

class AIRecipeController extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<Uint8List?> _compressImage(String imagePath) async {
    try {
      final compressedImage = await FlutterImageCompress.compressWithFile(
        imagePath,
        quality: 65,
        minWidth: 600,
        minHeight: 600,
      );
      return compressedImage;
    } catch (error) {
      print("Error compressing image: $error");
      return null;
    }
  }

  Future<Recipe> generateRecipeFromImage(String imagePath) async {
    try {
      final compressedImageBytes = await _compressImage(imagePath);
      final imageBytes =
          compressedImageBytes ?? await File(imagePath).readAsBytes();

      final base64Image = base64Encode(imageBytes);

      final body = {
        "image": base64Image,
        "language": Get.locale?.languageCode ?? "en",
      };

      final response = await post(
        "https://recipes.francids.com/api/ai/generate-recipe",
        body,
        contentType: "application/json",
        headers: {
          "TRA-SECRET-KEY": Env.TRA_SECRET_KEY,
        },
      );

      if (response.statusCode == 200) {
        return Recipe.fromMap(response.body);
      } else {
        response.printInfo();
        String errorMessage =
            _getErrorMessage(response.statusCode, response.body);
        throw AIRecipeException(errorMessage, response.statusCode!);
      }
    } catch (error) {
      if (error is AIRecipeException) {
        rethrow;
      }
      throw AIRecipeException("ai_errors.network_error".tr, 0);
    }
  }

  String _getErrorMessage(int? statusCode, dynamic responseBody) {
    switch (statusCode) {
      case 401:
        return "ai_errors.authentication_failed".tr;
      case 429:
        return "ai_errors.rate_limit_exceeded".tr;
      case 400:
        if (responseBody != null && responseBody['error'] != null) {
          String error = responseBody['error'].toString();
          if (error.contains("Image too large")) {
            return "ai_errors.image_too_large".tr;
          }
        }
        return "ai_errors.invalid_request".tr;
      case 500:
        return "ai_errors.server_error".tr;
      default:
        return "ai_errors.unknown_error".tr;
    }
  }
}

class AIRecipeException implements Exception {
  final String message;
  final int statusCode;

  AIRecipeException(this.message, this.statusCode);

  @override
  String toString() => message;
}
