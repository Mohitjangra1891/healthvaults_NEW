import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/exerciseCard.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/progressCard.dart';
import 'package:healthvaults/src/modals/WeeklyWorkoutPlan.dart';
import 'package:healthvaults/src/utils/router.dart';
import 'package:intl/intl.dart';

import '../../../common/views/widgets/logoWithTextNAme.dart';
import '../../../res/appImages.dart';
import '../../../res/const.dart';
import '../../plan/widgets/ask_yourSelf_card.dart';
import 'demoExercise/exerciseDetailScreen.dart';

class NewTodaysTaskScreen extends ConsumerWidget {
  final WorkoutPlan2 workoutPlan;

//
  const NewTodaysTaskScreen({super.key, required this.workoutPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = workoutPlan.todayTotalExercises;
    final done = workoutPlan.todayCompletedExercises;
    final todayKey = DateFormat('EEEE').format(DateTime.now());
    final todayWorkout = workoutPlan.todayWorkout;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // If week one is completed:
    if (workoutPlan.isWeekOneCompleted) {
      return Center(
        child: Text(
          "Week One Completed 🎉",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            (todayWorkout == null || todayWorkout.routine.isEmpty)
                ? Column(
                    children: [
                      NoTAskProgressCard(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          'No exercises for today, you can take a walk or do light stretching for active recover!',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      )
                    ],
                  )
                : Column(
                    spacing: 12,
                    children: [
                      InkWell(
                        onTap: () {
                          context.pushNamed(routeNames.Mygoalscreen);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workoutPlan.planName,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                todayWorkout.theme,
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: CupertinoColors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ProgressCard(
                        totalTask: total,
                        completed: done,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  // Prevent inner scroll
                                  shrinkWrap: true,
                                  itemCount: todayWorkout.routine.length,
                                  itemBuilder: (context, index) {
                                    final ex = todayWorkout.routine[index];
                                    // log(ex.toJson().toString());

                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: ExerciseCard4(
                                        exercise: ex,
                                        onStart: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DemoScreen(
                                                currentIndex: index,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      tipCards(
                        todayWorkout: todayWorkout,
                      ),
                      AskYourselfCard(
                        reflectionQuestions: workoutPlan.reflectionQuestions,
                      ),
                      ExpandableText(
                        text: DISCLAIMER,
                        style: TextStyle(fontWeight: FontWeight.w400),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      logoWithTextName(),
                      const SizedBox(height: 20),
                    ],
                  ),

   
          ],
        ),
      ),
    );
  }
}

class tipCards extends StatelessWidget {
  const tipCards({super.key, required this.todayWorkout});

  final WorkoutDay todayWorkout;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      spacing: 14,
      children: [
        card(screenWidth, context, "Alternative", todayWorkout.alternative, appImages.alternateExercise),
        card(screenWidth, context, "Common Mistakes", todayWorkout.commonMistake, appImages.commonMistake),
        card(screenWidth, context, "Coach Tips", todayWorkout.coachTip, appImages.coachTip),
      ],
    );
  }

  Widget card(double screenWidth, BuildContext context, String title, String subt, String img) {
    return Card(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.12,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Icon(
                    Icons.headset,
                    color: Colors.blue,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(child: Text(subt ,maxLines: 4,)),
            ],
          ),
        ));
  }
}
