// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../modals/firebase_workoutData_modal.dart';
// final workoutRepoProvider = Provider((ref) => WorkoutRepository());
//
// class WorkoutRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> saveWorkoutPlan(FirebaseWorkoutdataModal plan) async {
//     final docRef = _firestore
//         .collection('users')
//         .doc(plan.userId)
//         .collection('workoutdata')
//         .doc(plan.id.toString()); // or use a UUID
//
//     await docRef.set({'data': plan.toMap()});
//   }
//
//   Future<FirebaseWorkoutdataModal?> fetchWorkoutPlan(String userId, int planId) async {
//     final doc = await _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('workoutdata')
//         .doc(planId.toString())
//         .get();
//     if (doc.exists) {
//       final data = doc.data()?['data'];
//       return FirebaseWorkoutdataModal.fromMap(Map<String, dynamic>.from(data));
//     } else {
//       return null;
//     }
//   }
// }
//
