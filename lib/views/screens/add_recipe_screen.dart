import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_recipes/controllers/add_recipe_controller.dart';

class AddRecipeScreen extends StatelessWidget {
  const AddRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddRecipeController addRecipeController = Get.put(AddRecipeController());
    final ImagePicker imagePicker = ImagePicker();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Receta',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back(result: false);
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
                    Obx(() {
                      return GestureDetector(
                        onTap: () async {
                          final XFile? image = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            addRecipeController.setImagePath(image);
                          }
                        },
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
                              image: addRecipeController
                                      .fullPath.value.isNotEmpty
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(
                                          addRecipeController.fullPath.value,
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              border: Border.all(
                                color: Colors.deepOrange,
                                width: 3,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.deepOrange,
                              size: 40,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: addRecipeController.titleController.text,
                      onChanged: (value) {
                        addRecipeController.titleController.text = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Título de la receta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue:
                          addRecipeController.descriptionController.text,
                      onChanged: (value) {
                        addRecipeController.descriptionController.text = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Descripción de la receta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue:
                          addRecipeController.ingredientsController.text,
                      onChanged: (value) {
                        addRecipeController.ingredientsController.text = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        labelText: 'Ingredientes de la receta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        helperText: 'Separar en cada línea cada ingrediente',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue:
                          addRecipeController.directionsController.text,
                      onChanged: (value) {
                        addRecipeController.directionsController.text = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        labelText: 'Pasos de la receta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        helperText: 'Separar en cada línea cada paso',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              await addRecipeController.addRecipe();
                              Get.back(result: true);
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
