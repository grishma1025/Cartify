import 'dart:async';
import 'package:flutter/material.dart';
import 'user_type_screen.dart';

/// Splash Screen
/// This screen appears for 3 seconds when app starts
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds and navigate to next screen
    Timer(const Duration(seconds: 3), () {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserTypeScreen(),
        ),
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Light refreshing green background
      backgroundColor: const Color(0xFFD9F99D),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // Circular Logo Container
            Container(
              height: 180,
              width: 180,

              decoration: BoxDecoration(
                color: const Color(0xFF6CC51D),
                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
                ],
              ),

              child: const Center(
                child: Text(
                  "CARTIFY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // Tagline
            const Text(
              "AUTOMATING YOUR EVERYDAY\nSHOPPING!!",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 50),

            // Loading Indicator
            const CircularProgressIndicator(
              color: Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }
}