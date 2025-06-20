import 'package:flutter/material.dart';
import 'package:healthvaults/src/features/auth/views/widgets/signIn.dart';
import 'package:healthvaults/src/features/auth/views/widgets/signUp.dart';

//
// class LoginScreen extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   bool chechBoxValue = true;
//   final TextEditingController _phoneController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late String phoneNumber;
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final authState = ref.watch(authProvider);
//
//     ref.listen(authProvider, (prev, next) {
//       if (next is OTPSent) {
//         context.push("${routeNames.otpVerify}/${_phoneController.text}");
//
//         // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerificationScreen(phoneNumber: _phoneController.text)));
//       } else if (next is AuthError) {
//
//         showToast(next.message);
//
//         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
//       }
//     });
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.03, vertical: screenHeight * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.asset(
//                 'assets/logo.png', // Replace with your logo asset
//                 height: 60,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Welcome Back!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//               const Text(
//                 'Keep Your Health Documents Secured.',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 24),
//               Center(
//                 child: Image.asset(
//                   'assets/loginBG.png',
//                   height: screenHeight * 0.4,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Form(
//                 key: _formKey,
//                 child: IntlPhoneField(
//                   controller: _phoneController,
//                   // disableLengthCheck: true,
//                   flagsButtonPadding: const EdgeInsets.all(8),
//                   dropdownIconPosition: IconPosition.trailing,
//                   decoration: InputDecoration(
//                     hintText: 'Mobile Number',
//                     hintStyle: TextStyle(fontSize: 12, color: Color.fromRGBO(204, 204, 204, 1), fontWeight: FontWeight.w400),
//
//                     // No border
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: AppColors.primaryColor),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: AppColors.primaryColor),
//                     ),
//                     disabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                   ),
//                   initialCountryCode: 'IN',
//                   showCursor: true,
//                   showDropdownIcon: true,
//                   onChanged: (phone) {
//                     print(phone.completeNumber);
//                     phoneNumber = phone.completeNumber;
//                   },
//                   validator: (value) {
//                     if (value == null || value.number.isEmpty) {
//                       return 'Please enter your phone number';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//               Center(
//                 child: const Text(
//                   'We\'ll send you an otp to verify this\n mobile number.',
//                   style: TextStyle(fontSize: 12),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               authState is AuthLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: button_Primary(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               ref.read(authProvider.notifier).sendOtp(phoneNumber);
//                               print("sending otp to ${phoneNumber}");
//                               //
//                             } else {
//                               print("Validation failed");
//                             }
//                           },
//                           title: "Continue"),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//

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
