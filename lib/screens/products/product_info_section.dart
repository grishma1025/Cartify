import 'package:cartify/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({
    super.key,
    required this.product,
  });

  Widget infoTile(
      String title,
      String value,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.green.shade50,

            child: Icon(
              icon,
              size: 14,
              color: Colors.green,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,

                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        boxShadow: [

          BoxShadow(

            color: Colors.grey.withOpacity(.06),

            blurRadius: 8,

            offset: const Offset(0,2),

          ),

        ],

      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            "Product Information",

            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),

          ),

          const SizedBox(height: 14),

          infoTile(
            "Brand",
            product.brand,
            Icons.business_outlined,
          ),

          infoTile(
            "Category",
            product.categoryName,
            Icons.category_outlined,
          ),

          infoTile(
            "Sub Category",
            product.subCategory,
            Icons.grid_view_outlined,
          ),

          infoTile(
            "Manufacturer",
            product.manufacturer,
            Icons.factory_outlined,
          ),

          infoTile(
            "Country of Origin",
            product.countryOfOrigin,
            Icons.public,
          ),

          infoTile(
            "Shelf Life",
            "${product.shelfLifeDays} Days",
            Icons.calendar_today_outlined,
          ),

          infoTile(
            "Storage",
            product.storageInstructions,
            Icons.kitchen_outlined,
          ),

          infoTile(
            "Ingredients",
            product.ingredients,
            Icons.restaurant_menu_outlined,
          ),

          Divider(height: 22, color: Colors.grey.shade200),

          Text(

            "Description",

            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),

          ),

          const SizedBox(height: 8),

          Text(

            product.description,

            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey.shade700,
              height: 1.6,
            ),

          ),
        ],
      ),
    );
  }
}