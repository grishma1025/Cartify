import 'package:cartify/screens/main_screen.dart';
import 'package:cartify/screens/user_type_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? onboardingCompleted;

  @override
  void initState() {
    super.initState();
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    try {

      print("AuthWrapper Started");

      User? user = FirebaseAuth.instance.currentUser;

      print("Firebase User = ${user?.uid}");

      SharedPreferences prefs =
      await SharedPreferences.getInstance();

      print(
          "Shared Pref Value = "
              "${prefs.getBool('isOnboardingCompleted')}"
      );
      // Logged-in user → check Firestore
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        bool completed = false;

        if (userDoc.exists) {
          completed =
              (userDoc.data() as Map<String, dynamic>)[
              'isOnboardingCompleted'] ??
                  false;
        }

        setState(() {
          onboardingCompleted = completed;
        });
      }

      // Guest user → check SharedPreferences
      else {
        SharedPreferences prefs =
        await SharedPreferences.getInstance();

        bool completed =
            prefs.getBool('isOnboardingCompleted') ?? false;
        print(
            "Onboarding completed = $completed"
        );
        setState(() {
          onboardingCompleted = completed;
        });
      }
    } catch (e) {
      print("AuthWrapper Error: $e");

      setState(() {
        onboardingCompleted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (onboardingCompleted == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (onboardingCompleted == false) {
      return const UserTypeScreen();
    }

    return const MainScreen();
  }
}