import "package:get/get.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/views/screens/add_recipe_screen.dart";
import "package:the_recipes/views/screens/settings_screen.dart";
import "package:the_recipes/views/widgets/recipe_card.dart";
import "package:flutter/material.dart";

class InicialScreen extends StatelessWidget {
  const InicialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeController recipeController = Get.put(RecipeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "The Recipes App",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const SettingsScreen());
            },
            icon: const Icon(Icons.settings),
            tooltip: "Configuración",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var upd = await Get.to(const AddRecipeScreen());
          if (upd == true) {
            recipeController.refreshRecipes();
          }
        },
        tooltip: "Agregar receta",
        child: const Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GetX<RecipeController>(
            builder: (controller) {
              return Expanded(
                child: controller.recipes.isEmpty
                    ? const Center(
                        child: Text("No hay recetas disponibles"),
                      )
                    : ListView.builder(
                        itemCount: controller.recipes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                            child: RecipeCard(
                              recipe: controller.recipes[index],
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
