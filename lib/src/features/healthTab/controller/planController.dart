// lib/providers/workout_plan_provider.dart
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../modals/WeeklyWorkoutPlan.dart';
import '../../../modals/firebase_workoutData_modal.dart';

/// PROVIDER: Exposes `WorkoutPlan2?` and allows updates.
final workoutPlanProvider = StateNotifierProvider<WorkoutPlanNotifier, WorkoutPlan2?>((ref) {
  final box = Hive.box<WorkoutPlan2>('workoutPlanBox');
  return WorkoutPlanNotifier(box);
});

class WorkoutPlanNotifier extends StateNotifier<WorkoutPlan2?> {
  final Box<WorkoutPlan2> box;

  // final WorkoutRepository repo;

  static const _boxKey = 'plan';

  WorkoutPlanNotifier(this.box) : super(box.get(_boxKey)) {
    // Whenever Hive box changes under key 'plan', update state.
    box.watch(key: _boxKey).listen((event) {
      state = event.value as WorkoutPlan2?;
    });
  }

  /// Save a brand‑new plan → writes to Hive + updates state
  Future<void> savePlan(
    WorkoutPlan2 plan, {
    required String rawModelJson,
    required String prompt,
    required String userId,
  }) async {
    try {
      // 1. Save locally to Hive
      await box.put(_boxKey, plan);
      state = plan;

      // 2. Prepare model for Firebase
      final firebaseModel = FirebaseWorkoutdataModal(
        achievement: plan.achievement,
        id: DateTime.now().millisecondsSinceEpoch,
        model: rawModelJson,
        planName: plan.planName,
        reflectionQuestions: plan.reflectionQuestions,
        remark1: plan.remark1,
        remark2: plan.remark2,
        startDate: plan.startDate.toIso8601String(),
        startDay: 1,
        user: prompt,
        userId: userId,
        week: 1,
      );

      // 3. Upload to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('workoutData').doc('1').set(firebaseModel.toMap());

      log("✅ Plan saved to Firebase for user $userId");
    } catch (e, st) {
      log("❌ Failed to save plan to Firebase: $e");
      log("StackTrace: $st");
    }
  }

  /// ✅ Fallback fetch logic
  Future<void> fetchPlanWithFallback({required String userId}) async {
    final localPlan = box.get(_boxKey);
    if (localPlan != null) {
      log("✅ Loaded plan from local Hive");
      state = localPlan;
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('workoutData')
          .doc('1') // or any doc ID you used when uploading
          .get();

      if (!doc.exists) {
        log("ℹ️ No workout data found in Firebase for user: $userId");
        state = null;
        return;
      }

      final data = doc.data();
      if (data == null) {
        log("⚠️ Workout data is null in the document.");
        state = null;
        return;
      }
      print(data);
      final jsonData = json.decode(data["model"]);

      jsonData['start_date'] = data["startDate"];

      final plan = WorkoutPlan2.fromJson(jsonData); // assuming it matches your model

      // Save to Hive
      await box.put(_boxKey, plan);

      log("✅ Synced plan from Firebase → Hive");
      state = plan;
    } catch (e, st) {
      log("❌ Failed to fetch plan from Firebase: $e");
      log("StackTrace: $st");
      state = null;
    }
  }

  /// Delete the existing plan (if you ever need to reset)
  Future<void> deletePlan() async {
    await box.delete(_boxKey);
    state = null;
  }

  /// Save a brand‑new plan → writes to Hive + updates state
  Future<void> _update_exercise_completion(
    WorkoutPlan2 plan,
  ) async {
    await box.put(_boxKey, plan);
    state = plan;
  }

  /// Mark one RoutineItem as completed/incomplete
  /// dayKey: e.g. 'Monday', index: position in that WorkoutDay.routine
  void markExerciseComplete({
    required String dayKey,
    required int index,
    required bool isCompleted,
    required int completedInSeconds,
  }) {
    final current = state;
    if (current == null) return;

    final workoutDay = current.workouts[dayKey];
    if (workoutDay == null) return;

    // Make a copy of the routine list
    final updatedRoutine = [...workoutDay.routine];
    final oldItem = updatedRoutine[index];

    final newItem = RoutineItem(
      type: oldItem.type,
      name: oldItem.name,
      instruction: oldItem.instruction,
      duration: oldItem.duration,
      reps: oldItem.reps,
      isCompleted: isCompleted,
      userNote: oldItem.userNote,
      completedIN: completedInSeconds,
    );

    updatedRoutine[index] = newItem;

    // Build a new WorkoutDay
    final newWorkoutDay = WorkoutDay(
      theme: workoutDay.theme,
      routine: updatedRoutine,
      coachTip: workoutDay.coachTip,
      commonMistake: workoutDay.commonMistake,
      alternative: workoutDay.alternative,
    );

    // Rebuild the workouts map
    final newWorkouts = {
      ...current.workouts,
      dayKey: newWorkoutDay,
    };

    // Create a new WorkoutPlan2 (keeping all other fields)
    final newPlan = WorkoutPlan2(
      planName: current.planName,
      achievement: current.achievement,
      remark1: current.remark1,
      remark2: current.remark2,
      reflectionQuestions: current.reflectionQuestions,
      workouts: newWorkouts,
      startDate: current.startDate,
    );

    _update_exercise_completion(newPlan); // persist & update state
  }
}
