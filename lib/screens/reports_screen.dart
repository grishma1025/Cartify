import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  Future<Map<String, dynamic>> getReportData() async {
    final ordersSnapshot =
    await FirebaseFirestore.instance.collection('orders').get();

    int totalOrders = ordersSnapshot.docs.length;
    int pendingOrders = 0;
    double revenue = 0;

    for (var doc in ordersSnapshot.docs) {
      final data = doc.data();

      if ((data["status"] ?? "").toString().toLowerCase() == "pending") {
        pendingOrders++;
      }

      revenue += (data["grandTotal"] ?? 0).toDouble();
    }

    return {
      "totalOrders": totalOrders,
      "pendingOrders": pendingOrders,
      "revenue": revenue,
    };
  }

  Widget buildCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getReportData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildCard(
                  "Total Orders",
                  data["totalOrders"].toString(),
                  Icons.shopping_bag,
                  Colors.blue,
                ),
                const SizedBox(height: 15),
                buildCard(
                  "Pending Orders",
                  data["pendingOrders"].toString(),
                  Icons.pending_actions,
                  Colors.orange,
                ),
                const SizedBox(height: 15),
                buildCard(
                  "Revenue",
                  "₹${data["revenue"].toStringAsFixed(2)}",
                  Icons.currency_rupee,
                  Colors.green,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}