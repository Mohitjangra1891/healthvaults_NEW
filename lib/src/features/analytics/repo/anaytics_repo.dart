// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// import '../../../modals/sessionModel.dart';
//
// // Models
// class ExerciseSession {
//   final DateTime date;
//   final int totalExercises;
//   final int completedExercises;
//   final int durationMillis; // in milliseconds
//   final int week; // week identifier, e.g., year-weekNumber
//
//   ExerciseSession({
//     required this.date,
//     required this.totalExercises,
//     required this.completedExercises,
//     required this.durationMillis,
//     required this.week,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'date': date.toIso8601String(),
//     'totalExercises': totalExercises,
//     'completedExercises': completedExercises,
//     'durationMillis': durationMillis,
//     'week': week,
//   };
//
//   factory ExerciseSession.fromJson(Map<String, dynamic> json) {
//     return ExerciseSession(
//       date: DateTime.parse(json['date']),
//       totalExercises: json['totalExercises'],
//       completedExercises: json['completedExercises'],
//       durationMillis: json['durationMillis'],
//       week: json['week'],
//     );
//   }
// }
// int getWeekId(DateTime date) {
//   // ISO week calculation
//   final wednesday = date.add(Duration(days: (3 - date.weekday)));
//   final firstThursday = DateTime(wednesday.year, 1, 4);
//   final weekNumber = 1 + ((wednesday.difference(firstThursday).inDays) ~/ 7);
//   return date.year * 100 + weekNumber;
// }
//
// String formatDuration(int millis) {
//   final secondsTotal = millis ~/ 1000;
//   final hours = secondsTotal ~/ 3600;
//   final minutes = (secondsTotal % 3600) ~/ 60;
//   final seconds = secondsTotal % 60;
//   if (hours > 0) {
//     return '${hours}h ${minutes}m';
//   } else if (minutes > 0) {
//     return '${minutes}m ${seconds}s';
//   } else {
//     return '${seconds}s';
//   }
// }
//
//
// // Repository to manage storage (Hive for sessions, SharedPreferences placeholder if needed)
// class AnalyticsRepository {
//   static const _sessionsBox = 'exercise_sessions_box';
//   Box<ExerciseSessionHive>? _box;
//
//   Future<void> init() async {
//     if (!Hive.isAdapterRegistered(100)) {
//       Hive.registerAdapter(ExerciseSessionHiveAdapter());
//     }
//     if (!Hive.isBoxOpen(_sessionsBox)) {
//       _box = await Hive.openBox<ExerciseSessionHive>(_sessionsBox);
//     } else {
//       _box = Hive.box<ExerciseSessionHive>(_sessionsBox);
//     }
//   }
//
//   Future<List<ExerciseSession>> loadAllSessions() async {
//     if (_box == null) await init();
//     return _box!.values.map((h) => h.toModel()).toList();
//   }
//
//   Future<void> saveSession(ExerciseSession session) async {
//     if (_box == null) await init();
//     // Identify by date: store one per date
//     final existingKey = _box!.keys.cast<int?>().firstWhere(
//             (key) {
//           final h = _box!.get(key);
//           if (h == null) return false;
//           return h.date.year == session.date.year && h.date.month == session.date.month && h.date.day == session.date.day;
//         },
//         orElse: () => null);
//     final hiveObj = ExerciseSessionHive.fromModel(session);
//     if (existingKey != null) {
//       await _box!.put(existingKey, hiveObj);
//     } else {
//       await _box!.add(hiveObj);
//     }
//   }
// }
