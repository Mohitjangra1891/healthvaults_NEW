import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthvaults/src/common/views/widgets/logoWithTextNAme.dart';
import 'package:healthvaults/src/res/appImages.dart';

import '../../features/plan/widgets/ask_yourSelf_card.dart';
import '../../features/plan/widgets/coach_card.dart';
import '../../features/plan/widgets/goal_card.dart';
import '../../features/plan/widgets/reflection_question_card.dart';
import '../../modals/WeeklyWorkoutPlan.dart';
import '../../res/const.dart';

class WorkoutPlanScreen extends StatefulWidget {
  final WorkoutPlan2 plan;

  const WorkoutPlanScreen({Key? key, required this.plan}) : super(key: key);


  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {

  static const _dayOrder = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  String? selectedDay;
  int? expandedExerciseIndex;

  @override
  Widget build(BuildContext context) {
    // Build an ordered list of entries from the map
    final entries = <MapEntry<String, WorkoutDay>>[];
    for (var day in _dayOrder) {
      if (widget.plan.workouts.containsKey(day)) {
        entries.add(MapEntry(day, widget.plan.workouts[day]!));
      }
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Week Title
          Container(
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            child: Column(
              children: [
                Text(
                  "WeeK 1",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.plan.planName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Workouts Section
          const Text('Select Workout Day', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Column(
            children: entries
                .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ExerciseCard(dayKey: e.key, day: e.value),
                    ))
                .toList(),
          ),
          const Text('Word From Coach', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // Coach Remarks + Achievement
          Container(
            decoration: BoxDecoration(
              color: Colors.cyan[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                          child: CoachCard(
                        title: 'Remark 1',
                        text: widget.plan.remark1,
                        img: appImages.remark_1,
                      )),
                      const SizedBox(width: 12),
                      Expanded(
                          child: CoachCard(
                        title: 'Remark 2',
                        text: widget.plan.remark2,
                        img: appImages.remark_2,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AchievementCard(goal: widget.plan.achievement, remark1: widget.plan.remark1, remark2: widget.plan.remark2),
              ],
            ),
          ),
          ReflectionQuestionsTile(
            title: "Reflection Questions",
            questions: [
              "What went well today?",
              "What could I improve tomorrow?",
              "Did I stick to my plan?",
            ],
          ),
          // Reflection Questions
          AskYourselfCard(reflectionQuestions: widget.plan.reflectionQuestions),
          const SizedBox(height: 24),
          logoWithTextName(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}


class ExerciseCard extends StatefulWidget {
  final String dayKey;
  final WorkoutDay day;

  const ExerciseCard({Key? key, required this.dayKey, required this.day}) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 700),
        curve: Curves.elasticOut,
        child: _isExpanded ? _buildExpanded() : _buildCollapsed(),
      ),
    );
  }

  Widget _buildExpanded() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.cyan[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.dayKey.substring(0, 3), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(widget.day.theme, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    SvgPicture.asset(
                      Constants.getWorkoutIcon(widget.dayKey),
                      height: 50,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.day.routine
                        .map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(r.instruction)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsed() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(color: Colors.cyan[200], borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Text(widget.dayKey.substring(0, 3), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(width: 16),
            Expanded(child: Text("${widget.day.theme} ${widget.dayKey}")),
            Container(
              width: 42,
              height: 42,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
              child: SvgPicture.asset(
                Constants.getWorkoutIcon(widget.dayKey),
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
