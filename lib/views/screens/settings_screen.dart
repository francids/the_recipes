import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/theme_controller.dart";
import "package:the_recipes/env/env.dart";
import "package:the_recipes/views/screens/settings/language_screen.dart";
import "package:flutter_animate/flutter_animate.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings_screen.title".tr),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.back),
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
            _buildThemeCard(context)
                .animate()
                .fadeIn(duration: 300.ms)
                .slideX(begin: -0.1, curve: Curves.easeOutCubic),
            const SizedBox(height: 32),
            Text(
              "settings_screen.language_section".tr,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            _buildLanguageCard(context)
                .animate()
                .fadeIn(delay: 150.ms, duration: 300.ms)
                .slideX(begin: -0.1, curve: Curves.easeOutCubic),
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
                      CupertinoIcons.info_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 300.ms)
                .slideX(begin: -0.1, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context) {
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
                  controller.isDarkMode
                      ? CupertinoIcons.moon_fill
                      : CupertinoIcons.sun_max_fill,
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
                  CupertinoIcons.circle_lefthalf_fill,
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
            CupertinoIcons.globe,
            color: Theme.of(context).colorScheme.primary,
          ),
          trailing: Icon(
            CupertinoIcons.chevron_forward,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
