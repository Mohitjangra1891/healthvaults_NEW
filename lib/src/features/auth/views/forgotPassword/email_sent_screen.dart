
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/utils/router.dart';
class email_sent_screen extends StatelessWidget {
 final String email;
  const email_sent_screen({super.key ,required this.email});
 @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 42,
              children: [
                SizedBox(
                  height: screenHeight * 0.12,
                ),
                Icon(
                  Icons.check_circle_sharp,
                  color: Colors.blue,
                  size: 48,
                ),
                Text(
                  "Check Your Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                Text(
                  "We have sent a password reset link to",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              Text(
                  "$email",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19 ,color: Colors.blue),
                ),
              Text(
                  "Please check your inbox and click on the link to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),

                ElevatedButton(
                    onPressed: (){context.goNamed(routeNames.login);},
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(screenWidth, screenHeight * 0.06),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(8)),
                    child:Text(
                      "Go to Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}