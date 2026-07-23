import 'package:flutter/material.dart';

class ProductImageSlider extends StatefulWidget {
  final List<String> images;

  const ProductImageSlider({
    super.key,
    required this.images,
  });

  @override
  State<ProductImageSlider> createState() =>
      _ProductImageSliderState();
}

class _ProductImageSliderState
    extends State<ProductImageSlider> {

  final PageController _pageController =
  PageController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        SizedBox(
          height: 260,

          child: PageView.builder(

            controller: _pageController,

            itemCount: widget.images.length,

            onPageChanged: (index) {

              setState(() {

                currentPage = index;

              });

            },

            itemBuilder: (context, index) {

              return InteractiveViewer(

                minScale: 1,

                maxScale: 4,

                child: Padding(

                  padding: const EdgeInsets.all(18),

                  child: Image.network(

                    widget.images[index],

                    fit: BoxFit.contain,

                    errorBuilder:
                        (context, error, stackTrace) {

                      return Center(

                        child: Icon(

                          Icons.image_not_supported_outlined,

                          size: 70,

                          color: Colors.grey.shade400,

                        ),

                      );

                    },

                  ),

                ),

              );

            },

          ),

        ),

        const SizedBox(height: 14),

        Row(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: List.generate(

            widget.images.length,

                (index) {

              return AnimatedContainer(

                duration:
                const Duration(milliseconds: 250),

                margin:
                const EdgeInsets.symmetric(horizontal: 3),

                width: currentPage == index
                    ? 18
                    : 6,

                height: 6,

                decoration: BoxDecoration(

                  color: currentPage == index
                      ? Colors.green
                      : Colors.grey.shade300,

                  borderRadius:
                  BorderRadius.circular(20),

                ),

              );

            },

          ),

        ),
      ],
    );
  }
}