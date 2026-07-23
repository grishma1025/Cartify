import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {

  String? selectedDiet;

  Future<void> saveDiet(String diet) async {

    setState(() {
      selectedDiet = diet;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({

        'dietPreference': diet,
        'isOnboardingCompleted': true,
        'updatedAt': Timestamp.now(),

      });
    }
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      'isOnboardingCompleted',
      true,
    );

    print(
        "Diet Screen Saved Shared Pref = "
            "${prefs.getBool('isOnboardingCompleted')}"
    );
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFFFF5D7),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 30),

              const Text(
                "WHAT DO YOU\nPREFER MOST OF\nTHE TIMES?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 35),

              Expanded(
                child: GridView.count(

                  crossAxisCount: 2,

                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,

                  children: [

                    buildDietCard(
                      title: "PROTEIN RICH",
                      emoji: "🥩",
                    ),

                    buildDietCard(
                      title: "NUTRITION RICH",
                      emoji: "🥗",
                    ),

                    buildDietCard(
                      title: "NORMAL",
                      emoji: "🍛",
                    ),

                    buildDietCard(
                      title: "SUGAR FREE",
                      emoji: "🍎",
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  bottom: 20,
                ),

                child: GestureDetector(
                  onTap: () async {

                    final user =
                        FirebaseAuth.instance.currentUser;

                    if (user != null) {

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({

                        'dietPreference':
                        'Not Specified',

                        'isOnboardingCompleted': true,

                        'updatedAt':
                        Timestamp.now(),

                      });
                    }
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                    await prefs.setBool(
                      'isOnboardingCompleted',
                      true,
                    );

                    print(
                        "Skip Saved Shared Pref = "
                            "${prefs.getBool('isOnboardingCompleted')}"
                    );
                    if (!mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const MainScreen(),
                      ),
                          (route) => false,
                    );
                  },

                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.brown.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDietCard({
    required String title,
    required String emoji,
  }) {

    bool isSelected = selectedDiet == title;

    return GestureDetector(

      onTap: () => saveDiet(title),

      child: Container(

        decoration: BoxDecoration(

          color: isSelected
              ? Colors.orange.shade100
              : Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected
                ? Colors.orange
                : Colors.grey.shade300,

            width: 3,
          ),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            )
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Text(
              emoji,
              style: const TextStyle(
                fontSize: 50,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              title,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}