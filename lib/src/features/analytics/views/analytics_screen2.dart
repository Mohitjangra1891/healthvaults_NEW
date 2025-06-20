import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/analytics/views/widgets/barGraph.dart';
import 'package:healthvaults/src/features/analytics/views/widgets/lineChart.dart';

import '../../healthTab/controller/planController.dart';
import '../controller/analytics_controller.dart';

class AnalyticsScreen2 extends ConsumerWidget {
  const AnalyticsScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(workoutPlanProvider);

    final analytics = ref.watch(workoutAnalyticsProvider(plan));
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row: Current Streak and Weekly Average
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.white),
                          const SizedBox(height: 8),
                          const Text('Current Streak', style: TextStyle(color: Colors.white60)),
                          Text('${analytics.currentStreak} days',
                              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Keep it up! 🔥', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.local_fire_department),
                          const SizedBox(height: 8),
                          const Text('Weekly Average', style: TextStyle(color: Colors.black54)),
                          Text(
                            analytics.weeklyAverageCompletion.toString() + "%",
                          ),
                          const SizedBox(height: 4),
                          const Text('Exercise completion', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Row: Today's workout time and This Week
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Today's", style: TextStyle(color: Colors.black54)),
                          Text(formatTime(analytics.todayWorkoutTime), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Total workout time', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('This Week', style: TextStyle(color: Colors.white70)),
                          Text(formatTime(analytics.weeklyWorkoutTime),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          const Text('Total workout time', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Exercise Completion Rate Chart
            barGraph(analytics: analytics),
            const SizedBox(height: 16),

            WeeklyWorkoutLineChart(
              dailyWorkoutMinutes: analytics.dailyWorkoutMinutes,
              todayWorkoutTime: analytics.todayWorkoutTime,
              weeklyWorkoutTime: analytics.weeklyWorkoutTime,
            )
,
            const SizedBox(height: 16),
            // Weekly Achievement
            Card(
              color: Colors.purple.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.purple),
                        const SizedBox(width: 8),
                        const Text("This Week's Achievement", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text("You're doing great! Keep pushing forward.", style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _AchievementTile(label: 'Days active', value: '${analytics.activeDays}/7'),
                        _AchievementTile(label: 'Minutes total', value: formatTime(analytics.weeklyWorkoutTime)),
                        _AchievementTile(label: 'Exercises completed', value: '${analytics.weeklyCompletedExercises}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final String label;
  final String value;

  const _AchievementTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
