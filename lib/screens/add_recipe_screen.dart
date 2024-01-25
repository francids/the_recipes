import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_recipes/controllers/add_recipe_controller.dart';

class AddRecipeScreen extends StatelessWidget {
  const AddRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddRecipeController recipeController = Get.put(AddRecipeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Receta',
          style: TextStyle(color: Colors.black),
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
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.transparent,
                                blurRadius: 80,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.deepOrange,
                              width: 3,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add_a_photo,
                            size: 48,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      return TextFormField(
                        onChanged: recipeController.recipeTitle,
                        decoration: InputDecoration(
                          labelText: 'Título de la receta',
                          errorText: recipeController.recipeTitleValidate.value,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      return TextFormField(
                        onChanged: recipeController.recipeDescription,
                        decoration: InputDecoration(
                          labelText: 'Descripción de la receta',
                          errorText:
                              recipeController.recipeDescriptionValidate.value,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      return TextFormField(
                        onChanged: recipeController.recipeIngredients,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Tiempo de preparación',
                          errorText:
                              recipeController.recipeIngredientsValidate.value,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          helperText: 'Separar en cada línea cada ingrediente',
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      return TextFormField(
                        onChanged: recipeController.recipeDirections,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Pasos de la receta',
                          errorText:
                              recipeController.recipeDirectionsValidate.value,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          helperText: 'Separar en cada línea cada paso',
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return FilledButton(
                              onPressed: recipeController.addRecipe.value,
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
                            );
                          }),
                        ),
                      ],
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
