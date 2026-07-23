import 'package:cartify/models/product_model.dart';
import 'package:cartify/screens/products/product_card.dart';
import 'package:cartify/screens/products/product_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cartify/services/wishlist_service.dart';
import 'package:google_fonts/google_fonts.dart';

class SimilarProducts extends StatelessWidget {
  final ProductModel currentProduct;

   SimilarProducts({
    super.key,
    required this.currentProduct,
  });
  final WishlistService wishlistService = WishlistService();
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(

      stream: FirebaseFirestore.instance
          .collection('products')
          .where(
        'categoryId',
        isEqualTo: currentProduct.categoryId,
      )
          .where(
        'isActive',
        isEqualTo: true,
      )
          .limit(10)
          .snapshots(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data!.docs
            .where((doc) => doc.id != currentProduct.id)
            .toList();

        if (docs.isEmpty) {
          return const SizedBox();
        }

        return Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Text(
                "Similar Products",

                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---- 3-per-row grid, same card used on Products screen ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.50,
                ),

                itemCount: docs.length,

                itemBuilder: (context, index) {

                  final product =
                  ProductModel.fromDocument(
                    docs[index],
                  );

                  return ProductCard(

                    product: product,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(
                            product: product,
                          ),
                        ),
                      );
                    },
                    onWishlist: () async {
                      await wishlistService.toggleWishlist(product.id!);
                    },

                  );

                },

              ),
            ),

          ],

        );

      },

    );

  }

}