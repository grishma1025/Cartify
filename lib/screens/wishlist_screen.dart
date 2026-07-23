import 'package:cartify/screens/login_screen.dart';
import 'package:cartify/screens/products/product_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cartify/screens/products/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cartify/models/product_model.dart';
import 'package:cartify/services/wishlist_service.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({super.key});

  final WishlistService wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // =========================
    // Guest User
    // =========================

    if (user == null || user.isAnonymous) {
      return Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,

          title: Text(
            "Wishlist",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.green.shade50,

                  child: Icon(
                    Icons.favorite_border,
                    size: 42,
                    color: Colors.green.shade400,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Login Required",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Login to save and access your favourite products.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },

                    child: Text(
                      "Login Now",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // =========================
    // Logged In User
    // =========================

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Wishlist",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: wishlistService.wishlistStream(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final wishlistDocs = snapshot.data!.docs;

          if (wishlistDocs.isEmpty) {
            return Center(
              child: Text(
                "No Wishlist Items Yet",
                style: GoogleFonts.poppins(),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: wishlistDocs.length,

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.48,
            ),

            itemBuilder: (context, index) {

              final productId = wishlistDocs[index].id;

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .doc(productId)
                    .snapshots(),

                builder: (context, productSnapshot) {

                  if (!productSnapshot.hasData ||
                      !productSnapshot.data!.exists) {
                    return const SizedBox();
                  }

                  final product = ProductModel.fromDocument(
                    productSnapshot.data!,
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
              );
            },
          );
        },
      ),
    );
  }
}