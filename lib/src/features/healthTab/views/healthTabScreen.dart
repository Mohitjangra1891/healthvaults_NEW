import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/noPlanScreen.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../common/controller/userController.dart';
import '../../../common/views/widgets/imagwWidget.dart';
import '../../../res/appColors.dart';
import '../../../res/appImages.dart';
import '../controller/planController.dart';
import 'newToday_exe_screen.dart';

class healthTabScreen extends ConsumerStatefulWidget {
  const healthTabScreen({super.key});

  @override
  ConsumerState<healthTabScreen> createState() => _healthTabScreenState();
}

class _healthTabScreenState extends ConsumerState<healthTabScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 🛡️ This keeps your tab alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // IMPORTANT for keep alive!
    debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');

    final plan = ref.watch(workoutPlanProvider);

    return SafeArea(
      child: Scaffold(
        body: plan == null ? noPlanScreen() : NewTodaysTaskScreen(workoutPlan: plan),
        // body: plan == null ? noPlanScreen() : noPlanScreen(),
      ),
    );
  }
}
