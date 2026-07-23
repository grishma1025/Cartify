// product_details_screen.dart
import 'package:cartify/services/wishlist_service.dart';
import 'package:cartify/models/product_model.dart';
import 'package:cartify/screens/products/buy_buttons.dart';
import 'package:cartify/screens/products/price_section.dart';
import 'package:cartify/screens/products/product_image_slider.dart';
import 'package:cartify/screens/products/product_info_section.dart';
import 'package:cartify/screens/products/similar_products.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/screens/cart_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  ProductDetailsScreen({
    super.key,
    required this.product,
  });

  final WishlistService wishlistService = WishlistService();

  // ---- Design tokens (matches other screens) ----
  static const Color _accent = Color(0xFF061473);
  static const Color _pageBg = Color(0xFFF9F9FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        actions: [

          StreamBuilder<bool>(
            stream: wishlistService.isWishlisted(product.id!),
            builder: (context, snapshot) {
              final isWishlisted = snapshot.data ?? false;

              return IconButton(
                onPressed: () async {
                  await wishlistService.toggleWishlist(product.id!);
                },
                icon: Icon(
                  isWishlisted
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 20,
                  color: isWishlisted
                      ? Colors.red
                      : Colors.black,
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          product.productName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSlider(images: product.imageUrls),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.productName,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 2),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.brand,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PriceSection(product: product),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProductInfoSection(product: product),
            ),

            const SizedBox(height: 16),

            SimilarProducts(currentProduct: product),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {

          final qty = cartProvider.quantityOf(product.id!);

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              minimum: const EdgeInsets.all(14),

              child: Row(
                children: [

                  /// QUANTITY BUTTON

                  if (qty == 0)

                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(

                          onPressed: () async {

                            await cartProvider.addToCart(product);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${product.productName} added to cart",
                                  style: GoogleFonts.poppins(fontSize: 10),
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: _accent,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),

                          child: Text(
                            "Add to Cart",

                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    )

                  else

                    Container(
                      height: 46,

                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(24),
                      ),

                      child: Row(
                        children: [

                          IconButton(

                            onPressed: () {

                              cartProvider.decreaseQuantity(
                                product.id!,
                              );
                            },

                            icon: const Icon(
                              Icons.remove,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),

                          Text(
                            qty.toString(),

                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),

                          IconButton(

                            onPressed: () {

                              cartProvider.increaseQuantity(
                                product.id!,
                              );
                            },

                            icon: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(width: 10),

                  Expanded(
                    flex: 2,

                    child: SizedBox(
                      height: 46,

                      child: ElevatedButton(

                        onPressed: () async {

                          if (!cartProvider.isInCart(product.id!)) {
                            await cartProvider.addToCart(product);
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CartScreen(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E8B57),
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),

                        child: Text(
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
              ),
            ),
          );
        },
      ),
    );
  }
}