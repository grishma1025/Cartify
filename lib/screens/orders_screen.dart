import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_details_screen.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  // ---- Design tokens (matches Figma) ----
  static const Color _cardBg = Color(0xFFFFF8DB);
  static const Color _accent = Color(0xFFB7951D);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Please login to view your orders.",
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Orders",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
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
            return const Center(
              child: CircularProgressIndicator(
                color: _accent,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  snapshot.error.toString(),
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No Orders Yet",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Looks like you haven't placed any order.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order =
              orders[index].data() as Map<String, dynamic>;

              final Timestamp? timestamp =
              order["createdAt"] as Timestamp?;

              final String orderDate = timestamp == null
                  ? "-"
                  : DateFormat(
                "dd MMM yyyy, hh:mm a",
              ).format(timestamp.toDate());

              final List products = order["products"] as List;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ---- Title row: status + price ----
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              order["status"] == "Delivered"
                                  ? "Order Delivered"
                                  : "Order ${order["status"]}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "₹${order["grandTotal"].toStringAsFixed(0)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // ---- Placed at date ----
                      Text(
                        "Placed at $orderDate",
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ---- Product thumbnails row ----
                      Row(
                        children: [
                          ...products.take(3).map((product) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection("products")
                                    .doc(product["productId"])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData || !snapshot.data!.exists) {
                                    return Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.image_outlined,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    );
                                  }

                                  final data =
                                  snapshot.data!.data() as Map<String, dynamic>;

                                  final List images = data["imageUrls"] ?? [];

                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      images.isNotEmpty ? images.first : "",
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.image_outlined,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                          if (products.length > 3)
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                "+${products.length - 3}",
                                style: GoogleFonts.poppins(
                                  fontSize: 6,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Divider(
                          color: Color(0xFFD9D9D9),
                          thickness: 0.8,
                          height: 20,
                        ),
                      ),


                      // ---- View Details ----
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailsScreen(
                                  order: order,
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "View Details",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _accent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

