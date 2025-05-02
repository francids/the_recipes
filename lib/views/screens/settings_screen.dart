import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/theme_controller.dart";
import "package:the_recipes/env/env.dart";
import "package:the_recipes/views/screens/settings/language_screen.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings_screen.title".tr,
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
              "settings_screen.appearance_section".tr,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            _buildThemeCard(context),
            const SizedBox(height: 32),
            Text(
              "settings_screen.language_section".tr,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            _buildLanguageCard(context),
            // const SizedBox(height: 32),
            // Text(
            //   "Cuenta",
            //   style: Theme.of(context).textTheme.displayMedium,
            // ),
            // const SizedBox(height: 16),
            // _buildAuthCard(context),
            const SizedBox(height: 32),
            Text(
              "settings_screen.about_section".tr,
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
                      "settings_screen.version".tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      Env.APP_VERSION,
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

  Widget _buildThemeCard(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: GetBuilder<ThemeController>(
        builder: (controller) {
          return Column(
            children: [
              SwitchListTile(
                title: Text(
                  "settings_screen.dark_theme".tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: controller.followSystemTheme
                            ? Theme.of(context).colorScheme.outline
                            : null,
                      ),
                ),
                subtitle: Text(
                  "settings_screen.dark_theme_description".tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                value: controller.isDarkMode,
                onChanged: controller.followSystemTheme
                    ? null
                    : (value) {
                        controller.toggleTheme();
                      },
                secondary: Icon(
                  controller.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: controller.followSystemTheme
                      ? Theme.of(context).colorScheme.outline
                      : Theme.of(context).colorScheme.primary,
                ),
                activeColor: controller.followSystemTheme
                    ? Theme.of(context).colorScheme.outline
                    : null,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              SwitchListTile(
                title: Text(
                  "settings_screen.system_theme".tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  "settings_screen.system_theme_description".tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                value: controller.followSystemTheme,
                onChanged: (value) {
                  controller.setFollowSystemTheme(value);
                },
                secondary: Icon(
                  Icons.brightness_auto,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Get.bottomSheet(
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: const LanguageScreen(),
            ),
            isScrollControlled: true,
          );
        },
        child: ListTile(
          title: Text(
            "settings_screen.language".tr,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(
            "settings_screen.language_description".tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          leading: Icon(
            Icons.language,
            color: Theme.of(context).colorScheme.primary,
          ),
          trailing: const Icon(Icons.expand_more),
        ),
      ),
    );
  }

  // Widget _buildAuthCard(BuildContext context) {
  //   return GetBuilder<AuthController>(
  //     builder: (authController) {
  //       return authController.isLoggedIn
  //           ? _buildLoggedInCard(context, authController)
  //           : _buildLoggedOutCard(context, authController);
  //     },
  //   );
  // }

  // Widget _buildLoggedInCard(
  //     BuildContext context, AuthController authController) {
  //   return Card(
  //     elevation: 0,
  //     margin: EdgeInsets.zero,
  //     clipBehavior: Clip.antiAlias,
  //     child: Column(
  //       children: [
  //         ListTile(
  //           title: Text(
  //             "Usuario actual",
  //             style: Theme.of(context).textTheme.bodyLarge,
  //           ),
  //           subtitle: Text(
  //             authController.user?.email ?? "",
  //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                   color: Theme.of(context).colorScheme.outline,
  //                 ),
  //           ),
  //           leading: Icon(
  //             Icons.person,
  //             color: Theme.of(context).colorScheme.primary,
  //           ),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             Dialogs.materialDialog(
  //               context: context,
  //               msg: "¿Estás seguro de que deseas cerrar sesión?",
  //               title: "Cerrar sesión",
  //               msgAlign: TextAlign.center,
  //               titleStyle: Theme.of(context).textTheme.displayMedium!,
  //               msgStyle: Theme.of(context).textTheme.bodyMedium,
  //               color: Theme.of(context).colorScheme.surface,
  //               dialogWidth: MediaQuery.of(context).size.width * 0.8,
  //               useRootNavigator: true,
  //               useSafeArea: true,
  //               actionsBuilder: (context) {
  //                 return [
  //                   SizedBox(
  //                     width: MediaQuery.of(context).size.width,
  //                     child: TextButton(
  //                       onPressed: () {
  //                         Get.back();
  //                       },
  //                       child: const Text("Cancelar"),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: MediaQuery.of(context).size.width,
  //                     child: FilledButton(
  //                       onPressed: () {
  //                         Get.back();
  //                         authController.signOut();
  //                       },
  //                       style: FilledButton.styleFrom(
  //                         backgroundColor: Theme.of(context).colorScheme.error,
  //                       ),
  //                       child: const Text("Cerrar sesión"),
  //                     ),
  //                   ),
  //                 ];
  //               },
  //             );
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   Icons.logout,
  //                   color: Theme.of(context).colorScheme.error,
  //                 ),
  //                 const SizedBox(width: 16),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Cerrar sesión",
  //                         style:
  //                             Theme.of(context).textTheme.bodyLarge?.copyWith(
  //                                   color: Theme.of(context).colorScheme.error,
  //                                 ),
  //                       ),
  //                       Text(
  //                         "Salir de tu cuenta actual",
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .bodySmall
  //                             ?.copyWith(
  //                               color: Theme.of(context).colorScheme.outline,
  //                             ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildLoggedOutCard(
  //   BuildContext context,
  //   AuthController authController,
  // ) {
  //   return Card(
  //     elevation: 0,
  //     margin: EdgeInsets.zero,
  //     clipBehavior: Clip.antiAlias,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.login,
  //                 color: Theme.of(context).colorScheme.primary,
  //               ),
  //               const SizedBox(width: 16),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "Iniciar sesión",
  //                       style: Theme.of(context).textTheme.bodyLarge,
  //                     ),
  //                     Text(
  //                       "Accede con tu cuenta para sincronizar tus recetas",
  //                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                             color: Theme.of(context).colorScheme.outline,
  //                           ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 24),
  //           SizedBox(
  //             width: double.infinity,
  //             child: FilledButton(
  //               onPressed: () {
  //                 authController.signInWithGoogle();
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 backgroundColor: Theme.of(context).colorScheme.primary,
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 12),
  //                 child: Text(
  //                   "Iniciar sesión con Google",
  //                   style: TextStyle(
  //                     color: Theme.of(context).colorScheme.onPrimary,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
