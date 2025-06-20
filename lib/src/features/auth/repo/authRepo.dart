import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/controller/userController.dart';
import '../../../modals/userModel.dart';




final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  final _firestore = FirebaseFirestore.instance;

  final _storage = FirebaseStorage.instance;

  Future<void> saveUserProfile(UserModel userModel) async {
    await _firestore.collection('users').doc(userModel.userId).set(userModel.toMap());
  }
  Future<String> uploadProfilePicture(String userId, XFile image) async {
    final ref = _storage
        .ref()
        .child('user_uploads')
        .child(userId)
        .child('profile')
        .child('profile_photo.jpg');

    final uploadTask = ref.putFile(File(image.path));

    // Listen to progress (optional)
    uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      debugPrint('Upload Progress: ${(progress * 100).toStringAsFixed(2)}%');
    });

    // ❗️IMPORTANT: wait for upload to complete
    await uploadTask;

    // ✅ Now the URL will be the new one
    final url = await ref.getDownloadURL();
    debugPrint('Profile picture URL: $url');

    return url;
  }


}

