import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modals/userModel.dart';

final userNameProvider = StateProvider<String>((ref) => '');
final loaderProvider = StateProvider<bool>((ref) => false);

class UserProfileNotifier extends StateNotifier<AsyncValue<UserModel>> {
  UserProfileNotifier() : super(const AsyncValue.loading()) {
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    state = AsyncValue.data(UserModel.fromPrefs(prefs));
  }

  Future<void> updateUser(UserModel updatedUser) async {
    await updatedUser.saveToPrefs();
    state = AsyncValue.data(updatedUser);
  }
}
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserModel>>(
      (ref) => UserProfileNotifier(),
);
