import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/controller/userController.dart';
import '../../../modals/userModel.dart';
import '../repo/authRepo.dart';


class AddDetailsViewModel extends StateNotifier<AsyncValue<void>> {
  AddDetailsViewModel(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<void> saveUserDetails({
    required UserModel userModel,
    required XFile? profileImage,
  }) async {
    state = const AsyncLoading();
    try {
      String? profilePictureUrl;

      if (profileImage != null) {
        profilePictureUrl = await ref
            .read(userRepositoryProvider)
            .uploadProfilePicture(userModel.userId, profileImage);
      }

      final updatedUser = userModel.copyWith(profilePicture: profilePictureUrl);

      await ref.read(userRepositoryProvider).saveUserProfile(updatedUser);
      await ref.read(userProfileProvider.notifier).updateUser(updatedUser);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final addDetailsProvider = StateNotifierProvider<AddDetailsViewModel, AsyncValue<void>>((ref) {
  return AddDetailsViewModel(ref);
});

