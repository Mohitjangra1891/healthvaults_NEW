// lib/features/profile/widgets/profile_image_picker.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker2 extends StatelessWidget {
  final XFile? image;
  final String? fallbackUrl;
  final void Function(XFile) onImagePicked;

  const ProfileImagePicker2({
    super.key,
    required this.image,
    required this.onImagePicked,
    this.fallbackUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final picked = await picker.pickImage(source: ImageSource.gallery);
        if (picked != null) onImagePicked(picked);
      },
      child: Column(
        spacing: 22,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: image != null
                ? FileImage(File(image!.path))
                : (fallbackUrl != null
                ? NetworkImage(fallbackUrl!)
                : null) as ImageProvider<Object>?,
            child: image == null && fallbackUrl == null
                ? const Icon(Icons.camera_alt, size: 40)
                : null,
          ),
          Text(
            "Add Photo",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17 ,color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

