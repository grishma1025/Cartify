import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'family_info_screen.dart';
import 'diet_screen.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {

  String selectedOption = "";
  bool isLoading = false;

  Future<void> handleSelection(
      String option,
      Widget nextScreen,
      ) async {

    setState(() {
      selectedOption = option;
      isLoading = true;
    });

    try {

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({

          'userId': user.uid,
          'userType': option,
          'isOnboardingCompleted': false,
          'updatedAt': Timestamp.now(),

        }, SetOptions(merge: true));
      }

      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => nextScreen,
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Something went wrong: $e",
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isLoading = false;
          selectedOption = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const SizedBox(height: 60),

              const Text(
                "WHO ARE YOU\nSHOPPING FOR?",
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 70),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

                children: [

                  buildOptionCard(
                    title: "INDIVIDUAL",
                    emoji: "👩",

                    isSelected:
                    selectedOption == "individual",

                    onTap: isLoading
                        ? null
                        : () {

                      handleSelection(
                        "individual",
                        const DietScreen(),
                      );
                    },
                  ),

                  buildOptionCard(
                    title: "FAMILY",
                    emoji: "👨‍👩‍👧‍👦",

                    isSelected:
                    selectedOption == "family",

                    onTap: isLoading
                        ? null
                        : () {

                      handleSelection(
                        "family",
                        const FamilyInfoScreen(),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              if (isLoading)
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionCard({
    required String title,
    required String emoji,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 250),

        child: Column(
          children: [

            AnimatedContainer(
              duration:
              const Duration(milliseconds: 250),

              height: 140,
              width: 140,

              decoration: BoxDecoration(

                color: isSelected
                    ? Colors.blue.shade100
                    : Colors.white,

                shape: BoxShape.circle,

                border: Border.all(
                  color: isSelected
                      ? Colors.blue
                      : Colors.transparent,
                  width: 3,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: isSelected ? 14 : 8,
                  )
                ],
              ),

              child: Center(
                child: Text(
                  emoji,

                  style: const TextStyle(
                    fontSize: 60,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              title,

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,

                color: isSelected
                    ? Colors.blue
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}