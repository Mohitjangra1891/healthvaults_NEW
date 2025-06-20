import 'package:flutter/material.dart';

class CoachCard extends StatelessWidget {
  final String title;
  final String img;
  final String text;

  const CoachCard({required this.title, required this.text, required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            alignment: Alignment.center,
            child: Column(
              spacing: 12,
              children: [
                Image.asset(img),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}


