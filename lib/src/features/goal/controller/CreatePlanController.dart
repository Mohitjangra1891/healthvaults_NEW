import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../modals/WeeklyWorkoutPlan.dart';
import '../../../res/const.dart';

class PlanNotifier extends StateNotifier<AsyncValue<WorkoutPlan2?>> {
  // PlanNotifier() : super(const AsyncValue.loading());

  PlanNotifier() : super(const AsyncValue.data(null)); // Default state set to null

  late final ChatSession _chat;
  String _rawModelJson = '';
  String _lastPrompt = '';
  // Initialize Gemini chat session
  void initChatSession() {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: gemini_Api_key,
    );
    _chat = model.startChat();
  }

  Future<void> fetchPlan({required String prompt}) async {
    state = const AsyncValue.loading();
    try {
      _lastPrompt = prompt;

      final response = await _chat.sendMessage(Content.text(prompt));
      final rawText = response.text ?? 'No response.';
      final cleanedJson = rawText.replaceAll(RegExp(r'```json'), '').replaceAll(RegExp(r'```'), '').trim();
      _rawModelJson = cleanedJson;


      final jsonData = json.decode(cleanedJson);
      print(jsonData.toString());
      await jsonData.addAll({'start_date': DateTime.now().toIso8601String()});

      final plan2 = WorkoutPlan2.fromJson(jsonData);
      plan2.workouts.forEach((day, workoutDay) {
        print('--- $day ---');
        print('Theme: ${workoutDay.theme}');
        // for (int i = 0; i < workoutDay.routine.length; i++) {
        //   final item = workoutDay.routine[i];
        //
        //   print('    type: ${item.type}');
        //   print('    Name: ${item.name}');
        //   print('    Instruction: ${item.instruction}');
        //   print('    Reps: ${item.reps}');
        //   print('    Duration: ${item.duration}');
        //   print('    usernote: ${item.userNote}');
        //   print('    idcompleted: ${item.isCompleted}');
        //   print('    completed in: ${item.completedIN}');
        // }
        print('Coach Tip: ${workoutDay.coachTip}');
        print('Common Mistake: ${workoutDay.commonMistake}');
        print('Alternative: ${workoutDay.alternative}');
        print('----------------------\n');
      });
      // log(plan2.workouts.toString());
      // final plan = WorkoutPlan.fromJson(jsonData);

      state = AsyncValue.data(plan2);
    } catch (e, st) {
      log("Error in Creating WorkoutPlan: $e");

      state = AsyncValue.error(e, st);
    }
  }

  String get rawModelJson => _rawModelJson;
  String get lastPrompt => _lastPrompt;
}

final CreatePlan_Provider_Controller = StateNotifierProvider<PlanNotifier, AsyncValue<WorkoutPlan2?>>(
  (ref) => PlanNotifier(),
);
