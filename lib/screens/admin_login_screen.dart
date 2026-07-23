import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard_screen.dart';
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() =>
      _AdminLoginScreenState();
}

class _AdminLoginScreenState
    extends State<AdminLoginScreen> {


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  Future<void> adminLogin() async {

    try {

      QuerySnapshot snapshot =
      await FirebaseFirestore.instance
          .collection('admin')
          .where(
        'email',
        isEqualTo:
        emailController.text.trim(),
      )
          .where(
        'password',
        isEqualTo:
        passwordController.text.trim(),
      )
          .get();

      if (snapshot.docs.isNotEmpty) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const AdminDashboardScreen(),
          ),
        );

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Invalid Email or Password",
            ),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(24),

          child: Column(

            children: [

              const SizedBox(height: 60),

              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.shade50,

                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 50,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Admin Login",

                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Login to access the admin dashboard",

                textAlign: TextAlign.center,

                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 40),

              buildTextField(
                controller: emailController,
                hint: "Admin Email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,

                style: GoogleFonts.poppins(
                  fontSize: 13,
                ),

                decoration: InputDecoration(
                  hintText: "Password",

                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                  ),

                  prefixIcon:
                  const Icon(Icons.lock_outline),

                  suffixIcon: IconButton(
                    onPressed: () {

                      setState(() {
                        obscurePassword =
                        !obscurePassword;
                      });

                    },

                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: adminLogin,

                  child: Text(
                    "Login",

                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              TextButton(
                onPressed: () {

                  Navigator.pop(context);

                },

                child: Text(
                  "Back to Customer Login",

                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {

    return TextField(
      controller: controller,

      style: GoogleFonts.poppins(
        fontSize: 13,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: GoogleFonts.poppins(
          fontSize: 13,
        ),

        prefixIcon: Icon(icon),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}