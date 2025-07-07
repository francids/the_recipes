import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/models/recipe.dart";
import "package:the_recipes/views/widgets/common_recipe_view.dart";

class SharedRecipeScreen extends StatelessWidget {
  const SharedRecipeScreen({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("recipe_screen.title".tr),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.back),
        ),
      ),
      body: Column(
        children: [
          CommonRecipeView(
            recipe: recipe,
          ),
        ],
      ),
    );
  }
}
