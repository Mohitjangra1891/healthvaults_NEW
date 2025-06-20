import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../res/appImages.dart';
import '../../controller/authController.dart';

class goggle_login_button extends ConsumerWidget {
  const goggle_login_button({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    return OutlinedButton(
      onPressed: isLoading
          ? null
          : () {
              ref.read(authProvider.notifier).loginWithGoogle(context ,ref);
            },
      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            appImages.appLogo,
            height: 24,
            width: 24,
          ),
          Text(
            'Continue with Google',
            style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
