import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/app.dart';
import 'package:healthvaults/src/features/analytics/repo/anaytics_repo.dart';
import 'package:healthvaults/src/modals/WeeklyWorkoutPlan.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

const apiKey = 'AIzaSyD9qInR8qPrJf77MSovq2op_e4XeNzzYnY'; // Replace with your actual API key

Future<void> main() async {
  try {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle.dark.copyWith(
    //     statusBarColor: Colors.white,
    //     systemNavigationBarColor: Colors.white,
    //   ),
    // );
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      // Hive.init(appDocDir.path);
      await Hive.initFlutter(appDocDir.path);
    }

    Hive.registerAdapter(WorkoutPlan2Adapter());
    Hive.registerAdapter(WorkoutDayAdapter());
    Hive.registerAdapter(RoutineItemAdapter());



    await Hive.openBox<WorkoutPlan2>('workoutPlanBox');
    // await Hive.openBox<ExerciseSessionHive>('exercise_sessions_box');

    runApp(ProviderScope(child: const MyApp()));
  } catch (e) {
    print('Error initializing Hive: $e');
  }
}
