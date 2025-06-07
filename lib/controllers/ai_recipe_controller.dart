import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:the_recipes/env/env.dart';
import 'package:the_recipes/models/recipe.dart';

class AIRecipeController extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<Recipe> generateRecipeFromImage(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
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
        throw Exception("Failed to generate recipe: ${response.statusText}");
      }
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}
