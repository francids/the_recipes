import "dart:io";

import "package:the_recipes/models/recipe.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/views/screens/recipe_screen.dart";
import "package:flutter_animate/flutter_animate.dart";

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.all(0),
      // margin: const EdgeInsets.only(top: 8, bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isDarkMode ? Colors.white30 : Colors.black26,
          width: 0.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Get.to(
            RecipeScreen(recipe: recipe),
            curve: Curves.easeOutCirc,
          );
        },
        child: Row(
          children: [
            Hero(
              tag: "recipe_image_${recipe.id}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(recipe.image),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Hero(
                      tag: "recipe_title_${recipe.id}",
                      child: Text(
                        recipe.title,
                        style: Theme.of(context).textTheme.displayMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      recipe.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.2, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}
