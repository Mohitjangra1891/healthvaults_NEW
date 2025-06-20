
import 'package:flutter/material.dart';


class AchievementCard extends StatelessWidget {
  final String goal;
  final String remark1;
  final String remark2;

  const AchievementCard({
    required this.goal,
    required this.remark1,
    required this.remark2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.wallet_giftcard_rounded,
            color: Colors.blue,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Goal Achievement',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            goal,
            style: const TextStyle(fontSize: 16),
          ),
          Divider(color: Colors.black,),
          Text(
            remark1,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            remark2,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

