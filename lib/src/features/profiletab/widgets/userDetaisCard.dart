import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/controller/userController.dart';


class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProfileProvider);

    return userState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (user) => Card(
        margin: const EdgeInsets.all(0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user.profilePicture != null ? NetworkImage(user.profilePicture ?? " ") : null,
                child: user.profilePicture == null ? const Icon(Icons.person, size: 40) : null,
              ),
              const SizedBox(height: 12),
              Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(user.email, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
