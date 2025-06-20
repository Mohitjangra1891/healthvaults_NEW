import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/controller/userController.dart';
import '../../../common/views/widgets/button.dart';
import '../../../common/views/widgets/datePicker.dart';
import '../../../common/views/widgets/dropDowns.dart';
import '../../../common/views/widgets/toast.dart';
import '../../../modals/userModel.dart';
import '../../../utils/router.dart';
import '../../profiletab/widgets/profileImagePicker.dart';
import '../controller/addUserDetails_controller.dart';
import '../repo/authRepo.dart';

class addUserDetailsScreen extends ConsumerStatefulWidget {
  const addUserDetailsScreen({super.key});

  @override
  ConsumerState<addUserDetailsScreen> createState() => _addUserDetailsScreenState();
}

class _addUserDetailsScreenState extends ConsumerState<addUserDetailsScreen> {
  DateTime? selectedDate;
  String? gender;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addDetailsProvider);

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
              state.isLoading
                  ? CircularProgressIndicator()
                  : button_Primary(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty && gender != null && selectedDate != null) {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) return;
                          final userModel = UserModel(
                            userId: user.uid,
                            name: nameController.text.trim(),
                            email: user.email!,
                            profilePicture: null,
                            dob: selectedDate!.toIso8601String(),
                            gender: gender!,
                            subToken: null,
                            createdAt: DateTime.now(),
                            modifiedAt: DateTime.now(),
                          );
                          await ref.read(addDetailsProvider.notifier).saveUserDetails(
                                userModel: userModel,
                                profileImage: pickedImage,
                              );

                          final resultState = ref.read(addDetailsProvider);

                          if (mounted && resultState is AsyncData) {
                            context.goNamed(routeNames.home);
                          } else if (resultState is AsyncError) {
                            // Stay here, show error
                          }
                        } else {
                          showToast("Please enter your Details");
                        }
                      },
                      title: "Continue")
            ],
          ),
        ),
      ),
    );
  }
}
