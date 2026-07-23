import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  // ---- Design tokens (matches Figma / Orders screen) ----
  static const Color _accent = Color(0xFFB7951D);
  static const Color _pageBg = Color(0xFFF9F9FB);

  @override
  Widget build(BuildContext context) {
    final products = List<Map<String, dynamic>>.from(order["products"]);

    return Scaffold(
      backgroundColor: _pageBg,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Order Details",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),

        child: Column(
          children: [

            // ---- Order info card ----
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Order #${order["orderId"]}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _infoRow("Status", "${order["status"]}",
                      valueColor: _statusColor("${order["status"]}")),

                  const SizedBox(height: 4),

                  _infoRow("Payment", "${order["paymentMethod"]}"),

                  const SizedBox(height: 4),

                  _infoRow(
                    "Placed On",
                    DateFormat("dd MMM yyyy, hh:mm a")
                        .format(order["createdAt"].toDate()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---- Products card ----
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: products.length,

                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                  indent: 16,
                  endIndent: 16,
                ),

                itemBuilder: (context, index) {

                  final product = products[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product["imageUrl"],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey.shade100,
                              child: const Icon(Icons.image, size: 16),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["productName"],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "${product["cartQuantity"]} x ₹${product["sellingPrice"]}",
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          "₹${product["totalPrice"].toStringAsFixed(0)}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // ---- Bill summary card ----
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                children: [

                  _bill("Items Total",
                      "₹${order["subtotal"].toStringAsFixed(0)}"),

                  _bill("Savings",
                      "₹${order["totalSavings"].toStringAsFixed(0)}"),

                  _bill("Delivery", "FREE"),

                  Divider(color: Colors.grey.shade200),

                  _bill(
                    "Grand Total",
                    "₹${order["grandTotal"].toStringAsFixed(0)}",
                    bold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(
          "$label : ",
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _bill(
      String title,
      String value, {
        bool bold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        children: [

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: bold ? 12 : 10,
              fontWeight:
              bold ? FontWeight.w600 : FontWeight.normal,
              color: bold ? Colors.black : Colors.grey.shade700,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: bold ? 12 : 10,
              fontWeight:
              bold ? FontWeight.w600 : FontWeight.normal,
              color: bold ? _accent : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "processing":
        return Colors.blue;
      case "shipped":
        return Colors.deepPurple;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.black87;
    }
  }
}