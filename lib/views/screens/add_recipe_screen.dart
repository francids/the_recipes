import "dart:io";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "package:lottie/lottie.dart";
import "package:material_dialogs/material_dialogs.dart";
import "package:the_recipes/controllers/add_recipe_controller.dart";
import "package:the_recipes/controllers/ai_recipe_controller.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/gestures/drag_start_listener.dart";
import "package:the_recipes/views/widgets/form_field.dart";

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final AddRecipeController addRecipeController =
      Get.put(AddRecipeController());
  final ImagePicker imagePicker = ImagePicker();
  final PageController _pageController = PageController();
  final RxInt _currentStep = 0.obs;
  final RxBool _isCurrentStepValid = false.obs;

  @override
  void initState() {
    super.initState();
    _validateCurrentStep();
    addRecipeController.fullPath.listen((_) => _validateCurrentStep());
    addRecipeController.title.listen((_) => _validateCurrentStep());
    addRecipeController.description.listen((_) => _validateCurrentStep());
    ever(addRecipeController.ingredientsList, (_) => _validateCurrentStep());
    ever(addRecipeController.directionsList, (_) => _validateCurrentStep());
    _currentStep.listen((_) => _validateCurrentStep());
  }

  void _validateCurrentStep() {
    _isCurrentStepValid.value = _validateStep();
  }

  void _nextStep() {
    if (_isCurrentStepValid.value) {
      if (_currentStep.value < 3) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _currentStep.value++;
      }
    } else {
      Get.snackbar(
        "Error",
        "Completa todos los campos antes de continuar",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _previousStep() {
    if (_currentStep.value > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _currentStep.value--;
    }
  }

  bool _validateStep() {
    switch (_currentStep.value) {
      case 0:
        return addRecipeController.fullPath.value.isNotEmpty;
      case 1:
        return addRecipeController.title.value.isNotEmpty &&
            addRecipeController.description.value.isNotEmpty;
      case 2:
        return addRecipeController.ingredientsList.isNotEmpty &&
            addRecipeController.ingredientsList.every((i) => i.isNotEmpty);
      case 3:
        return addRecipeController.directionsList.isNotEmpty &&
            addRecipeController.directionsList.every((i) => i.isNotEmpty);
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Agregar Receta"),
          leading: IconButton(
            onPressed: () {
              bool hasData = addRecipeController.fullPath.value.isNotEmpty ||
                  addRecipeController.title.value.isNotEmpty ||
                  addRecipeController.description.value.isNotEmpty ||
                  addRecipeController.ingredientsList.isNotEmpty ||
                  addRecipeController.directionsList.isNotEmpty;

              if (hasData) {
                Dialogs.materialDialog(
                  context: context,
                  title: "Confirmar salida",
                  msg: "¿Salir sin guardar? Se perderán los cambios.",
                  lottieBuilder: LottieBuilder.asset(
                    "assets/lottie/back.json",
                    fit: BoxFit.contain,
                  ),
                  msgAlign: TextAlign.center,
                  titleStyle: Theme.of(context).textTheme.displayMedium!,
                  msgStyle: Theme.of(context).textTheme.bodyMedium,
                  color: Theme.of(context).colorScheme.surface,
                  dialogWidth: MediaQuery.of(context).size.width * 0.8,
                  useRootNavigator: true,
                  useSafeArea: true,
                  actionsBuilder: (context) {
                    return [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancelar"),
                      ),
                      FilledButton(
                        onPressed: () {
                          Get.back();
                          Get.back(result: false);
                        },
                        child: const Text("Salir"),
                      ),
                    ];
                  },
                );
              } else {
                Get.back(result: false);
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            Obx(
              () => _currentStep.value == 3
                  ? IconButton(
                      onPressed: () async {
                        if (!_isCurrentStepValid.value) {
                          Get.snackbar(
                            "Error",
                            "Completa todos los campos antes de guardar",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        await addRecipeController.addRecipe();
                        Get.back(result: true);
                      },
                      icon: const Icon(Icons.save),
                    )
                  : SizedBox(),
            ),
          ],
        ),
        body: Column(
          children: [
            Obx(
              () {
                String title = "";
                switch (_currentStep.value) {
                  case 0:
                    title = "Selecciona una imagen";
                    break;
                  case 1:
                    title = "Detalles de la receta";
                    break;
                  case 2:
                    title = "Ingredientes";
                    break;
                  case 3:
                    title = "Instrucciones";
                    break;
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "(Paso ${_currentStep.value + 1} de 4)",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                allowImplicitScrolling: false,
                scrollBehavior: const ScrollBehavior().copyWith(
                  overscroll: false,
                ),
                controller: _pageController,
                onPageChanged: (index) => _currentStep.value = index,
                children: [
                  _buildScrollablePage(_buildImageStep()),
                  _buildScrollablePage(_buildTitleAndDescriptionStep()),
                  _buildScrollablePage(_buildIngredientsStep()),
                  _buildScrollablePage(_buildInstructionsStep()),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currentStep.value > 0
                        ? TextButton(
                            onPressed: _previousStep,
                            child: Text("Anterior"),
                          )
                        : SizedBox(),
                    _currentStep.value < 3
                        ? _isCurrentStepValid.value
                            ? FilledButton(
                                onPressed: _nextStep,
                                child: Text("Siguiente"),
                              )
                            : SizedBox()
                        : SizedBox(),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollablePage(Widget content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: content,
    );
  }

  Widget _buildImageStep() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authController = Get.find<AuthController>();

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final XFile? image =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                addRecipeController.setImagePath(image);
              }
            },
            child: Obx(
              () => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepOrange, width: 3),
                    borderRadius: BorderRadius.circular(10),
                    image: addRecipeController.fullPath.value.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(
                              File(addRecipeController.fullPath.value),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: addRecipeController.fullPath.value.isEmpty
                      ? Icon(
                          Icons.add_a_photo,
                          color: Colors.deepOrange,
                          size: 40,
                        )
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Toca la imagen para seleccionar una foto de la receta",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          SizedBox(height: 24),
          Obx(
            () => addRecipeController.fullPath.value.isNotEmpty &&
                    authController.isLoggedIn
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: FilledButton.icon(
                      onPressed: _generateRecipeFromImage,
                      icon: Icon(Icons.auto_awesome, color: Colors.white),
                      label: Text(
                        "Generar información de la receta",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                : addRecipeController.fullPath.value.isNotEmpty &&
                        !authController.isLoggedIn
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            Text(
                              "La función de generar recetas automáticamente a partir de imágenes no está disponible actualmente. Esta característica estará disponible en futuras versiones.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
          ),
        ],
      ),
    );
  }

  void _generateRecipeFromImage() async {
    Dialogs.materialDialog(
      context: context,
      barrierDismissible: false,
      title: "Analizando imagen",
      msg: "Por favor espera mientras procesamos la imagen",
      lottieBuilder: LottieBuilder.asset(
        "assets/lottie/loading.json",
        fit: BoxFit.contain,
      ),
      msgAlign: TextAlign.center,
      titleStyle: Theme.of(context).textTheme.displayMedium!,
      msgStyle: Theme.of(context).textTheme.bodyMedium,
      color: Theme.of(context).colorScheme.surface,
      dialogWidth: MediaQuery.of(context).size.width * 0.8,
      useRootNavigator: true,
      useSafeArea: true,
    );

    try {
      final aiController = Get.put(AIRecipeController());
      final recipe = await aiController
          .generateRecipeFromImage(addRecipeController.fullPath.value);

      addRecipeController.title.value = recipe.title;
      addRecipeController.description.value = recipe.description;
      addRecipeController.ingredientsList.value = recipe.ingredients;
      addRecipeController.directionsList.value = recipe.directions;

      Get.back();
      _nextStep();

      Get.snackbar(
        "Éxito",
        "Se ha generado información de la receta",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "No se pudo generar la receta: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    }
  }

  Widget _buildTitleAndDescriptionStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildTextField(
            "Título de la receta",
            addRecipeController.title,
            "Ejemplo: Ensalada César",
          ),
          _buildTextField(
            "Descripción de la receta",
            addRecipeController.description,
            "Ejemplo: Una deliciosa ensalada con pollo y aderezo César",
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsStep() {
    return _buildDynamicList(
      addRecipeController.ingredientsList,
      "Ingrediente",
    );
  }

  Widget _buildInstructionsStep() {
    return _buildDynamicList(
      addRecipeController.directionsList,
      "Paso",
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

  Widget _buildDynamicList(RxList<String> list, String label) {
    final listKey = GlobalKey(debugLabel: label);

    return Obx(
      () => Column(
        children: [
          FilledButton(
            onPressed: () => list.add(""),
            child: Text(
              "Agregar $label",
            ),
          ),
          SizedBox(height: 16),
          list.isEmpty
              ? Center(
                  child: Text(
                    "Ningún ${label.toLowerCase()} agregado todavía",
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : ReorderableListView.builder(
                  key: listKey,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final List<String> updatedList = List<String>.from(list);

                    final item = updatedList.removeAt(oldIndex);
                    updatedList.insert(newIndex, item);

                    list.value = updatedList;
                    setState(() {});
                  },
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    return Container(
                      key: ValueKey('item-$i'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          CustomDragStartListener(
                            index: i,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.drag_handle,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ModernFormField(
                              initialValue: list[i],
                              onChanged: (text) => list[i] = text,
                              keyboardType: TextInputType.text,
                              hintText: "$label ${i + 1}",
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              list.removeAt(i);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
