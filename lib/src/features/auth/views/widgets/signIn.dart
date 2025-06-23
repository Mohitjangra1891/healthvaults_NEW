import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/views/widgets/toast.dart';

import '../../../../res/appColors.dart';
import '../../../../utils/router.dart';
import '../../controller/authController.dart';
import 'goggle_login_button.dart';

/// SignInForm matches exactly what you showed in the screenshot:
/// - Email field with mail icon
/// - Password field with lock + visibility toggle
/// - “Forgot Password?” link
/// - “Sign In” button
/// - Divider + “or” + Divider
/// - “Continue with Google” outlined button
class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // void _listenAuthState(AuthState state) {
  //   if (state is AuthSuccess) {
  //     context.goNamed(routeNames.home);
  //     ref.read(authProvider.notifier).reset();
  //   } else if (state is AuthError) {
  //     showToast(state.message);
  //     ref.read(authProvider.notifier).reset();
  //   }
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme
        .of(context)
        .brightness == Brightness.light;
    final authState = ref.watch(authProvider);
    // ref.listen<AuthState>(authProvider, (_, state) => _listenAuthState(state));

    final isLoading = authState is AuthLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          // Email Address field
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              labelText: 'Email Address',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            onTapOutside: (PointerDownEvent) {
              FocusScope.of(context).unfocus();
            },
          ),
          const SizedBox(height: 16),

          // Password field with visibility toggle
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                child: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
              ),
            ),
            onTapOutside: (PointerDownEvent) {
              FocusScope.of(context).unfocus();
            },
          ),

          // “Forgot Password?” aligned right
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                context.pushNamed(routeNames.forgotPassword);
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Theme
                    .of(context)
                    .colorScheme
                    .onSurface),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Sign In button
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
              ref.read(authProvider.notifier).login(
                  _emailController.text.trim(),
                  _passwordController.text.toString(),
                  context, ref
              );
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: isLight ? AppColors.primaryColor : Colors.white),
            child: isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )

                : Text(
              'Sign In',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isLight ? Colors.white : Colors.black),
            ),
          ),

          const SizedBox(height: 16),

          // Divider + “or” + Divider
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: isLight ? Colors.grey.shade300 : Colors.grey.shade700,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'or',
                  style: TextStyle(
                    color: isLight ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: isLight ? Colors.grey.shade300 : Colors.grey.shade700,
                  thickness: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          goggle_login_button(),
        ],
      ),
    );
  }
}
