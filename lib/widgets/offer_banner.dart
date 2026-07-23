import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferBanner extends StatelessWidget {
  const OfferBanner({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Color> bannerColors = [
      const Color(0xFFDFFFD6),
      const Color(0xFFFFF3CD),
      const Color(0xFFE3F2FD),
    ];

    final List<String> titles = [
      "50% OFF On Fresh Fruits",
      "Free Delivery Above ₹299",
      "Daily Essentials Delivered Fast",
    ];

    return CarouselSlider.builder(
      itemCount: 3,

      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        enlargeCenterPage: true,
        viewportFraction: 1,
      ),

      itemBuilder: (context, index, realIndex) {

        return Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: bannerColors[index],
            borderRadius: BorderRadius.circular(20),
          ),

          padding: const EdgeInsets.all(20),

          child: Row(
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    Text(
                      titles[index],

                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Shop now and save more with Cartify.",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.shopping_basket,
                size: 60,
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}