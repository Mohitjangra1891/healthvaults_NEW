import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../../common/views/widgets/toast.dart';
import '../../controller/authController.dart';

class forgotPassword_screen extends ConsumerStatefulWidget {
  const forgotPassword_screen({super.key});

  @override
  ConsumerState<forgotPassword_screen> createState() => _forgotPassword_screenState();
}

class _forgotPassword_screenState extends ConsumerState<forgotPassword_screen> {
  final _email_controller = TextEditingController();

  void _listenAuthState(AuthState state) {
    if (state is AuthSuccess) {
      context.pushReplacement(routeNames.emailSent, extra: _email_controller.text);
      ref.read(authProvider.notifier).reset();
    } else if (state is AuthError) {
      showToast(state.message);
      ref.read(authProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    ref.listen<AuthState>(authProvider, (_, state) => _listenAuthState(state));

    final isLoading = authState is AuthLoading;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 42,
              children: [
                SizedBox(
                  height: screenHeight * 0.12,
                ),
                Icon(
                  Icons.email,
                  color: Colors.blue,
                  size: 48,
                ),
                Text(
                  "Reset Your Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                Text(
                  "Reset Your email address and we/'ll send you a link to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
                TextFormField(
                  controller: _email_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                    ),
                    labelText: "Email Address",
                    prefixIcon: Icon(Icons.mail),
                  ),
                  onTapOutside: (PointerDownEvent) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            ref.read(authProvider.notifier).sendPasswordResetEmail(_email_controller.text.trim());
                          },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(screenWidth, screenHeight * 0.06),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(8)),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            "Send Reset Link",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
