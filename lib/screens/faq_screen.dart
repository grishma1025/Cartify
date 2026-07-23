import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "FAQs",
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

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: const [

          FAQTile(
            question: "How can I place an order?",
            answer:
            "Browse products, add items to your cart and proceed to checkout.",
          ),

          FAQTile(
            question: "How can I track my order?",
            answer:
            "Go to the Orders page to check the latest status of your order.",
          ),

          FAQTile(
            question: "Can I cancel my order?",
            answer:
            "Yes, orders can be cancelled before they are packed for delivery.",
          ),

          FAQTile(
            question: "How do I add a delivery address?",
            answer:
            "Open Profile → My Addresses and add a new address.",
          ),

          FAQTile(
            question: "How can I contact support?",
            answer:
            "Open Help & Support and choose Email Support or Call Support.",
          ),

          FAQTile(
            question: "Is online payment secure?",
            answer:
            "Yes, all payments are processed securely through trusted payment gateways.",
          ),
        ],
      ),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 6,
          )
        ],
      ),

      child: ExpansionTile(

        tilePadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 4,
        ),

        childrenPadding: const EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: 16,
        ),

        title: Text(
          question,

          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        children: [

          Text(
            answer,

            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}