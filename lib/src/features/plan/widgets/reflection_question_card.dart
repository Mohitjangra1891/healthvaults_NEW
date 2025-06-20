import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReflectionQuestionsTile extends StatelessWidget {
  final String title;
  final List<String> questions;

  const ReflectionQuestionsTile({
    super.key,
    required this.title,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          childrenPadding: EdgeInsets.all(0),
          expandedAlignment: Alignment.centerLeft,
          title: Row(
            spacing: 12,
            children: [
              Icon(
                CupertinoIcons.question_square_fill,
                color: Colors.blue,
              ),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                questions.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "${index + 1}. ${questions[index]}",
                    textAlign: TextAlign.left, // ✅ fix: force left alignment

                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
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
