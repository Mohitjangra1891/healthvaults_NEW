import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/profiletab/widgets/profileImagePicker.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/controller/userController.dart';
import '../../common/views/widgets/button.dart';
import '../../common/views/widgets/datePicker.dart';
import '../../common/views/widgets/dropDowns.dart';
import 'controller/update_profile_Controller.dart';

class editUserProfileSceen extends ConsumerStatefulWidget {
  const editUserProfileSceen({
    super.key,
  });

  @override
  ConsumerState<editUserProfileSceen> createState() => _editUserProfileSceenState();
}

class _editUserProfileSceenState extends ConsumerState<editUserProfileSceen> {
  DateTime? selectedDate;
  String? gender;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  XFile? pickedImage;

  @override
  void initState() {
    super.initState();

    final userAsync = ref.read(userProfileProvider);

    userAsync.maybeWhen(
      data: (user) {
        nameController.text = user.name;
        selectedDate = DateTime.tryParse(user.dob);
        gender = user.gender;
      },
      orElse: () {},
    );
  }

  void saveProfile() {
    final user = ref.read(userProfileProvider).maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );

    if (user == null || selectedDate == null || gender == null) return;

    final updatedUser = user.copyWith(
      name: nameController.text.trim(),
      dob: selectedDate!.toIso8601String(),
      gender: gender!,
    );

    ref.read(profileControllerProvider.notifier).updateProfile(
      userModel: updatedUser,
      profileImage: pickedImage,
    );
  }



  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(profileControllerProvider).isLoading;
    ref.listen(profileControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $err")),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text("Just a few more details..."),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 32),
              ProfileImagePicker2(
                image: pickedImage,
                onImagePicked: (img) => setState(() => pickedImage = img),
                fallbackUrl: ref.read(userProfileProvider).maybeWhen(
                  data: (user) => user.profilePicture,
                  orElse: () => null,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),

              CustomDatePicker(
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                title: 'DOB',
                initialDate:selectedDate, // 👈 Pass default here

              ),
              const SizedBox(height: 16),

              // CustomDropdownBox(),
              selectAgeDropdownBox(
                selectedValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              // Gender

              const SizedBox(height: 32),

              // Continue Button
              loading
                  ? CircularProgressIndicator()
                  : button_Primary(
                      onPressed: () {
                        loading ? null : saveProfile();
                      },
                      title: "Continue")
            ],
          ),
        ),
      ),
    );
  }
}
