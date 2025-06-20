
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCentreScreen extends StatefulWidget {
  const HelpCentreScreen({Key? key}) : super(key: key);

  @override
  State<HelpCentreScreen> createState() => _HelpCentreScreenState();
}

class _HelpCentreScreenState extends State<HelpCentreScreen> {
  int? expandedIndex;

  final List<Map<String, String>> faqList = [
    {
      'question': 'How does the AI create my workout plans?',
      'answer':
      'Our AI analyzes your previous week\'s performance, fitness level, and goals to create personalized weekly workout plans.',
    },
    {
      'question': 'Can I modify the suggested workouts?',
      'answer':
      'Yes, you can customize the workouts manually to better suit your preferences or constraints.',
    },
    {
      'question': 'How often are workout plans updated?',
      'answer':
      'New workout plans are generated every week based on your progress and performance from the previous week.',
    },
    {
      'question': 'Is my workout data secure?',
      'answer':
      'Yes, your data is stored securely and handled in accordance with our privacy policies.',
    },
  ];
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'jangramohit18912@gmail.com', // your target email
      query: Uri(queryParameters: {
        'subject': 'Support Request',
        'body': 'Hello, I need help with...',
      }).query,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email apps installed or unable to open email client')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Help Centre"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: const [
                Icon(Icons.help_outline, color: Colors.blue, size: 40),
                SizedBox(height: 8),
                Text(
                  "Need Quick Help?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 4),
                Text("Get instant answers to common questions", textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text("Contact Support", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _launchEmail,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: Row(
                children: const [
                  Icon(Icons.email_outlined, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email Support", style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text("Send us your questions via email", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Frequently Asked Questions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

          // Single card containing all expandable items
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: List.generate(faqList.length, (index) {
                final isExpanded = expandedIndex == index;
                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        expandedIndex = expanded ? index : null;
                      });
                    },
                    initiallyExpanded: isExpanded,
                    title: Text(
                      faqList[index]['question']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    children: [
                      Text(faqList[index]['answer']!),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}