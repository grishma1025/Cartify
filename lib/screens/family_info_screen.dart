import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FamilyInfoScreen extends StatefulWidget {
  const FamilyInfoScreen({super.key});

  @override
  State<FamilyInfoScreen> createState() => _FamilyInfoScreenState();
}

class _FamilyInfoScreenState extends State<FamilyInfoScreen> {

  int adults = 0;
  int kids = 0;
  int infants = 0;

  Future<void> saveFamilyInfo() async {

    if (adults == 0 &&
        kids == 0 &&
        infants == 0) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please add at least one family member or press Skip",
          ),
        ),
      );

      return;
    }

    final user = FirebaseAuth.instance.currentUser;


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


    if (user != null) {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({

        'adults': adults,
        'kids': kids,
        'infants': infants,

        'isOnboardingCompleted': true,

        'updatedAt': Timestamp.now(),

      });
    }

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
          (route) => false,
    );
  }

  Future<void> skipOnboarding() async {

    final user = FirebaseAuth.instance.currentUser;

    // Save locally for guest users
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

    if (user != null) {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({

        'adults': 0,
        'kids': 0,
        'infants': 0,

        'isOnboardingCompleted': true,

        'updatedAt': Timestamp.now(),

      });
    }

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

      backgroundColor: const Color(0xFFF5DDF8),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 30),

              const Text(
                "HOW MANY MEMBERS\nARE THERE IN YOUR\nFAMILY ?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),

              buildCounterRow(
                title: "ADULTS",
                count: adults,

                onAdd: () {
                  setState(() {
                    adults++;
                  });
                },

                onRemove: () {
                  if (adults > 0) {
                    setState(() {
                      adults--;
                    });
                  }
                },
              ),

              const SizedBox(height: 25),

              buildCounterRow(
                title: "KIDS",
                count: kids,

                onAdd: () {
                  setState(() {
                    kids++;
                  });
                },

                onRemove: () {
                  if (kids > 0) {
                    setState(() {
                      kids--;
                    });
                  }
                },
              ),

              const SizedBox(height: 25),

              buildCounterRow(
                title: "INFANTS",
                count: infants,

                onAdd: () {
                  setState(() {
                    infants++;
                  });
                },

                onRemove: () {
                  if (infants > 0) {
                    setState(() {
                      infants--;
                    });
                  }
                },
              ),

              const Spacer(),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  TextButton(

                    onPressed: skipOnboarding,

                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),

                  ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 12,
                      ),
                    ),

                    onPressed: saveFamilyInfo,

                    child: const Text("Next"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCounterRow({
    required String title,
    required int count,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius:
            BorderRadius.circular(30),
          ),

          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Row(
          children: [

            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove),
            ),

            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}