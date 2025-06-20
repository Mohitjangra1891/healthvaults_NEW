import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/auth/controller/authController.dart';
import 'package:healthvaults/src/res/appImages.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../services/authSharedPrefHelper.dart';

class Splashscreen extends ConsumerStatefulWidget {
  const Splashscreen({super.key});

  @override
  ConsumerState<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends ConsumerState<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // Optional splash delay
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final seenOnboard = await SharedPrefHelper.seenOnboard();
    if (seenOnboard) {
      if (isLoggedIn) {
        ref.read(authProvider.notifier).checkUserProfile(context, ref);
      } else {
        context.goNamed(routeNames.login);
      }
    } else {
      context.goNamed(routeNames.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image.asset(appImages.appLogo),
      ),
    );
  }
}
