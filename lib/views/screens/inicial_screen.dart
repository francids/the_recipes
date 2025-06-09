import "package:flutter/cupertino.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/views/screens/profile_page.dart";
import "package:the_recipes/views/screens/settings_screen.dart";
import "package:the_recipes/views/screens/recipes_page.dart";
import "package:flutter/material.dart";

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

class _InicialScreenState extends State<InicialScreen> {
  int _currentIndex = 0;

  List<String> get _titles => [
        "inicial_screen.title".tr,
        "profile_page.title".tr,
      ];

  List<Widget> get _pages => [
        const RecipesPage(),
        const ProfilePage(),
      ];

  @override
  Widget build(BuildContext context) {
    final RecipeController recipeController = Get.put(RecipeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.ellipsis_vertical,
            ),
            tooltip: "inicial_screen.menu_tooltip".tr,
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(CupertinoIcons.refresh),
                      title: Text("inicial_screen.menu_item_reload".tr),
                      horizontalTitleGap: 8,
                    ),
                    onTap: () {
                      recipeController.refreshRecipes();
                    },
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(CupertinoIcons.settings),
                      title: Text("inicial_screen.menu_item_settings".tr),
                      horizontalTitleGap: 8,
                    ),
                    onTap: () {
                      Get.to(() => const SettingsScreen());
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white30
                  : Colors.black26,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(CupertinoIcons.home),
              ),
              label: _titles[0],
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(CupertinoIcons.person),
              ),
              label: _titles[1],
            ),
          ],
        ),
      ),
    );
  }
}
