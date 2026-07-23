import 'package:cartify/screens/auth_wrapper.dart';
import 'package:cartify/screens/phone_login_screen.dart';
import 'package:cartify/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin_login_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Image.asset(
                "assets/images/cartify_logo.png",
                height: 145,
              ),

              const SizedBox(height: 30),

              Text(
                "Welcome to Cartify",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Continue to automate your daily shopping",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 50),

              // PHONE LOGIN

              SizedBox(
                width: double.infinity,
                height: 54,

                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF4B66FF),
                        Color(0xFFB144FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PhoneLoginScreen(),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.phone_android,
                      color: Colors.white,
                      size: 22,
                    ),

                    label: Text(
                      "Continue with phone",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // GOOGLE LOGIN

              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,

                    side: const BorderSide(
                      color: Color(0xFFE5E5E5),
                      width: 1,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {

                    final userCredential =
                    await AuthService().signInWithGoogle();

                    if (userCredential != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AuthWrapper(),
                        ),
                      );
                    }
                  },

                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                    width: 24,
                  ),

                  label: Text(
                    "Continue with Google",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // OR DIVIDER

              Row(
                children: [

                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12),

                    child: Text(
                      "OR",
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // GUEST LOGIN

              TextButton(
                onPressed: () async {

                  final userCredential =
                  await AuthService()
                      .signInAnonymously();

                  if (userCredential != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AuthWrapper(),
                      ),
                    );
                  }
                },

                child: Text(
                  "Continue as Guest",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4B66FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AdminLoginScreen(),
                    ),
                  );
                },

                child: Text(
                  "Are you an Admin? Login",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFB144FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}