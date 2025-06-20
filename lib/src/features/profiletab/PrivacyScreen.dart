
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to HealthVaults!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Text(
              "HealthVaults is committed to protecting your privacy. Our app collects your personal information — such as age, weight, height, workout preferences, and goals — to create a personalized workout plan using advanced AI technology.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            const Text(
              "We use your data solely for tailoring workouts and tracking your fitness journey. Your information is never sold to third parties.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            const Text(
              "By using HealthVaults, you consent to the collection and use of your personal data as described in this policy.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            const Text(
              "If you have questions or concerns about your privacy, please contact our support team.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF3FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.privacy_tip, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Your Privacy Matters",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "HealthVaults uses your data exclusively to improve your fitness experience. Your workout data stays secure and is never sold to third parties.",
                          style: TextStyle(fontSize: 14.5),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
