import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/views/SplashScreen.dart';
import 'package:healthvaults/src/features/auth/views/addUserDetailsScreen.dart';
import 'package:healthvaults/src/features/auth/views/forgotPassword/email_sent_screen.dart';
import 'package:healthvaults/src/features/auth/views/loginScreen.dart';
import 'package:healthvaults/src/features/profiletab/PrivacyScreen.dart';
import 'package:healthvaults/src/homePage.dart';

import '../features/auth/views/forgotPassword/forgotPasswod_screen.dart';
import '../features/auth/views/onboardingScreen.dart';
import '../features/goal/views/myGoalScreen.dart';
import '../features/goal/views/setYourGoalScreen.dart';
import '../features/profiletab/myProfileScreen.dart';
import '../features/profiletab/editUserProfileScreen.dart';
import '../features/profiletab/about_Screen.dart';
import '../features/profiletab/helpScreen.dart';


class routeNames {
  static String splash = '/splash';
  static String onboarding = '/onboarding';
  static String home = '/home';
  static String login = '/login';
  static String forgotPassword = '/forgotPassword';
  static String emailSent = '/emailSent';
  static String addDetails = '/addDetails';
  static String otpVerify = '/otpVerify';
  static String profile = '/profile';
  static String createProfile = '/createProfile';
  static String editProfile = '/editProfile';
  static String uploadDocument = '/uploadDocument';
  static String Mygoalscreen = '/Mygoalscreen';
  static String SetYourGoalScreen = '/SetYourGoalScreen';
  static String demoScreen = '/demoScreen';
  static String privacyPolicy = '/privacyPolicy';
  static String helpCenter = '/helpCenter';
  static String aboutScreen = '/aboutScreen';
}

final GoRouter router = GoRouter(
  initialLocation: routeNames.splash,
  routes: [
    GoRoute(
      name: routeNames.splash,
      path: routeNames.splash,
      builder: (BuildContext context, GoRouterState state) {
        return Splashscreen();
      },
    ),
    GoRoute(
      name: routeNames.onboarding,
      path: routeNames.onboarding,
      builder: (BuildContext context, GoRouterState state) {
        return OnboardingScreen();
      },
    ),
    GoRoute(
      name: routeNames.login,
      path: routeNames.login,
      builder: (BuildContext context, GoRouterState state) {
        return LoginScreen();
      },
    ),   GoRoute(
      name: routeNames.forgotPassword,
      path: routeNames.forgotPassword,
      builder: (BuildContext context, GoRouterState state) {
        return forgotPassword_screen();
      },
    ),
    GoRoute(
      name: routeNames.emailSent,
      path: routeNames.emailSent,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return email_sent_screen(email: email);
      },
    ),

    GoRoute(
      name: routeNames.addDetails,
      path: "${routeNames.addDetails}",
      builder: (BuildContext context, GoRouterState state) {
        return addUserDetailsScreen();
      },
    ),

    GoRoute(
      name: routeNames.home,
      path: routeNames.home,
      builder: (BuildContext context, GoRouterState state) {
        return MainScreen();
      },
    ),
    GoRoute(
      name: routeNames.profile,
      path: routeNames.profile,
      builder: (BuildContext context, GoRouterState state) {
        return MyProfilePage();
      },
    ), GoRoute(
      name: routeNames.editProfile,
      path: routeNames.editProfile,
      builder: (BuildContext context, GoRouterState state) {
        return editUserProfileSceen();
      },
    ),
    GoRoute(
      name: routeNames.SetYourGoalScreen,
      path: routeNames.SetYourGoalScreen,
      builder: (BuildContext context, GoRouterState state) {
        return SetYourGoalScreen();
      },
    ),
    GoRoute(
      name: routeNames.Mygoalscreen,
      path: routeNames.Mygoalscreen,
      builder: (BuildContext context, GoRouterState state) {
        return Mygoalscreen();
      },
    ),

    GoRoute(
      name: routeNames.privacyPolicy,
      path: routeNames.privacyPolicy,
      builder: (BuildContext context, GoRouterState state) {
        return PrivacyPolicyScreen();
      },
    ),
 GoRoute(
      name: routeNames.helpCenter,
      path: routeNames.helpCenter,
      builder: (BuildContext context, GoRouterState state) {
        return HelpCentreScreen();
      },
    ),

 GoRoute(
      name: routeNames.aboutScreen,
      path: routeNames.aboutScreen,
      builder: (BuildContext context, GoRouterState state) {
        return AboutScreen();
      },
    ),


  ],
);
