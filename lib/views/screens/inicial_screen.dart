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
            icon: const Icon(Icons.more_vert),
            tooltip: "Menu",
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    child: const Text("Recargar recetas"),
                    onTap: () {
                      recipeController.refreshRecipes();
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Configuración"),
                    onTap: () {
                      Get.to(() => const SettingsScreen());
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Tooltip(
            message: "Funciones de IA",
            preferBelow: false,
            child: FloatingActionButton.small(
              onPressed: () {
                Get.showSnackbar(
                  const GetSnackBar(
                    title: "Función no disponible",
                    message: "Esta función no está disponible en esta versión",
                    duration: Duration(seconds: 1),
                    snackPosition: SnackPosition.TOP,
                  ),
                );
              },
              child: const Icon(Icons.hexagon_outlined),
            ),
          ),
          const SizedBox(height: 10),
          Tooltip(
            message: "Agregar receta",
            preferBelow: false,
            child: FloatingActionButton(
              onPressed: () async {
                var upd = await Get.to(const AddRecipeScreen());
                if (upd == true) {
                  recipeController.refreshRecipes();
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
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
