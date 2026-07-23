import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DynamicBanner extends StatefulWidget {
  const DynamicBanner({super.key});

  @override
  State<DynamicBanner> createState() =>
      _DynamicBannerState();
}

class _DynamicBannerState
    extends State<DynamicBanner> {

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(

      stream: FirebaseFirestore.instance
          .collection('banners')
          .where('isActive', isEqualTo: true)
          .snapshots(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final banners = snapshot.data!.docs;

        if (banners.isEmpty) {

          return AspectRatio(
            aspectRatio: 2.4,

            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100,

                borderRadius:
                BorderRadius.circular(20),
              ),

              child: const Center(
                child: Text(
                  "No Banner Available",
                ),
              ),
            ),
          );
        }

        return Column(

          children: [

            CarouselSlider.builder(

              itemCount: banners.length,

              itemBuilder:
                  (context, index, realIndex) {

                final data =
                banners[index].data()
                as Map<String, dynamic>;

                return ClipRRect(

                  borderRadius:
                  BorderRadius.circular(20),

                  child: Image.network(
                    data['imageUrl'],

                    width: double.infinity,

                    fit: BoxFit.fill,

                    errorBuilder:
                        (context, error, stackTrace) {

                      return Container(
                        color: Colors.grey.shade200,

                        child: const Center(
                          child: Text(
                            "Invalid Banner",
                          ),
                        ),
                      );
                    },
                  ),
                );
              },

              options: CarouselOptions(

                aspectRatio: 2.4,

                viewportFraction: 1,

                autoPlay: true,

                autoPlayInterval:
                const Duration(seconds: 4),

                enlargeCenterPage: false,

                onPageChanged:
                    (index, reason) {

                  setState(() {
                    activeIndex = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 12),

            AnimatedSmoothIndicator(

              activeIndex: activeIndex,

              count: banners.length,

              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,

                activeDotColor: const Color(0xFFDBDFFB),

                dotColor: const Color(0xFFE5E7EB),
              ),
            ),
          ],
        );
      },
    );
  }
}