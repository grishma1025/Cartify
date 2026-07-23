import 'package:cartify/screens/auth_wrapper.dart';
import 'package:cartify/screens/login_screen.dart';
import 'package:cartify/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cartify/services/auth_service.dart';
import 'address_list_screen.dart';
import 'edit_profile_screen.dart';
import 'wishlist_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    String userName = "Guest User";
    String userInfo = "Anonymous Account";
    bool showLoginButton = true;

    if (user != null && !user.isAnonymous) {

      showLoginButton = false;

      userName =
          user.displayName ??
              "Cartify User";

      userInfo =
          user.email ??
              user.phoneNumber ??
              "No Email";
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // PROFILE CARD

            GestureDetector(
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const EditProfileScreen(),
                  ),
                );
              },

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.06),
                      blurRadius: 6,
                    )
                  ],
                ),

                child: Column(
                  children: [

                    CircleAvatar(
                      radius: 38,
                      backgroundColor:
                      Colors.green.shade50,

                      child: Text(

                        userName[0].toUpperCase(),

                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      userName,

                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      userInfo,

                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    if (!showLoginButton) ...[
                      const SizedBox(height: 12),

                      Text(
                        "Tap to Edit Profile",
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            buildOption(
              context,
              Icons.location_on_outlined,
              "My Addresses",
                  () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const AddressListScreen(),
                  ),
                );
              },
            ),

            buildOption(
              context,
              Icons.favorite_border,
              "Wishlist",
                  () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                     WishlistScreen(),
                  ),
                );
              },
            ),

            buildOption(
              context,
              Icons.help_outline,
              "Help & Support",
                  () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const HelpSupportScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // LOGIN BUTTON

            if (showLoginButton)

              TextButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );

                },

                child: Text(
                  "Login",

                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2A912B),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            // LOGOUT BUTTON

            if (!showLoginButton)

              TextButton(
              onPressed: () {

                showDialog(
                  context: context,

                  builder: (context) {

                    return AlertDialog(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      elevation: 0,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 38),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      titlePadding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
                      contentPadding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),

                      title: Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),

                      content: Text(
                        "Are you sure you want to logout?",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700,
                          height: 1.35,
                        ),
                      ),

                      actionsAlignment: MainAxisAlignment.end,

                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),

                        FilledButton(
                          style: FilledButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF86E18A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            minimumSize: const Size(72, 34),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {

                            Navigator.pop(context);
                            await AuthService().signOut();

                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                            await prefs.remove('isOnboardingCompleted');

                            if (!context.mounted) return;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AuthWrapper(),
                              ),
                                  (route) => false,
                            );                          },
                          child: Text(
                            "Logout",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },

              child: Text(
                "Logout",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2A912B),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "Cartify v1.0.0",

              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: const Color(0xFFEAFBF0),

        borderRadius:
        BorderRadius.circular(18),


      ),

      child: ListTile(
        onTap: onTap,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 4,
        ),

        leading: CircleAvatar(
          radius: 20,

          backgroundColor: const Color(0xFFEAFBF0),

          child: Icon(
            icon,
            color: const Color(0xFF3FAE5A),
            size: 20,
          ),
        ),

        title: Text(
          title,

          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }
}