import 'package:flutter/material.dart';
import 'package:the_recipes/models/recipe.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({
    super.key,
    required this.recipe,
    required this.index,
  });

  final Recipe recipe;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: const TextStyle(color: Colors.black),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: "recipe_image_$index",
                          child: Image.network(
                            recipe.image,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Hero(
                      tag: "recipe_title_$index",
                      child: Text(
                        recipe.title,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Hero(
                      tag: "recipe_description_$index",
                      child: Text(
                        recipe.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
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
                            overflow: TextOverflow.ellipsis,
                            maxLines: 20,
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
                            overflow: TextOverflow.ellipsis,
                            maxLines: 20,
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
