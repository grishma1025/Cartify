import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'faq_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> sendEmail() async {

    final Uri emailUri = Uri.parse(
      'mailto:cartify@gmail.com?subject=CartifySupport',
    );

    try {
      await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint("Could not launch email app");
    }
  }

  Future<void> makeCall() async {

    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '9876543210',
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Help & Support",
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

            supportTile(
              icon: Icons.quiz_outlined,
              title: "FAQs",
              subtitle: "Frequently asked questions",

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FAQScreen(),
                  ),
                );
              },
            ),

            supportTile(
              icon: Icons.email_outlined,
              title: "Email Support",
              subtitle: "cartify@gmail.com",
              onTap: () {
                sendEmail();
              },
            ),

            supportTile(
              icon: Icons.call_outlined,
              title: "Call Support",
              subtitle: "+91 9876543210",
              onTap: () {
                makeCall();
              },
            ),



            const SizedBox(height: 30),

            Container(

              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.green.shade50,

                borderRadius:
                BorderRadius.circular(20),
              ),

              child: Column(

                children: [

                  Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.support_agent,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Need Assistance?",

                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Our support team is available to help you anytime.",

                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    "Cartify v1.0.0",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget supportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {

    return Container(

      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 6,
          )
        ],
      ),

      child: ListTile(

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),

        leading: CircleAvatar(
          radius: 22,

          backgroundColor: Colors.green.shade50,

          child: Icon(
            icon,
            color: Colors.green,
            size: 22,
          ),
        ),

        title: Text(
          title,

          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        subtitle: Text(
          subtitle,

          style: GoogleFonts.poppins(
            fontSize: 11,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),

        onTap: onTap,
      ),
    );
  }
}