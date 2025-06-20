import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/analytics_controller.dart';

class barGraph extends StatelessWidget {
  const barGraph({
    super.key,
    required this.analytics,
  });

  final WorkoutAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Exercise Completion Rate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Daily percentage of exercises completed', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barGroups: List.generate(7, (i) {
                    return BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                        toY: analytics.dailyCompletionPercentages[i].toDouble(),
                        color: Colors.blue,
                        width: 24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ]);
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < analytics.orderedDays.length) {
                            return Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(analytics.orderedDays[index].shortDay(),
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today: ${analytics.todayAverageCompletion}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Average: ${analytics.weeklyAverageCompletion}%', style: const TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

