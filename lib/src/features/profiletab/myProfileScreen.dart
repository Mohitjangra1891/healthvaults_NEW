import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/services/authSharedPrefHelper.dart';
import 'package:healthvaults/src/features/profiletab/widgets/userDetaisCard.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../res/appColors.dart';
import '../../utils/themes/themeProvider.dart';
import '../auth/controller/authController.dart';
import '../goal/views/e.dart';
import '../healthTab/controller/planController.dart';

class MyProfilePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage> {
  bool notification_allowed = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(),
            const SizedBox(height: 24),

            /// Section: Preferences
            const Text("Preferences", style: TextStyle(fontWeight: FontWeight.bold)),
            Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ToggleOption(
                      title: 'Dark Theme',
                      subtitle: 'Toggle dark mode appearance',
                      icon: CupertinoIcons.moon,
                      value: isDark,
                      onChanged: (val) {
                        themeNotifier.setTheme(themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 4,
                      endIndent: 4,
                    ),
                    ToggleOption(
                      title: 'Notifications',
                      subtitle: 'Receive push notifications',
                      icon: Icons.notifications_active_outlined,
                      value: notification_allowed,
                      onChanged: (val) => setState(() => notification_allowed = val),
                    ),
                  ],
                ),
              ),
            ),

            /// Section: Account
            const Text("Account", style: TextStyle(fontWeight: FontWeight.bold)),
            Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ToggleOption(
                      title: 'Edit Profile',
                      subtitle: 'Update your personal details',
                      value: false,
                      // ignored
                      icon: Icons.person,
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.pushNamed(routeNames.editProfile);
                        // Navigate to profile screen
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 4,
                      endIndent: 4,
                    ),
                    ToggleOption(
                      title: 'Privacy Policy',
                      subtitle: 'Manage your Privacy Policy',
                      value: false,
                      // ignored
                      icon: Icons.lock,
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.pushNamed(routeNames.privacyPolicy);

                        // Navigate to profile screen
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// Section: Support
            const Text("Support", style: TextStyle(fontWeight: FontWeight.bold)),
            Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ToggleOption(
                      title: 'Help Center',
                      subtitle: 'Get help and support',
                      value: false,
                      // ignored
                      icon: Icons.person,
                      trailing: Icon(Icons.question_mark_rounded, size: 16),
                      onTap: () {
                        // Navigate to profile screen
                        context.pushNamed(routeNames.helpCenter);

                      },
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 4,
                      endIndent: 4,
                    ),
                    ToggleOption(
                      title: 'About',
                      subtitle: 'App version and information',
                      value: false,
                      // ignored
                      icon: Icons.info,
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigate to profile screen
                        context.pushNamed(routeNames.aboutScreen);

                      },
                    ),
                  ],
                ),
              ),
            ),

            Card(
              elevation: 0,
              color: isDark ? Colors.redAccent.shade200 : Colors.orange.shade200,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.login_rounded, color: !isDark ? Colors.black : Colors.white),
                title: Text(
                  "Logout",
                  style: TextStyle(color: !isDark ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  await ref.read(workoutPlanProvider.notifier).deletePlan();

                  await ref.read(authProvider.notifier).logout();

                  // await SharedPrefHelper.clearAll();
                  context.goNamed(routeNames.splash);
                }, // Add navigation logic here
              ),
            )
          ],
        ),
      ),
    );
  }
}
