import 'package:flutter/material.dart';
import 'package:healthvaults/src/features/auth/views/widgets/signIn.dart';
import 'package:healthvaults/src/features/auth/views/widgets/signUp.dart';



/// AuthScreen contains a TabController with two tabs: "Sign In" and "Sign Up".
/// It also shows a bottom text that changes based on the selected tab.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Two tabs: 0 = Sign In, 1 = Sign Up
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        // Just to rebuild when the user switches tabs, so bottom text changes
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _inactiveTabColor(BuildContext context) {
    // Slightly tinted background behind the entire tab‐bar area:
    return Theme.of(context).brightness == Brightness.light ? Colors.grey.shade200 : Colors.grey.shade800;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top icon + title + subtitle
                const SizedBox(height: 32),
                Image.asset(
                  'assets/logo.png', // Replace with your logo asset
                  height: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  'HealthVaults',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _tabController.index == 0 ? 'Welcome back! Please sign in to continue' : "Create new account to HealthVaults",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),

                // The white/pick‐tinted "card" with rounded corners
                Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(24),
                  color: isDark ? Colors.black : Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        // BoxShadow(
                        //   color: Colors.black.withOpacity(isLight ? 0.05 : 0.4),
                        //   blurRadius: 12,
                        //   offset: const Offset(0, 4),
                        // ),
                      ],
                    ),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1) The TabBar “card”
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: _inactiveTabColor(context),
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            dividerHeight: 0,
                            controller: _tabController,
                            padding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.zero,
                            indicator: BoxDecoration(
                              color: isDark ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            unselectedLabelColor: isLight ? Colors.grey.shade700 : Colors.grey.shade400,
                            labelStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isLight ? Colors.black : Colors.white,
                            ),
                            unselectedLabelStyle: const TextStyle(fontSize: 16),
                            tabs: [
                              Tab(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                  child: Text("Sign In"),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                  child: Text("Sign Up"),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 2) The content under each tab
                        SizedBox(
                          height: 420, // adjust height if needed
                          child: TabBarView(
                            controller: _tabController,
                            children: const [
                              SignInForm(),
                              SignUpForm(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 3) Bottom text below the “card”
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _tabController.index == 0 ? "Don’t have an account?" : "Already have an account?",
                      style: TextStyle(
                        color: isLight ? Colors.grey.shade700 : Colors.grey.shade400,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Switch tabs when user taps this bottom link
                        final newIndex = _tabController.index == 0 ? 1 : 0;
                        _tabController.animateTo(newIndex);
                      },
                      child: Text(
                        _tabController.index == 0 ? "Sign Up" : "Sign In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
