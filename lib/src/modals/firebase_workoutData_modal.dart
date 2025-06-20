import 'dart:convert';

import 'WeeklyWorkoutPlan.dart';

class FirebaseWorkoutdataModal {
  final String achievement;
  final int id;
  final String model;
  final String planName;
  final List<String> reflectionQuestions;
  final String remark1;
  final String remark2;
  final String startDate;
  final int startDay;
  final String user;
  final String userId;
  final int week;

  FirebaseWorkoutdataModal({
    required this.achievement,
    required this.id,
    required this.model,
    required this.planName,
    required this.reflectionQuestions,
    required this.remark1,
    required this.remark2,
    required this.startDate,
    required this.startDay,
    required this.user,
    required this.userId,
    required this.week,
  });

  Map<String, dynamic> toMap() {
    return {
      'achievement': achievement,
      'id': id,
      'model': model,
      'planName': planName,
      'reflectionQuestions': reflectionQuestions,
      'remark1': remark1,
      'remark2': remark2,
      'startDate': startDate,
      'startDay': startDay,
      'user': user,
      'userId': userId,
      'week': week,
    };
  }

  factory FirebaseWorkoutdataModal.fromMap(Map<String, dynamic> map) {
    return FirebaseWorkoutdataModal(
      achievement: map['achievement'],
      id: map['id'],
      model: map['model'],
      planName: map['planName'],
      reflectionQuestions: List<String>.from(map['reflectionQuestions']),
      remark1: map['remark1'],
      remark2: map['remark2'],
      startDate: map['startDate'],
      startDay: map['startDay'],
      user: map['user'],
      userId: map['userId'],
      week: map['week'],
    );
  }
}

// 🔁 Extension to convert WorkoutPlan2 to Firebase Model
extension FirebaseMapper on WorkoutPlan2 {
  FirebaseWorkoutdataModal toFirebaseModel(String userId) {
    return FirebaseWorkoutdataModal(
      model: json.encode(toJson()), // Convert your plan to JSON string
      userId: userId,
      planName: planName,
      achievement: achievement,
      remark1: remark1,
      remark2: remark2,
      reflectionQuestions: reflectionQuestions,
      week: 1, // Optional, calculate dynamically if needed
      startDate: startDate.toIso8601String(), id: 1, startDay: 1, user: '',
    );
  }
}

