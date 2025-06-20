
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appVersion = '';
  String lastUpdated = 'June 2025'; // You can automate this with real logic if needed

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  Future<void> _getAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  Future<void> _rateUs() async {
    const url = 'https://play.google.com/store/apps/details?id=com.yourapp.id';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _shareApp() {
    Share.share('Check out HealthVaults app: https://play.google.com/store/apps/details?id=com.yourapp.id');
  }

  Widget _infoCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.black54))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About HealthVaults"),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _infoCard(Icons.auto_awesome, "AI-Generated Plans",
                "Get personalized workout plans created by AI based on your performance data"),
            _infoCard(Icons.trending_up, "Progressive Training",
                "Automatically adjust workout intensity and volume based on your improvements"),
            _infoCard(Icons.schedule, "Weekly Planning",
                "Receive new workout plans every week that evolve with your fitness journey"),

            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildAppInfoTile("Version", appVersion),
                  _buildAppInfoTile("Developer", "HealthVaults Team"),
                  _buildAppInfoTile("Category", "Health & Fitness"),
                  _buildAppInfoTile("Last Updated", lastUpdated),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Get in Touch", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _rateUs,
                  icon: const Icon(Icons.star_border),
                  label: const Text("Rate Us"),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: _shareApp,
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                ),
              ],
            ),
            const Spacer(),
            const Text("Made with ❤️ for your fitness journey",
                style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
