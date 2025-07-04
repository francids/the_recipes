import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/views/screens/recipes_page.dart";
import "package:the_recipes/views/widgets/recipe_card.dart";

class SharedRecipesScreen extends StatelessWidget {
  const SharedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeController = Get.find<RecipeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("shared_recipes_screen.title".tr),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final publicRecipes = recipeController.recipes
                  .where((recipe) => recipe.isPublic == true)
                  .toList();

              return publicRecipes.isEmpty
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "shared_recipes_screen.no_public_recipes".tr,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: publicRecipes.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          recipe: publicRecipes[index],
                          viewOption: ViewOption.list,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
