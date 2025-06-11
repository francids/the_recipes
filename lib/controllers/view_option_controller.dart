import "package:get/get.dart";
import "package:hive_ce_flutter/adapters.dart";
import "package:the_recipes/hive_boxes.dart";
import "package:the_recipes/views/screens/recipes_page.dart";

class ViewOptionController extends GetxController {
  static const viewOptionKey = "view_option_key";

  final Rx<ViewOption> _currentViewOption = ViewOption.list.obs;
  ViewOption get currentViewOption => _currentViewOption.value;

  @override
  void onInit() {
    super.onInit();
    loadViewOption();
  }

  void loadViewOption() async {
    try {
      if (!Hive.isBoxOpen(settingsBox)) {
        await Hive.openBox(settingsBox);
      }

      final box = Hive.box(settingsBox);
      final viewOptionString = box.get(
        viewOptionKey,
        defaultValue: ViewOption.list.toString(),
      );

      _currentViewOption.value = ViewOption.values.firstWhere(
        (e) => e.toString() == viewOptionString,
        orElse: () => ViewOption.list,
      );
      update();
    } catch (e) {
      print("Error loading view option: $e");
      _currentViewOption.value = ViewOption.list;
      update();
    }
  }

  void changeViewOption(ViewOption option) async {
    _currentViewOption.value = option;
    update();

    try {
      if (!Hive.isBoxOpen(settingsBox)) {
        await Hive.openBox(settingsBox);
      }

      final box = Hive.box(settingsBox);
      await box.put(viewOptionKey, _currentViewOption.value.toString());
    } catch (e) {
      print("Error saving view option: $e");
    }
  }

  void toggleViewOption() {
    if (_currentViewOption.value == ViewOption.list) {
      changeViewOption(ViewOption.grid);
    } else {
      changeViewOption(ViewOption.list);
    }
  }
}
