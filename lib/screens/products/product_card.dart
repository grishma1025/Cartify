// NOTE:
// This is a starter template for the redesigned ProductCard.
// It preserves your existing API so you can replace the UI.
// (The full logic can be copied into this file as needed.)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:cartify/models/product_model.dart';
import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/services/wishlist_service.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onWishlist;

  ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onWishlist,
  });

  final WishlistService wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final qty = cart.quantityOf(product.id!);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEAEAEA)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 95,
              child: Stack(
                children: [
                  Center(
                    child: Image.network(
                      product.imageUrls.isEmpty ? "" : product.imageUrls.first,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: StreamBuilder<bool>(
                      stream: wishlistService.isWishlisted(product.id!),
                      builder: (context, snap) {
                        final fav = snap.data ?? false;
                        return GestureDetector(
                          onTap: () async {
                            onWishlist();
                          },
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              fav ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: fav ? Colors.red : Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "${product.quantity} ${product.unit}",
              style: GoogleFonts.poppins(
                fontSize: 8,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Text(
                  "₹${product.sellingPrice.toStringAsFixed(0)}",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Spacer(),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),

                  child: qty == 0

                      ? SizedBox(
                    key: const ValueKey("add"),

                    width: 44,
                    height: 22,

                    child: OutlinedButton(

                      onPressed: () async {
                        await cart.addToCart(product);
                      },

                      style: OutlinedButton.styleFrom(

                        padding: EdgeInsets.zero,

                        backgroundColor: Colors.white,

                        side: BorderSide.none,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      child: Text(
                        "ADD",

                        style: GoogleFonts.poppins(

                          color: const Color(0xff1D3D8F),

                          fontWeight: FontWeight.w600,

                          fontSize: 10,
                        ),
                      ),
                    ),
                  )

                      : Container(

                    key: const ValueKey("qty"),

                    width: 44,

                    height: 22,

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius: BorderRadius.circular(8),


                    ),

                    child: Row(

                      children: [

                        Expanded(

                          child: InkWell(

                            onTap: () async {
                              await cart.decreaseQuantity(product.id!);
                            },

                            child: const Icon(
                              Icons.remove,
                              size: 11,
                              color: Color(0xff1D3D8F),
                            ),
                          ),
                        ),

                        Text(
                          qty.toString(),

                          style: GoogleFonts.poppins(

                            color: const Color(0xff1D3D8F),

                            fontSize: 8,

                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Expanded(

                          child: InkWell(

                            onTap: () async {
                              await cart.increaseQuantity(product.id!);
                            },

                            child: const Icon(
                              Icons.add,
                              size: 11,
                              color: Color(0xff1D3D8F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
