import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/controller/userController.dart';
import '../../../common/services/authSharedPrefHelper.dart';
import '../../../modals/userModel.dart';
import '../../../utils/router.dart';
import '../../healthTab/controller/planController.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthInitial());

  Future<void> sendPasswordResetEmail(String email) async {
    state = AuthLoading();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      state = AuthSuccess();

    } on FirebaseAuthException catch (e) {
      state = AuthError(e.code);

      switch (e.code) {
        case 'invalid-email':
          throw 'The email address is not valid.';
        case 'user-not-found':
          throw 'No user found with this email.';
        case 'missing-email':
          throw 'Please enter your email.';
        default:
          throw 'Something went wrong. Please try again.';
      }
    } catch (e) {
      state = AuthError(e.toString());

      throw 'An unexpected error occurred.';
    }
  }

  Future<void> login(String email, String password, BuildContext context, WidgetRef ref) async {
    state = AuthLoading();
    try {
      final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await SharedPrefHelper.saveUserLOggedIn(true);
      await SharedPrefHelper.saveUserEmail(email);

      state = AuthSuccess();
      // After login success → check profile
      await checkUserProfile(context, ref);
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message ?? 'Login failed');
    }
  }

  Future<void> register(String email, String password, BuildContext context, WidgetRef ref) async {
    state = AuthLoading();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await SharedPrefHelper.saveUserLOggedIn(true);
      await SharedPrefHelper.saveUserEmail(email);

      state = AuthSuccess();
      // After login success → check profile
      await checkUserProfile(context, ref);
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message ?? 'Registration failed');
    }
  }

  Future<void> loginWithGoogle(BuildContext context, WidgetRef ref) async {
    state = AuthLoading();
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = AuthInitial(); // user canceled
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      state = AuthSuccess();
      // After login success → check profile
      await checkUserProfile(context, ref);
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message ?? 'Google login failed');
    } catch (e, stacktrace) {
      print('Google login failed: $e');
      print('Stacktrace: $stacktrace');
      state = AuthError('Google login failed: $e');
    }
  }

  Future<void> logout() async {
    state = AuthLoading();
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      await SharedPrefHelper.saveUserLOggedIn(false);
      await SharedPrefHelper.saveUserEmail("");
      state = AuthSuccess(); // will trigger splash to go to login
      log("✅ logged out");
    } catch (e) {
      state = AuthError('Logout failed');
    }
  }

  void reset() {
    state = AuthInitial();
  }

  Future<void> checkUserProfile(BuildContext context, WidgetRef ref) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // fail safe
    await SharedPrefHelper.saveUserLOggedIn(true);

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final userModel = UserModel.fromMap(doc.data()!);

      // Debug print the user details
      debugPrint('User Profile Found:');
      debugPrint('Name: ${userModel.name}');
      debugPrint('Email: ${userModel.email}');
      debugPrint('Sex: ${userModel.gender}');
      debugPrint('DOB: ${userModel.dob}');
      debugPrint('Profile Picture: ${userModel.profilePicture}');
      debugPrint('SubToken: ${userModel.subToken}');
      debugPrint('Created At: ${userModel.createdAt}');
      debugPrint('Modified At: ${userModel.modifiedAt}');
      await ref.read(userProfileProvider.notifier).updateUser(userModel);
      await ref.read(workoutPlanProvider.notifier).fetchPlanWithFallback(userId: FirebaseAuth.instance.currentUser!.uid);

      context.goNamed(routeNames.home);
    } else {
      // User profile not found → Go to AddDetailsScreen
      context.goNamed(routeNames.addDetails);
    }
  }
}
