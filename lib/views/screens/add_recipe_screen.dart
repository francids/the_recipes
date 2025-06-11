import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/add_recipe_controller.dart";
import "package:the_recipes/views/widgets/recipe_form/image_step_widget.dart";
import "package:the_recipes/views/widgets/recipe_form/text_fields_step_widget.dart";
import "package:the_recipes/views/widgets/recipe_form/dynamic_list_step_widget.dart";
import "package:the_recipes/views/widgets/ui_helpers.dart";
import "package:flutter_animate/flutter_animate.dart";

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final AddRecipeController controller = Get.put(AddRecipeController());
  final PageController _pageController = PageController();
  final RxInt _currentStep = 0.obs;
  final RxBool _isCurrentStepValid = false.obs;
  static const _animationDuration = Duration(milliseconds: 300);
  final _stepTitles = [
    "add_recipe_screen.step_image".tr,
    "add_recipe_screen.step_details".tr,
    "add_recipe_screen.step_ingredients".tr,
    "add_recipe_screen.step_instructions".tr,
  ];

  @override
  void initState() {
    super.initState();
    _setupValidation();
  }

  void _setupValidation() {
    _validateStep();
    controller.fullPath.listen((_) => _validateStep());
    controller.title.listen((_) => _validateStep());
    controller.description.listen((_) => _validateStep());
    controller.preparationTime.listen((_) => _validateStep());
    ever(controller.ingredientsList, (_) => _validateStep());
    ever(controller.directionsList, (_) => _validateStep());
    _currentStep.listen((_) => _validateStep());
  }

  void _validateStep() {
    _isCurrentStepValid.value = _isValid();
  }

  bool _isValid() {
    switch (_currentStep.value) {
      case 0:
        return controller.fullPath.value.isNotEmpty;
      case 1:
        return controller.title.value.isNotEmpty &&
            controller.description.value.isNotEmpty &&
            controller.preparationTime.value > 0;
      case 2:
        return _isListValid(controller.ingredientsList);
      case 3:
        return _isListValid(controller.directionsList);
      default:
        return true;
    }
  }

  bool _isListValid(RxList<String> list) =>
      list.isNotEmpty && list.every((item) => item.isNotEmpty);

  void _handleNavigation(bool isNext) {
    if (isNext) {
      if (_isCurrentStepValid.value && _currentStep.value < 3) {
        _pageController.nextPage(
            duration: _animationDuration, curve: Curves.easeInOut);
        _currentStep.value++;
      } else if (!_isCurrentStepValid.value) {
        UIHelpers.showErrorSnackbar(
          "add_recipe_screen.error_complete_fields".tr,
          context,
        );
      }
    } else if (_currentStep.value > 0) {
      _pageController.previousPage(
          duration: _animationDuration, curve: Curves.easeInOut);
      _currentStep.value--;
    }
  }

  Future<void> _handleSaveRecipe() async {
    if (!_isCurrentStepValid.value) {
      UIHelpers.showErrorSnackbar(
        "add_recipe_screen.error_complete_all".tr,
        context,
      );
      return;
    }
    await controller.addRecipe();
    Get.back(result: true);
  }

  void _handleBackButton() {
    final hasData = controller.fullPath.value.isNotEmpty ||
        controller.title.value.isNotEmpty ||
        controller.description.value.isNotEmpty ||
        controller.preparationTime.value > 0 ||
        controller.ingredientsList.isNotEmpty ||
        controller.directionsList.isNotEmpty;

    if (hasData) {
      UIHelpers.showConfirmationDialog(
        context: context,
        title: "add_recipe_screen.exit_title".tr,
        message: "add_recipe_screen.exit_without_saving".tr,
        lottieAsset: "assets/lottie/back.json",
        confirmAction: () {
          Get.back();
          Get.back(result: false);
        },
      );
    } else {
      Get.back(result: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic) {
        if (didPop) return;

        final hasData = controller.fullPath.value.isNotEmpty ||
            controller.title.value.isNotEmpty ||
            controller.description.value.isNotEmpty ||
            controller.preparationTime.value > 0 ||
            controller.ingredientsList.isNotEmpty ||
            controller.directionsList.isNotEmpty;

        if (hasData) {
          UIHelpers.showConfirmationDialog(
            context: context,
            title: "add_recipe_screen.exit_title".tr,
            message: "add_recipe_screen.exit_without_saving".tr,
            lottieAsset: "assets/lottie/back.json",
            confirmAction: () {
              Get.back();
              Get.back(result: false);
            },
          );
        } else {
          Get.back(result: false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("add_recipe_screen.title".tr),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: _handleBackButton,
          ),
          actions: [
            Obx(
              () => _currentStep.value == 3 && _isCurrentStepValid.value
                  ? IconButton(
                      icon:
                          const Icon(CupertinoIcons.checkmark_alt_circle_fill),
                      onPressed: _handleSaveRecipe)
                  : const SizedBox(),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _stepTitles[_currentStep.value],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "add_recipe_screen.step_counter".trParams(
                            {
                              "0": (_currentStep.value + 1).toString(),
                              "1": "4",
                            },
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms),
                ),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) => _currentStep.value = index,
                    children: [
                      _wrapInScrollView(
                        ImageStepWidget(controller: controller),
                      ),
                      _wrapInScrollView(
                        TextFieldsStepWidget(controller: controller),
                      ),
                      _wrapInScrollView(
                        DynamicListStepWidget(
                          list: controller.ingredientsList,
                          label: "add_recipe_screen.ingredient".tr,
                        ),
                      ),
                      _wrapInScrollView(
                        DynamicListStepWidget(
                          list: controller.directionsList,
                          label: "add_recipe_screen.step".tr,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withAlpha(0),
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withAlpha(90),
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withAlpha(180),
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        stops: const [0.0, 0.25, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 8,
                  bottom: 32,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currentStep.value > 0
                        ? TextButton(
                            style: Theme.of(context)
                                .textButtonTheme
                                .style!
                                .copyWith(
                                  backgroundColor: WidgetStateProperty.all(
                                    Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                            onPressed: () => _handleNavigation(false),
                            child: Text("add_recipe_screen.previous".tr),
                          )
                            .animate()
                            .fadeIn(duration: 200.ms)
                            .slideX(begin: -0.5, curve: Curves.easeOutCubic)
                        : const SizedBox(),
                    _currentStep.value < 3 && _isCurrentStepValid.value
                        ? FilledButton(
                            onPressed: () => _handleNavigation(true),
                            child: Text("add_recipe_screen.next".tr),
                          )
                            .animate()
                            .fadeIn(duration: 200.ms)
                            .slideX(begin: 0.5, curve: Curves.easeOutCubic)
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wrapInScrollView(Widget child) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 16,
        bottom: (MediaQuery.of(context).viewInsets.bottom == 0) ? 80 : 16,
      ),
      child: child.animate().fadeIn(duration: 400.ms, delay: 100.ms),
    );
  }
}
