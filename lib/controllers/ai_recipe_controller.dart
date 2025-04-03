import 'dart:io';

import 'package:get/get.dart';
import 'package:the_recipes/models/recipe.dart';

class AIRecipeController extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<Recipe> generateRecipeFromImage(String imagePath) async {
    try {
      final formData = FormData({
        'image': MultipartFile(
          File(imagePath),
          filename: imagePath.split('/').last,
        ),
      });

      final response = await post(
        "http://10.0.0.173:3000/generate-recipe",
        formData,
      );

      if (response.statusCode == 200) {
        return Recipe.fromMap(response.body);
      } else {
        throw Exception("Failed to generate recipe: ${response.statusText}");
      }
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}
