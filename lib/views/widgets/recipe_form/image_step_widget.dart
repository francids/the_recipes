import "dart:io";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:image_picker/image_picker.dart";
import "package:the_recipes/controllers/add_recipe_controller.dart";
import "package:the_recipes/messages.dart";
import "package:flutter_animate/flutter_animate.dart";

class ImageStepWidget extends ConsumerWidget {
  final ImagePicker _imagePicker = ImagePicker();
  final VoidCallback? onImageSelected;

  ImageStepWidget({Key? key, this.onImageSelected}) : super(key: key);

  Future<void> _pickImage(WidgetRef ref) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(addRecipeControllerProvider.notifier).setImagePath(image);
      onImageSelected?.call();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addRecipeControllerProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickImage(ref),
            child: _buildImageContainer(state, ref),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .scaleXY(begin: 0.8, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "image_step.tap_to_select".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildImageContainer(AddRecipeState state, WidgetRef ref) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepOrange, width: 3),
            borderRadius: BorderRadius.circular(10),
            image: state.fullPath.isNotEmpty
                ? DecorationImage(
                    image: FileImage(File(state.fullPath)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: state.fullPath.isEmpty
              ? const Icon(
                  CupertinoIcons.photo_on_rectangle,
                  color: Colors.deepOrange,
                  size: 40,
                )
              : null,
        ),
      ),
    );
  }
}
