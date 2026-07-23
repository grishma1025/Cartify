import 'package:cartify/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceSection extends StatelessWidget {
  final ProductModel product;

  const PriceSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {

    final discount =
    product.discountPercentage.round();

    final savings =
        product.mrp - product.sellingPrice;

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        boxShadow: [

          BoxShadow(

            color: Colors.grey.withOpacity(.06),

            blurRadius: 8,

            offset: const Offset(0, 2),

          ),

        ],

      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // ---- Net quantity ----
          Row(
            children: [
              Text(
                "Net quantity : ",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "${product.quantity.toStringAsFixed(0)} ${product.unit}",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              if (discount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$discount% OFF",
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // ---- Price pill ----
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "₹${product.sellingPrice.toStringAsFixed(0)}",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ---- MRP + tax note ----
          if (product.mrp > product.sellingPrice)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "MRP  ",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  TextSpan(
                    text: "₹${product.mrp.toStringAsFixed(0)}  ",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  TextSpan(
                    text: "(Inclusive of all taxes)",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              "Inclusive of all taxes",
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),

          const SizedBox(height: 10),

          if (product.mrp > product.sellingPrice)

            Container(

              padding: const EdgeInsets.symmetric(

                horizontal: 10,

                vertical: 8,

              ),

              decoration: BoxDecoration(

                color: Colors.green.shade50,

                borderRadius:
                BorderRadius.circular(10),

              ),

              child: Row(

                children: [

                  const Icon(

                    Icons.local_offer_outlined,

                    color: Colors.green,

                    size: 14,

                  ),

                  const SizedBox(width: 6),

                  Expanded(

                    child: Text(

                      "You saved ₹${savings.toStringAsFixed(0)} on this product",

                      style: GoogleFonts.poppins(

                        fontSize: 10,

                        color: Colors.green.shade800,

                        fontWeight: FontWeight.w600,

                      ),

                    ),

                  ),

                ],

              ),

            ),

        ],

      ),

    );

  }

}