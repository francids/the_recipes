import "dart:io";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lottie/lottie.dart";
import "package:material_dialogs/material_dialogs.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/models/recipe.dart";

class RecipeScreen extends StatelessWidget {
  RecipeScreen({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;
  final RecipeController recipeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "recipe_title_${recipe.id}",
          child: Text(
            recipe.title,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Dialogs.materialDialog(
                msg:
                    "¿Estás seguro de que quieres eliminar esta receta? Esta acción no se puede deshacer.",
                title: "Eliminar receta",
                lottieBuilder: LottieBuilder.asset(
                  "assets/lottie/delete.json",
                  fit: BoxFit.fill,
                ),
                titleStyle: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                msgStyle: GoogleFonts.openSans(
                  fontSize: 13,
                ),
                msgAlign: TextAlign.center,
                useRootNavigator: true,
                useSafeArea: true,
                context: context,
                actionsBuilder: (context) {
                  return [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          foregroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FilledButton(
                        onPressed: () {
                          recipeController.deleteRecipe(
                            recipe.id,
                            recipe.image,
                          );
                          Get.back();
                          Get.back();
                          recipeController.refreshRecipes();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Eliminar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
            icon: const Icon(Icons.delete_outline),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: "recipe_image_${recipe.id}",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(recipe.image),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      recipe.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Divider(
                      thickness: 0.3,
                      height: 16,
                      color: Colors.black12,
                    ),
                    Text(
                      "Ingredientes",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 2);
                        },
                        itemBuilder: (context, index) {
                          return Text(
                            "\u2022   ${recipe.ingredients[index]}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        },
                        itemCount: recipe.ingredients.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 3),
                      ),
                    ),
                    const Divider(
                      thickness: 0.3,
                      height: 16,
                      color: Colors.black12,
                    ),
                    Text(
                      "Instrucciones",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 8);
                        },
                        itemBuilder: (context, index) {
                          return Text(
                            "${index + 1}. ${recipe.directions[index]}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        },
                        itemCount: recipe.directions.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
