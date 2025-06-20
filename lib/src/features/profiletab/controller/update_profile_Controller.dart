
// lib/features/profile/controllers/profile_controller.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/controller/userController.dart';
import '../../../modals/userModel.dart';
import '../../auth/repo/authRepo.dart';

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
  return ProfileController(ref);
});

class ProfileController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  ProfileController(this.ref) : super(const AsyncData(null));

  /// Updates user profile in Firebase and updates local state
  Future<void> updateProfile({
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


      final updatedUser = userModel.copyWith(
        profilePicture: profilePictureUrl ?? "",
        modifiedAt: DateTime.now(),
      );

      // Save to Firestore
      await ref.read(userRepositoryProvider).saveUserProfile(updatedUser);

      // Update locally
      await ref.read(userProfileProvider.notifier).updateUser(updatedUser);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
