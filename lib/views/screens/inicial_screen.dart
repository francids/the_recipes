import 'package:get/get.dart';
import 'package:the_recipes/controllers/recipe_controller.dart';
import 'package:the_recipes/views/screens/add_recipe_screen.dart';
import 'package:the_recipes/views/widgets/recipe_card.dart';
import 'package:flutter/material.dart';

class InicialScreen extends StatelessWidget {
  const InicialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeController recipeController = Get.put(RecipeController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Recipes App',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              recipeController.refreshRecipes();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: FilledButton(
                      onPressed: () {
                        Get.to(const AddRecipeScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Agregar Receta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            indent: 16,
            endIndent: 16,
            thickness: 0.6,
            color: Colors.black12,
          ),
          Obx(() {
            return Expanded(
              child: ListView.builder(
                itemCount: recipeController.recipes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: RecipeCard(recipe: recipeController.recipes[index]),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
