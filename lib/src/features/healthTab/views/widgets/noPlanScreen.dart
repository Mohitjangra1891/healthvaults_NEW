import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../../res/appColors.dart';

class FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

final features = [
  FeatureItem(
    icon: Icons.bolt,
    title: "AI-Powered Planning",
    subtitle: "Our intelligent system creates personalized workout plans based on your preferences, goals, and fitness level.",
  ),
  FeatureItem(
    icon: Icons.timeline,
    title: "Adaptive Progress",
    subtitle: "Your workout plan evolves weekly based on your performance, ensuring continuous improvement.",
  ),
  FeatureItem(
    icon: Icons.schedule,
    title: "Weekly Structure",
    subtitle: "Get a complete 7-day workout schedule that fits your lifestyle and available time.",
  ),
  FeatureItem(
    icon: Icons.auto_graph,
    title: "Smart Tracking",
    subtitle: "Monitor your progress and let our AI adjust future plans for optimal results.",
  ),
];

class noPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : AppColors.primaryColor;
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, right: 24, left: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Welcome to your fitness journey!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            SizedBox(height: 12),
            Text(
              "Get ready to transform your fitness routine with AI-powered workout plans tailored just for you.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 42),
            Text(
              "What Makes Us Special",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            SizedBox(height: 32),
            ...features.map((f) => FeatureCard(feature: f)).toList(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(routeNames.SetYourGoalScreen);
              },
              icon: const Icon(Icons.auto_fix_high),
              label: const Text(
                'Create My Workout Plan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3A78F2),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(color: Color(0xFFF5F6FA), borderRadius: BorderRadius.circular(12)),
              child: Row(
                spacing: 8,
                children: [
                  const Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                  Expanded(
                    child: Text(
                      "Takes only 2–3 minutes to set up your personalized plan",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final FeatureItem feature;

  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
            child: Icon(
              feature.icon,
              color: Colors.blueAccent,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
