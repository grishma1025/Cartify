import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/screens/products/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cartify/services/product_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cartify/screens/login_screen.dart';
import 'package:cartify/screens/checkout_screen.dart';
import 'package:cartify/models/product_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // ---- Design tokens (matches Figma) ----
  static const Color _cardBg = Color(0xFFE0EAFF);
  static const Color _accent = Color(0xFF061473);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final items = cartProvider.cartItems;

        return Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "My Cart",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),

          body: items.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "Your Cart is Empty",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Add products to start shopping.",
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          )
              : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),

                      onTap: () async {

                        final product = await ProductService()
                            .getProductById(item.productId);

                        if (product == null) {

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Product not found",
                                style: GoogleFonts.poppins(fontSize: 10),
                              ),
                            ),
                          );

                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsScreen(
                              product: product,
                            ),
                          ),
                        );
                      },

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      width: 56,
                                      height: 56,
                                      color: Colors.white,
                                      child: const Icon(
                                        Icons.image,
                                        size: 18,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.productName,
                                            maxLines: 2,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight:
                                              FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        // ---- Quantity stepper ----
                                        Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  cartProvider
                                                      .decreaseQuantity(
                                                    item.productId,
                                                  );
                                                },
                                                child: const Padding(
                                                  padding:
                                                  EdgeInsets.all(4),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                item.cartQuantity
                                                    .toString(),
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  cartProvider
                                                      .increaseQuantity(
                                                    item.productId,
                                                  );
                                                },
                                                child: const Padding(
                                                  padding:
                                                  EdgeInsets.all(4),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "${item.quantity} ${item.unit}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade700,
                                        fontSize: 10,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Row(
                                      children: [
                                        Text(
                                          "₹${item.sellingPrice.toStringAsFixed(0)}",
                                          style: GoogleFonts.poppins(
                                            color: _accent,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),


                                      ],
                                    ),

                                    if (item.isSuggested)
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 6),
                                        child: Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            "Suggested",
                                            style:
                                            GoogleFonts.poppins(
                                              color: _accent,
                                              fontSize: 8,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Subtotal",
                          style: GoogleFonts.poppins(fontSize: 10),
                        ),
                        const Spacer(),
                        Text(
                          "₹${cartProvider.subtotal.toStringAsFixed(0)}",
                          style: GoogleFonts.poppins(fontSize: 10),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Text(
                          "Delivery",
                          style: GoogleFonts.poppins(fontSize: 10),
                        ),
                        const Spacer(),
                        Text(
                          "FREE",
                          style: GoogleFonts.poppins(fontSize: 10),
                        ),
                      ],
                    ),

                    const Divider(height: 25),

                    Row(
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "₹${cartProvider.subtotal.toStringAsFixed(0)}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: _accent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ---- Proceed to Checkout ----
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {

                          final user = FirebaseAuth.instance.currentUser;

                          if (user == null || user.isAnonymous) {

                            showDialog(
                              context: context,
                              builder: (context) {

                                return AlertDialog(

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),

                                  title: Text(
                                    "Login Required",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  content: Text(
                                    "Please sign in to continue with Checkout.",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                    ),
                                  ),

                                  actions: [

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _accent,
                                      ),
                                      onPressed: () {

                                        Navigator.pop(context);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Login",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Proceed to Checkout",
                          style: GoogleFonts.poppins(
                            color: _accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}