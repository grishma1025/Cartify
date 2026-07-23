import 'package:cartify/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'track_order_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Container(
                padding: const EdgeInsets.all(30),

                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 90,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Order Placed Successfully!",

                textAlign: TextAlign.center,

                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Your groceries will arrive in approximately 20-30 minutes.",

                textAlign: TextAlign.center,

                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 50),



              const SizedBox(height: 15),

              TextButton(

                onPressed: () {

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainScreen(),
                    ),
                        (route) => false,
                  );
                },

                child: Text(
                  "Continue Shopping",

                  style: GoogleFonts.poppins(
                    color: Colors.green,
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