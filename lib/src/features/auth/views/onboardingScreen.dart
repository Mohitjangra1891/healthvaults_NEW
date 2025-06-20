import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/utils/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;

  List<OnboardData> onboardPages = [
    OnboardData(
        title: 'Welcome to HealthVaults',
        subtitle: 'Your Personal AI Fitness Coach',
        color: Colors.deepPurple,
        buttonColor: Colors.deepPurpleAccent,
        des: 'Transform your fitness journey with intelligent workout planning designed for you.',
        features: ["Personalized\nPlans", "AI\nTechnology", "Progress\nTracking"]),
    OnboardData(
        title: 'AI-Powered Workouts',
        subtitle: 'Smart Plans That Adapt',
        color: Colors.green,
        buttonColor: Colors.greenAccent,
        des: 'Get personalized weekly workout plans that evolve based on your progress and preferences.',
        features: ["Weekly\nUpdates", "Adaptive\nPlanning", "Smart\nRecommend"]),
    OnboardData(
        title: 'Track Your Progress',
        subtitle: 'See Real Results',
        color: Colors.red,
        buttonColor: Colors.redAccent,
        des: 'Monitor your fitness journey with detailed analytics and performance insights.',
        features: ["Detailed\nAnalytics", "Performance\nInsights", "Goal\nMonitoring"]),
    OnboardData(
        title: 'Achieve Your Goals',
        subtitle: 'Stay Motivated',
        color: Colors.orange,
        buttonColor: Colors.orangeAccent,
        des: 'Reach new heights with structured plans, progress tracking, and personalized recommendations.',
        features: ["Structured\nPlans", "Motivation\nTools", "Success\nTracking"]),
  ];

  void completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboard', true);
    context.goNamed(routeNames.login);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.03),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardPages.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: onboardPages[currentPage].color.withOpacity(0.2), // shadow color
                                  spreadRadius: 1, // how wide the shadow spreads
                                  blurRadius: 60, // how soft the shadow is
                                  offset: Offset(0, 0), // (0, 0) makes it spread equally in all directions
                                ),
                              ],
                            ),

                            child: Icon(
                              Icons.emoji_events,
                              size: 100,
                              color: onboardPages[currentPage].color,
                            ),
                          ),
                          SizedBox(height: 40),
                          Text(onboardPages[index].title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(onboardPages[index].subtitle,
                              style: TextStyle(fontSize: 16, color: onboardPages[currentPage].color, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center),
                          SizedBox(height: 20),
                          Text(onboardPages[index].des, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                          SizedBox(height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: onboardPages[index].features.map((feature) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color:  onboardPages[index].color.withOpacity(0.1), // background color
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  feature,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:  onboardPages[index].color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          )

                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(onboardPages.length, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      width: currentPage == index ? 24 : 8,
                      height: currentPage == index ? 8 : 8,
                      decoration: BoxDecoration(
                          color: currentPage == index ? onboardPages[currentPage].color : Colors.grey, borderRadius: BorderRadius.circular(4)),
                    );
                  }),
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth, screenHeight * 0.06),
                    backgroundColor: onboardPages[currentPage].buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    if (currentPage == onboardPages.length - 1) {
                      completeOnboarding();
                    } else {
                      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                    }
                  },
                  child: Text(
                    currentPage == onboardPages.length - 1 ? 'Get Started' : 'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 20,
              child: TextButton(
                onPressed: completeOnboarding,
                child: Text('Skip', style: TextStyle()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardData {
  final String title;
  final String subtitle;
  final String des;
  final Color color;
  final Color buttonColor;
  final List<String> features;

  OnboardData({
    required this.title,
    required this.subtitle,
    required this.des,
    required this.color,
    required this.buttonColor,
    required this.features,
  });
}
