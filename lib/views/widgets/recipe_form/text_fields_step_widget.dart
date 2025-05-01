import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_recipes/controllers/add_recipe_controller.dart';
import 'package:the_recipes/views/widgets/form_field.dart';

class TextFieldsStepWidget extends StatelessWidget {
  final AddRecipeController controller;

  const TextFieldsStepWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildTextField(
            "Título de la receta",
            controller.title,
            "Ejemplo: Ensalada César",
          ),
          _buildTextField(
            "Descripción de la receta",
            controller.description,
            "Ejemplo: Una deliciosa ensalada con pollo y aderezo César",
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, RxString value, String hint) {
    return Obx(
      () => ModernFormField(
        topLabel: label,
        initialValue: value.value,
        onChanged: (text) => value.value = text,
        keyboardType: TextInputType.text,
        hintText: hint,
      ),
    );
  }
}
