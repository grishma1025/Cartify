import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    // Default values from Firebase Auth

    nameController.text =
        user.displayName ?? "";

    emailController.text =
        user.email ?? "";

    phoneController.text =
        user.phoneNumber ?? "";

    // Fetch extra profile details from Firestore

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {

      final data =
      doc.data() as Map<String, dynamic>;

      nameController.text =
          data['fullName'] ??
              nameController.text;

      emailController.text =
          data['email'] ??
              emailController.text;

      phoneController.text =
          data['phone'] ??
              phoneController.text;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveProfile() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (nameController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter your name",
          ),
        ),
      );

      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({

      'fullName':
      nameController.text.trim(),

      'email':
      emailController.text.trim(),

      'phone':
      phoneController.text.trim(),

      'updatedAt': Timestamp.now(),

    }, SetOptions(merge: true));

    // Update Firebase Auth display name too

    await user.updateDisplayName(
      nameController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Profile Updated Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          "Edit Profile",

          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            CircleAvatar(
              radius: 45,
              backgroundColor:
              Colors.green.shade50,

              child: Text(

                nameController.text.isEmpty
                    ? "G"
                    : nameController.text[0]
                    .toUpperCase(),

                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 30),

            buildTextField(
              controller: nameController,
              label: "Full Name",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 16),

            buildTextField(
              controller: emailController,
              label: "Email Address",
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 16),

            buildTextField(
              controller: phoneController,
              label: "Phone Number",
              icon: Icons.phone_outlined,
            ),

            const SizedBox(height: 35),

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

                onPressed: saveProfile,

                child: Text(
                  "Save Changes",

                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {

    return TextField(
      controller: controller,

      style: GoogleFonts.poppins(
        fontSize: 13,
      ),

      cursorColor: Colors.green,

      decoration: InputDecoration(

        labelText: label,

        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
        ),

        floatingLabelStyle: GoogleFonts.poppins(
          color: Colors.green,
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.green,
        ),

        filled: true,
        fillColor: Colors.white,

        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(16),

          borderSide: const BorderSide(
            color: Colors.green,
            width: 1.5,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
      ),
    );
  }
}