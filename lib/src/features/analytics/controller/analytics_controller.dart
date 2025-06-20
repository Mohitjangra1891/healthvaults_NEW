import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../modals/WeeklyWorkoutPlan.dart';
import '../controller/analytics_controller.dart';
import '../repo/anaytics_repo.dart';
class WorkoutAnalytics {
  final int todayWorkoutTime;
  final int weeklyWorkoutTime;
  final int weeklyCompletedExercises;
  final int activeDays;
  final int todayAverageCompletion;
  final int weeklyAverageCompletion;
  final int currentStreak;
  final List<int> dailyCompletionPercentages;
  final List<double> dailyWorkoutMinutes;
  final List<String> orderedDays; // NEW FIELD

  WorkoutAnalytics({
    required this.todayWorkoutTime,
    required this.weeklyWorkoutTime,
    required this.weeklyCompletedExercises,
    required this.activeDays,
    required this.todayAverageCompletion,
    required this.weeklyAverageCompletion,
    required this.currentStreak,
    required this.dailyCompletionPercentages,
    required this.dailyWorkoutMinutes,
    required this.orderedDays,

  });
}
String formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final secs = seconds % 60;

  if (minutes == 0) return "${secs}s";
  if (secs == 0) return "${minutes}m";
  return "${minutes}m ${secs}s";
}
extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
  String shortDay() => capitalize().substring(0, 3);
}
final workoutAnalyticsProvider = Provider.family<WorkoutAnalytics, WorkoutPlan2?>((ref, plan) {
  final todayKey = DateFormat('EEEE').format(DateTime.now());

  int todayWorkoutTime = 0;
  int todayAverageCompletion = 0;

  int totalWorkoutTime = 0;
  int completedExercises = 0;
  int totalExercises = 0;
  int activeDays = 0;
  int daysWith100PercentCompletion = 0;

  List<int> dailyCompletionPercentages = [];
  List<double> dailyWorkoutMinutes = [];
  List<String> orderedDays = [];

  // Gather existing workout day keys in the stored order
  final allDays = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];

  if (plan == null || plan.workouts.isEmpty) {
    return WorkoutAnalytics(
      todayWorkoutTime: 0,
      weeklyWorkoutTime: 0,
      weeklyCompletedExercises: 0,
      activeDays: 0,
      todayAverageCompletion: 0,
      weeklyAverageCompletion: 0,
      currentStreak: 0,
      dailyCompletionPercentages: List.filled(7, 0),
      dailyWorkoutMinutes: List.filled(7, 0.0),
      orderedDays: allDays,
    );
  }

  // Reorder allDays based on the first key in plan.workouts
  String startDay = plan.workouts.keys.first;
  int startIndex = allDays.indexOf(startDay);
  final reorderedDays = [
    ...allDays.sublist(startIndex),
    ...allDays.sublist(0, startIndex)
  ];

  for (String day in reorderedDays) {
    final workout = plan.workouts[day];
    final routine = workout?.routine ?? [];
    // print('Day: $day → Total: ${routine.length}');

    for (final e in routine) {
      // print('  ${e.name}: completed=${e.isCompleted}, time=${e.completedIN}');
    }
    final dayTotal = routine.length;
    final dayCompleted = routine.where((e) => e.isCompleted).length;
    final dayTimeSecs = routine.where((e) => e.isCompleted).fold(0, (sum, e) => sum! + e.completedIN);
    final dayTimeMins = dayTimeSecs / 60.0;

    dailyCompletionPercentages.add(dayTotal > 0 ? ((dayCompleted / dayTotal) * 100).round() : 0);
    dailyWorkoutMinutes.add(dayTimeMins);
    orderedDays.add(day);

    totalExercises += dayTotal;
    completedExercises += dayCompleted;
    totalWorkoutTime += dayTimeSecs;

    if (dayCompleted > 0) activeDays++;
    if (dayTotal > 0 && dayCompleted == dayTotal) daysWith100PercentCompletion++;

    if (day == todayKey) {
      todayWorkoutTime = dayTimeSecs;
      todayAverageCompletion = dayTotal > 0
          ? ((dayCompleted / dayTotal) * 100).round()
          : 0;
    }
  }

  final weeklyAverageCompletion = totalExercises > 0
      ? ((completedExercises / totalExercises) * 100).round()
      : 0;
  for (int i = 0; i < reorderedDays.length; i++) {
    // print('${reorderedDays[i]} → ${dailyWorkoutMinutes[i].toStringAsFixed(2)} min');
  }

  return WorkoutAnalytics(
    todayWorkoutTime: todayWorkoutTime,
    weeklyWorkoutTime: totalWorkoutTime,
    weeklyCompletedExercises: completedExercises,
    activeDays: activeDays,
    todayAverageCompletion: todayAverageCompletion,
    weeklyAverageCompletion: weeklyAverageCompletion,
    currentStreak: daysWith100PercentCompletion,
    dailyCompletionPercentages: dailyCompletionPercentages,
    dailyWorkoutMinutes: dailyWorkoutMinutes,
    orderedDays: orderedDays,
  );
});
