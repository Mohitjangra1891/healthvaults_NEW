import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/healthTab/views/healthTabScreen.dart';
import 'package:healthvaults/src/utils/router.dart';

import 'features/analytics/views/analytics_screen2.dart';
import 'features/profiletab/myProfileScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isBottomBarVisible = true;
  DateTime? _lastBackPressed;

  final List<Widget> _tabs = [healthTabScreen(), AnalyticsScreen2(), MyProfilePage()];
  final List<String> _titles = [
    "Workouts",
    "Analytics",
    "Profile",
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleBackPress(BuildContext context) async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return;
    }

    final now = DateTime.now();
    if (_lastBackPressed == null || now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Press back again to exit')),
      );
      return;
    }

    // Exit the app
    SystemNavigator.pop();
  }
  void _onMenuSelected(String value) {
    if (value == 'change') {

      context.pushNamed(routeNames.SetYourGoalScreen);

    } else if (value == 'show') {
      context.pushNamed(routeNames.Mygoalscreen);

    }
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _handleBackPress(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(_titles[_currentIndex]),
          actions: [
            PopupMenuButton<String>(
              onSelected: _onMenuSelected,
              offset: const Offset(0, 40), // shows below dot
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'change',
                  child: Row(
                    children: const [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text("Change My Workout Plan"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'show',
                  child: Row(
                    children: const [
                      Icon(Icons.remove_red_eye_outlined, size: 20),
                      SizedBox(width: 8),
                      Text("Show My Workout Plan"),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
        bottomNavigationBar: AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          offset: _isBottomBarVisible ? Offset.zero : const Offset(0, 1),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center_outlined), label: 'Plan'),
              BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Analytics'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
