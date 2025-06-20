import 'package:flutter/material.dart';

class AskYourselfCard extends StatelessWidget {
  const AskYourselfCard({
    super.key,
    required this.reflectionQuestions,
  });

  final List<String> reflectionQuestions;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 220,
        // color: Colors.cyan[100],

        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
        ),
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
                  'Ask to yourself',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: reflectionQuestions.length,
                itemBuilder: (context, i) => Container(
                  width: screenWidth * 0.70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      reflectionQuestions[i],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
