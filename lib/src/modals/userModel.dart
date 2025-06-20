import 'package:shared_preferences/shared_preferences.dart';

import '../common/services/authSharedPrefHelper.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? profilePicture;
  final String dob;
  final String gender;
  final String? subToken;
  final DateTime createdAt;
  final DateTime modifiedAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.dob,
    required this.gender,
    this.subToken,
    required this.createdAt,
    required this.modifiedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'dob':DateTime.parse(dob).millisecondsSinceEpoch,
      'gender': gender,
      'subToken': subToken,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'modifiedAt': modifiedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      profilePicture: map['profilePicture'],
      dob: DateTime.fromMillisecondsSinceEpoch(map['dob']).toIso8601String(),
      gender: map['gender'],
      subToken: map['subToken'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map['modifiedAt']),
    );
  }

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? profilePicture,
    String? dob,
    String? gender,
    String? subToken,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      subToken: subToken ?? this.subToken,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  factory UserModel.fromPrefs(SharedPreferences prefs) {
    return UserModel(
      name: prefs.getString(SharedPrefKeys.name) ?? 'Guest',
      email: prefs.getString(SharedPrefKeys.email) ?? 'guest@example.com',
      gender: prefs.getString(SharedPrefKeys.gender) ?? 'Other',
      profilePicture: prefs.getString(SharedPrefKeys.dp),
      dob: prefs.getString(SharedPrefKeys.dob) ?? ' ',
      userId: prefs.getString(SharedPrefKeys.userId) ?? ' ',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    );
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.userId, userId);
    await prefs.setString(SharedPrefKeys.name, name);
    await prefs.setString(SharedPrefKeys.email, email);
    await prefs.setString(SharedPrefKeys.gender, gender);
    await prefs.setString(SharedPrefKeys.dob, dob);
    if (profilePicture != null) {
      await prefs.setString(SharedPrefKeys.dp, profilePicture!);
    }
  }
}
