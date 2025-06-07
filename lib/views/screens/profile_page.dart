import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:the_recipes/controllers/auth_controller.dart";
import "package:the_recipes/views/screens/profile_info_screen.dart";
import "package:the_recipes/views/widgets/ui_helpers.dart";
import "package:flutter_animate/flutter_animate.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(
        builder: (controller) {
          if (!controller.isLoggedIn) {
            return _buildSignInPrompt(context);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, controller)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: -0.2, curve: Curves.easeOutCubic),
                const SizedBox(height: 32),
                Text(
                  "profile_page.account_section".tr,
                  style: Theme.of(context).textTheme.displayMedium,
                )
                    .animate()
                    .fadeIn(delay: 50.ms, duration: 250.ms)
                    .slideX(begin: -0.15, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
                _buildAccountCard(context)
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 250.ms)
                    .slideX(begin: -0.15, curve: Curves.easeOutCubic),
                const SizedBox(height: 32),
                Text(
                  "profile_page.data_section".tr,
                  style: Theme.of(context).textTheme.displayMedium,
                )
                    .animate()
                    .fadeIn(delay: 150.ms, duration: 250.ms)
                    .slideX(begin: -0.15, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
                _buildDataCard(context)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 250.ms)
                    .slideX(begin: -0.15, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
                const Divider(
                  indent: 16,
                  endIndent: 16,
                )
                    .animate()
                    .fadeIn(delay: 250.ms, duration: 200.ms)
                    .slideX(begin: -0.1, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
                _buildSignOutCard(context, controller)
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 250.ms)
                    .slideX(begin: -0.15, curve: Curves.easeOutCubic),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final authController = Get.find<AuthController>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.person_circle,
              size: 80,
              color: theme.colorScheme.primary.withAlpha(153),
            ),
            const SizedBox(height: 24),
            Text(
              "profile_page.sign_in_required".tr,
              style: textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "profile_page.sign_in_description".tr,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => authController.signInWithGoogle(),
              icon: const Icon(CupertinoIcons.person_add),
              label: Text("profile_page.sign_in_with_google".tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthController controller) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final user = controller.user;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: theme.colorScheme.primary.withAlpha(25),
              backgroundImage:
                  user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null
                  ? Icon(
                      CupertinoIcons.person,
                      size: 32,
                      color: theme.colorScheme.primary,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? "profile_page.unknown_user".tr,
                    style: textTheme.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? "",
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Text(
              "profile_page.account_info".tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              "profile_page.account_info_description".tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            leading: Icon(
              CupertinoIcons.person_circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: Theme.of(context).colorScheme.outline,
            ),
            onTap: () {
              Get.to(() => const ProfileInfoScreen());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SwitchListTile(
            title: Text(
              "profile_page.backup_recipes".tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              "profile_page.backup_recipes_description".tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            value: false,
            onChanged: (value) {},
            secondary: Icon(
              CupertinoIcons.cloud_upload,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: Text(
              "profile_page.export_recipes".tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              "profile_page.export_recipes_description".tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            leading: Icon(
              CupertinoIcons.share,
              color: Theme.of(context).colorScheme.primary,
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: Theme.of(context).colorScheme.outline,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutCard(BuildContext context, AuthController controller) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          UIHelpers.showConfirmationDialog(
            context: context,
            title: "profile_page.sign_out_confirmation_title".tr,
            message: "profile_page.sign_out_confirmation_message".tr,
            lottieAsset: "assets/lottie/exit.json",
            confirmAction: () {
              Get.back();
              controller.signOut();
            },
          );
        },
        child: ListTile(
          title: Text(
            "profile_page.sign_out".tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          subtitle: Text(
            "profile_page.sign_out_description".tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          leading: Icon(
            CupertinoIcons.square_arrow_right,
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
