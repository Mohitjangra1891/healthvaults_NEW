import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../modals/WeeklyWorkoutPlan.dart';
import '../../../../res/const.dart';

class ExerciseCard4 extends ConsumerWidget {
  final RoutineItem exercise;
  final VoidCallback onStart;

  const ExerciseCard4({
    super.key,
    required this.exercise,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 🐞 Debug print inside widget:
    // debugPrint('Building Card → type: $title, title: $value, subtitle: ${exercise['duration'] ?? ""}, reps: ${exercise['reps'] ?? " np repa"}');

    return Material(
      elevation: 0,
      color: Colors.white70,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onStart,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Constants.getTaskIcon2(exercise.type),
                            color: Colors.blue,
                          ),
                          Text(
                            exercise.type,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 12,),
                          if (exercise.isCompleted)
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.green,
                            ),
                          if (exercise.isCompleted)
                            Text(
                              "DONE",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      ExpandableText(
                        text: exercise.name.split('(').first.trim(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration:exercise.isCompleted? TextDecoration.lineThrough: null,

                        ),
                      ),
                      Expanded(
                        child: Text(
                          exercise.reps ?? exercise.duration ?? " ",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.stopwatch_fill,
                      color: Colors.blue,
                    ),
                    Text(
                      " ${exercise.completedIN}s",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  final TextStyle style;

  const ExpandableText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines = 2,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: _isExpanded ? null : widget.maxLines,
        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }
}
