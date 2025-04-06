import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:the_recipes/controllers/auth_controller.dart';
import 'package:the_recipes/controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configuración",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Apariencia",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Obx(
                () => SwitchListTile(
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  title: Text(
                    "Tema oscuro",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    "Cambia entre tema claro y oscuro",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  value: themeController.isDarkMode,
                  onChanged: (value) {
                    themeController.toggleTheme();
                  },
                  secondary: Icon(
                    themeController.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Cuenta",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Dialogs.materialDialog(
                    context: context,
                    msg: "¿Estás seguro de que deseas cerrar sesión?",
                    title: "Cerrar sesión",
                    msgAlign: TextAlign.center,
                    titleStyle: Theme.of(context).textTheme.displayMedium!,
                    msgStyle: Theme.of(context).textTheme.bodyMedium,
                    color: Theme.of(context).colorScheme.surface,
                    dialogWidth: MediaQuery.of(context).size.width * 0.8,
                    useRootNavigator: true,
                    useSafeArea: true,
                    actionsBuilder: (context) {
                      return [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("Cancelar"),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FilledButton(
                            onPressed: () {
                              Get.back();
                              authController.signOut();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                            child: const Text("Cerrar sesión"),
                          ),
                        ),
                      ];
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cerrar sesión",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                            Text(
                              "Salir de tu cuenta actual",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Acerca de la aplicación",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Versión",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      "1.0.0",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    leading: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
