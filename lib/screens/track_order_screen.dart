import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          "Track Order",
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

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // Delivery Partner Card

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.green.shade50,

                    child: const Icon(
                      Icons.delivery_dining,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Rahul Sharma",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          "Delivery Partner",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            buildStep(
              "Order Confirmed",
              "Your order has been confirmed.",
              true,
            ),

            buildStep(
              "Order Packed",
              "Items are packed and ready.",
              true,
            ),

            buildStep(
              "Out For Delivery",
              "Delivery partner is on the way.",
              true,
            ),

            buildStep(
              "Delivered",
              "Order will arrive soon.",
              false,
            ),

            const Spacer(),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [

                  Text(
                    "Estimated Delivery Time",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "20 Minutes",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStep(
      String title,
      String subtitle,
      bool completed,
      ) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Column(
          children: [

            CircleAvatar(
              radius: 14,

              backgroundColor:
              completed
                  ? Colors.green
                  : Colors.grey.shade300,

              child: Icon(
                completed
                    ? Icons.check
                    : Icons.radio_button_unchecked,

                color: Colors.white,
                size: 16,
              ),
            ),

            Container(
              width: 2,
              height: 55,
              color: Colors.grey.shade300,
            ),
          ],
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,

                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}