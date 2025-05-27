import "package:get/get.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/views/screens/add_recipe_screen.dart";
import "package:the_recipes/views/screens/settings_screen.dart";
import "package:the_recipes/views/widgets/recipe_card.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

class InicialScreen extends StatelessWidget {
  const InicialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeController recipeController = Get.put(RecipeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "inicial_screen.title".tr,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: "inicial_screen.menu_tooltip".tr,
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.sync_rounded),
                      title: Text("inicial_screen.menu_item_reload".tr),
                      horizontalTitleGap: 8,
                    ),
                    onTap: () {
                      recipeController.refreshRecipes();
                    },
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.settings_outlined),
                      title: Text("inicial_screen.menu_item_settings".tr),
                      horizontalTitleGap: 8,
                    ),
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
          // Tooltip(
          //   message: "inicial_screen.fab_tooltip_ai".tr,
          //   preferBelow: false,
          //   child: FloatingActionButton.small(
          //     onPressed: () {
          //       Get.showSnackbar(
          //         GetSnackBar(
          //           title: "inicial_screen.snackbar_title_not_available".tr,
          //           message: "inicial_screen.snackbar_message_not_available".tr,
          //           duration: Duration(seconds: 1),
          //           snackPosition: SnackPosition.TOP,
          //         ),
          //       );
          //     },
          //     child: const Icon(Icons.hexagon_outlined),
          //   ),
          // ),
          const SizedBox(height: 10),
          Tooltip(
            message: "inicial_screen.fab_tooltip_add".tr,
            preferBelow: false,
            child: FloatingActionButton(
              onPressed: () async {
                var upd = await Get.to(const AddRecipeScreen());
                if (upd == true) {
                  recipeController.refreshRecipes();
                }
              },
              child: const Icon(Icons.add),
            ).animate().scale(
                delay: 300.ms, duration: 400.ms, curve: Curves.easeOutBack),
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
                    ? Center(
                        child: Text("inicial_screen.empty_list".tr),
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
                      ).animate().fadeIn(duration: 300.ms),
              );
            },
          ),
        ],
      ),
    );
  }
}
