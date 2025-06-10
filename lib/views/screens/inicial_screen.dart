import "package:flutter/cupertino.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/recipe_controller.dart";
import "package:the_recipes/views/screens/profile_page.dart";
import "package:the_recipes/views/screens/settings_screen.dart";
import "package:the_recipes/views/screens/recipes_page.dart";
import "package:the_recipes/views/screens/add_recipe_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

class _InicialScreenState extends State<InicialScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  bool _isScrolledToTop = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    _tabController.animation?.addListener(() {
      final animationValue = _tabController.animation?.value ?? 0;
      final newIndex = animationValue.round();
      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            shadows: [
              Shadow(
                blurRadius: 32.0,
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withAlpha(isDark ? 150 : 100),
                offset: Offset(15.0, 15.0),
              ),
            ],
          ),
        ),
        shape: _isScrolledToTop || _currentIndex == 1
            ? Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white30 : Colors.black26,
                  width: 0.5,
                ),
              )
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor.withAlpha(75),
                Theme.of(context).scaffoldBackgroundColor.withAlpha(0),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
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
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // Solo procesar si es de la pestaña actual de recetas
          if (_currentIndex == 0) {
            final isAtTop = scrollInfo.metrics.pixels <= 0;
            if (isAtTop != _isScrolledToTop) {
              setState(() {
                _isScrolledToTop = isAtTop;
              });
            }
          } else {
            // Si no estamos en la pestaña de recetas, consideramos que estamos en el top
            if (!_isScrolledToTop) {
              setState(() {
                _isScrolledToTop = true;
              });
            }
          }
          return false;
        },
        child: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: _pages,
            ),
            Positioned(
              bottom: 48,
              left: 20,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor ??
                      Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withAlpha(25)
                        : Colors.black.withAlpha(25),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withAlpha(77)
                          : Colors.black.withAlpha(25),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(4),
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  labelColor: Colors.white,
                  unselectedLabelColor: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
                  labelStyle: Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedLabelStyle ??
                      const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedLabelStyle ??
                      const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                  tabs: [
                    Tab(
                      iconMargin: const EdgeInsets.only(bottom: 4),
                      icon: Icon(CupertinoIcons.home),
                      text: _titles[0],
                    ),
                    Tab(
                      iconMargin: const EdgeInsets.only(bottom: 4),
                      icon: Icon(CupertinoIcons.person),
                      text: _titles[1],
                    ),
                  ],
                ),
              ),
            ),
            if (_currentIndex == 0)
              Positioned(
                bottom: 48,
                right: 20,
                child: Tooltip(
                  message: "inicial_screen.fab_tooltip_add".tr,
                  preferBelow: false,
                  child: FloatingActionButton(
                    onPressed: () async {
                      await Get.to(const AddRecipeScreen());
                    },
                    child: const Icon(CupertinoIcons.add),
                  ).animate().scale(
                        delay: 150.ms,
                        duration: 300.ms,
                        curve: Curves.easeOutBack,
                      ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
