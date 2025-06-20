import 'package:flutter/material.dart';

import '../../modals/WeeklyWorkoutPlan.dart';

class ExerciseCard extends StatefulWidget {
  final RoutineItem exercise;
  final bool isExpanded;
  final VoidCallback onTap;
  final int index;

  const ExerciseCard({
    required this.exercise,
    required this.isExpanded,
    required this.onTap,
    required this.index,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final circleColor = isDark ? Colors.white : Colors.blue;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      // ✅ required!
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // boxShadow: [
          //   if (!isDark)
          //     BoxShadow(
          //       color: Colors.black12,
          //       blurRadius: 6,
          //       offset: Offset(0, 2),
          //     ),
          // ],
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(0),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row with number and title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: circleColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${widget.index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.exercise.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (widget.exercise.duration != null) Text('Duration: ${widget.exercise.duration!}'),
                          if (widget.exercise.reps != null) Text('Reps: ${widget.exercise.reps!}'),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: widget.isExpanded ? 0.5 : 0,
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),

                if (widget.isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      children: [
                        Divider(),
                        Text(widget.exercise.instruction),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
