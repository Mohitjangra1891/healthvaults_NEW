import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/plan/exercise_card.dart';
import 'package:healthvaults/src/features/plan/widgets/goal_card.dart';
import 'package:healthvaults/src/features/plan/widgets/reflection_question_card.dart';

import '../../modals/WeeklyWorkoutPlan.dart';

final selectedDayProvider = StateProvider<String?>((ref) => null);
final expandedExerciseIndexProvider = StateProvider<int?>((ref) => null);

class newWorkoutPlanScreen extends ConsumerWidget {
  final WorkoutPlan2 plan;

  const newWorkoutPlanScreen({required this.plan});

  static const _dayOrder = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final expandedIndex = ref.watch(expandedExerciseIndexProvider);

    final entries = <MapEntry<String, WorkoutDay>>[];
    for (var day in _dayOrder) {
      if (plan.workouts.containsKey(day)) {
        entries.add(MapEntry(day, plan.workouts[day]!));
      }
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Week Title
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            child: Column(
              children: [
                Text(
                  "WeeK 1",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Text(
                  plan.planName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: CupertinoColors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Workouts Section
          const Text('Select Workout Day', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // Day Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: entries.map((entry) {
                final isSelected = entry.key == selectedDay;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(
                      entry.key,
                      style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    ),
                    checkmarkColor: isSelected ? Colors.white : Colors.black,
                    selected: isSelected,
                    selectedColor: Colors.blue.shade400,
                    onSelected: (_) {
                      ref.read(expandedExerciseIndexProvider.notifier).state = null;
                      if (isSelected) {
                        ref.read(selectedDayProvider.notifier).state = null;
                      } else {
                        ref.read(selectedDayProvider.notifier).state = entry.key;
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Exercises List
          if (selectedDay != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Get current WorkoutDay
                    Row(
                      spacing: 12,
                      children: [
                        Icon(
                          Icons.sports_gymnastics,
                          color: Colors.blue,
                        ),
                        Text(
                          plan.workouts[selectedDay]!.theme,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "Workout Routine",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      itemCount: plan.workouts[selectedDay]!.routine.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final exercise = plan.workouts[selectedDay]!.routine[index];
                        final isExpanded = expandedIndex == index;

                        return ExerciseCard(
                          exercise: exercise,
                          isExpanded: isExpanded,
                          index: index,
                          onTap: () {
                            ref.read(expandedExerciseIndexProvider.notifier).state = isExpanded ? null : index;
                          },
                        );
                      },
                    ),

                    tipCard(
                      title: "Coach Tip",
                      des: plan.workouts[selectedDay]!.coachTip,
                      color: Colors.blue.shade50,
                    ),
                    tipCard(
                      title: "Common Mistake",
                      des: plan.workouts[selectedDay]!.commonMistake,
                      color: Colors.orange.shade50,
                    ),
                    tipCard(
                      title: "Alternative",
                      des: plan.workouts[selectedDay]!.alternative,
                      color: Colors.pink.shade50,
                    ),
                  ],
                ),
              ),
            ),

          AchievementCard(goal: plan.achievement, remark1: plan.remark1, remark2: plan.remark2),
          ReflectionQuestionsTile(
            title: "Reflection Questions",
            questions: [
              "What went well today?",
              "What could I improve tomorrow?",
              "Did I stick to my plan?",
            ],
          ),
        ],
      ),
    );
  }
}

class tipCard extends StatelessWidget {
  final String title;
  final String des;
  final Color color;

  const tipCard({super.key, required this.title, required this.des, required this.color});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 0,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.transfer_within_a_station,
              color: Colors.black,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    des,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
