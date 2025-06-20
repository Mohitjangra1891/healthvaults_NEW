import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyWorkoutLineChart extends StatelessWidget {
  final List<double> dailyWorkoutMinutes;
  final int todayWorkoutTime;
  final int weeklyWorkoutTime;

  const WeeklyWorkoutLineChart({
    super.key,
    required this.dailyWorkoutMinutes,
    required this.todayWorkoutTime,
    required this.weeklyWorkoutTime,
  });

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes == 0) return "${secs}s";
    if (secs == 0) return "${minutes}m";
    return "${minutes}m ${secs}s";
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: const Color(0xFFF8F6FB),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daily Workout Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Minutes spent exercising each day', style: TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: (dailyWorkoutMinutes.reduce((a, b) => a > b ? a : b).toDouble() + 2).clamp(5, 60),

                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, _) {
                            int day = value.toInt() + 1;
                            if (day < 1 || day > 7) return const SizedBox.shrink();
                            return Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text('Day $day', style: const TextStyle(fontSize: 12 ,fontWeight: FontWeight.w500)));
                          },
                          interval: 1,
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(dailyWorkoutMinutes.length, (i) {
                          return FlSpot(i.toDouble(), dailyWorkoutMinutes[i]);
                        }),
                        isCurved: false, // ✅ makes the line sharp (no rounded edges)
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],

                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today: ${formatTime(todayWorkoutTime)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Average: ${formatTime(weeklyWorkoutTime)}', style: const TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

