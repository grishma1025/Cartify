import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyButtons extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final bool isLoading;

  const BuyButtons({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {

    return Row(

      children: [

        Expanded(

          child: SizedBox(

            height: 46,

            child: OutlinedButton.icon(

              onPressed: isLoading
                  ? null
                  : onAddToCart,

              style: OutlinedButton.styleFrom(

                side: const BorderSide(
                  color: Colors.green,
                  width: 1.2,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(24),
                ),

              ),

              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 16,
                color: Colors.green,
              ),

              label: Text(

                "Add to Cart",

                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),

              ),

            ),

          ),

        ),

        const SizedBox(width: 10),

        Expanded(

          child: SizedBox(

            height: 46,

            child: ElevatedButton.icon(

              onPressed: isLoading
                  ? null
                  : onBuyNow,

              style: ElevatedButton.styleFrom(

                elevation: 0,

                backgroundColor: Colors.green,

                shape: RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(24),

                ),

              ),

              icon: isLoading
                  ? const SizedBox(

                width: 16,
                height: 16,

                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),

              )
                  : const Icon(
                Icons.flash_on,
                size: 16,
                color: Colors.white,
              ),

              label: Text(

                "Buy Now",

                style: GoogleFonts.poppins(

                  color: Colors.white,

                  fontWeight: FontWeight.w600,

                  fontSize: 12,

                ),

              ),

            ),

          ),

        ),

      ],

    );

  }

}