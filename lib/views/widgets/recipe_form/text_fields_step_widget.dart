import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/add_recipe_controller.dart";
import "package:the_recipes/views/widgets/form_field.dart";
import "package:flutter_animate/flutter_animate.dart";

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
            "text_fields_step.title_label".tr,
            controller.title,
            "text_fields_step.title_hint".tr,
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideX(begin: -0.1, curve: Curves.easeOutCubic),
          _buildTextField(
            "text_fields_step.description_label".tr,
            controller.description,
            "text_fields_step.description_hint".tr,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideX(begin: -0.1, curve: Curves.easeOutCubic),
          _buildTimeField()
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms)
              .slideX(begin: -0.1, curve: Curves.easeOutCubic),
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

  Widget _buildTimeField() {
    return Obx(
      () => ModernFormField(
        topLabel: "text_fields_step.preparation_time_label".tr,
        initialValue: controller.preparationTime.value > 0
            ? (controller.preparationTime.value / 60).round().toString()
            : "",
        onChanged: (text) {
          final minutes = int.tryParse(text) ?? 0;
          controller.preparationTime.value = minutes * 60; // convert to seconds
        },
        keyboardType: TextInputType.number,
        hintText: "text_fields_step.preparation_time_hint".tr,
        decoration: ModernFormFieldDecoration(
          suffixIcon: Container(
            alignment: Alignment.center,
            width: 40,
            height: 40,
            child: Text(
              "text_fields_step.minutes".tr,
              style: TextStyle(
                color:
                    Theme.of(Get.context!).colorScheme.onSurface.withAlpha(153),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
