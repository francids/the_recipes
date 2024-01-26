import 'package:get/get.dart';

class AddRecipeController extends GetxController {
  RxString title = ''.obs;
  RxString image = ''.obs;
  RxString description = ''.obs;
  RxString ingredients = ''.obs;
  RxString directions = ''.obs;

  RxnString recipeTitleValidate = RxnString(null);
  RxnString recipeImageValidate = RxnString(null);
  RxnString recipeDescriptionValidate = RxnString(null);
  RxnString recipeIngredientsValidate = RxnString(null);
  RxnString recipeDirectionsValidate = RxnString(null);

  Rxn<Function()> addRecipe = Rxn<Function()>(null);

  @override
  void onInit() {
    super.onInit();
    debounce<String>(
      title,
      titleValidate,
      time: const Duration(milliseconds: 500),
    );
    debounce<String>(
      image,
      imageValidate,
      time: const Duration(milliseconds: 500),
    );
    debounce<String>(
      description,
      descriptionValidate,
      time: const Duration(milliseconds: 500),
    );
    debounce<String>(
      ingredients,
      ingredientsValidate,
      time: const Duration(milliseconds: 500),
    );
    debounce<String>(
      directions,
      directionsValidate,
      time: const Duration(milliseconds: 500),
    );
  }

  void titleValidate(String value) {
    addRecipe.value = null;
    if (value.isEmpty) {
      recipeTitleValidate.value = 'El título es requerido';
    } else {
      recipeTitleValidate.value = null;
      addRecipe.value = addRecipeValidate();
    }
  }

  void imageValidate(String value) {
    addRecipe.value = null;
    if (value.isEmpty) {
      recipeImageValidate.value = 'La imagen es requerida';
    } else {
      recipeImageValidate.value = null;
      addRecipe.value = addRecipeValidate();
    }
  }

  void descriptionValidate(String value) {
    addRecipe.value = null;
    if (value.isEmpty) {
      recipeDescriptionValidate.value = 'La descripción es requerida';
    } else {
      recipeDescriptionValidate.value = null;
      addRecipe.value = addRecipeValidate();
    }
  }

  void ingredientsValidate(String value) {
    addRecipe.value = null;
    if (value.isEmpty) {
      recipeIngredientsValidate.value = 'Los ingredientes son requeridos';
    } else {
      recipeIngredientsValidate.value = null;
      addRecipe.value = addRecipeValidate();
    }
  }

  void directionsValidate(String value) {
    addRecipe.value = null;
    if (value.isEmpty) {
      recipeDirectionsValidate.value = 'Los pasos son requeridos';
    } else {
      recipeDirectionsValidate.value = null;
      addRecipe.value = addRecipeValidate();
    }
  }

  void recipeTitle(String value) => title.value = value;

  void recipeImage(String value) => image.value = value;

  void recipeDescription(String value) => description.value = value;

  void recipeIngredients(String value) => ingredients.value = value;

  void recipeDirections(String value) => directions.value = value;

  Future<bool> Function() addRecipeValidate() {
    return () async {
      return true;
    };
  }
}
