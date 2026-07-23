
import 'package:cartify/models/product_model.dart';
import 'package:cartify/screens/products/product_card.dart';
import 'package:cartify/screens/products/product_details_screen.dart';
import 'package:cartify/services/product_service.dart';
import 'package:cartify/services/wishlist_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyAgainScreen extends StatefulWidget {
  const BuyAgainScreen({super.key});

  @override
  State<BuyAgainScreen> createState() => _BuyAgainScreenState();
}

class _BuyAgainScreenState extends State<BuyAgainScreen> {
  final ProductService _productService = ProductService();
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Please login first")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
        "Buy Again",
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("userId", isEqualTo: user.uid)
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("Nothing to Buy Again",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            );
          }

          final Map<String, Timestamp> latest = {};

          for (final doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final Timestamp created = data["createdAt"];
            final List products = data["products"] ?? [];
            for (final p in products) {
              final id = p["productId"];
              if (!latest.containsKey(id) ||
                  latest[id]!.seconds < created.seconds) {
                latest[id] = created;
              }
            }
          }

          final ids = latest.keys.toList()
            ..sort((a, b) => latest[b]!.compareTo(latest[a]!));

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.48,
            ),
            itemCount: ids.length,
            itemBuilder: (context, index) {
              return FutureBuilder<ProductModel?>(
                future: _productService.getProductById(ids[index]),
                builder: (context, snap) {
                  if (!snap.hasData) return const SizedBox();

                  final product = snap.data!;

                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                    onWishlist: () async {
                      await _wishlistService.toggleWishlist(product.id!);
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
