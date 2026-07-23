import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCard extends StatelessWidget {

  final IconData icon;
  final String title;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
          )
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(

              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: Colors.green,
              size: 28,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,

            textAlign: TextAlign.center,

            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}